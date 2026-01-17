require("mini.pick").setup({
	options = {
		content_from_bottom = false,
		use_cache = true,
	},
	window = {
		config = function()
			local height = math.floor(0.618 * vim.o.lines)
			local width = math.floor(0.618 * vim.o.columns)
			return {
				anchor = "NW",
				height = height,
				width = width,
				row = math.floor(0.5 * (vim.o.lines - height)),
				col = math.floor(0.5 * (vim.o.columns - width)),
			}
		end,
	},
	mappings = {
		toggle_preview = "<c-k>",
		toggle_info = "?",
		refine = "<c-q>",
		move_start = "",
		choose_marked = "<c-g>",
	},
})
vim.ui.select = MiniPick.ui_select

local utils = require("config.utils")
utils.map("n", utils.L("ff"), MiniPick.builtin.files, "Find files")
utils.map({ "n", "v" }, utils.L("fw"), function()
	local getMode = vim.api.nvim_get_mode().mode
	if getMode == "v" then
		MiniPick.builtin.grep({
			pattern = vim.fn.expand("<cword>"),
		})
	elseif getMode == "n" then
		MiniPick.builtin.grep_live()
	end
end, "Find word (Grep)")
utils.map("n", utils.L("fr"), MiniExtra.pickers.registers, "Find registers")
utils.map("n", utils.L("fc"), MiniExtra.pickers.commands, "Find commands")
utils.map("n", utils.L("fh"), MiniPick.builtin.help, "Find help")
utils.map("n", utils.L("fR"), MiniPick.builtin.resume, "Resume last pick")
utils.map("n", utils.L("fk"), MiniExtra.pickers.keymaps, "Find keymaps")
utils.map("n", utils.L("fb"), MiniPick.builtin.buffers, "Find buffers")
utils.map("n", utils.L("fq"), function()
	MiniExtra.pickers.list({ scope = "quickfix" })
end, "Find quickfix list")
utils.map("n", utils.L("fC"), function()
	MiniPick.builtin.files({
		tool = "fd",
	}, {
		source = {
			cwd = vim.fn.stdpath("config"),
		},
	})
end, "Find Config files")
utils.map("n", utils.L("fp"), function()
	local project_dir = vim.fs.joinpath(vim.fn.expand("~"), "projects")
	if vim.fn.isdirectory(project_dir) == 0 then
		return
	end
	local projects = {}
	for file in vim.fs.dir(project_dir) do
		local path = vim.fs.joinpath(project_dir, file)
		if vim.fn.isdirectory(path) == 1 then
			table.insert(projects, path)
		end
	end
	if #projects == 0 then
		return
	end
	MiniPick.start({
		source = {
			items = projects,
			name = "Projects",
			show = function(buf_id, items, query)
				MiniPick.default_show(buf_id, items, query, {
					show_icons = true,
				})
			end,
		},
	})
end, "Find project files")
utils.map("n", utils.L("fd"), function()
	MiniExtra.pickers.diagnostic(nil, { scope = "current" })
end, "Find Diagnostics in buffer")
utils.map("n", utils.L("fD"), function()
	MiniExtra.pickers.diagnostic(nil, { scope = "all" })
end, "Find Diagnostics")
utils.map("n", utils.L("fm"), MiniExtra.pickers.marks, "Find marks")
utils.map("n", utils.L("fH"), MiniExtra.pickers.history, "Find history")
utils.map("n", utils.L("fv"), MiniExtra.pickers.visit_paths, "Find visit paths")
utils.map("n", utils.L("fl"), function()
	MiniExtra.pickers.buf_lines({
		scope = "current",
	})
end, "Find buffer line")
utils.map("n", utils.L("ft"), function()
	MiniExtra.pickers.colorschemes()
end, "Find colorschemes")
utils.map("n", utils.L("fT"), function()
	MiniExtra.pickers.hipatterns({
		scope = "all",
		highlighters = {
			"todo",
			"fixme",
			"note",
			"bug",
		},
	})
end, "Find task comment")
utils.map("n", utils.L("fV"), MiniExtra.pickers.visit_labels, "Find visit labels")
-- LSP =======================================================================
utils.map("n", utils.L("lr"), function()
	MiniExtra.pickers.lsp({ scope = "references" })
end, "LSP references")
utils.map("n", utils.L("ld"), function()
	MiniExtra.pickers.lsp({ scope = "definition" })
end, "LSP definitions")
utils.map("n", utils.L("lt"), function()
	MiniExtra.pickers.lsp({ scope = "type_definition" })
end, "LSP type definitions")
utils.map("n", utils.L("li"), function()
	MiniExtra.pickers.lsp({ scope = "implementation" })
end, "LSP implementations")
utils.map("n", utils.L("lD"), function()
	MiniExtra.pickers.lsp({ scope = "declaration" })
end, "LSP declarations")
utils.map("n", utils.L("ls"), function()
	MiniExtra.pickers.lsp({ scope = "document_symbol" })
end, "LSP symbols")
utils.map("n", utils.L("lS"), function()
	MiniExtra.pickers.lsp({ scope = "workspace_symbol_live" })
end, "LSP workspace symbols")
