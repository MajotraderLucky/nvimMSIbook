# План миграции Neovim: Packer → Lazy.nvim + Улучшения

**Дата начала:** 2025-11-27
**Текущая версия:** Packer + 11 плагинов
**Целевая версия:** Lazy.nvim + 20 плагинов (поэтапно)

---

## Текущее состояние

**Plugin Manager:** Packer.nvim
**Плагинов:** 11
**Строк кода:** ~426
**Языки:** Go, Rust, Python, YAML, Bash, C/C++
**Особенности:** Nvim 0.11+ LSP API ✅

---

## Стратегия миграции

**Принцип:** Постепенное улучшение без потери функциональности
**Подход:** Поэтапное тестирование каждого изменения
**Откат:** Каждый этап создает бэкап для возможности отката

---

## Этапы миграции

### ЭТАП 0: Подготовка [КРИТИЧЕСКИ ВАЖНО]

**Цель:** Создать точку восстановления и понять текущую конфигурацию

**Действия:**

- [ ] Создать полный бэкап текущей конфигурации
  ```bash
  cp -r ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
  ```

- [ ] Создать Git коммит текущего состояния
  ```bash
  cd ~/.config/nvim
  git add -A
  git commit -m "Checkpoint before Lazy.nvim migration"
  git tag pre-lazy-migration
  ```

- [ ] Протестировать текущую конфигурацию
  ```bash
  nvim --version  # Проверить версию Neovim
  nvim +checkhealth | grep -A 5 "ERROR"  # Проверить здоровье
  ```

- [ ] Задокументировать работающие функции
  - LSP работает для: Go, Rust, Python, YAML, Bash, C/C++
  - Автодополнение работает
  - Treesitter работает
  - nvim-tree работает
  - Autopairs работает

**Критерии успеха:**
- Бэкап создан
- Git коммит сохранен
- Нет критических ошибок в checkhealth
- Все LSP серверы запускаются

**Время:** 10 минут
**Риск:** Низкий

---

### ЭТАП 1: Миграция на Lazy.nvim [ФУНДАМЕНТ]

**Цель:** Заменить Packer на Lazy.nvim с сохранением всех текущих плагинов

**Текущие плагины для переноса:**
1. wbthomason/packer.nvim → удалить
2. neovim/nvim-lspconfig → перенести
3. williamboman/mason.nvim → перенести
4. williamboman/mason-lspconfig.nvim → перенести
5. hrsh7th/nvim-cmp → перенести
6. hrsh7th/cmp-nvim-lsp → перенести
7. saadparwaiz1/cmp_luasnip → перенести
8. L3MON4D3/LuaSnip → перенести
9. nvim-treesitter/nvim-treesitter → перенести
10. fatih/vim-go → перенести
11. nvim-tree/nvim-tree.lua → перенести
12. nvim-tree/nvim-web-devicons → перенести
13. windwp/nvim-autopairs → перенести
14. mrcjkb/rustaceanvim → перенести

**Действия:**

- [ ] 1.1 Создать новую структуру каталогов
  ```bash
  mkdir -p ~/.config/nvim/lua/config
  mkdir -p ~/.config/nvim/lua/plugins
  ```

- [ ] 1.2 Создать `lua/config/lazy.lua` - bootstrap Lazy.nvim
  ```lua
  -- Автоматическая установка lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup("plugins", {
    checker = { enabled = false },
    change_detection = { notify = false },
  })
  ```

- [ ] 1.3 Переписать init.lua для Lazy.nvim
  ```lua
  -- Загрузить базовые настройки
  require('config.init')

  -- Инициализировать Lazy.nvim
  require('config.lazy')

  -- Настройки LSP, Treesitter, CMP (переместить из init.lua в отдельные файлы)
  ```

- [ ] 1.4 Создать файлы плагинов в `lua/plugins/`:
  - [ ] `lua/plugins/lsp.lua` - LSP + Mason
  - [ ] `lua/plugins/completion.lua` - nvim-cmp + LuaSnip
  - [ ] `lua/plugins/treesitter.lua` - Treesitter
  - [ ] `lua/plugins/editor.lua` - nvim-tree, autopairs
  - [ ] `lua/plugins/language.lua` - vim-go, rustaceanvim

