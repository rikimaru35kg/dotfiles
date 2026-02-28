return {
  {
    "nvim-mini/mini.bufremove",
    version = "*",
    config = function()
      -- ここで何も設定しなくてOK。関数を呼ぶだけで使える。
    end,
    keys = {
      {
        "Q",
        function() require("mini.bufremove").delete(0, false) end,
        desc = "Delete buffer (keep window)",
      },
    },
  },
}

