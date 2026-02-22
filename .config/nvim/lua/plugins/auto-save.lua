return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "TextChanged", "TextChangedI" },
    },
    debounce_delay = 200,
    condition = function(buf)
      local fn = vim.fn
      local bo = vim.bo[buf]
      if bo.buftype ~= "" or bo.readonly then return false end
      if fn.getbufvar(buf, "&modifiable") == 0 then return false end
      local name = fn.bufname(buf)
      return name ~= nil and name ~= ""
    end,
    write_all_buffers = false,
    noautocmd = false,
  },
  keys = {
    { "<leader>ua", function() require("auto-save").toggle() end, desc = "Auto Save 切替" },
  },
}