- [ ] 1.5 Удалить Packer
  ```bash
  rm -rf ~/.local/share/nvim/site/pack/packer
  rm ~/.config/nvim/plugin/packer_compiled.lua
  ```

- [ ] 1.6 Первый запуск Lazy.nvim
  ```bash
  nvim +Lazy
  # Должен появиться UI с установкой плагинов
  ```

- [ ] 1.7 Протестировать все функции
  - [ ] LSP работает для всех языков
  - [ ] Автодополнение работает
  - [ ] Treesitter подсветка работает
  - [ ] nvim-tree открывается
  - [ ] Autopairs работает

**Критерии успеха:**
- Все 14 плагинов установлены через Lazy
- Нет ошибок при запуске nvim
- LSP работает для всех языков
- `:Lazy` показывает все плагины зелеными

**Откат при проблемах:**
```bash
rm -rf ~/.config/nvim
cp -r ~/.config/nvim.backup.YYYYMMDD_HHMMSS ~/.config/nvim
```

**Время:** 30-40 минут
**Риск:** Средний (но с откатом)

---

### ЭТАП 2: Базовые улучшения UI/UX [БЫСТРЫЕ ПОБЕДЫ]

**Цель:** Добавить визуальные улучшения без изменения workflow

**Новые плагины:**

1. **nvim-web-devicons** - уже есть ✅
2. **lualine.nvim** - красивая statusline
3. **bufferline.nvim** - вкладки буферов

**Действия:**

- [ ] 2.1 Создать `lua/plugins/ui.lua`
  ```lua
  return {
    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
          options = {
            theme = "auto",
            component_separators = "|",
            section_separators = "",
          },
        })
      end,
    },

    -- Bufferline
    {
      "akinsho/bufferline.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("bufferline").setup({
          options = {
            diagnostics = "nvim_lsp",
            offsets = {
              { filetype = "NvimTree", text = "File Explorer", text_align = "center" }
            },
          },
        })
      end,
    },
  }
  ```

- [ ] 2.2 Установить плагины
  ```bash
  nvim +Lazy sync
  ```

- [ ] 2.3 Протестировать
  - [ ] Statusline отображается внизу
  - [ ] Bufferline отображается вверху
  - [ ] Переключение между буферами работает (`:bnext`, `:bprev`)

**Критерии успеха:**
- Красивая statusline с информацией о файле, git branch, LSP
- Вкладки буферов вверху экрана
- Нет визуальных глюков

**Время:** 10 минут
**Риск:** Низкий

---

### ЭТАП 3: Навигация и поиск [PRODUCTIVITY BOOST]

**Цель:** Добавить мощные инструменты поиска и навигации

**Новые плагины:**

1. **telescope.nvim** - fuzzy finder
2. **telescope-fzf-native.nvim** - ускорение поиска
3. **which-key.nvim** - подсказки по клавишам

**Действия:**

- [ ] 3.1 Создать `lua/plugins/navigation.lua`
  ```lua
  return {
    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        require("telescope").setup()
        require("telescope").load_extension("fzf")
      end,
    },

    -- Which-key
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup()
      end,
    },
  }
  ```

- [ ] 3.2 Добавить keymaps в `lua/config/keymaps.lua`
  ```lua
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
  vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
  ```

- [ ] 3.3 Установить зависимости
  ```bash
  # Для telescope-fzf-native требуется make и gcc
  sudo apt-get install build-essential  # Debian/Ubuntu
  ```

- [ ] 3.4 Установить плагины
  ```bash
  nvim +Lazy sync
  ```

- [ ] 3.5 Протестировать
  - [ ] `<leader>ff` - поиск файлов работает
  - [ ] `<leader>fg` - grep по проекту работает
  - [ ] `<leader>fb` - список буферов работает
  - [ ] `<leader>` - which-key показывает доступные команды

**Критерии успеха:**
- Telescope поиск файлов молниеносно быстрый
- Live grep находит текст по всему проекту
- Which-key показывает подсказки при нажатии leader key

**Время:** 15 минут
**Риск:** Низкий

---

### ЭТАП 4: Git интеграция [DEVELOPER TOOLS]

**Цель:** Видеть изменения Git прямо в редакторе

**Новые плагины:**

1. **gitsigns.nvim** - git decorations и hunks

**Действия:**

