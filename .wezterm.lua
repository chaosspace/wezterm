local wezterm = require 'wezterm'

local config = wezterm.config_builder()

local C = {
  lavender = "#b7bdf8",
  blue = "#8aadf4",
  sapphire = "#7dc4e4",
  sky = "#91d7e3",
  teal = "#8bd5ca",
  green = "#a6da95",
  yellow = "#eed496",
  peech = "#f5a97f",
  maroon = "#ee99a0",
  red = "#ed8796",
  pink = "#f5bde6",
  flamingo = "#f0c6c6",
  rosewater = "#f4dbd6",
  white = "#ffffff",
  ice_white = "#f0f8ff",
  mint_cream = "#f5fffa",
}

local border_color = C.lavender

local function file_exists(path)
  local file = io.open(path, "rb")
  if file then
    file:close()
    return true
  end
  return false
end

local background_image = os.getenv("WEZTERM_BACKGROUND_IMAGE")
if not background_image or background_image == "" then
  background_image = wezterm.config_dir .. "/background.jpg"
end

config.colors = {
  split = border_color,
}
config.window_frame = {
  border_left_width = "0.25cell",
  border_right_width = "0.25cell",
  border_bottom_height = "0.25cell",
  border_top_height = "0.25cell",
  border_left_color = border_color,
  border_right_color = border_color,
  border_top_color = border_color,
  border_bottom_color = border_color,
}

config.char_select_bg_color = C.sapphire
config.char_select_fg_color = C.rosewater

if file_exists(background_image) then
  config.background = {
    {
      source = {
        File = background_image,
      },
      hsb = {
        brightness = 0.15,
        saturation = 0.7,
      },
    },
    {
      source = {
        Color = "#000000",
      },
      width = "100%",
      height = "100%",
      opacity = 0.45,
    },
  }

  config.text_background_opacity = 0.85
end

-- 可以根据需要选择是否开启GPU渲染
-- config.max_fps = 120
-- config.front_end = 'WebGpu'
-- config.webgpu_power_preference = 'HighPerformance'

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
