return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts = opts or {}
    opts.keymap = {
      preset      = "none",

      -- Enterは改行だけ
      ["<CR>"]    = { "fallback" },

      -- Tabで確定（snippetがある場合はジャンプ）、必要なら表示も復活
      ["<Tab>"]   = { "select_and_accept", "snippet_forward", "fallback" },

      -- ★ ここがポイント：show を追加してメニューが閉じない/閉じても復活する
      ["<Down>"]  = { "select_next", "fallback" },
      ["<Up>"]    = { "select_prev", "fallback" },
    }

    return opts
  end,
}
