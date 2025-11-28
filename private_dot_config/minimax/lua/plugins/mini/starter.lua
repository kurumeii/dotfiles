local starter = require("mini.starter")
starter.setup({
	items = {
		starter.sections.sessions(1, true),
		starter.sections.recent_files(3, true, true),
		starter.sections.builtin_actions(),
	},

	header = function()
		return [[
					Meow! Here's your Neovim
           __..--''``---....___   _..._    __
 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
///_.-' _..--.'_    \                    `( ) ) // //
/ (_..-' // (< _     ;_..__               ; `' / ///
 / // // //  `-._,_)' // / ``--...____..-' /// / //
    ]]
	end,
	footer = function()
		return "It's - " .. os.date("%x %X")
	end,
})
local utils = require("config.utils")
utils.map("n", utils.L("h"), MiniStarter.open, "Open Dashboard")
