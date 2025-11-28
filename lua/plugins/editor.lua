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
          icons = {
            git_placement = "after",
            glyphs = {
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        git = {
          enable = true,
          ignore = false,  -- Show gitignored files
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

  -- Surround - manipulate surrounding characters
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Default keymaps:
        -- ys{motion}{char} - add surround
        -- ds{char} - delete surround
        -- cs{target}{replacement} - change surround
        -- Examples:
        --   ysiw" - surround word with "
        --   cs"' - change " to '
        --   ds" - delete "
        --   yss) - surround line with ()
      })
    end,
  },

  -- Auto-save - automatically save files
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup({
        enabled = true,
        trigger_events = {
          immediate_save = { "BufLeave", "FocusLost" },
          defer_save = { "InsertLeave", "TextChanged" },
          cancel_deferred_save = { "InsertEnter" },
        },
        condition = function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils.data")

          -- Don't save for special buffers
          if fn.getbufvar(buf, "&modifiable") == 1 and
             utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true
          end
          return false
        end,
        write_all_buffers = false,  -- Only save current buffer
        debounce_delay = 1000,      -- Wait 1s after last change
      })
    end,
  },
}
