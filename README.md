# Neovim Configuration

Personal Neovim configuration for development with Go, Rust, and YAML.

## Features

- **LSP Support**: gopls (Go), rust-analyzer (Rust), yamlls (YAML)
- **Treesitter**: Advanced syntax highlighting for multiple languages
- **Autocompletion**: nvim-cmp with LSP integration
- **Autopairs**: Automatic bracket pairing with cmp integration
- **File Explorer**: nvim-tree for file navigation
- **Plugin Manager**: Packer.nvim

## Language Support

- **Go**: Full LSP support with gopls
- **Rust**: Advanced support via rustaceanvim + rust-analyzer
- **YAML**: LSP with Kubernetes schema support
- **TOML**: Syntax highlighting

## Plugins

- `neovim/nvim-lspconfig` - LSP configuration
- `williamboman/mason.nvim` - LSP installer
- `hrsh7th/nvim-cmp` - Autocompletion
- `nvim-treesitter/nvim-treesitter` - Syntax highlighting
- `windwp/nvim-autopairs` - Auto bracket pairing
- `mrcjkb/rustaceanvim` - Rust support
- `nvim-tree/nvim-tree.lua` - File explorer
- `fatih/vim-go` - Go tooling

## Installation

1. Clone this repository:
```bash
git clone git@github.com:MajotraderLucky/nvimMSIbook.git ~/.config/nvim
```

2. Install Packer (if not already installed):
```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

3. Open nvim and install plugins:
```bash
nvim +PackerSync +qa
```

4. Restart nvim and enjoy!

## Key Features

### Bracket Highlighting
- `showmatch` enabled for visual bracket matching
- Auto-closing brackets with nvim-autopairs

### LSP Integration
- Uses modern nvim 0.11+ `vim.lsp.config` API
- Automatic LSP server installation via Mason
- Real-time diagnostics and code completion

### File Navigation
- nvim-tree keybindings:
  - `gy` - copy absolute path
  - `Y` - copy relative path
  - `y` - copy filename

## Requirements

- Neovim >= 0.11
- Git
- Node.js (for some LSP servers)
- Rust toolchain (for rust-analyzer)
- Go toolchain (for gopls)

## Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration
├── lua/
│   ├── config/
│   │   └── init.lua        # Basic vim settings
│   └── plugins/
│       ├── init.lua        # Plugin definitions
│       ├── lsp.lua         # LSP configuration
│       ├── treesitter.lua  # Treesitter config
│       ├── nvim-tree.lua   # File explorer config
│       └── cmp.lua         # Completion config
└── plugin/
    └── packer_compiled.lua # Auto-generated
```

## License

MIT
