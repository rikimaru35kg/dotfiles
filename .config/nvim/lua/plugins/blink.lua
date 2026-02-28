return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts = opts or {}
    opts.keymap = {
      preset      = "none",
      -- Enterは改行だけ (not accept)
      ["<CR>"]    = { "fallback" },
      -- Tabで確定（snippetがある場合はジャンプ）、必要なら表示も復活
      ["<Tab>"]   = { "select_and_accept", "snippet_forward", "fallback" },
      -- how to move up/down in the input hint window
      ["<C-n>"]  = { "select_next", "fallback" },
      ["<C-p>"]    = { "select_prev", "fallback" },
      ["<Down>"]  = { "select_next", "fallback" },
      ["<Up>"]    = { "select_prev", "fallback" },
    }
    return opts
  end,
}
