-- Load basic config first
require('config.init')

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
        config = function()
            require('nvim-tree').setup()
        end
    }

    -- Autopairs - automatic bracket pairing
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup{}
        end
    }

    -- Rust support
    use {
        'mrcjkb/rustaceanvim',
        version = '^5',
        lazy = false,
    }
end)

require('nvim-treesitter.configs').setup {
    ensure_installed = { "yaml", "go", "rust", "toml", "python", "bash", "c", "cpp", "lua" },
    highlight = {
        enable = true,
    },
}

require("mason").setup()
require("mason-lspconfig").setup {
    -- Note: rust-analyzer is managed by rustaceanvim plugin, not mason-lspconfig
    ensure_installed = { "gopls", "yamlls", "pyright", "bashls", "clangd" }
}

-- LSP Configuration using new nvim 0.11+ API
-- Golang LSP
vim.lsp.config.gopls = {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.work', 'go.mod', '.git' },
}

-- YAML LSP
vim.lsp.config.yamlls = {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
    root_markers = { '.git' },
    settings = {
        yaml = {
            schemas = {
                kubernetes = "/*.yaml", -- Поддержка схем Kubernetes
            },
        },
    },
}

-- Python LSP
vim.lsp.config.pyright = {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
}

-- Bash LSP
vim.lsp.config.bashls = {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/bash-language-server', 'start' },
    filetypes = { 'sh', 'bash' },
    root_markers = { '.git' },
}

-- C/C++ LSP
vim.lsp.config.clangd = {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', '.clangd', '.git' },
}

-- Enable LSP servers
vim.lsp.enable({ 'gopls', 'yamlls', 'pyright', 'bashls', 'clangd' })

-- Note: rust-analyzer is configured automatically by rustaceanvim plugin

local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }),
})
