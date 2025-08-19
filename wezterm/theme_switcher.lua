local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

M.theme_switcher = function(window, pane)
  -- get builtin color schemes
  local schemes = wezterm.get_builtin_color_schemes()
  local choices = {}

  -- populate theme names in choices list
  for key, _ in pairs(schemes) do
    table.insert(choices, { label = tostring(key) })
  end

  -- sort choices list
  table.sort(choices, function(c1, c2)
    return c1.label < c2.label
  end)

  window:perform_action(
    act.InputSelector({
      title = "🎨 Pick a Theme!",
      choices = choices,
      fuzzy = true,

      -- Dynamically set the color scheme for the current window
      action = wezterm.action_callback(function(inner_window, inner_pane, _, label)
        if label then
          inner_window:set_config_overrides({
            color_scheme = label,
          })
        end
      end),
    }),
    pane
  )
end

return M