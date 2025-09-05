local wez = require("wezterm")

---@module 'wezterm'
---@type Config
return {
	font = wez.font("FiraCode Nerd Font"),
	font_size = 12,
	front_end = "OpenGL",
	freetype_load_target = "HorizontalLcd",
	line_height = 1.1,
}
