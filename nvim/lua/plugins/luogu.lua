return {
  dir = "/home/usfese/Workspace/luogu.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Luogu",
  config = function()
    require("luogu").setup({})
  end,
}
