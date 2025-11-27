-- Language-specific plugins
return {
  -- Go tooling
  {
    "fatih/vim-go",
    ft = "go",  -- Lazy load on Go files
  },

  -- Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = "rust",  -- Lazy load on Rust files
  },
}