- [ ] 4.1 Создать `lua/plugins/git.lua`
  ```lua
  return {
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({
          signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
          },
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            -- Навигация по hunks
            vim.keymap.set('n', ']c', function()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, {expr=true, buffer = bufnr, desc = "Next hunk"})

            vim.keymap.set('n', '[c', function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, {expr=true, buffer = bufnr, desc = "Previous hunk"})

            -- Действия с hunks
            vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer = bufnr, desc = "Stage hunk"})
            vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer = bufnr, desc = "Reset hunk"})
            vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer = bufnr, desc = "Preview hunk"})
            vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {buffer = bufnr, desc = "Blame line"})
          end,
        })
      end,
    },
  }
  ```

- [ ] 4.2 Установить плагин
  ```bash
  nvim +Lazy sync
  ```

- [ ] 4.3 Протестировать в git репозитории
  - [ ] Изменить файл - должны появиться знаки +/~ в gutter
  - [ ] `]c` / `[c` - навигация по изменениям
  - [ ] `<leader>hp` - preview изменений
  - [ ] `<leader>hb` - git blame текущей строки

**Критерии успеха:**
- Видны изменения в левом gutter (+, ~, -)
- Навигация по изменениям работает
- Preview и blame работают

**Время:** 10 минут
**Риск:** Низкий

---

### ЭТАП 5: Улучшения редактирования [TEXT MANIPULATION]

**Цель:** Добавить мощные инструменты для работы с текстом

**Новые плагины:**

1. **nvim-surround** - работа с окружением
2. **nvim-autopairs** - уже есть ✅
3. **auto-save.nvim** - автосохранение

**Действия:**

- [ ] 5.1 Добавить в `lua/plugins/editor.lua`
  ```lua
  -- Nvim-surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Auto-save
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup({
        enabled = true,
        execution_message = {
          message = function()
            return ""  -- Не показывать сообщение о сохранении
          end,
        },
        trigger_events = {
          immediate_save = { "BufLeave", "FocusLost" },
          defer_save = { "InsertLeave", "TextChanged" },
        },
      })
    end,
  },
  ```

- [ ] 5.2 Установить плагины
  ```bash
  nvim +Lazy sync
  ```

- [ ] 5.3 Протестировать nvim-surround
  - [ ] `ysiw"` - обернуть слово в кавычки
  - [ ] `cs"'` - заменить " на '
  - [ ] `ds"` - удалить кавычки
  - [ ] `yss)` - обернуть строку в скобки

- [ ] 5.4 Протестировать auto-save
  - [ ] Изменить файл → выйти из insert mode → файл сохранен
  - [ ] Переключиться на другой буфер → файл сохранен

**Критерии успеха:**
- Nvim-surround работает для всех операций
- Файлы автоматически сохраняются при изменениях
- Нет назойливых уведомлений о сохранении

**Время:** 10 минут
**Риск:** Низкий

---

### ЭТАП 6: Диагностика и отладка [ОПЦИОНАЛЬНО]

**Цель:** Улучшить отображение ошибок и добавить отладчик

**Новые плагины:**

1. **trouble.nvim** - красивая панель диагностики
2. **nvim-dap** - отладчик (только если нужен)
3. **nvim-dap-ui** - UI для отладчика
4. **nvim-dap-go** - адаптер для Go
5. **nvim-dap-python** - адаптер для Python

**Действия:**

- [ ] 6.1 Установить Trouble (минимум)
  ```lua
  -- lua/plugins/diagnostics.lua
  return {
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("trouble").setup()
      end,
    },
  }
  ```

- [ ] 6.2 Добавить keymaps
  ```lua
  vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
  vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
  vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
  ```

- [ ] 6.3 Тестировать
  - [ ] Открыть файл с ошибками
  - [ ] `<leader>xx` - показать все ошибки проекта
  - [ ] Переход по ошибкам работает

**DAP (устанавливать только если нужна отладка):**

- [ ] 6.4 Установить DAP (если нужен)
  ```lua
  -- lua/plugins/dap.lua
  return {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
      },
      config = function()
        require("dapui").setup()
        require("dap-go").setup()
        require("dap-python").setup("python3")

        -- Keymaps
        vim.keymap.set('n', '<F5>', require('dap').continue)
        vim.keymap.set('n', '<F10>', require('dap').step_over)
        vim.keymap.set('n', '<F11>', require('dap').step_into)
        vim.keymap.set('n', '<F12>', require('dap').step_out)
        vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint)
      end,
    },
  }
  ```

