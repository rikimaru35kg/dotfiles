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

-- default program
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
local CS = {
  wsl = "Tokyo Night",
  ssh = "Catppuccin Mocha",
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
  ssh = {
    {
      source = { File = home .. "/dotfiles/pictures/grape.jpg" },
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
    elseif title:find("@") or title:find("ssh") then
       background = BG.ssh
       color_scheme = CS.ssh
    elseif title:find("cmd.exe") then
       background = BG.cmd
       color_scheme = CS.cmd
    end
    window:set_config_overrides({
      background = background,
      color_scheme = color_scheme,
    })
  end
end)

-- launch menu when start up window
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():perform_action(
    act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' },
    pane
  )
end)

-- format tab (change color of active tab)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local bg = "#222222"
  local fg = "#AAAAAA"
  local title = tab.active_pane.title
  title = title:gsub(".*[\\/]", "")  -- delete from start to last separator
  title = title:gsub("%.exe$", "")  -- delete last .exe

  -- active tab
  if tab.is_active then
    bg = "#755735"
    fg = "#FFFFFF"
    if title:find("@") or title:find("ssh") then
      bg = "#4c335c"  -- ssh connection
    elseif title:find("wsl") then
      bg = "#1d638f" -- wsl
    elseif title:find("cmd") then
      bg = "#355c33" -- cmd
    end
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = title },
  }
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
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection "Left",
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection "Down",
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection "Up",
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection "Right",
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = act{ AdjustPaneSize = {"Left", 5} },
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = act{ AdjustPaneSize = {"Down", 5} },
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = act{ AdjustPaneSize = {"Up", 5} },
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = act{ AdjustPaneSize = {"Right", 5} },
  },
  {
    key = 'D',
    mods = 'CTRL|SHIFT',
    action = act.ShowDebugOverlay,
  },
  {
    key = '+',
    mods = 'CTRL|SHIFT',
    action = act.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'CTRL',
    action = act.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'CTRL',
    action = act.ResetFontSize,
  },
}

return config

