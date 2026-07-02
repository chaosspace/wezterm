local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Tokyo Night 主题配色
local C = {
  -- 背景与前景
  bg = "#1a1b26",
  bg_dark = "#16161e",
  bg_highlight = "#292e42",
  fg = "#c0caf5",

  -- UI 颜色
  selection = "#33467c",
  comment = "#565f89",
  dark_fg = "#3b4261",

  -- 强调色
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  green = "#9ece6a",
  magenta = "#bb9af7",
  red = "#f7768e",
  orange = "#ff9e64",
  yellow = "#e0af68",

  -- 特殊颜色
  border = "#7aa2f7",
}

local border_color = C.border

local function file_exists(path)
  local file = io.open(path, "rb")
  if file then
    file:close()
    return true
  end
  return false
end

local function is_absolute_path(path)
  return path:sub(1, 1) == "/"
    or path:sub(1, 2) == "\\\\"
    or path:match("^%a:[/\\]") ~= nil
end

local function resolve_background_image(path)
  if not path or path == "" then
    return wezterm.config_dir .. "/background.jpg"
  end

  if path == "~" then
    return wezterm.home_dir
  end

  if path:sub(1, 2) == "~/" then
    return wezterm.home_dir .. path:sub(2)
  end

  if is_absolute_path(path) then
    return path
  end

  return wezterm.config_dir .. "/" .. path
end

local background_image = resolve_background_image(os.getenv("WEZTERM_BACKGROUND_IMAGE"))

config.colors = {
  split = border_color,
}

-- 窗口装饰：使用集成按钮和调整大小功能
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"

config.window_frame = {
  -- 字体配置
  font = wezterm.font({ family = 'Fira Code', weight = 'Bold' }),
  font_size = 10.0,

  -- 标题栏颜色
  active_titlebar_bg = C.bg_dark,
  inactive_titlebar_bg = C.bg,

  -- 边框颜色
  active_titlebar_border_bottom = C.border,
  inactive_titlebar_border_bottom = C.comment,

  -- 按钮颜色
  active_titlebar_fg = C.fg,
  inactive_titlebar_fg = C.comment,

  -- 边框宽度
  border_left_width = "0.25cell",
  border_right_width = "0.25cell",
  border_bottom_height = "0.25cell",
  border_top_height = "0.25cell",
  border_left_color = border_color,
  border_right_color = border_color,
  border_top_color = border_color,
  border_bottom_color = border_color,
}

config.window_padding = {
  left = 8,
  right = 8,
  top = 6,
  bottom = 6,
}

config.char_select_bg_color = C.bg_highlight
config.char_select_fg_color = C.fg

if file_exists(background_image) then
  config.background = {
    {
      source = {
        File = background_image,
      },
      hsb = {
        brightness = 0.22,
        saturation = 0.7,
      },
    },
    {
      source = {
        Color = "#000000",
      },
      width = "100%",
      height = "100%",
      opacity = 0.35,
    },
  }

  config.text_background_opacity = 0.85
end

-- 性能优化：启用 GPU 加速和高帧率
config.max_fps = 120
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

-- 窗口设置
config.initial_cols = 150
config.initial_rows = 42

-- 字体配置
config.font_size = 16
config.color_scheme = "Tokyo Night (Gogh)"
config.font = wezterm.font_with_fallback {
  'Fira Code',
  'PingFang SC',
  'DengXian',
  'Apple Color Emoji',
}
-- 启用字体连字特性
config.harfbuzz_features = { 'calt', 'clig', 'liga' }
-- 增加行高提升可读性
config.line_height = 1.1

-- 非活动窗格效果
config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 0.6,
}

-- 标签栏配置
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.tab_max_width = 60
config.colors.tab_bar = {
  background = C.bg_dark,
  active_tab = {
    bg_color = C.blue,
    fg_color = C.bg,
    intensity = "Bold",
  },
  inactive_tab = {
    bg_color = C.bg_highlight,
    fg_color = C.comment,
  },
  inactive_tab_hover = {
    bg_color = C.cyan,
    fg_color = C.bg,
  },
  new_tab = {
    bg_color = C.bg_highlight,
    fg_color = C.comment,
  },
  new_tab_hover = {
    bg_color = C.green,
    fg_color = C.bg,
  },
}

-- 窗口行为
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.native_macos_fullscreen_mode = true

-- 实用功能
config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.window_padding = {
  left = 8,
  right = 12,
  top = 6,
  bottom = 6,
}

