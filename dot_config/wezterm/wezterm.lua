---@type Wezterm
local wez = require("wezterm")
local mux = wez.mux
local config = wez.config_builder()
local tabline = wez.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
-- local tabbar = wez.plugin.require("https://github.com/adriankarlen/bar.wezterm")

local mods = {
	C = "CTRL",
	M = "ALT",
	S = "SHIFT",
	L = "LEADER",
}

local join_mods = function(m)
	local result = ""
	for i, v in ipairs(m) do
		result = result .. v
		if i < #m then
			result = result .. "|"
		end
	end
	return result
end

config = {
	font = wez.font("CaskaydiaCove Nerd Font"),
	adjust_window_size_when_changing_font_size = false,
	font_size = 12,
	-- front_end = "OpenGL",
	front_end = "WebGpu",
	line_height = 1,
	window_background_opacity = 1,
	-- win32_system_backdrop = "Acrylic",
	enable_wayland = false,
	kde_window_background_blur = true,
	-- macos_window_background_blur = 30,
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 500,
	tab_bar_at_bottom = false,

	color_scheme = "GruvboxDark",
	enable_scroll_bar = false,
	window_decorations = "NONE",
	window_padding = {
		bottom = 0,
		right = 3,
		left = 3,
	},
	allow_win32_input_mode = false,

	leader = {
		key = "q",
		mods = mods.M,
		timeout_milliseconds = 1500,
	},
	keys = {
		{
			key = "n", -- Create new tab
			mods = mods.L,
			action = wez.action.SpawnTab("DefaultDomain"),
		},
		{
			key = "e", -- Rename tab
			mods = mods.L,
			action = wez.action.PromptInputLine({
				description = "Rename tab",
				action = wez.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{
			key = "d", -- Duplicate tab
			mods = mods.L,
			action = wez.action.SpawnTab("CurrentPaneDomain"),
		},
		{
			key = "c", -- Close tab
			mods = mods.L,
			action = wez.action.CloseCurrentPane({
				confirm = true,
			}),
		},
		{
			key = "w", -- Workspace
			mods = mods.L,
			action = wez.action.PromptInputLine({
				description = "Enter name for workspace",
				action = wez.action_callback(function(window, pane, line)
					if line then
						window:perform_action(
							wez.action.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
		{
			key = "\\", -- Toggle launcher for workspace
			mods = mods.L,
			action = wez.action.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
		{
			key = "]", -- Cycle next workpsace
			mods = mods.L,
			action = wez.action.SwitchWorkspaceRelative(1),
		},
		{
			key = "[", -- Cycle previous workspace
			mods = mods.L,
			action = wez.action.SwitchWorkspaceRelative(-1),
		},
		{
			key = "o",
			mods = mods.L,
			action = "ShowLauncher",
		},
		{
			key = "x", -- Close tab
			mods = mods.L,
			action = wez.action.CloseCurrentTab({
				confirm = true,
			}),
		},
		{
			key = "l", -- Split pane to the right
			mods = join_mods({ mods.L, mods.S }),
			action = wez.action.SplitHorizontal({
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = "j", -- Split pane to the bottom
			mods = join_mods({ mods.L, mods.S }),
			action = wez.action.SplitVertical({
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = "l", -- Focus next tab
			mods = join_mods({ mods.M, mods.S }),
			action = wez.action.ActivateTabRelative(1),
		},
		{
			key = "h", -- Focus previous tab
			mods = join_mods({ mods.M, mods.S }),
			action = wez.action.ActivateTabRelative(-1),
		},
		{
			key = "h", -- Focus Right Pane,
			mods = mods.L,
			action = wez.action.ActivatePaneDirection("Left"),
		},
		{
			key = "l", -- Focus Left Pane,
			mods = mods.L,
			action = wez.action.ActivatePaneDirection("Right"),
		},
		{
			key = "k", -- Focus Up Pane,
			mods = mods.L,
			action = wez.action.ActivatePaneDirection("Up"),
		},
		{
			key = "j", -- Focus Down Pane,
			mods = mods.L,
			action = wez.action.ActivatePaneDirection("Down"),
		},
		{
			key = "c",
			mods = join_mods({ mods.C, mods.S }),
			action = wez.action.CopyTo("Clipboard"),
		},
		{
			key = "v",
			mods = join_mods({ mods.C, mods.S }),
			action = wez.action.PasteFrom("Clipboard"),
		},
		{
			key = "p",
			mods = mods.L,
			action = wez.action.PaneSelect({
				-- alphabet = "123456",
			}),
		},
		{
			key = "p", -- Swap current pane with selected pane
			mods = join_mods({ mods.L, mods.S }),
			action = wez.action.PaneSelect({
				alphabet = "123456",
				mode = "SwapWithActive",
			}),
		},
	},
}

-- config.hyperlink_rules = wez.default_hyperlink_rules()
--
-- table.insert(config.hyperlink_rules, {
-- 	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
-- 	format = "https://www.github.com/$1/$3",
-- })

tabline.setup({
	options = {
		theme = config.color_scheme,
	},
	sections = {
		tabline_a = {
			"hostname",
		},
		tab_active = {
			"index",
			{ "process", padding = { right = 1, left = 0 } },
		},
	},
})

tabline.apply_to_config(config)

-- tabbar.apply_to_config(config)

-- wez.on("gui-startup", function(cmd)
-- 	local _, _, window = mux.spawn_window(cmd or {})
-- 	local gui_window = window:gui_window()
-- 	gui_window:perform_action(wez.action.ToggleFullScreen, pane) -- Like full ass screen
-- 	gui_window:maximize()
-- end)

config.window_decorations = "NONE"

return config
