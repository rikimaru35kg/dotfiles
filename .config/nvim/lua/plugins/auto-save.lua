return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" }, -- 遅延ロード
  opts = {
    -- どのイベントで保存するか
    trigger_events = { immediate_save = { "InsertLeave" }, defer_save = { "TextChanged" } },
    debounce_delay = 200, -- 0.2s 以内の連続保存をまとめる
  },
}

