-- Seamless <C-h/j/k/l> movement between nvim splits and herdr panes
-- (odpowiednik vim-tmux-navigator, ale dla herdr).
--
-- Dwie współpracujące strony:
--   * herdr side — companion plugin `vim-herdr-navigation` (navigate.sh),
--     podpięty pod ctrl+h/j/k/l w ~/.config/herdr/config.toml. Na każde
--     naciśnięcie sprawdza foreground process focusowanego panelu: jeśli
--     vim/nvim → forwarduje klawisz do panelu (`herdr pane send-keys`), inaczej
--     przesuwa focus herdr (`herdr pane focus`). Instalacja (raz, imperatywnie):
--       herdr plugin install paulbkim-dev/vim-herdr-navigation
--   * editor side — to co niżej. Gdy klawisz trafi do nvim: przesuń split;
--     na krawędzi oddaj focus sąsiedniemu panelowi herdr. Panel identyfikujemy
--     przez $HERDR_PANE_ID, które herdr wstrzykuje do każdego panelu.
--
-- W przeciwieństwie do upstream editor/nvim.lua obsługujemy TAKŻE terminal-mode
-- — bez tego <C-h/j/k/l> w :terminalu (np. lazygit/snacks) przeciekłoby do
-- programu zamiast nawigować.

local function nav(wincmd, dir)
	local prev = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. wincmd)
	if vim.api.nvim_get_current_win() ~= prev then
		return -- ruch w obrębie nvim
	end
	-- Krawędź splitu: przejdź do sąsiedniego panelu herdr. --pane wskazuje
	-- konkretnie NASZ panel (--current bierze globalny focus serwera, nie ten).
	local pane = vim.env.HERDR_PANE_ID
	if pane and pane ~= "" then
		vim.fn.system({ "herdr", "pane", "focus", "--direction", dir, "--pane", pane })
	end
end

local directions = {
	["<C-h>"] = { "h", "left" },
	["<C-j>"] = { "j", "down" },
	["<C-k>"] = { "k", "up" },
	["<C-l>"] = { "l", "right" },
}

-- Funkcyjny callback działa jak <cmd>: wykonuje się bez opuszczania trybu i nic
-- nie przecieka na stdin programu w :terminalu.
for lhs, spec in pairs(directions) do
	local fn = function()
		nav(spec[1], spec[2])
	end
	vim.keymap.set("n", lhs, fn, { silent = true, noremap = true, desc = "Navigate " .. spec[2] .. " (vim/herdr)" })
	vim.keymap.set("t", lhs, fn, { silent = true, noremap = true, desc = "Navigate " .. spec[2] .. " (vim/herdr)" })
end
