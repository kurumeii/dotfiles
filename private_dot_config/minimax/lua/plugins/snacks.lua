local utils = require("config.utils")
require("snacks").setup({
	statuscolumn = {
		enabled = true,
		left = {
			"git",
		},
		right = {
			"sign",
			"fold",
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
		enabled = not vim.g.mini_picks,
		sources = {
			explorer = {
				hidden = vim.g.show_dotfiles,
				ignored = vim.g.show_dotfiles,
				exclude = { ".git", "node_modules" },
			},
		},
	},
	animate = {
		easing = "inOutQuad",
	},
	quickfile = { enabled = true },
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

-- Terminal tracking
local active_terminals = {}
local next_terminal_id = 1

utils.map("n", utils.L("gg"), Snacks.lazygit.open, "Open Lazygit")
utils.map("n", utils.L("tn"), function()
	local term_id = next_terminal_id
	next_terminal_id = next_terminal_id + 1
	active_terminals[term_id] = true
	Snacks.terminal.open(nil, {
		count = term_id,
	})
end, "Terminal New")

utils.map("n", utils.L("tb"), function()
	Snacks.terminal.open("btop", { win = { style = "float" } })
end, "Open btop in floating terminal")

utils.map("n", utils.L("td"), function()
	local terminals = {}
	for id, _ in pairs(active_terminals) do
		table.insert(terminals, { id = id, label = "term-" .. id })
	end
	if #terminals == 0 then
		utils.notify("No terminals created yet", "WARN")
		return
	end
	table.sort(terminals, function(a, b)
		return a.id < b.id
	end)
	local terminal_labels = {}
	for _, term in ipairs(terminals) do
		table.insert(terminal_labels, term.label)
	end
	if #terminals == 1 then
		local term = Snacks.terminal.get(nil, { create = false })
		if term then
			active_terminals[term.id] = nil
			term:close()
		end
		return
	else
		vim.ui.select(terminal_labels, {
			prompt = "Select terminal:",
		}, function(choice)
			if choice then
				local term_id = tonumber(string.match(choice, "%d+"))
				local term = Snacks.terminal.get(nil, { count = term_id, create = false })
				if term then
					active_terminals[term.id] = nil
					term:close()
				end
			end
		end)
	end
end, "Destroy Terminal")

utils.map("n", utils.L("tt"), function()
	local terminals = {}
	for id, _ in pairs(active_terminals) do
		table.insert(terminals, { id = id, label = "term-" .. id })
	end
	if #terminals == 0 then
		utils.notify("No terminals created yet", "WARN")
		return
	end
	table.sort(terminals, function(a, b)
		return a.id < b.id
	end)
	local terminal_labels = {}
	for _, term in ipairs(terminals) do
		table.insert(terminal_labels, term.label)
	end
	if #terminals == 1 then
		Snacks.terminal.toggle(nil)
		return
	else
		vim.ui.select(terminal_labels, {
			prompt = "Select terminal:",
		}, function(choice)
			if choice then
				Snacks.terminal.toggle(nil, {
					count = tonumber(string.match(choice, "%d+")),
				})
			end
		end)
	end
end, "Terminal List/Select")

if not vim.g.mini_picks then
	vim.ui.select = Snacks.picker.select
	utils.map("n", utils.L("ff"), Snacks.picker.files, "Find files")
	utils.map({ "n", "v" }, utils.L("fw"), function()
		local getMode = vim.api.nvim_get_mode().mode
		if getMode == "v" then
			Snacks.picker.grep_word()
		else
			Snacks.picker.grep()
		end
	end, "Find word (Grep)")
	utils.map("n", utils.L("fr"), Snacks.picker.registers, "Find registers")
	utils.map("n", utils.L("fc"), Snacks.picker.commands, "Find commands")
	utils.map("n", utils.L("fh"), Snacks.picker.help, "Find help")
	utils.map("n", utils.L("fR"), Snacks.picker.resume, "Resume last pick")
	utils.map("n", utils.L("fk"), Snacks.picker.keymaps, "Find keymaps")
	utils.map("n", utils.L("fb"), Snacks.picker.buffers, "Find buffers")
	utils.map("n", utils.L("fq"), Snacks.picker.qflist, "Find quickfix list")
	utils.map("n", utils.L("fC"), function()
		Snacks.picker.files({
			cwd = vim.fn.stdpath("config"),
		})
	end, "Find Config files")
	utils.map("n", utils.L("fp"), function()
		local project_dir = vim.fs.joinpath(vim.fn.expand("~"), "projects")
		if vim.fn.isdirectory(project_dir) == 0 then
			return
		end
		Snacks.picker.projects({
			cwd = project_dir,
		})
	end, "Find project files")
	utils.map("n", utils.L("fd"), Snacks.picker.diagnostics_buffer, "Find Diagnostics in buffer")
	utils.map("n", utils.L("fD"), Snacks.picker.diagnostics, "Find Diagnostics")
	utils.map("n", utils.L("fm"), Snacks.picker.marks, "Find marks")
	utils.map("n", utils.L("fH"), Snacks.picker.command_history, "Find history")
	utils.map("n", utils.L("fv"), Snacks.picker.recent, "Find visit paths")
	utils.map("n", utils.L("fl"), function()
		Snacks.picker.lines({
			buf = vim.api.nvim_get_current_buf(),
		})
	end, "Find buffer line")
	utils.map("n", utils.L("ft"), Snacks.picker.colorschemes, "Find colorschemes")
	require("mini.deps").later(function()
		require("mini.deps").add("folke/todo-comments.nvim")
		require("todo-comments").setup({
			signs = false,
		})
		utils.map("n", utils.L("fT"), function()
			Snacks.picker.todo_comments({
				keywords = { "todo", "fixme", "note", "bug" },
			})
		end, "Find task comment")
	end)

	utils.map("n", utils.L("lr"), Snacks.picker.lsp_references, "LSP references")
	utils.map("n", utils.L("ld"), Snacks.picker.lsp_definitions, "LSP definitions")
	utils.map("n", utils.L("lt"), Snacks.picker.lsp_type_definitions, "LSP type definitions")
	utils.map("n", utils.L("li"), Snacks.picker.lsp_implementations, "LSP implementations")
	utils.map("n", utils.L("lD"), Snacks.picker.lsp_declarations, "LSP declarations")
	utils.map("n", utils.L("ls"), Snacks.picker.lsp_symbols, "LSP symbols")
	utils.map("n", utils.L("lS"), Snacks.picker.lsp_workspace_symbols, "LSP symbols")
end
