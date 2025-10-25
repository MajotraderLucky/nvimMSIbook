require('nvim-treesitter.configs').setup {
    ensure_installed = { "yaml", "go" },
    highlight = {
        enable = true,
    },
} 