-- lua/plugins/colorscheme.lua
return {
  -- ❶ LazyVim に「tokyonight を使う」と宣言
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- ❷ TokyoNight 本体を「最優先・遅延なし」でロードし、透明＆コメント色を同時設定
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- 起動時に必ずロード（重要）
    priority = 1000, -- ほかより先にロード（重要）
    opts = {
      -- 好きなスタイル: "storm" / "night" / "moon" / "day"
      style = "moon",

      -- ★ 背景透過（公式オプション）
      transparent = true,

      -- ★ テーマ適用直前にハイライトを上書きする公式のやり方
      on_highlights = function(hl, c)
        -- コメントだけ「落ち着いた明るめの緑」
        hl.Comment     = { fg = "#88cc88", italic = false }

        -- 浮動ウィンドウも完全透過にしたい場合
        hl.Normal      = { bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { bg = "NONE" }

        -- 未定義変数をグレーに (デフォルトは暗すぎる)
        hl.DiagnosticUnnecessary = { fg = "#888888", undercurl = false, italic = false, strikethrough = false }
      end,
    },
  },
}
