vim.pack.add({ {
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	version = "main",
} })

require("nvim-treesitter").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"bash",
					"css",
					"html",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"rust",
					"scss",
					"svelte",
					"swift",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"yaml",
				},
				auto_install = true,
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local function should_disable_for_buf(buf)
						local max_filesize = 100 * 1024 -- 100 KiB
						local name = vim.api.nvim_buf_get_name(buf)
						if name == "" then
							return false
						end

						local ok, stats = pcall(vim.loop.fs_stat, name)
						return ok and stats and stats.size > max_filesize
					end

					if vim.bo[args.buf].buftype ~= "" then
						return
					end
					if should_disable_for_buf(args.buf) then
						return
					end

					pcall(vim.treesitter.start, args.buf)
				end,
			})
			vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	},
})
