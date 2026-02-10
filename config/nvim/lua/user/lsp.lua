---@mod user.lsp
---@brief [[
--- LSP related helpers
---@brief ]]

local M = {}

---@return lsp.ClientCapabilities
function M.make_client_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities.textDocument.completion.completionItem.snippetSupport = true

	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
			"insertTextFormat",
			"insertTextMode",
			"command",
		},
	}

	return capabilities
end

return M
