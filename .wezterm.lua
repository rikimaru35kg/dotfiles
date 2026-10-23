local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()
local default_keys = wezterm.gui.default_key_tables()

config.automatically_reload_config = true
config.font_size = 13
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
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
config.default_prog = { "C:/msys64/usr/bin/env.exe", "MSYSTEM=UCRT64", "CHERE_INVODING=1",
                        "/usr/bin/bash", "--login" }

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
  pwr = "Kanagawa (Gogh)",
  def = "Catppuccin Frappe",
}
config.color_scheme = CS.def

-- Background
home = os.getenv("HOME") or os.getenv("USERPROFILE")
local BG = {
  def = {
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
  pwr = {
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
  msys2 = {
    {
      source = { File = home .. "/dotfiles/pictures/cyber.jpg" },
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
config.background = BG.def

-- Make new tab with shell options
config.launch_menu = {
  {
    label = 'MSYS2 bash',
    args = { "C:/msys64/usr/bin/env.exe", "MSYSTEM=UCRT64", "CHERE_INVODING=1",
                            "/usr/bin/bash", "--login" }
  },
  {
    label = 'WSL Ubuntu',
    args = { 'wsl.exe', '--cd', '~'},
  },
  {
    label = 'Windows PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
    cwd = home,
  },
  {
    label = 'Command Prompt',
    args = { 'cmd.exe' },
    cwd = home,
  },
}

-- Change the window setting depending on tab-name
local last_st = ""
wezterm.on("update-status", function(window, pane)
  local st = pane:get_user_vars().SHELL_TYPE
  if last_st == st then return end
  last_st = st
  
  local background = BG.def
  local color_scheme = CS.def
  if st == "wsl" then
    background = BG.wsl
    color_scheme = CS.wsl
  elseif st == "msys2" then
    background = BG.msys2
    color_scheme = CS.msys2
  elseif st == "powershell" then
    background = BG.pwr
    color_scheme = CS.pwr
  elseif st == "ssh" then
    background = BG.ssh
    color_scheme = CS.ssh
  end
  window:set_config_overrides({
    background = background,
    color_scheme = color_scheme,
  })
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
  local fg = "#FFFFFF"
  local title = tab.active_pane.title
  title = title:gsub(".*[\\/]", "")  -- delete from start to last separator
  title = title:gsub("%.exe$", "")  -- delete last .exe

  -- active tab
  if tab.is_active then
    local st = tab.active_pane.user_vars.SHELL_TYPE
    if st == "msys2" then
      bg = "#5c4972"
    elseif st == "ssh" then
      bg = "#A96269"
    elseif st == "powershell" then
      bg = "#6b5748"
    elseif st == "wsl" then
      bg = "#74c7ec"
    elseif title:find("cmd") then
      bg = "#355c33"
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
    key = 'LeftBracket',
    mods = 'CTRL|SHIFT',
    action = act.SplitPane { direction = "Right", size = { Percent = 50 },
    },
  },
  {
    key = 'RightBracket',
    mods = 'CTRL|SHIFT',
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
  {
    key = '<',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = '>',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
}

local function close_copy_mode()
    return act.Multiple({
        act.CopyMode('ClearSelectionMode'),
        act.CopyMode('ClearPattern'),
        act.CopyMode('Close'),
    })
end
local function copy_to()
    return act.Multiple({
        act.CopyTo('Clipboard'),
        act.CopyMode('ClearSelectionMode'),
        act.CopyMode('ClearPattern'),
        act.CopyMode('Close'),
    })
end
local function next_match(int)
    local m = act.CopyMode('NextMatch')
    if int == -1 then
        m = act.CopyMode('PriorMatch')
    end
    return act.Multiple({ m, act.CopyMode('ClearSelectionMode') })
end

local function extend_keys(target, source)
  local map = {}
  for _, k in ipairs(target) do
    map[k.key .. (k.mods or '')] = k
  end
  for _, k in ipairs(source) do
    map[k.key .. (k.mods or '')] = k
  end
  local result = {}
  for _, v in pairs(map) do table.insert(result, v) end
  return result
end

config.key_tables = {
    copy_mode = extend_keys(default_keys.copy_mode, {
        { key = 'q', mods = 'NONE', action = close_copy_mode() },
        { key = 'y', mods = 'NONE', action = copy_to() },
        { key = 'Escape', mods = 'NONE', action = close_copy_mode() },
        { key = '/', mods = 'NONE', action = act.Multiple({
                act.CopyMode('ClearPattern'),
                act.Search({ CaseInSensitiveString = '' }),
            }),
        },
        { key = 'n', mods = 'NONE', action = next_match(1) },
        { key = 'N', mods = 'NONE', action = next_match(-1) },
    }),
    search_mode = {
        { key = 'Escape', mods = 'NONE', action = act.ActivateCopyMode },
        { key = 'Enter', mods = 'NONE', action = act.ActivateCopyMode },
    },
}

return config

