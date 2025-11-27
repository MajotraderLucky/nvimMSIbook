-- Editor plugins: nvim-tree and autopairs
return {
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require('nvim-tree').setup({
        view = {
          adaptive_size = true,  -- Automatically adjust width to content
          width = {
            min = 30,            -- Minimum width
          },
          -- No max - unlimited width
        },
        renderer = {
          indent_markers = {
            enable = true,
          },
        },
      })
    end,
  },

  -- Autopairs - automatic bracket pairing
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },
}
