local wezterm = require 'wezterm'

local config = wezterm.config_builder()


config.initial_cols = 150
config.initial_rows = 42

config.font_size = 16
config.color_scheme = "Tokyo Night (Gogh)"
config.font = wezterm.font_with_fallback {
  'Fira Code',
  'DengXian',
}

config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 0.6,
}

config.use_fancy_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.enable_tab_bar = false

config.tab_max_width = 60


config.adjust_window_size_when_changing_font_size = false

return config
