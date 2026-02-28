return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" }, -- 遅延ロード
  opts = {
    -- どのイベントで保存するか
    -- 既定: "InsertLeave", "TextChanged"
    trigger_events = { immediate_save = { "BufLeave", "FocusLost" }, defer_save = { "TextChanged", "TextChangedI" } },
    -- 保存対象の条件（無名/特殊バッファ/readonly 等は除外）
    debounce_delay = 200, -- 0.2s 以内の連続保存をまとめる
    condition = function(buf)
      local fn = vim.fn
      local bo = vim.bo[buf]
      if bo.buftype ~= "" or bo.readonly then return false end
      if fn.getbufvar(buf, "&modifiable") == 0 then return false end
      local name = fn.bufname(buf)
      return name ~= nil and name ~= ""
    end,
    -- 保存時にメッセージ出したくない場合
    execution_message = { enabled = false },
  },
  keys = {
    -- トグル
    { "<leader>ua", function() require("auto-save").toggle() end, desc = "Auto Save 切替" },
  },
}
