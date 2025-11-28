require("mini.keymap").setup()
local map_combo = MiniKeymap.map_combo
local mode = { "i", "t", "c", "s", "x" }
map_combo(mode, "jk", "<bs><bs><esc>")
map_combo(mode, "kj", "<bs><bs><esc>")
map_combo(mode, "qq", "<BS><BS><C-\\><C-n>")
map_combo(mode, "qk", "<BS><BS><C-\\><C-n>")
