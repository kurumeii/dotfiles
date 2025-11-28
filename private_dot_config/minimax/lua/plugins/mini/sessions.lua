local utils = require("config.utils")
local MiniSessions = require("mini.sessions")
MiniSessions.setup({
	autoread = false,
	autowrite = true,
	force = {
		delete = true,
		write = true,
	},
	directory = vim.fn.stdpath("data") .. "/sessions/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
})

utils.map({ "n" }, utils.L("ss"), function()
	local default_sessions = "session-" .. os.date("%Y%m%d-%H%M%S")
	vim.ui.input({ prompt = "Enter session name: ", default = default_sessions }, function(input)
		if input == nil or input == "" then
			utils.notify("Name is required for session", "WARN")
			return
		end
		MiniSessions.write(input)
		utils.notify("Session " .. input .. " saved", "INFO")
	end)
end, "Save session")
utils.map({ "n" }, utils.L("sd"), function()
	local ok, err = pcall(function()
		MiniSessions.select("delete")
	end)
	if not ok then
		utils.notify("Error: " .. tostring(err), "ERROR")
	end
end, "Delete session")
utils.map({ "n" }, utils.L("sl"), function()
	MiniSessions.select()
end, "Load session")
