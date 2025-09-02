--- @type Wezterm
local wez = require("wezterm")
local mux = wez.mux

wez.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()
	-- gui_window:perform_action(wez.action.ToggleFullScreen, pane) -- Like full ass screen
	gui_window:maximize()
end)

return {
	native_macos_fullscreen_mode = true,
}
