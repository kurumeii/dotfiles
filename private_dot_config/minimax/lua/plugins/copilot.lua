local utils = require("config.utils")
vim.g.copilot_no_tab_map = true
vim.g.sidekick_nes = false
vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
utils.map("i", "<c-l>", "<Plug>(copilot-accept-line)", "Copilot accept line")

-- AGENT
require("sidekick").setup()

utils.map("n", utils.L("aa"), function()
	require("sidekick.cli").toggle({ filter = { installed = true } })
end, "Agent: Toggle")
utils.map({ "x", "n" }, utils.L("as"), function()
	local sk_cli = require("sidekick.cli")
	sk_cli.send({ msg = "{this}" })
end, "Agent: Send Selection")
