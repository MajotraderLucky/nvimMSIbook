# Neovim Configuration Roadmap

**Last Updated:** 2026-02-08  
**Version:** 1.0  
**Status:** Planning phase

## Project Overview

Систематическое развитие конфигурации Neovim с фокусом на стабильность, производительность и удобство разработки на Go/Rust.

---

## 🔴 CRITICAL - Исправление проблем стабильности

### Issue #1: Swap File Accumulation (240 files)

**Priority:** P0 (Critical)  
**Status:** Open  
**Discovered:** 2026-02-08  
**Impact:** Зависания при открытии файлов (2-4 минуты I/O блокировка)

**Current State:**
- 240 swap файлов в `~/.local/state/nvim/swap/`
- Самые старые файлы от августа 2025 (6 месяцев)
- Neovim проверяет каждый swap при открытии файла

**Root Cause:**
- Аварийные завершения Neovim (Ctrl+C, kill, crashes)
- Нет автоматической очистки старых swap файлов
- Нет лимитов на количество swap файлов

**Solution Steps:**
1. [ ] Создать backup swap файлов
2. [ ] Удалить файлы старше 7 дней
3. [ ] Добавить автоматическую очистку при старте
4. [ ] Настроить лимиты swap файлов
5. [ ] Добавить мониторинг количества swap файлов

**Files to modify:**
- `lua/config/init.lua` - добавить автоочистку
- New: `lua/utils/swap_manager.lua` - утилита управления swap

**Testing:**
```bash
# Before: ~240 files
# After: <10 files (only active sessions)
ls ~/.local/state/nvim/swap/ | wc -l
```

**Time Estimate:** 1-2 hours

---

### Issue #2: Zombie Neovim Processes

**Priority:** P0 (Critical)  
**Status:** Open  
**Discovered:** 2026-02-08  
**Impact:** File locks, memory leaks (240+ MB), потенциальные deadlocks

**Current State:**
```
PID    ELAPSED  MEM    CMD
5516   1 day    59 MB  nvim --embed
5800   1 day    58 MB  nvim --embed
6186   1 day    63 MB  nvim --embed
6635   1 day    65 MB  nvim --embed
```

**Root Cause:**
- Процессы `nvim --embed` от IDE плагинов (VSCode?)
- Не завершаются при закрытии IDE
- Держат file locks на открытые файлы

**Solution Steps:**
1. [ ] Идентифицировать источник `nvim --embed` процессов
2. [ ] Убить текущие зомби-процессы
3. [ ] Найти и отключить проблемный плагин IDE
4. [ ] Добавить мониторинг фоновых процессов
5. [ ] Создать команду для очистки зомби

**Files to modify:**
- `lua/config/keymaps.lua` - добавить `<leader>dk` (debug kill zombies)
- New: `lua/utils/process_monitor.lua` - мониторинг процессов

**Testing:**
```bash
# After fix: only 1 current nvim process
ps aux | grep -E '[n]vim' | wc -l
```

**Time Estimate:** 2-3 hours

---

### Issue #3: TUI Race Conditions

**Priority:** P1 (High)  
**Status:** Open  
**Discovered:** 2026-02-08  
**Impact:** Случайные зависания UI, ошибки при быстром закрытии

**Current State:**
- 50+ ошибок "TUI already stopped (race?)" за 3 месяца
- Происходит при быстром open/close или force quit
- Затрагивает плагины: telescope, trouble

**Root Cause:**
- Асинхронные UI операции в telescope/trouble
- Neovim пытается остановить TUI дважды
- Race condition между UI потоками

**Solution Steps:**
1. [ ] Добавить graceful shutdown hook
2. [ ] Увеличить timeout для UI операций
3. [ ] Проверить telescope/trouble на обновления
4. [ ] Добавить error handling для TUI операций
5. [ ] Протестировать быстрое open/close

**Files to modify:**
- `lua/config/init.lua` - добавить VimLeavePre autocmd
- `lua/plugins/navigation.lua` - настроить telescope timeouts
- `lua/plugins/diagnostics.lua` - настроить trouble timeouts

**Testing:**
```bash
# Monitor errors
tail -f ~/.local/state/nvim/log | grep TUI
```

**Time Estimate:** 2-4 hours

---

### Issue #4: LSP Configuration Gaps

