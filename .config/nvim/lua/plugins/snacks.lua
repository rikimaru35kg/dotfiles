return {
  "folke/snacks.nvim",
  opts = {
    -- Explorer（ツリー）で隠しファイルを常時表示
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = false,
        },
      },
    },
    indent = {
      enabled = true,
      animate = { enabled = false }, -- animation off
    },
  },
  keys = {
    -- <leader>ff だけ上書き（既定はそのままにしたい場合はこちら）
    {
      "<leader>ff",
      function()
        require("snacks").picker.files({
          hidden = true,
          ignored = false,
          follow = true,
        })
      end,
      desc = "Find Files (include dotfiles & ignored)",
    }
  },
}
