-- Claude Code (protokół IDE jak w VS Code: diff accept/reject, selekcja, diagnostyka)
vim.pack.add({
	"https://github.com/coder/claudecode.nvim",
})

require("claudecode").setup({
	terminal = {
		split_side = "right",
		split_width_percentage = 0.25,
		provider = "snacks",
	},
	diff_opts = {
		layout = "vertical",
		open_in_new_tab = false,
		keep_terminal_focus = false,
	},
})

local map = vim.keymap.set

map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

-- Diff
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
