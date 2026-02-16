vim.pack.add({ { src = "https://github.com/folke/lazydev.nvim", name = "lazydev" } })

require("lazydev").setup({
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
		-- disable when a .luarc.json file is found
		enabled = function(root_dir)
			return vim.uv.fs_stat(root_dir .. "nvim-pack-lock.json")
		end,
	},
})
