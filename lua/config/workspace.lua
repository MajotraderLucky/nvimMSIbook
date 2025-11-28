-- Workspace setup: multiple terminals in splits
local M = {}

-- Default project directory
M.default_dir = "/home/ryazanov/Development/k8s_moex_ml_bot/finam_integration/finam-rs"

M.setup = function(dir)
  dir = dir or M.default_dir
  local terminals = {}

  -- 1. First terminal (top left)
  vim.cmd("terminal")
  terminals[1] = vim.b.terminal_job_id
  vim.fn.chansend(terminals[1], "cd " .. dir .. "\n")

  -- 2. Vertical split + terminal (top right)
  vim.cmd("vsplit | terminal")
  terminals[2] = vim.b.terminal_job_id
  vim.fn.chansend(terminals[2], "cd " .. dir .. "\n")

  -- 3. Horizontal split at bottom (full width)
  vim.cmd("wincmd t")  -- go to first window
  vim.cmd("botright split | terminal")  -- bottom split spans full width
  terminals[3] = vim.b.terminal_job_id
  vim.fn.chansend(terminals[3], "cd " .. dir .. "\n")

  -- Return to first terminal
  vim.cmd("wincmd t")

  -- Store terminals for later use
  M.terminals = terminals

  vim.notify("Workspace opened: " .. dir, vim.log.levels.INFO)
end

-- Send command to specific terminal (1, 2, or 3)
M.send = function(term_num, cmd)
  if M.terminals and M.terminals[term_num] then
    vim.fn.chansend(M.terminals[term_num], cmd .. "\n")
  else
    vim.notify("Terminal " .. term_num .. " not found", vim.log.levels.ERROR)
  end
end

return M
