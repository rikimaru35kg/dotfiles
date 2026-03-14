local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 13
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

-- default shell
config.default_prog = { "powershell.exe", "-NoLogo" }

-- Ligature OFF
config.harfbuzz_features = {
  "calt=0",  -- contextual alternates off
  "liga=0",  -- standard ligatures off
  "clig=0",  -- contextual ligatures off
}

-- colorscheme
config.color_scheme = "Tokyo Night"

-- initial window size
config.initial_cols = 120
config.initial_rows = 30

-------------------------------------
-- Background
-------------------------------------
-- paths to background pictures
home = os.getenv("HOME") or os.getenv("USERPROFILE")
local BG = {
  wsl = {
    { source = { File = home .. "/dotfiles/pictures/mt_fuji.png" } },
  },
  other = {
    { source = { File = home .. "/dotfiles/pictures/forest.png" } },
  },
}

-- default background
config.background = BG.other

-- Make new tab with shell options
config.launch_menu = {
  {
    label = 'Windows PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  },
  {
    label = 'WSL Ubuntu',
    args = { 'wsl.exe', '--cd', '~'},
  },
  { label = 'Command Prompt', args = { 'cmd.exe' } },
}

-- Change the background setting depending on tab-name
wezterm.on("update-status", function(window, pane)
  local domain = pane:get_title()
  if domain:find("wsl") then
    window:set_config_overrides({ background = BG.wsl })
  else
    window:set_config_overrides({ background = BG.pwsh })
  end
end)

-- Keymaps
config.keys = {
  {
    key = 'T',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' },
  },
  {
    key = '[',
    mods = 'CTRL|ALT',
    action = act.SplitPane { direction = "Right", size = { Percent = 50 },
    },
  },
  {
    key = ']',
    mods = 'CTRL|ALT',
    action = act.SplitPane { direction = "Down", size = { Percent = 50 },
    },
  },
  {
    key = 'h',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection "Left",
  },
  {
    key = 'j',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection "Down",
  },
  {
    key = 'k',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection "Up",
  },
  {
    key = 'l',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection "Right",
  },
}

-- debug mode
config.debug_key_events = true
table.insert(config.keys, {
    key = "D", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay
})

return config

