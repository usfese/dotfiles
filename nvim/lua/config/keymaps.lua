-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- F5: 启动/继续调试 (DAP)
map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Debug: Start/Continue" })

-- Shift + F5: 终止调试
map("n", "<S-F5>", function()
  require("dap").terminate()
end, { desc = "Debug: Stop" })

-- F10: 单步跳过 (Step Over)
map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over" })

-- F11: 单步步入 (Step Into)
map("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })

map("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })

map("n", "<S-F9>", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Conditional Breakpoint" })

map("n", "<leader>o", "o<Esc>", { desc = "Insert blank line below" })
map("n", "<leader>O", "O<Esc>", { desc = "Insert blank line above" })

map("i", "jk", "<Esc>", { desc = "Return to Normal Mode" })
