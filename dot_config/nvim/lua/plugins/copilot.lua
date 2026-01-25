local utils = require("config.utils")
vim.g.copilot_no_tab_map = true
vim.g.sidekick_nes = false
vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
utils.map("i", "<c-l>", "<Plug>(copilot-accept-line)", "Copilot accept line")

-- AGENT
require("sidekick").setup({
	cli = {
		---@type sidekick.win.Opts
		win = {
			split = {
				width = 70,
			},
			keys = {
				prompt = { "<c-]>", "prompt" },
			},
		},
	},
})

local sk_cli = require("sidekick.cli")
local get_installed = { installed = true }

utils.map("n", utils.L("aa"), function()
	sk_cli.toggle({ filter = get_installed })
end, "Agent: Toggle")
utils.map({ "x", "n" }, utils.L("as"), function()
	sk_cli.send({ msg = "{this}", filter = get_installed })
end, "Agent: Send Selection")
utils.map("n", utils.L("af"), function()
	sk_cli.send({ msg = "{file}", filter = get_installed })
end, "Agent: Send File")
