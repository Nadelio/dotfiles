local wezterm = require 'wezterm'
local theme = require ("theme_switcher")
local config = wezterm.config_builder()

-- initial size
config.initial_cols = 120
config.initial_rows = 28

-- background
config.window_background_image = '.\\media\\2b_sword_flowers.png'
config.window_background_opacity = 0.75

-- font and color scheme
config.font = wezterm.font("CodeNewRoman Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}) -- ~\APPDATA\LOCAL\MICROSOFT\WINDOWS\FONTS\CODENEWROMANNERDFONT-REGULAR.OTF, DirectWrite
config.font_size = 11
config.color_scheme = 'CyberDyne'

-- default shell -- comment out to use system shell (cmd prompt or bash typically)
config.default_prog = { '~\\AppData\\Local\\Programs\\nu\\bin\\nu.exe' }

-- custom keybinds
config.keys = {
  {-- <C-t> => switch wezterm theme
    key = "T",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      theme.theme_switcher(window, pane)
    end),
  },
	{-- <A-t> => create a new tab
		key = "t",
		mods = "ALT",
		action = wezterm.action.SpawnTab('CurrentPaneDomain'),
	},
}

return config
