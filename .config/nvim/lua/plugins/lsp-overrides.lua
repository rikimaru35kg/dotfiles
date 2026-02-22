return {
  -- LSP 全体のインラインヒントを無効化
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        virtual_text = false, -- ← これだけで行右の警告が全消える
      },
    },
  },
}
