return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_c = {
        { "filename", path = 2 }, -- 4 = 绝对路径
      },
    },
  },
}
