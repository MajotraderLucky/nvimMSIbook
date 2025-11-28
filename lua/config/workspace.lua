-- Workspace setup: multiple terminals in splits
local M = {}

-- Default project directory
M.default_dir = "/home/ryazanov/Development/k8s_moex_ml_bot/finam_integration/finam-rs"

-- Commands for each terminal: { cmd = "...", delay = ms }
-- delay is from workspace open (default 500ms for immediate)
M.commands = {
  [1] = {
    delay = 500,
    cmd = [[cargo run --release --bin orchestrator -- \
  --no-ui \
  --collect-ml-data \
  --collect-candles \
  --enable-ml-retraining \
  --symbol SBERF@RTSX \
  --ml-symbols \
    SBERF@RTSX,GAZPF@RTSX,LKOHF@RTSX,RTKM@RTSX,YDEX@RTSX \
  --candle-symbols \
    SBERF@RTSX,GAZPF@RTSX,LKOHF@RTSX,RTKM@RTSX,YDEX@RTSX \
  --database-url \
    "postgresql://mlbot_user:mlbot_secure_2024@localhost:5432/moex_trading" \
  --ml-target-samples 20000 \
  --ml-interval 60 \
  --candle-interval 300]],
  },
  [2] = {
    delay = 180500,  -- 1 minute after terminal 3 (120500 + 60000)
    cmd = [[cargo run --release --bin bot4rest SBERF@RTSX 0.12]],
  },
  [3] = {
    delay = 120500,  -- 2 minutes after first command (120000 + 500)
    cmd = [[cargo run --release --bin spread_visualizer -- \
  --symbols SBERF@RTSX \
  --load-historical \
  --database-url \
    "postgresql://mlbot_user:mlbot_secure_2024@localhost:5432/moex_trading" \
  --no-size-check]],
  },
}

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

  -- Store terminals for later use
  M.terminals = terminals

  -- Execute commands with their delays
  for i, config in pairs(M.commands) do
    if config and config.cmd and terminals[i] then
      local term_id = terminals[i]
      local cmd = config.cmd
      vim.defer_fn(function()
        vim.fn.chansend(term_id, cmd .. "\n")
        if config.delay > 1000 then
          vim.notify("Command started in terminal " .. i, vim.log.levels.INFO)
        end
      end, config.delay)
    end
  end

  -- Return to first terminal
  vim.cmd("wincmd t")

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

-- VPN check and auto-start
M.vpn_dir = "/home/ryazanov/.myBashScripts"

M.vpn_check = function()
  -- Open terminal in bottom split
  vim.cmd("botright split | terminal")
  local term_id = vim.b.terminal_job_id

  -- Send commands: cd, check status, start if needed, show status
  local vpn_script = [[
cd ]] .. M.vpn_dir .. [[

if ./vpn_control.sh status 2>&1 | grep -q "VPN интерфейс неактивен"; then
  echo "VPN выключен, запускаем..."
  ./vpn_control.sh start
  sleep 2
  ./vpn_control.sh status
else
  echo "VPN уже активен"
fi
]]

  vim.defer_fn(function()
    vim.fn.chansend(term_id, vpn_script)
  end, 300)

  vim.notify("VPN check started", vim.log.levels.INFO)
end

return M
