require("mini.keymap").setup()
local map_combo = MiniKeymap.map_combo
local map_multistep = MiniKeymap.map_multistep
local mode = { "i", "t", "c", "s", "x" }
local utils = require("config.utils")

map_combo(mode, "jk", "<bs><bs><esc>")
map_combo(mode, "kj", "<bs><bs><esc>")
map_combo(mode, "qq", "<BS><BS><C-\\><C-n>")
map_combo(mode, "qk", "<BS><BS><C-\\><C-n>")
map_multistep("i", "<cr>", {
	"pmenu_accept",
	"minipairs_cr",
})

utils.map("n", utils.L("pu"), function()
	vim.cmd("DepsUpdate!")
	vim.cmd("DepsSnapSave")
end, "Deps: Package update")
utils.map("n", utils.L("pm"), utils.C("Mason"), "Mason: Package")
utils.map("n", utils.L("pc"), utils.C("DepsClean"), "Deps: Package Clean")
utils.map("n", utils.L("ps"), utils.C("DepsSnapLoad"), "Deps: Package Sync")
