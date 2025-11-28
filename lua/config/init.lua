-- Disable unused providers (removes :checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Python provider (pynvim via pipx)
vim.g.python3_host_prog = vim.fn.expand('~/.local/bin/pynvim-python')

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true

-- Bracket matching and highlighting
vim.opt.showmatch = true  -- Highlight matching brackets
vim.opt.matchtime = 2     -- How long to show matching bracket (in tenths of a second) 