local eslint = dofile(vim.fn.stdpath("config") .. "/lsp/eslint.lua")
if eslint.disabled then
	return
end

local function has_eslint_client(bufnr)
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if c.name == "eslint" then
			return true
		end
	end
	return false
end

local group = vim.api.nvim_create_augroup("UserEslintAutostart", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufFilePost", "FileType" }, {
	group = group,
	callback = function(args)
		local bufnr = args.buf
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end

		local ft = vim.bo[bufnr].filetype
		local ok_ft = (
			ft == "javascript"
			or ft == "javascriptreact"
			or ft == "typescript"
			or ft == "typescriptreact"
			or ft == "vue"
			or ft == "svelte"
			or ft == "astro"
			or ft == "htmlangular"
		)
		if not ok_ft then
			return
		end

		if has_eslint_client(bufnr) then
			return
		end

		local root_dir = eslint.find_root(bufnr)
		if not root_dir then
			return
		end

		local cfg = eslint.make_config(root_dir)
		vim.lsp.start(cfg, { bufnr = bufnr })
	end,
})
