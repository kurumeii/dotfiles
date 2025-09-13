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

---@module 'wezterm.wezterm'
---@type Config
return {
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
}
