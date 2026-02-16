local NVIM_ROOT = vim.fs.normalize(vim.fn.expand("~/.dotfiles/config/nvim"))

local function is_subpath(path, root)
	path = vim.fs.normalize(path)
	root = vim.fs.normalize(root)
	return path:sub(1, #root) == root
end

local function root_dir(fname)
	fname = fname or vim.api.nvim_buf_get_name(0)
	fname = vim.fs.normalize(fname)

	if is_subpath(fname, NVIM_ROOT) then
		return NVIM_ROOT
	end

	return vim.fs.root(fname, {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"selene.toml",
		"selene.yml",
		"stylua.toml",
		"nvim-pack-lock.json",
	})
end

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },

	root_markers = {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"selene.toml",
		"selene.yml",
		"stylua.toml",
		"nvim-pack-lock.json",
	},

	root_dir = root_dir,
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,

	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},

			diagnostics = {
				globals = { "vim" },
			},

			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},

			telemetry = { enable = false },
		},
	},
}
