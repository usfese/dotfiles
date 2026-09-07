-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 设置编辑时制表符占用的空格数
vim.opt.tabstop = 4
-- 设置格式化时缩进占用的空格数
vim.opt.shiftwidth = 4
-- 在编辑模式下输入 Tab 时转换为空格
vim.opt.expandtab = true
-- 设置连续空格在退格时删掉的长度
vim.opt.softtabstop = 4

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25"

-- 每次切换 colorscheme 后重设 Cursor 为反色显示
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
  end,
})
vim.api.nvim_set_hl(0, "Cursor", { reverse = true })

vim.o.shell = "fish"
