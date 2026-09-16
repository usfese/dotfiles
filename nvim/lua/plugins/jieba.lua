return {
  {
    "tpope/vim-repeat",
  },

  {
    "kkew3/jieba.vim",
    branch = "release",
    build = ":call jieba_vim#install()",

    init = function()
      -- 中文出现时才加载 jieba 词典
      vim.g.jieba_vim_lazy = 1

      -- 启用默认按键
      vim.g.jieba_vim_keymap = 1
    end,
  },
}