- [ ] 6.5 Тестировать отладчик
  - [ ] Установить breakpoint на строке
  - [ ] F5 - запустить отладку
  - [ ] F10 - step over
  - [ ] Просмотр переменных работает

**Критерии успеха (минимум):**
- Trouble показывает все ошибки проекта
- Навигация по ошибкам удобная

**Критерии успеха (с DAP):**
- Breakpoints работают
- Step over/into работает
- Просмотр переменных работает

**Время:** 15-30 минут (зависит от DAP)
**Риск:** Низкий (Trouble), Средний (DAP)

---

### ЭТАП 7: Финализация и оптимизация

**Цель:** Очистить конфигурацию и создать документацию

**Действия:**

- [ ] 7.1 Очистить старые файлы
  ```bash
  # Удалить старые конфиги Packer (если еще остались)
  rm -rf ~/.config/nvim/plugin/packer_compiled.lua
  rm -rf ~/.local/share/nvim/site/pack/packer
  ```

- [ ] 7.2 Проверить производительность
  ```bash
  nvim --startuptime startup.log
  # Проверить время загрузки - должно быть < 100ms
  ```

- [ ] 7.3 Запустить полную проверку
  ```bash
  nvim +checkhealth
  ```

- [ ] 7.4 Обновить README.md
  - [ ] Список всех плагинов
  - [ ] Keymaps
  - [ ] Скриншоты (опционально)

- [ ] 7.5 Создать финальный коммит
  ```bash
  cd ~/.config/nvim
  git add -A
  git commit -m "Complete migration to Lazy.nvim + new plugins"
  git tag v2.0-lazy-nvim
  ```

- [ ] 7.6 Удалить старые бэкапы (через месяц использования)
  ```bash
  rm -rf ~/.config/nvim.backup.*
  ```

**Критерии успеха:**
- Startup time < 100ms
- Нет ошибок в checkhealth
- Все плагины работают
- Документация обновлена

**Время:** 20 минут
**Риск:** Низкий

---

## Полный чек-лист плагинов

### Текущие плагины (14) - Этап 1
- [ ] neovim/nvim-lspconfig
- [ ] williamboman/mason.nvim
- [ ] williamboman/mason-lspconfig.nvim
- [ ] hrsh7th/nvim-cmp
- [ ] hrsh7th/cmp-nvim-lsp
- [ ] saadparwaiz1/cmp_luasnip
- [ ] L3MON4D3/LuaSnip
- [ ] nvim-treesitter/nvim-treesitter
- [ ] fatih/vim-go
- [ ] nvim-tree/nvim-tree.lua
- [ ] nvim-tree/nvim-web-devicons
- [ ] windwp/nvim-autopairs
- [ ] mrcjkb/rustaceanvim
- [ ] folke/lazy.nvim (новый plugin manager)

### Новые плагины UI (2) - Этап 2
- [ ] nvim-lualine/lualine.nvim
- [ ] akinsho/bufferline.nvim

### Новые плагины навигации (3) - Этап 3
- [ ] nvim-telescope/telescope.nvim
- [ ] nvim-telescope/telescope-fzf-native.nvim
- [ ] folke/which-key.nvim

### Новые плагины Git (1) - Этап 4
- [ ] lewis6991/gitsigns.nvim

### Новые плагины редактирования (2) - Этап 5
- [ ] kylechui/nvim-surround
- [ ] okuuva/auto-save.nvim

### Новые плагины диагностики (1+5) - Этап 6
- [ ] folke/trouble.nvim (обязательно)
- [ ] mfussenegger/nvim-dap (опционально)
- [ ] rcarriga/nvim-dap-ui (опционально)
- [ ] theHamsta/nvim-dap-virtual-text (опционально)
- [ ] leoluz/nvim-dap-go (опционально)
- [ ] mfussenegger/nvim-dap-python (опционально)

**Итого:** 14 → 22 плагина (минимум) или 27 плагинов (с DAP)

---

## Временные затраты

