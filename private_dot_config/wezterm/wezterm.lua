--- @type Wezterm
local wez = require("wezterm")
local mux = wez.mux
local config = wez.config_builder()
local tabline = wez.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local items = {
	pwsh = {
		label = "󰨊 PowerShell",
		args = { "pwsh.exe" },
	},
	ubuntu = {
		label = "󰕈 Ubuntu",
		args = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" },
	},
	fedora = {
		label = "󰣛 fedora",
		args = { "wsl.exe", "-d", "FedoraLinux-42", "--cd", "~" },
	},
}

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
	font = wez.font("Caskaydia Nerd Font", {
		is_fallback = true,
	}),
	font_size = 12,
	front_end = "OpenGL",
	freetype_load_target = "Light",
	freetype_render_target = "HorizontalLcd",
	line_height = 1.1,

	launch_menu = {
		items.pwsh,
		items.ubuntu,
	},
	default_prog = items.ubuntu.args,
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 500,
	prefer_egl = true,
	max_fps = 120,
	tab_bar_at_bottom = true,

	color_scheme = "GruvboxDark",
	enable_scroll_bar = false,
	window_decorations = "RESIZE",
	window_padding = {
		bottom = 0,
		right = 3,
		left = 3,
	},

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
			key = "r", -- Rename tab
			mods = mods.L,
			action = wez.action.PromptInputLine({
				description = wez.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Change tab title" },
				}),
				action = wez.action_callback(function(win, _, line)
					if line == nil then
						return
					end
					win:active_tab():set_title(line)
				end),
			}),
		},
		{
			key = "o",
			mods = mods.L,
			action = "ShowLauncher",
		},
		{
			key = "w", -- Close tab without confirm
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
				alphabet = "123456",
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
			{
				"tab",
				padding = { left = 1, right = 1 },
			},
		},
	},
})

tabline.apply_to_config(config)

wez.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()
	-- gui_window:perform_action(wez.action.ToggleFullScreen, pane) -- Like full ass screen
	gui_window:maximize()
end)

return config
