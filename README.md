# Neovim Configuration

Modern Neovim configuration using Lazy.nvim plugin manager.

## Features

- **Plugin Manager**: Lazy.nvim with lazy loading for optimal performance
- **LSP Support**: Full LSP integration for Go, Rust, Python, YAML, Bash, C/C++
- **Autocompletion**: nvim-cmp with LuaSnip snippets
- **Syntax Highlighting**: Tree-sitter with 9 parsers
- **UI Enhancements**: Lualine statusline and Bufferline tabs
- **File Navigation**: Telescope fuzzy finder and NvimTree file explorer
- **Git Integration**: Gitsigns for visual git decorations
- **Diagnostics**: Trouble.nvim for beautiful error display
- **Editing Tools**: nvim-surround and auto-save

## Requirements

### Essential
- **Neovim** >= 0.11.0
- **Git** - for plugin management
- **Build tools** (gcc, make) - for native extensions (telescope-fzf-native, LuaSnip jsregexp)

### Recommended (for Telescope)
- **ripgrep** (rg) - Fast text search for `:Telescope live_grep`
- **fd** - Fast file finding for `:Telescope find_files`

### Python Provider (optional)
- **pynvim** - Required for Python-based plugins
```bash
pipx install pynvim
```

## Installation

### 1. Clone this repository
```bash
git clone git@github.com:MajotraderLucky/nvimMSIbook.git ~/.config/nvim
```

### 2. Install external dependencies (recommended)

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y ripgrep fd-find

# Create symlink for fd (Ubuntu installs it as fdfind)
sudo ln -s $(which fdfind) /usr/local/bin/fd
```

**Or via snap:**
```bash
sudo snap install ripgrep --classic
sudo snap install fd --classic
```

**Verify installation:**
```bash
rg --version  # ripgrep 14.1.0+
fd --version  # fd 9.0.0+
```

### 3. Start Neovim
```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch.

### 4. Verify installation
```bash
:checkhealth
:checkhealth telescope
```

Expected results:
- ✅ rg: found ripgrep
- ✅ fd: found fd
- ✅ fzf extension working

## Plugin List (24 total)

### Core
- **lazy.nvim** - Plugin manager

### LSP & Completion
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP server installer
- **mason-lspconfig.nvim** - Mason integration with lspconfig
- **nvim-cmp** - Autocompletion engine
- **cmp-nvim-lsp** - LSP source for nvim-cmp
- **cmp_luasnip** - Snippet source for nvim-cmp
- **LuaSnip** - Snippet engine with jsregexp support

### Syntax & Parsing
- **nvim-treesitter** - Better syntax highlighting

### Language-Specific
- **vim-go** - Go development tools
- **rustaceanvim** - Rust development support

### UI & Visual
- **lualine.nvim** - Statusline
- **bufferline.nvim** - Buffer tabs
- **nvim-web-devicons** - File icons
- **nvim-tree.lua** - File explorer

### Navigation & Search
- **telescope.nvim** - Fuzzy finder
- **telescope-fzf-native.nvim** - FZF native sorter
- **plenary.nvim** - Telescope dependency
- **which-key.nvim** - Keybinding hints

### Git
- **gitsigns.nvim** - Git decorations and hunks
- **nvim-tree git integration** - Git status icons in file explorer

### Editing
- **nvim-autopairs** - Auto-close brackets
- **nvim-surround** - Surround text objects
- **auto-save.nvim** - Automatic file saving

### Diagnostics
- **trouble.nvim** - Beautiful diagnostics list

## Key Mappings

Leader key: `Space`

### Buffer Navigation
- `Tab` - Next buffer
- `Shift+Tab` - Previous buffer
- `Space+x` - Close buffer
- `Space+1-5` - Jump to buffer 1-5

### Window Navigation
- `Ctrl+h/j/k/l` - Move between windows

### File Operations
- `Space+e` - Toggle file explorer
- `Ctrl+s` - Save file