**Priority:** P1 (High)  
**Status:** Open  
**Discovered:** 2026-02-08  
**Impact:** Задержки при старте LSP (5-10 секунд), отсутствие функционала

**Current Problems:**

#### 4a. rust-analyzer без конфигурации
```
WARN: rust-analyzer does not have a configuration
```
- Зависает при инициализации
- Нет настроек cargo, clippy

#### 4b. yamlls игнорирует dynamicRegistration
```
WARN: yamlls triggers registerCapability despite dynamicRegistration=false
```
- Лишние запросы к серверу
- Предупреждения в логах

#### 4c. shellcheck отсутствует
```
WARN: ShellCheck: disabling linting as no executable was found
```
- bashls не может делать linting
- Нет проверки shell скриптов

#### 4d. Нет общих LSP keybindings
- Отсутствует `on_attach` функция
- Нет единых биндингов для gd, K, gr, etc.

**Solution Steps:**
1. [ ] Добавить rust-analyzer конфигурацию
2. [ ] Исправить yamlls settings
3. [ ] Установить shellcheck
4. [ ] Создать общую on_attach функцию
5. [ ] Добавить LSP keybindings

**Files to modify:**
- `lua/plugins/lsp.lua` - добавить конфиги и on_attach

**Testing:**
```bash
# Check shellcheck
which shellcheck

# Check LSP logs
tail ~/.local/state/nvim/lsp.log | grep WARN
```

**Time Estimate:** 1-2 hours

---

## 🟡 HIGH - Улучшение функциональности

### Feature #5: Code Formatting

**Priority:** P2 (High)  
**Status:** Not Started  
**Impact:** Ручное форматирование кода, несогласованный стиль

**Current State:**
- Нет автоформатирования
- Нет интеграции с rustfmt, gofmt, black

**Desired State:**
- Format on save для всех языков
- Fallback на LSP форматирование
- Настраиваемые правила

**Solution Steps:**
1. [ ] Установить conform.nvim
2. [ ] Настроить formatters для Go, Rust, Python, Lua
3. [ ] Добавить format on save
4. [ ] Добавить manual format keymap
5. [ ] Интегрировать с Mason

**Files to create:**
- `lua/plugins/formatting.lua`

**Keymaps:**
- `<leader>cf` - Format current buffer
- `<leader>cF` - Format range (visual mode)

**Time Estimate:** 2-3 hours

---

### Feature #6: Git Integration (LazyGit)

**Priority:** P2 (High)  
**Status:** Not Started  
**Impact:** Приходится выходить из Neovim для git операций

**Current State:**
- Только gitsigns (hunks, blame)
- Нет UI для commits, push, pull
- Нет визуального git log

**Desired State:**
- LazyGit UI внутри Neovim
- Быстрые коммиты без выхода
- Интерактивный git log

**Solution Steps:**
1. [ ] Установить lazygit (system package)
2. [ ] Добавить lazygit.nvim плагин
3. [ ] Настроить floating window
4. [ ] Добавить keymaps

**Files to modify:**
- `lua/plugins/git.lua`
- `lua/config/keymaps.lua`

**Keymaps:**
- `<leader>gg` - Open LazyGit
- `<leader>gc` - Git commit (quick)
- `<leader>gl` - Git log

**Time Estimate:** 1 hour

---

### Feature #7: Debugging Support (DAP)

**Priority:** P2 (High)  
**Status:** Not Started  
**Impact:** Нет встроенной отладки, приходится использовать внешние инструменты

**Current State:**
- Нет DAP интеграции
- Отладка через print statements
- Нет breakpoints, step-through

**Desired State:**
- DAP для Go (delve) и Rust (codelldb)
- UI для breakpoints, variables, call stack
- Integration с LSP

**Solution Steps:**
1. [ ] Установить nvim-dap
2. [ ] Установить nvim-dap-ui
3. [ ] Настроить nvim-dap-go (delve)
4. [ ] Настроить codelldb для Rust
5. [ ] Добавить keymaps

**Files to create:**
- `lua/plugins/dap.lua`

**Keymaps:**
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>ds` - Step over
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>du` - Toggle DAP UI

**Time Estimate:** 4-6 hours

---

## 🟢 MEDIUM - Улучшение UX

### Feature #8: Which-Key Group Descriptions

**Priority:** P3 (Medium)  
**Status:** Not Started  
**Impact:** Непонятно что делают группы клавиш

