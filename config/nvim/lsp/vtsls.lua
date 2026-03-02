return {
	name = "vtsls",
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
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
	settings = {
		typescript = {
			suggest = {
				autoImports = true,
			},
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		javascript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		vtsls = {
			enableMoveToFileCodeAction = true,
		},
	},
}
