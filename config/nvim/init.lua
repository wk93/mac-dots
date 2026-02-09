-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
-- mini.nvim

-- mini deps
require('mini.deps').setup()
local add = MiniDeps.add
add({ source = "catppuccin/nvim", name = "catppuccin" })

add({ source = "folke/snacks.nvim", name = "snacks" })
-- mini deps

-- nvim config
vim.g.mapleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.cmd.colorscheme("catppuccin-macchiato")
-- nvim config

-- keymaps
local nmap = function(lhs, rhs, desc)
  -- See `:h vim.keymap.set()`
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

---- snacks picker
nmap_leader('fb', function() Snacks.picker.buffers() end, 'Buffers')
nmap_leader('ff', function() Snacks.picker.git_files() end, 'Files')
nmap_leader('fg', function() Snacks.picker.grep() end, 'Grep live')
---- snacks picker
-- keymaps