**Current State:**
- Which-key показывает отдельные keymaps
- Нет описаний групп (`<leader>f`, `<leader>w`, etc.)
- Сложно запомнить структуру

**Desired State:**
- Группы с названиями ("+find", "+workspace", etc.)
- Иерархическая структура
- Подсказки для всех лидер-комбинаций

**Solution Steps:**
1. [ ] Добавить which-key.register() для групп
2. [ ] Описать все группы клавиш
3. [ ] Добавить иконки (если нужно)

**Files to modify:**
- `lua/plugins/navigation.lua` - добавить группы

**Time Estimate:** 30 minutes

---

### Feature #9: Telescope Ignore Patterns

**Priority:** P3 (Medium)  
**Status:** Not Started  
**Impact:** Поиск показывает ненужные файлы (node_modules, target/, etc.)

**Current State:**
- Telescope ищет во всех файлах
- Медленный поиск в больших проектах
- Лишние результаты

**Desired State:**
- Игнорировать `.git/`, `node_modules/`, `target/`
- Игнорировать `*.lock` файлы
- Настраиваемые паттерны

**Solution Steps:**
1. [ ] Добавить `file_ignore_patterns` в telescope setup
2. [ ] Протестировать на больших проектах
3. [ ] Добавить toggle ignore (если нужен поиск везде)

**Files to modify:**
- `lua/plugins/navigation.lua`

**Time Estimate:** 30 minutes

---

### Feature #10: Workspace Improvements

**Priority:** P3 (Medium)  
**Status:** Not Started  
**Impact:** Неудобное управление workspace терминалами

**Current Problems:**
- Нет функции остановки всех команд
- Нельзя перезапустить отдельный терминал
- Нет логирования команд
- Хардкод паролей БД в коде

**Desired State:**
- `<leader>wk` - Kill all workspace commands
- `<leader>wr` - Restart specific terminal
- Логирование в `~/.local/state/nvim/workspace.log`
- Database URL из environment variable

**Solution Steps:**
1. [ ] Добавить `M.stop_all()` функцию
2. [ ] Добавить `M.restart(term_num)` функцию
3. [ ] Добавить логирование в файл
4. [ ] Вынести DB_URL в переменную окружения
5. [ ] Добавить keymaps

**Files to modify:**
- `lua/config/workspace.lua`
- `lua/config/keymaps.lua`

**Time Estimate:** 2 hours

---

## 🔵 LOW - Nice to Have

### Feature #11: Startup Profiling

**Priority:** P4 (Low)  
**Status:** Not Started  
**Impact:** Нет visibility в производительность старта

**Desired Features:**
- Плагин для профилирования старта
- Dashboard с timing каждого плагина
- Оптимизация медленных плагинов

**Solution Steps:**
1. [ ] Установить dstein64/vim-startuptime
2. [ ] Добавить команду `:ProfileStartup`
3. [ ] Оптимизировать медленные плагины

**Time Estimate:** 1 hour

---

### Feature #12: Better Terminal Management

**Priority:** P4 (Low)  
**Status:** Not Started  
**Impact:** Неудобная работа с терминалами

**Desired Features:**
- toggleterm.nvim для floating terminals
- Именованные терминалы
- Сохранение истории команд

**Solution Steps:**
1. [ ] Установить toggleterm.nvim
2. [ ] Настроить layouts
3. [ ] Интегрировать с workspace.lua

**Time Estimate:** 2-3 hours

---

### Feature #13: Session Management

**Priority:** P4 (Low)  
**Status:** Not Started  
**Impact:** Нет автосохранения сессий

**Desired Features:**
- Автосохранение layout и открытых файлов
- Быстрое переключение между проектами
- Session persistence

**Solution Steps:**
1. [ ] Установить auto-session или persistence.nvim
2. [ ] Настроить автосохранение
3. [ ] Добавить session picker

**Time Estimate:** 1-2 hours

---

## 📊 Kanban Board

### 🔴 To Do (Backlog)

