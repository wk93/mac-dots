vim.pack.add({
	"https://github.com/onsails/lspkind.nvim",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/saghen/blink.cmp",
})

local function find_pack_plugin_dir(name)
	for _, base in ipairs(vim.api.nvim_list_runtime_paths()) do
		local candidate = base:match("(.*/pack/[^/]+/(?:start|opt)/" .. name .. ")$")
		if candidate then
			return candidate
		end
	end

	local data = vim.fn.stdpath("data")

	local glob = data .. "/site/pack/*/start/" .. name
	local found = vim.fn.glob(glob, true, true)[1]
	if found and #found > 0 then
		return found
	end

	glob = data .. "/site/pack/*/opt/" .. name
	found = vim.fn.glob(glob, true, true)[1]
	if found and #found > 0 then
		return found
	end

	return nil
end

local function ensure_blink_fuzzy_built()
	local plugin_dir = find_pack_plugin_dir("blink.cmp")
	if not plugin_dir then
		vim.notify("blink.cmp: could not find plugin directory in packpath", vim.log.levels.ERROR)
		return
	end

	local target = plugin_dir .. "/target/release"
	if vim.uv.fs_stat(target) then
		return
	end

	if vim.fn.executable("cargo") ~= 1 then
		vim.notify("blink.cmp: `cargo` not found in PATH. Please install Rust/Cargo and try again.",
			vim.log.levels.ERROR)
		return
	end

	local cmd = { "cargo", "build", "--release" }

	vim.notify("blink.cmp: building Rust fuzzy matcher (one-time)...", vim.log.levels.WARN)
	local res = vim.system(cmd, { cwd = plugin_dir }):wait()
	if res.code ~= 0 then
		vim.notify("blink.cmp: build failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
	end
end

ensure_blink_fuzzy_built()

require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	signature = {
		enabled = true,
		window = { border = "rounded" },
	},
	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "normal",
	},
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
			cmdline = {
				min_keyword_length = 2,
			},
		},
	},
	keymap = {
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept", "fallback" },

		["<Tab>"] = {
			function(cmp)
				return cmp.select_next()
			end,
			"snippet_forward",
			"fallback",
		},
		["<S-Tab>"] = {
			function(cmp)
				return cmp.select_prev()
			end,
			"snippet_backward",
			"fallback",
		},

		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-k>"] = { "scroll_documentation_up", "fallback" },
		["<C-j>"] = { "scroll_documentation_down", "fallback" },
	},
	cmdline = {
		enabled = false,
		completion = { menu = { auto_show = true } },
		keymap = {
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 250,
			treesitter_highlighting = true,
			window = { border = "rounded" },
		},

		list = {
			selection = {
				preselect = true,
				auto_insert = function(ctx)
					return ctx.mode == "cmdline"
				end,
			},
		},

		menu = {

			border = "rounded",

			cmdline_position = function()
				if vim.g.ui_cmdline_pos ~= nil then
					local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
					return { pos[1] - 1, pos[2] }
				end
				local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
				return { vim.o.lines - height, 0 }
			end,

			draw = {
				columns = {
					{ "kind_icon", "label", gap = 1 },
					{ "kind" },
				},
				components = {
					kind_icon = {
						text = function(item)
							local kind = require("lspkind").symbol_map[item.kind] or ""
							return kind .. " "
						end,
						highlight = "CmpItemKind",
					},
					label = {
						text = function(item)
							return item.label
						end,
						highlight = "CmpItemAbbr",
					},
					kind = {
						text = function(item)
							return item.kind
						end,
						highlight = "CmpItemKind",
					},
				},
			},
		},
	},

})

require("luasnip.loaders.from_vscode").lazy_load()
