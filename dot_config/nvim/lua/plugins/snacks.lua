local utils = require("config.utils")
require("mini.deps").add("folke/snacks.nvim")

require("snacks").setup({
	statuscolumn = {
		enabled = true,
		left = {
			"git",
			"mark",
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
		enabled = not vim.g.mini.explorer,
		replace_netrw = true,
	},
	picker = {
		enabled = not vim.g.mini.picks,
		sources = {
			explorer = {
				hidden = vim.g.mini.show_dotfiles,
				ignored = vim.g.mini.show_dotfiles,
				exclude = { ".git", "node_modules" },
			},
		},
	},
	animate = {
		easing = "inOutQuad",
	},
	quickfile = { enabled = false },
	scroll = { enabled = not vim.g.mini.animate },
	lazygit = { enabled = true },
	terminal = { enabled = true, win = { enter = false } },
	bigfile = { enabled = true },
	image = { enabled = true },
	input = { enabled = true },
	indent = { enabled = not vim.g.mini.notify, style = "compact", margin = {
		top = 2,
	} },
	-- Styles
	styles = {
		notification = {
			wo = { wrap = true },
		},
	},
})

if not vim.g.mini.notify then
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

if not vim.g.mini.explorer then
	utils.map("n", utils.L("e"), Snacks.explorer.open, "Find Explorer")
end

local function get_terms()
	---@type { id : integer, term: snacks.win }[]
	local terms = {}
	for i = 1, 20 do
		local term = Snacks.terminal.get(nil, { count = i, create = false })
		if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
			table.insert(terms, { id = i, term = term })
		end
	end
	return terms
end

local function get_next_id()
	local terms = get_terms()
	local map = {}
	for _, t in ipairs(terms) do
		map[t.id] = true
	end
	for i = 1, 20 do
		if not map[i] then
			return i
		end
	end
	return #terms + 1
end

local function kill_term(term)
	if term.destroy then
		term:destroy()
	else
		term:close()
		if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
			vim.api.nvim_buf_delete(term.buf, { force = true })
		end
	end
end

utils.map("n", utils.L("gg"), function()
	Snacks.lazygit.open({ win = { enter = true } })
end, "Open Lazygit")

utils.map("n", utils.L("tb"), function()
	Snacks.terminal.open("btop", { win = { style = "float", enter = true } })
end, "Open btop in floating terminal")

utils.map("n", utils.L("tn"), function()
	Snacks.terminal.open(nil, {
		count = get_next_id(),
	})
end, "Terminal New")

utils.map("n", utils.L("td"), function()
	local terms = get_terms()
	if #terms == 0 then
		utils.notify("No terminals to destroy", "WARN")
		return
	end

	if #terms == 1 then
		kill_term(terms[1].term)
	else
		vim.ui.select(terms, {
			prompt = "Select terminal to destroy:",
			format_item = function(item)
				return "Terminal " .. item.id
			end,
		}, function(choice)
			if choice then
				kill_term(choice.term)
			end
		end)
	end
end, "Destroy Terminal")

utils.map("n", utils.L("tt"), function()
	for _, item in ipairs(get_terms()) do
		item.term:toggle()
	end
end, "Hide all terminals")

utils.map("n", utils.L("tx"), function()
	for _, item in ipairs(get_terms()) do
		kill_term(item.term)
	end
end, "Close all terminals")

utils.map("n", utils.L("tl"), function()
	local terms = get_terms()
	if #terms == 0 then
		utils.notify("No terminals found", "WARN")
		return
	end
	vim.ui.select(terms, {
		prompt = "Select terminal:",
		format_item = function(item)
			return "Terminal " .. item.id
		end,
	}, function(choice)
		if choice then
			choice.term:toggle({ win = { enter = false } })
		end
	end)
end, "Terminal List/Select")

if not vim.g.mini.picks then
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
