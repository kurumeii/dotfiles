local starter = require("mini.starter")
local header = [[
					Meow! Here's your Neovim
           __..--''``---....___   _..._    __
 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
///_.-' _..--.'_    \                    `( ) ) // //
/ (_..-' // (< _     ;_..__               ; `' / ///
 / // // //  `-._,_)' // / ``--...____..-' /// / //
    ]]

starter.setup({
	-- query_updaters = "",
	items = {
		starter.sections.sessions(1, true),
		starter.sections.recent_files(3, true, true),
		starter.sections.builtin_actions(),
	},
	header = header,
	footer = function()
		local elapsed_ns = vim.uv.hrtime() - vim.g.start_time
		local elapsed_ms = elapsed_ns / 1e6
		return "⚡ Neovim loaded in " .. string.format("%.2f", elapsed_ms) .. "ms"
	end,
})
local utils = require("config.utils")
utils.map("n", utils.L("h"), MiniStarter.open, "Open Dashboard")

vim.api.nvim_create_augroup("MiniStarterJK", { clear = true })

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniStarterOpened",
	callback = function()
		if vim.bo.filetype == "ministarter" then
			local opts = { silent = true, buffer = true }
			utils.map("n", "j", function()
				MiniStarter.update_current_item("next")
			end, "Dashboard: Next item", opts)
			utils.map("n", "k", function()
				MiniStarter.update_current_item("prev")
			end, "Dashboard: Previous item", opts)
		end
	end,
})
