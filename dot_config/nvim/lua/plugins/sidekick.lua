MiniDeps.add("folke/sidekick.nvim")
local utils = require("config.utils")
-- AGENT
require("sidekick").setup({
	nes = {
		enabled = false,
		debounce = 200,
		diff = {
			inline = "words",
		},
	},
	cli = {
		---@type sidekick.win.Opts
		win = {
			layout = "right",
			split = {
				width = 75,
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
	sk_cli.toggle("opencode")
end, "Agent: Toggle")
utils.map({ "x", "n" }, utils.L("as"), function()
	sk_cli.send({ msg = "{this}", filter = get_installed })
end, "Agent: Send Selection")
utils.map("n", utils.L("af"), function()
	sk_cli.send({ msg = "{file}", filter = get_installed })
end, "Agent: Send File")
utils.map("n", "<s-tab>", function()
	require("sidekick.nes").apply()
end, "Goto/Apply NES", { expr = true })
