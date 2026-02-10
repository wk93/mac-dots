-- mini.nvim
local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		-- Uncomment next line to use 'stable' branch
		-- '--branch', 'stable',
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
-- mini.nvim

-- mini deps
require("mini.deps").setup()
local add = MiniDeps.add
add({ source = "catppuccin/nvim", name = "catppuccin" })
add({ source = "folke/snacks.nvim", name = "snacks" })
add({ source = "stevearc/conform.nvim", name = "conform" })
add({ source = "folke/trouble.nvim", name = "trouble" })
-- mini deps

-- nvim config
vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true

vim.o.cursorline = true

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

vim.cmd.colorscheme("catppuccin-macchiato")

vim.opt.updatetime = 300
-- nvim config

-- completion
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
	snippets = {
		-- Load custom file with global snippets first (adjust for Windows)
		-- gen_loader.from_file('~/.config/nvim/snippets/global.json'),

		-- Load snippets based on current language by reading files from
		-- "snippets/" subdirectories from 'runtimepath' directories.
		gen_loader.from_lang(),
	},
})

require("mini.completion").setup()
-- completion

-- lsp config
vim.lsp.enable({
	"vtsls",
	"lua_ls",
})
-- lsp config

-- formatting
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },

		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		markdown = { "prettierd" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
	notify_on_error = true,
})

-- formatting

-- errors
require("trouble").setup()
-- errors

-- keymaps
local nmap = function(lhs, rhs, desc)
	-- See `:h vim.keymap.set()`
	vim.keymap.set("n", lhs, rhs, { desc = desc })
end

local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end

local imap_expr = function(lhs, rhs)
	vim.keymap.set("i", lhs, rhs, { expr = true })
end

---- snacks picker
nmap_leader("fb", function()
	Snacks.picker.buffers()
end, "Buffers")
nmap_leader("ff", function()
	Snacks.picker.git_files()
end, "Files")
nmap_leader("fg", function()
	Snacks.picker.grep()
end, "Grep live")

---- lsp
nmap("gd", function()
	Snacks.picker.lsp_definitions()
end, "Goto Definition")
nmap("gD", function()
	Snacks.picker.lsp_declarations()
end, "Goto Declaration")
nmap("gr", function()
	Snacks.picker.lsp_references()
end, "References")
nmap("gI", function()
	Snacks.picker.lsp_implementations()
end, "Goto Implementation")

nmap("gy", function()
	Snacks.picker.lsp_type_definitions()
end, "Goto T[y]pe Definition")
nmap("gai", function()
	Snacks.picker.lsp_incoming_calls()
end, "C[a]lls Incoming")
nmap("gao", function()
	Snacks.picker.lsp_outgoing_calls()
end, "C[a]lls Outgoing")

nmap_leader("ss", function()
	Snacks.picker.lsp_symbols()
end, "LSP Symbols")
nmap_leader("sS", function()
	Snacks.picker.lsp_workspace_symbols()
end, "LSP Workspace Symbols")
----lsp

---- snacks picker
imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
---- snacks picker

-- diagnostics nav (native)
nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
nmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")

nmap("]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, "Next error")

nmap("[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, "Prev error")

-- show float on demand (optional, lepsze niż zawsze CursorHold)
nmap("gl", function()
	vim.diagnostic.open_float(nil, {
		focus = false,
		scope = "cursor",
		border = "rounded",
		source = "if_many",
	})
end, "Line diagnostics")

-- trouble
nmap_leader("xx", function()
	require("trouble").toggle()
end, "Trouble: Toggle")

nmap_leader("xw", function()
	require("trouble").toggle("diagnostics")
end, "Trouble: Workspace diagnostics")

nmap_leader("xb", function()
	require("trouble").toggle("diagnostics", { filter = { buf = 0 } })
end, "Trouble: Buffer diagnostics")

-- trouble next/prev + jump
nmap("]t", function()
	require("trouble").next({ skip_groups = true, jump = true })
end, "Trouble: Next")

nmap("[t", function()
	require("trouble").prev({ skip_groups = true, jump = true })
end, "Trouble: Prev")

-- keymaps
