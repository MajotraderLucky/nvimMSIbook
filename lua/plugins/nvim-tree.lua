require('nvim-tree').setup({
  view = {
    adaptive_size = true,  -- Автоматически подстраивает ширину под содержимое
    width = {
      min = 30,            -- Минимальная ширина
    },
    -- Без max - ширина не ограничена
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
}) 