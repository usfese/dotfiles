-- sudo 保存文件
vim.api.nvim_create_user_command("W", function()
  local file = vim.fn.expand("%:p")
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") .. "\n"

  -- 检查 sudo 缓存
  local cached = vim.fn.system({ "sudo", "-n", "-v" })

  if vim.v.shell_error ~= 0 then
    -- 没有缓存，要求输入密码
    local password = vim.fn.inputsecret("sudo password: ")

    if password == "" then
      return
    end

    local result = vim.fn.system({ "sudo", "-S", "tee", file }, password .. "\n" .. content)

    if vim.v.shell_error ~= 0 then
      vim.notify("sudo 保存失败: " .. result, vim.log.levels.ERROR)
      return
    end
  else
    -- 已有 sudo 缓存，直接保存
    vim.fn.system({ "sudo", "tee", file }, content)

    if vim.v.shell_error ~= 0 then
      vim.notify("sudo 保存失败", vim.log.levels.ERROR)
      return
    end
  end

  vim.bo.modified = false
end, {})
