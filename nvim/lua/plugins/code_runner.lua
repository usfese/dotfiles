return {
  "crag666/code_runner.nvim",
  opts = {
    mode = "term",
    filetype = {
      c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
      cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
      python = "python3 -u",
      go = "go run",
      rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
      javascript = "node",
      typescript = "npx ts-node",
    },
  },
  keys = { {
    "<F3>",
    "<cmd>RunCode<cr>",
    desc = "Run the code",
  } },
}
