-- Keymaps for better workflow

-- Set leader key
vim.g.mapleader = " "  -- Space as leader key
vim.g.maplocalleader = " "

-- Buffer navigation (working with tabs in bufferline)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer", silent = true })
vim.keymap.set("n", "<leader>X", ":bdelete!<CR>", { desc = "Force close buffer", silent = true })

-- Quick buffer switching by number
vim.keymap.set("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1", silent = true })
vim.keymap.set("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2", silent = true })
vim.keymap.set("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3", silent = true })
vim.keymap.set("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4", silent = true })
vim.keymap.set("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to buffer 5", silent = true })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window", silent = true })

-- NvimTree toggle
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer", silent = true })

-- Save file
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file (insert mode)", silent = true })

-- Quit
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit", silent = true })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all without saving", silent = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right", silent = true })

-- Move lines up and down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })
