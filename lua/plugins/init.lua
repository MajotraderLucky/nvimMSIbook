-- Packer setup
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- LSP Configuration & Plugins
    use 'neovim/nvim-lspconfig' -- Core LSP support
    use 'williamboman/mason.nvim' -- LSP/DAP installer
    use 'williamboman/mason-lspconfig.nvim'

    -- Autocompletion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip' -- Snippet engine

    -- Treesitter for better syntax highlighting
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- Additional tools
    use 'fatih/vim-go' -- Golang tooling

    -- File tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    -- Autopairs - automatic bracket pairing
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup{}
        end
    }
end)

-- Load plugin configurations
require('plugins.lsp')
require('plugins.treesitter')
require('plugins.nvim-tree')
require('plugins.cmp') 