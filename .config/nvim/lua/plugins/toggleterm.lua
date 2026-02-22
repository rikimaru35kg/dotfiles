return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<leader>ft]], -- ← これ1行でOK（Normal/Insert/Terminal で機能）
      direction = "float",
      float_opts = { border = "rounded", width = 120, height = 40 },
    },
  },
}
