-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -- ~/.config/nvim/lua/config/keymaps.lua

-- LazyVim/プラグイン既定の H/L（および <S-h>/<S-l>）を消して、
-- Vimデフォルトの H/M/L を使えるようにする
local ok = pcall

ok(vim.keymap.del, "n", "H")
ok(vim.keymap.del, "n", "L")
ok(vim.keymap.del, "n", "<S-h>")
ok(vim.keymap.del, "n", "<S-l>")

-- 5 行スクロール
vim.keymap.set("n", "m", "5<C-e>", { noremap = true, silent = true, desc = "Scroll down 5 lines" })
vim.keymap.set("n", "t", "5<C-y>", { noremap = true, silent = true, desc = "Scroll up 5 lines" })

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "U", "<C-r>")

-- buffer delete using mini.bufremove
vim.keymap.set("n", "Q", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer (keep window)" })

-- x / X で削除してもクリップボードに入れない（黒穴レジスタへ）
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true, silent = true, desc = "Delete char (no clipboard)" })
vim.keymap.set("n", "X", '"_X', { noremap = true, silent = true, desc = "Delete char before cursor (no clipboard)" })

vim.keymap.set("n", "<F2>", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostics (float)" })