-- Windows 毛玻璃效果（可选：Auto, Disable, Mica, Acrylic, Tabbed）
config.win32_system_backdrop = "Acrylic"
-- 如果毛玻璃效果不生效，可以尝试注释掉上面一行，取消注释下面一行
-- config.win32_system_backdrop = "Mica"

-- 右键粘贴
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- Ctrl+点击打开链接
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- 快捷键配置
config.keys = {
  -- 窗格分割
  {
    key = '\\',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- 窗格导航（兼容 Neovim）
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  -- 调整窗格大小
  {
    key = 'h',
    mods = 'CTRL|ALT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'j',
    mods = 'CTRL|ALT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },
  {
    key = 'k',
    mods = 'CTRL|ALT',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'l',
    mods = 'CTRL|ALT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  -- 关闭窗格
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- 标签页管理
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  -- 标签页导航器
  {
    key = 'n',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowTabNavigator,
  },
  -- 复制粘贴
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  -- 搜索
  {
    key = 'f',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.Search { CaseInSensitiveString = '' },
  },
  -- 命令面板
  {
    key = 'p',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateCommandPalette,
  },
  -- 全屏
  {
    key = 'F11',
    mods = 'NONE',
    action = wezterm.action.ToggleFullScreen,
  },
  -- 调整字体大小
  {
    key = '=',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.ResetFontSize,
  },
}

-- 标签页数字快捷键
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

-- 状态栏：显示 Git 分支、工作目录、时间
config.status_update_interval = 1000
wezterm.on('update-right-status', function(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local cwd = ''
  local git_branch = ''

  if cwd_uri then
    cwd = cwd_uri.file_path or tostring(cwd_uri)
    -- 尝试获取 Git 分支
    local success, stdout = wezterm.run_child_process { 'git', '-C', cwd, 'branch', '--show-current' }
    if success then
      git_branch = stdout:gsub('\n', '')
    end
  end

  local time = wezterm.strftime '%H:%M:%S'
  local date = wezterm.strftime '%Y-%m-%d'

  -- 使用 Unicode 圆角字符来美化状态栏
  local separator_left = ""
  local separator_right = ""

  window:set_right_status(wezterm.format {
    { Foreground = { Color = C.bg_highlight } },
    { Text = separator_left },
    { Foreground = { Color = C.green } },
    { Background = { Color = C.bg_highlight } },
    { Text = git_branch ~= '' and ('  ' .. git_branch .. '  ') or '' },
    { Foreground = { Color = C.cyan } },
    { Text = '  ' .. cwd .. '  ' },
    { Foreground = { Color = C.comment } },
    { Text = '  ' .. date .. '  ' .. time .. '  ' },
    { Foreground = { Color = C.bg_highlight } },
    { Text = separator_right },
  })
end)

-- 启动菜单配置
config.launch_menu = {
  {
    label = 'Git Bash',
    args = { 'C:/Users/94001/scoop/apps/git/current/bin/bash.exe', '-l' },
  },
  {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  },
  {
    label = 'CMD',
    args = { 'cmd.exe' },
  },
  {
    label = 'Neovim',
    args = { 'C:/Users/94001/scoop/apps/neovim/current/bin/nvim.exe' },
  },
}

--[[
-- Neovim 集成：需要安装 mrjones2014/smart-splits.nvim 插件
-- 取消注释以下配置可实现 Neovim 和 WezTerm 窗格无缝切换

-- 检查是否在 Neovim 中
local function is_vim(pane)
  local process_name = pane:get_foreground_process_name()
  return process_name:find('nvim') ~= nil
end

-- Neovim 窗格切换
wezterm.on('ActivatePaneDirection', function(window, pane, direction)
  if is_vim(pane) then
    window:perform_action(
      wezterm.action.SendKey { key = direction, mods = 'CTRL' },
      pane
    )
  else
    window:perform_action(
      wezterm.action.ActivatePaneDirection(direction),
      pane
    )
  end
end)

-- 为 Neovim 集成添加快捷键（替换上面的窗格导航配置）
config.keys = {
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.EmitEvent 'ActivatePaneDirection',
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = wezterm.action.EmitEvent 'ActivatePaneDirection',
  },
  {
    key = 'k',
    mods = 'CTRL',
    action = wezterm.action.EmitEvent 'ActivatePaneDirection',
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = wezterm.action.EmitEvent 'ActivatePaneDirection',
  },
}
]]

return config
