vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

-- Navigation: <C-h/j/k/l> obsługiwane przez plugins/herdr-navigation.lua
-- (seamless nvim splits <-> herdr panes).

-- Splits (jak w tmux: | i -)
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Resize (leader + H/J/K/L)
vim.keymap.set("n", "<leader>H", "<cmd>vertical resize -5<cr>", { desc = "Resize left" })
vim.keymap.set("n", "<leader>L", "<cmd>vertical resize +5<cr>", { desc = "Resize right" })
vim.keymap.set("n", "<leader>J", "<cmd>resize -5<cr>", { desc = "Resize down" })
vim.keymap.set("n", "<leader>K", "<cmd>resize +5<cr>", { desc = "Resize up" })

-- LSP
vim.keymap.set("n", "<leader>li", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
