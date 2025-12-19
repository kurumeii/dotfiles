vim.g.using_snack_notif = true
local utils = require("config.utils")
require("snacks").setup({
	statuscolumn = {
		enabled = true,
		folds = {
			git_hl = false,
			open = true,
		},
	},
	explorer = {
		enabled = true,
		replace_netrw = false,
	},
	lazygit = { enabled = true },
	terminal = { enabled = true },
	bigfile = { enabled = true },
	image = { enabled = true },
	indent = { enabled = true },
	animate = {
		fps = 120,
		duration = 200,
		easing = "inOutCirc",
	},
	notifier = {
		enabled = vim.g.using_snack_notif,
		style = "compact",
		margin = {
			top = 2,
		},
	},
	-- Styles
	styles = {
		notification = {
			wo = { wrap = true },
		},
	},
})

if vim.g.using_snack_notif then
	vim.notify = Snacks.notifier
	vim.api.nvim_create_autocmd("LspProgress", {
		---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
		callback = function(ev)
			vim.notify(vim.lsp.status(), "info", {
				id = "lsp_progress",
				title = "LSP Progress",
				opts = function(notif)
					local spinner = mininvim.icons.spinner
					notif.icon = ev.data.params.value.kind == "end" and mininvim.icons.check
						or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
				end,
			})
		end,
	})
	utils.map("n", utils.L("nh"), function()
		Snacks.notifier.show_history()
	end, "Snacks show history")
	utils.map("n", utils.L("nc"), function()
		local all_notif = Snacks.notifier.get_history()
		for _, notification in ipairs(all_notif) do
			Snacks.notifier.hide(notification.id)
		end
	end, "Snacks clear all history")
end

utils.map("n", utils.L("fe"), Snacks.explorer.open, "Find Explorer")
utils.map("n", utils.L("gg"), Snacks.lazygit.open, "Open Lazygit")
utils.map("n", utils.L("t"), function()
	Snacks.terminal.toggle()
end, "Terminal")
