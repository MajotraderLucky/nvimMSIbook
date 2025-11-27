-- Treesitter for better syntax highlighting
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "yaml", "go", "rust", "toml", "python", "bash", "c", "cpp", "lua" },
        highlight = {
          enable = true,
        },
      })
    end,
  },
}
