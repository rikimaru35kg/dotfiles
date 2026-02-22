-- ~/.config/nvim/lua/plugins/lazyvim-overrides.lua
return {
  {
    "LazyVim/LazyVim",
    -- 既定のキー配列 `keys` を受け取り、<leader>ft を除去してから自分の定義を追加する
    keys = function(_, keys)
      -- 1) 既存の <leader>ft を“配列から削除”
      local new = {}
      for _, k in ipairs(keys or {}) do
        if k[1] ~= "<leader>ft" then
          table.insert(new, k)
        end
      end
      -- 2) 自分の <leader>ft を“フロートで開く”ように追加
      table.insert(new, {
        "<leader>ft",
        function()
          require("toggleterm").toggle(1, 40, vim.loop.cwd(), "float")
        end,
        desc = "Floating Terminal",
      })
      return new
    end,
  },
}
