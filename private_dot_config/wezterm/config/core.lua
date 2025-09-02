---@module 'wezterm.wezterm'
---@type Config

local wsl_distro = "Ubuntu"

local items = {
	pwsh = {
		label = "󰨊 PowerShell",
		args = { "pwsh.exe" },
	},
	ubuntu = {
		label = "󰕈 Ubuntu",
		args = { "wsl.exe", "-d", "Ubuntu" },
		cwd = "~",
	},
	fedora = {
		label = "󰣛 fedora",
		args = { "wsl.exe", "-d", "FedoraLinux-42" },
		cwd = "~",
	},
}

return {
	launch_menu = {
		items.pwsh,
		items.ubuntu,
	},
	default_prog = items.ubuntu.args,
	default_cwd = "~",
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 500,
	prefer_egl = true,
	max_fps = 120,
}
