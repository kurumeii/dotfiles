local MiniNotify = require("mini.notify")
MiniNotify.setup({
	content = {
		format = function(notif)
			if notif.data.source == "lsp_progress" then
				return notif.msg
			end
			return MiniNotify.default_format(notif)
		end,
		sort = function(notif_arr)
			table.sort(notif_arr, function(a, b)
				return a.ts_update > b.ts_update
			end)
			return notif_arr
		end,
	},
	lsp_progress = {
		enable = true,
		duration_last = 2000,
	},
	window = {
		config = function()
			local pad = 2
			return { col = vim.o.columns, row = pad }
		end,
	},
})

vim.notify = MiniNotify.make_notify()
local utils = require("config.utils")
utils.map("n", utils.L("nd"), MiniNotify.clear, "Notification Dismiss")
utils.map("n", utils.L("nh"), MiniNotify.show_history, "Notification History")

-- Mini notify
vim.api.nvim_create_autocmd("BufWritePost", {
	desc = "MiniNotify Saved",
	callback = function(args)
		local path = vim.api.nvim_buf_get_name(args.buf)
		if path ~= "" then
			path = vim.fn.fnamemodify(path, ":~:.")
		end
		vim.notify("Saved " .. vim.inspect(path))
	end,
})

-- vim.api.nvim_create_autocmd("TextYankPost", {
-- 	desc = "MiniNotify on yank",
-- 	callback = function()
-- 		if vim.fn.getreg('"') then
-- 			local number_of_lines = vim.fn.getreg('"'):len()
-- 			utils.notify("Yanked " .. number_of_lines .. " lines", "INFO")
-- 		end
-- 	end,
-- })
--
