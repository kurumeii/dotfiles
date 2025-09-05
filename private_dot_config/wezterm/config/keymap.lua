--- @type Wezterm
local wez = require("wezterm")
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

---@module "wezterm"
---@type Config
return {
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
