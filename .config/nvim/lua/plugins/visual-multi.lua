return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    -- <C-d> for selecting words like vscode
    vim.g.VM_default_mappings = 0
    vim.g.VM_maps = {
      ["Find Under"] = "<C-d>", -- VS Code の Ctrl-D と同じ動作
      ["Find Subword Under"] = "<C-d>",
    }
  end,
  config = function()
    -- colorscheme 適用後に毎回上書きする
    local function apply_vm_highlights()
      local hl = vim.api.nvim_set_hl
      -- 目に入りやすい “暗背景＋明るい前景”／“明背景＋暗い前景” の組み合わせ
      hl(0, "VM_Cursor", { fg = "#000000", bg = "#FFD166", bold = true }) -- 濃い黄色
      hl(0, "VM_Insert", { fg = "#000000", bg = "#06D6A0", bold = true }) -- 緑
      hl(0, "VM_Extend", { fg = "#000000", bg = "#EF476F", bold = true }) -- 赤
      hl(0, "VM_Mono", { fg = "#1E1E1E", bg = "#A78BFA", bold = true })   -- ラベンダ
      -- 一致箇所（背景だけ色を付け、文字は colorscheme に任せる）
      hl(0, "VM_Matches", { bg = "#264653" })                             -- 濃い青緑
    end

    apply_vm_highlights()

    -- colorscheme を切り替えた時に消えないように再適用
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = apply_vm_highlights,
    })
  end,

}
