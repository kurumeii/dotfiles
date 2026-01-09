local utils = require("config.utils")
require("snacks").setup({
	statuscolumn = {
		enabled = true,
		left = {
			"git",
			"mark",
		},
		right = {
			"fold",
			"sign",
		},
		folds = {
			git_hl = false,
			open = true,
		},
		git = {
			patterns = { "MiniDiffSign" },
		},
	},
	explorer = {
		enabled = vim.g.snacks_explorer,
		replace_netrw = false,
	},
	picker = {
		sources = {
			explorer = {
				hidden = true,
				ignored = true,
				exclude = { ".git", "node_modules" },
			},
		},
	},
	animate = {
		easing = "inOutQuad",
	},
	scroll = { enabled = vim.g.mini_animate == false },
	lazygit = { enabled = true },
	terminal = { enabled = true },
	bigfile = { enabled = true },
	image = { enabled = true },
	indent = { enabled = vim.g.snacks_indent },
	notifier = {
		enabled = vim.g.snacks_notify,
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

if vim.g.snacks_notify then
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

if vim.g.snacks_explorer then
	utils.map("n", utils.L("e"), Snacks.explorer.open, "Find Explorer")
end

utils.map("n", utils.L("gg"), Snacks.lazygit.open, "Open Lazygit")
utils.map("n", utils.L("tt"), Snacks.terminal.toggle, "Terminal")
utils.map("n", utils.L("td"), function()
	Snacks.terminal:destroy()
end, "Destroy Terminal")
