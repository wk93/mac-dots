require("config.options")
require("config.keymaps")
require("core.lsp")

-- theme
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" }
})
vim.cmd("colorscheme catppuccin-macchiato");

vim.lsp.enable('lua_ls')

vim.lsp.config('*', {
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			}
		}
	},
	root_markers = { '.git' },
})
