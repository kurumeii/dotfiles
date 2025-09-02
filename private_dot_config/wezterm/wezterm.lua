--- @type Wezterm
local wez = require("wezterm")
local config = wez.config_builder()
local config_dir = wez.glob(wez.config_dir .. "/config/*.lua")
local tabline = wez.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

for _, file in ipairs(config_dir) do
	local tbl = dofile(file)
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			config[k] = v
		end
	end
end

tabline.setup({
	options = {
		theme = config.color_scheme,
	},

	sections = {
		tabline_a = {
			"hostname",
		},
		tabline_b = {},
		tab_active = {
			"index",
			"process",
		},
		tabline_x = {
			"domain",
		},
		tabline_y = {
			"datetime",
		},
		tabline_z = {
			"battery",
		},
	},
})

tabline.apply_to_config(config)
require("events")

return config