| Task ID | Title                          | Priority | Estimate |
|---------|--------------------------------|----------|----------|
| #1      | Swap File Cleanup              | P0       | 1-2h     |
| #2      | Kill Zombie Processes          | P0       | 2-3h     |
| #3      | Fix TUI Race Conditions        | P1       | 2-4h     |
| #4      | LSP Configuration Gaps         | P1       | 1-2h     |
| #5      | Code Formatting (conform.nvim) | P2       | 2-3h     |
| #6      | Git Integration (LazyGit)      | P2       | 1h       |
| #7      | Debugging Support (DAP)        | P2       | 4-6h     |
| #8      | Which-Key Group Descriptions   | P3       | 30min    |
| #9      | Telescope Ignore Patterns      | P3       | 30min    |
| #10     | Workspace Improvements         | P3       | 2h       |
| #11     | Startup Profiling              | P4       | 1h       |
| #12     | Better Terminal Management     | P4       | 2-3h     |
| #13     | Session Management             | P4       | 1-2h     |

### 🟡 In Progress

*Empty - ready to start*

### 🟢 Done

*Empty - start working!*

### ⛔ Blocked

*None*

---

## 🎯 Sprint Planning

### Sprint 1: Стабильность (P0 issues)

**Goal:** Устранить все критические проблемы стабильности  
**Duration:** 1-2 дня (5-9 часов работы)  
**Tasks:**
- [ ] #1: Swap File Cleanup
- [ ] #2: Kill Zombie Processes
- [ ] #3: Fix TUI Race Conditions
- [ ] #4: LSP Configuration Gaps

**Success Criteria:**
- Swap файлов < 10
- Нет zombie процессов
- Нет TUI errors в логах 24 часа
- Все LSP работают без WARN

---

### Sprint 2: Основной функционал (P1-P2)

**Goal:** Добавить ключевой недостающий функционал  
**Duration:** 2-3 дня (7-10 часов работы)  
**Tasks:**
- [ ] #5: Code Formatting
- [ ] #6: Git Integration
- [ ] #7: Debugging Support

**Success Criteria:**
- Format on save работает для всех языков
- LazyGit доступен через `<leader>gg`
- DAP настроен для Go/Rust

---

### Sprint 3: UX улучшения (P3)

**Goal:** Улучшить удобство использования  
**Duration:** 1 день (3-4 часа работы)  
**Tasks:**
- [ ] #8: Which-Key Groups
- [ ] #9: Telescope Ignore
- [ ] #10: Workspace Improvements

**Success Criteria:**
- Which-key показывает группы
- Telescope не ищет в node_modules
- Workspace управляется через keymaps

---

### Sprint 4: Опциональное (P4)

**Goal:** Nice-to-have features  
**Duration:** As time permits  
**Tasks:**
- [ ] #11: Startup Profiling
- [ ] #12: Better Terminals
- [ ] #13: Session Management

---

## 📈 Метрики успеха

### Performance

| Metric              | Current | Target  | Measure                      |
|---------------------|---------|---------|------------------------------|
| Startup time        | ~70ms   | <100ms  | nvim --startuptime           |
| Swap files          | 240     | <10     | ls swap/ wc -l               |
| Zombie processes    | 4       | 0       | ps aux grep nvim             |
| TUI errors/week     | ~3-5    | 0       | grep TUI log                 |
| LSP start time      | 5-10s   | <2s     | :LspInfo timing              |

### Functionality

| Feature             | Status       |
|---------------------|--------------|
| Auto-formatting     | [ ] Missing  |
| Git UI              | [ ] Missing  |
| Debugging           | [ ] Missing  |
| LSP complete        | [ ] Partial  |
| Swap auto-clean     | [ ] Missing  |

---

## 🔄 Update Log

| Date       | Sprint | Completed Tasks | Notes                    |
|------------|--------|-----------------|--------------------------|
| 2026-02-08 | -      | Investigation   | Identified 4 P0 issues   |

---

## 📝 Notes

### Technical Debt

1. **Security:** Database password хардкод в workspace.lua
2. **Performance:** Нет lazy loading для тяжелых плагинов
3. **Maintainability:** Нет автотестов для конфигурации

### Future Considerations

- Миграция на Neovim 0.12+ когда выйдет
- Рассмотреть альтернативы telescope (fzf-lua?)
- Добавить support для TypeScript/JavaScript

### Resources

- [Neovim Docs](https://neovim.io/doc/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Mason Registry](https://mason-registry.dev/)
- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)

---

**Roadmap Status:** Draft v1.0  
**Next Review:** После Sprint 1  
**Owner:** @ryazanov
