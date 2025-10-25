local lspconfig = require('lspconfig')

-- Setup Mason
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "gopls", "yamlls" } -- Golang and YAML LSPs
}

-- Golang LSP
lspconfig.gopls.setup {}

-- YAML LSP
lspconfig.yamlls.setup {
    settings = {
        yaml = {
            schemas = {
                kubernetes = "/*.yaml", -- Поддержка схем Kubernetes
            },
        },
    },
} 