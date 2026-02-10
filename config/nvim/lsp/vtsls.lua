return {
	name = "vtsls",
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_dir = vim.fs.dirname(vim.fs.find({
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	}, { upward = true })[1]),
	reuse_client = function(client, config)
		return client.name == config.name and client.config.root_dir == config.root_dir
	end,
	capabilities = require("user.lsp").make_client_capabilities(),
	settings = {
		typescript = {
			suggest = {
				autoImports = true,
			},
		},
		vtsls = {
			enableMoveToFileCodeAction = true,
		},
	},
}
