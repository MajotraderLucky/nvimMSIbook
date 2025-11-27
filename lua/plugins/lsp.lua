-- LSP Configuration
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- Note: rust-analyzer is managed by rustaceanvim plugin, not mason-lspconfig
        ensure_installed = { "gopls", "yamlls", "pyright", "bashls", "clangd" },
      })

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
              kubernetes = "/*.yaml",  -- Kubernetes schema support
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
    end,
  },
}