### Telescope (Fuzzy Finder)
- `Space+ff` - Find files
- `Space+fg` - Live grep
- `Space+fb` - Find buffers
- `Space+fh` - Help tags
- `Space+fs` - LSP symbols
- `Space+fr` - Recent files

### Git (Gitsigns)
- `]c` / `[c` - Next/previous hunk
- `Space+hs` - Stage hunk
- `Space+hr` - Reset hunk
- `Space+hS` - Stage buffer
- `Space+hR` - Reset buffer
- `Space+hu` - Undo stage hunk
- `Space+hp` - Preview hunk
- `Space+hb` - Blame line (full)
- `Space+hd` - Diff this
- `Space+hD` - Diff this ~
- `Space+tb` - Toggle blame line
- `Space+td` - Toggle deleted

### Diagnostics (Trouble)
- `Space+xx` - Workspace diagnostics
- `Space+xX` - Buffer diagnostics
- `Space+xL` - Location list
- `Space+xQ` - Quickfix list
- `Space+cs` - Symbols
- `Space+cl` - LSP definitions/references

### File Explorer (NvimTree)
- `Space+e` - Toggle file explorer
- Git status icons:
  - `✗` - Unstaged changes
  - `✓` - Staged changes
  - `★` - Untracked file
  - `` - Deleted
  - `◌` - Ignored

### Editing (nvim-surround)
- `ysiw"` - Surround word with quotes
- `cs"'` - Change surrounding " to '
- `ds"` - Delete surrounding quotes
- `yss)` - Surround line with ()

### Other
- `Esc` - Clear search highlighting
- `Alt+j/k` - Move lines up/down
- `Space+q` - Quit
- `Space+Q` - Quit all without saving

## File Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/
│   │   ├── init.lua           # Basic settings
│   │   ├── lazy.lua           # Lazy.nvim bootstrap
│   │   └── keymaps.lua        # Key mappings
│   └── plugins/
│       ├── lsp.lua            # LSP configuration
│       ├── completion.lua     # Autocompletion
│       ├── treesitter.lua     # Syntax highlighting
│       ├── editor.lua         # Editor plugins
│       ├── language.lua       # Language-specific
│       ├── ui.lua             # UI plugins
│       ├── navigation.lua     # Navigation & search
│       ├── git.lua            # Git integration
│       └── diagnostics.lua    # Diagnostics
├── CHECKLIST.md               # Migration checklist
├── MIGRATION_PLAN.md          # Migration plan
└── README.md                  # This file
```

## Performance

- Startup time: ~70ms
- All plugins lazy loaded where appropriate
- Total plugin count: 24

## Health Check

Run `:checkhealth` in Neovim to verify installation.

Key checks:
- Lazy.nvim working
- No Packer remnants
- LuaSnip jsregexp installed
- Mason working
- 6 LSP servers configured
- Python provider (pynvim 0.6.0)

## Treesitter Parsers

Installed syntax highlighting for:
- Rust, Go, Python, C/C++
- Lua, Bash, YAML, TOML
- Markdown, Vim, Vimdoc

## LSP Servers

Configured via Mason:
- **gopls** - Go
- **yamlls** - YAML
- **pyright** - Python
- **bashls** - Bash
- **clangd** - C/C++
- **rust-analyzer** - Rust (via rustaceanvim)

## Troubleshooting

### Plugins not loading
```bash
:Lazy sync
```

### LSP not working
```bash
:Mason
# Install required servers
```

### Slow startup
```bash
nvim --startuptime startup.log +q
tail -1 startup.log  # Should be < 100ms
```

## Migration History

Migrated from Packer.nvim to Lazy.nvim:
- Before: 11 plugins, Packer.nvim
- After: 24 plugins, Lazy.nvim
- Migration completed in 7 stages
- All commits tagged for rollback capability

## License

Personal configuration - use as you wish.
