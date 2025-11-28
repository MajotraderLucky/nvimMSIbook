-- Neovim configuration with Lazy.nvim

-- Set leader keys BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load basic settings
require('config.init')

-- Initialize Lazy.nvim plugin manager
require('config.lazy')

-- Load keymaps
require('config.keymaps')
