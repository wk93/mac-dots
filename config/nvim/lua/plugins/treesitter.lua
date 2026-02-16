vim.pack.add({{
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	version = "main"
}})

require("nvim-treesitter").setup {
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
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
			vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	}
}
