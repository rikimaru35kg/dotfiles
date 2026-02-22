local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12
config.font = wezterm.font_with_fallback({
 "PlemolJP Console NF",
 "Segoe UI Emoji",      -- Windows 標準のカラー絵文字にフォールバック
 })

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "#000000" },
}

config.default_prog = { "powershell.exe", "-NoLogo" }

-- Ligature OFF
config.harfbuzz_features = {
  "calt=0",  -- contextual alternates off
  "liga=0",  -- standard ligatures off
  "clig=0",  -- contextual ligatures off
}

-- 背景
config.window_background_opacity = 1.0
config.initial_cols = 180
config.initial_rows = 50

config.window_background_gradient = {
        orientation = { Linear = { angle = -50.0 } },
        colors = {
                "#0f0c29",
                "#282a36",
                "#343746",
                "#3a3f52",
                "#343746",
                "#282a36",
        },
        interpolation = "Linear",
        blend = "Rgb",
        noise = 64,
        segment_size = 11,
        segment_smoothness = 1.0,
}

return config

