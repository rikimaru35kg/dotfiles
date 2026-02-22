-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = true
vim.opt.relativenumber = false
-- LazyVim の format-on-save 全体をオフ (autosaveの場合、trueだと末尾に空行を入れられなくなるのでfalseとする)
vim.g.autoformat = false

-- yankレジスタとクリップボード (windows)を共有
vim.o.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = { "win32yank.exe", "-i", "--crlf" },
    ["*"] = { "win32yank.exe", "-i", "--crlf" },
  },
  paste = {
    ["+"] = { "win32yank.exe", "-o", "--lf" },
    ["*"] = { "win32yank.exe", "-o", "--lf" },
  },
  cache_enabled = 0,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