| Этап | Описание | Время | Риск |
|------|----------|-------|------|
| 0 | Подготовка и бэкап | 10 мин | Низкий |
| 1 | Миграция на Lazy.nvim | 30-40 мин | Средний |
| 2 | UI улучшения | 10 мин | Низкий |
| 3 | Навигация и поиск | 15 мин | Низкий |
| 4 | Git интеграция | 10 мин | Низкий |
| 5 | Улучшения редактирования | 10 мин | Низкий |
| 6 | Диагностика | 15-30 мин | Низкий-Средний |
| 7 | Финализация | 20 мин | Низкий |
| **ИТОГО** | **Весь процесс** | **2-2.5 часа** | **Управляемый** |

---

## Стратегия тестирования

### После каждого этапа:

1. **Запустить nvim** - проверить, что нет ошибок при старте
2. **Проверить checkhealth** - `nvim +checkhealth`
3. **Протестировать новые функции** - согласно чек-листу этапа
4. **Проверить старые функции** - LSP, автодополнение, навигация
5. **Создать коммит** - если всё работает

### Если что-то сломалось:

1. **Проверить логи** - `:messages` в nvim
2. **Проверить Lazy UI** - `:Lazy` для статуса плагинов
3. **Откатиться к предыдущему коммиту**
   ```bash
   git reset --hard HEAD~1
   nvim +Lazy sync
   ```
4. **Или откатиться к бэкапу**
   ```bash
   rm -rf ~/.config/nvim
   cp -r ~/.config/nvim.backup.YYYYMMDD_HHMMSS ~/.config/nvim
   ```

---

## Критерии завершения миграции

### Обязательные:
- [+] Все текущие плагины работают через Lazy.nvim
- [+] LSP работает для всех языков (Go, Rust, Python, YAML, Bash, C/C++)
- [+] Автодополнение работает
- [+] Treesitter подсветка работает
- [+] Нет ошибок при запуске nvim
- [+] Startup time < 100ms

### Желательные:
- [+] Telescope поиск работает
- [+] Which-key показывает подсказки
- [+] Gitsigns показывает изменения
- [+] Lualine/bufferline красиво отображаются
- [+] Nvim-surround работает
- [+] Auto-save сохраняет файлы

### Опциональные:
- [+] Trouble показывает диагностику
- [+] DAP отладчик работает (если установлен)

---

## Полезные команды для управления

### Lazy.nvim команды:
```vim
:Lazy                 " Открыть UI менеджера плагинов
:Lazy sync            " Обновить и установить плагины
:Lazy update          " Обновить все плагины
:Lazy clean           " Удалить неиспользуемые плагины
:Lazy check           " Проверить обновления
:Lazy profile         " Профилирование загрузки
```

### Диагностика:
```vim
:checkhealth          " Проверить здоровье конфигурации
:messages             " Показать сообщения/ошибки
:LspInfo              " Информация о LSP серверах
:Mason                " Открыть Mason (установщик LSP)
```

### Telescope команды (после Этапа 3):
```vim
:Telescope find_files       " Поиск файлов
:Telescope live_grep        " Grep по проекту
:Telescope buffers          " Список буферов
:Telescope lsp_references   " LSP ссылки
:Telescope diagnostics      " Диагностика
```

---

## Следующие шаги после завершения

### Возможные дополнения:
1. **Темы оформления** - catppuccin, tokyonight
2. **Markdown рендеринг** - render-markdown.nvim (если работаете с документацией)
3. **Русская раскладка** - langmap для работы без переключения (если нужно)
4. **Refactoring tools** - refactoring.nvim
5. **Testing frameworks** - neotest
6. **Project management** - project.nvim

### Оптимизации:
1. Профилирование загрузки - `:Lazy profile`
2. Настройка lazy loading для редко используемых плагинов
3. Тонкая настройка LSP для конкретных проектов

---

## Контакты и поддержка

**Документация:**
- Lazy.nvim: https://github.com/folke/lazy.nvim
- Telescope: https://github.com/nvim-telescope/telescope.nvim
- Which-key: https://github.com/folke/which-key.nvim

**Проблемы:**
- Создать issue в репозитории плагина
- Проверить `:checkhealth` для диагностики
- Откатиться к бэкапу при критических ошибках

---

**Автор плана:** Claude Code
**Дата создания:** 2025-11-27
**Версия плана:** 1.0
