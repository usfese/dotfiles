-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- fcitx5
-- 离开插入模式时记录状态并关闭输入法，进入插入模式时恢复。
-- 全部走异步 job：不要在 autocmd 里用 vim.fn.system()（同步 spawn 进程，会阻塞 UI）。
local fcitx_st = ""

local function fcitx_query_then_deactivate()
  local out = {}
  vim.fn.jobstart({ "fcitx5-remote" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      out = data
    end,
    -- 先拿到状态再关输入法，保证顺序，且主线程不等待
    on_exit = function()
      fcitx_st = (out[1] or ""):match("%d") or fcitx_st
      vim.fn.jobstart({ "fcitx5-remote", "-c" })
    end,
  })
end

vim.api.nvim_create_autocmd("InsertLeave", { callback = fcitx_query_then_deactivate })
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if fcitx_st == "2" then
      vim.fn.jobstart({ "fcitx5-remote", "-o" })
    end
  end,
})
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.fn.jobstart({ "fcitx5-remote", "-c" })
  end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
  end,
})
