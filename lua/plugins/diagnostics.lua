-- Diagnostics and error display
return {
  -- Trouble - beautiful diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    opts = {
      auto_close = false,
      auto_open = false,
      auto_preview = true,
      focus = true,
      win = {
        position = "bottom",
        size = 10,
      },
      keys = {
        q = "close",
        ["<esc>"] = "cancel",
        r = "refresh",
        ["<cr>"] = "jump_close",
        ["<tab>"] = "jump",
        ["<c-x>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        K = "hover",
        p = "preview",
        k = "prev",
        j = "next",
      },
    },
  },
}
