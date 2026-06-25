-- Keymaps for better workflow
-- Note: mapleader and maplocalleader are set in init.lua (before lazy.nvim)

-- Buffer navigation (working with tabs in bufferline)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Buffer group under <leader>b
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer", silent = true })
vim.keymap.set("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force close buffer", silent = true })
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Find buffer", silent = true })

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

-- Copy file path to clipboard
vim.keymap.set("n", "<leader>yp", ':let @+ = expand("%:p")<CR>:echo "Path copied: " .. expand("%:p")<CR>', { desc = "Copy file path", silent = true })

-- Telescope - fuzzy finder
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files", silent = true })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep", silent = true })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers", silent = true })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags", silent = true })
vim.keymap.set("n", "<leader>fs", "<cmd>Trouble symbols toggle focus=true win.position=right win.size=70<cr>", { desc = "LSP symbols", silent = true })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files", silent = true })

-- Diagnostics navigation
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic float", silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic", silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic", silent = true })
vim.keymap.set("n", "<leader>xf", function() vim.diagnostic.goto_next({ cursor_position = {1, 0} }) end, { desc = "First diagnostic", silent = true })

-- Trouble - diagnostics
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)", silent = true })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)", silent = true })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)", silent = true })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)", silent = true })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)", silent = true })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)", silent = true })


-- Goose - AI terminal inside nvim (local cockpit + T-050 paid parking-mode)
local function open_goose_terminal(name, cmd)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr):match(name .. "$") then
      local job_id = vim.b[bufnr].terminal_job_id
      if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
        vim.api.nvim_set_current_buf(bufnr)
        vim.cmd("startinsert")
        return
      end
      vim.api.nvim_buf_delete(bufnr, { force = true })
      break
    end
  end

  vim.cmd("enew")
  vim.cmd("terminal " .. cmd)
  vim.cmd("file " .. name)
  vim.opt_local.buflisted = true
  vim.opt_local.scrollback = 100000
  vim.cmd("startinsert")
end

-- <leader>wgl = local cockpit (resident 3B); <leader>wgp = T-050 paid parking-mode (aitunnel, real spend)
vim.keymap.set("n", "<leader>wgl", function()
  open_goose_terminal("goose-terminal", "goose-local-session")
end, { desc = "Goose local cockpit", silent = true })
-- <leader>wgn = T-053 net-lane cockpit (exit-pool only: small packet, faithful node list incl timeweb)
vim.keymap.set("n", "<leader>wgn", function()
  open_goose_terminal("goose-terminal-net", "goose-net-session")
end, { desc = "Goose net-lane cockpit (T-053)", silent = true })
-- <leader>wga = T-053 lan-lane cockpit (LAN/archbook/Cisco only: small packet, no exit-pool/Kanban/disk)
vim.keymap.set("n", "<leader>wga", function()
  open_goose_terminal("goose-terminal-lan", "goose-lan-session")
end, { desc = "Goose lan-lane cockpit (archbook/LAN, T-053)", silent = true })
-- <leader>wgs = T-053 planning-lane cockpit (task-status only: Обзор IN PROGRESS, no net/disk/LAN)
vim.keymap.set("n", "<leader>wgs", function()
  open_goose_terminal("goose-terminal-planning", "goose-planning-session")
end, { desc = "Goose planning-lane cockpit (status, T-053)", silent = true })
-- <leader>wgc = T-056 code-lane cockpit (active-repo git context only: branch/status/commits, no net/disk/LAN/Kanban)
vim.keymap.set("n", "<leader>wgc", function()
  open_goose_terminal("goose-terminal-code", "goose-code-session")
end, { desc = "Goose code-lane cockpit (active-repo git, T-056)", silent = true })
vim.keymap.set("n", "<leader>wgp", function()
  open_goose_terminal("goose-paid-terminal", "goose-paid-session " .. vim.fn.expand("~/Development/cppskillbox"))
end, { desc = "Goose PAID (parking, real spend)", silent = true })
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode", silent = true })

-- Workspace - terminal splits
vim.keymap.set("n", "<leader>ws", function()
  require("config.workspace").setup()
end, { desc = "Open workspace (3 terminals)", silent = true })

-- VPN check and auto-start
vim.keymap.set("n", "<leader>wv", function()
  require("config.workspace").vpn_check()
end, { desc = "VPN check/start", silent = true })

-- Validation Dashboard
vim.keymap.set("n", "<leader>wd", function()
  require("config.workspace").validation_dashboard()
end, { desc = "ML Validation Dashboard", silent = true })
