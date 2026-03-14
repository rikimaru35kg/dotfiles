local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 13
config.window_close_confirmation = "NeverPrompt"
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

-- initial window size
config.initial_cols = 120
config.initial_rows = 30

-- colorscheme
--config.color_scheme = "Tokyo Night"
--config.color_scheme = "Kanagawa (Gogh)"
local CS = {
  wsl = "Tokyo Night",
  cmd = "Ayu Dark (Gogh)",
  other = "Kanagawa (Gogh)",
}
config.color_scheme = CS.other

-- Background
home = os.getenv("HOME") or os.getenv("USERPROFILE")
local BG = {
  wsl = {
    {
      source = { File = home .. "/dotfiles/pictures/mt_fuji.jpg" },
      opacity = 1.0,
    },
    {
      source = { Color = "#000000" },
      opacity = 0.8,
      width = "100%",
      height = "100%",
    },
  },
  cmd = {
    {
      source = { File = home .. "/dotfiles/pictures/forest.png" },
      opacity = 1.0,
    },
    {
      source = { Color = "#000000" },
      opacity = 0.0,
      width = "100%",
      height = "100%",
    },
  },
  other = {
    {
      source = { File = home .. "/dotfiles/pictures/snow_tree.jpg" },
      opacity = 1.0,
    },
    {
      source = { Color = "#000000" },
      opacity = 0.8,
      width = "100%",
      height = "100%",
    },
  },
}
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

-- Change the window setting depending on tab-name
local last_title = ""
wezterm.on("update-status", function(window, pane)
  local title = pane:get_title()
  if title == "Launcher" then return end
  if title == "Debug" then return end
  if title == "wezterm" then return end

  if last_title ~= title then
    last_title = title
    local background = BG.other
    local color_scheme = CS.other
    if title:find("wslhost.exe") then
       background = BG.wsl
       color_scheme = CS.wsl
    elseif title:find("cmd.exe") then
       background = BG.cmd
       color_scheme = CS.cmd
    end
    window:set_config_overrides({ background = background, color_scheme = color_scheme })
  end
end)

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():perform_action(
    act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' },
    pane
  )
end)

-- Keymaps
config.keys = {
  {
    key = 'T',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' },
  },
  {
    key = 'W',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  {
    key = 'Q',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = false },
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

return config

