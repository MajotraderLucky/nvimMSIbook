-- Navigation and search improvements
return {
  -- Telescope - fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
            },
            n = {
              ["<Esc>"] = actions.close,
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
          },
        },
      })
    end,
  },

  -- Telescope FZF native - performance optimization
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- Which-key - keyboard shortcut hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "modern",
        win = {
          border = "rounded",
        },
      })

      -- Register leader key groups
      wk.add({
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>e", desc = "Toggle file explorer" },
        { "<leader>x", desc = "Close buffer" },
        { "<leader>X", desc = "Force close buffer" },
        { "<leader>q", desc = "Quit" },
        { "<leader>Q", desc = "Quit all without saving" },
        { "<leader>1", desc = "Go to buffer 1" },
        { "<leader>2", desc = "Go to buffer 2" },
        { "<leader>3", desc = "Go to buffer 3" },
        { "<leader>4", desc = "Go to buffer 4" },
        { "<leader>5", desc = "Go to buffer 5" },
      })
    end,
  },
}
