local utils = require("config.utils")

-- Mini Files
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local MiniFiles = require("mini.files")
		utils.map({ "n" }, "//", function()
			utils.show_dotfiles = not utils.show_dotfiles
			local new_filter = utils.show_dotfiles and utils.filter_show or utils.filter_hide
			MiniFiles.refresh({ content = { filter = new_filter } })
		end, "Toggle hidden files", { buffer = args.buf })
		utils.map_split(args.buf, "<C-w>s", "horizontal", false)
		utils.map_split(args.buf, "<C-w>v", "vertical", false)
	end,
})

-- LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(args)
		utils.map("n", utils.L("cr"), function()
			vim.ui.input({ prompt = "Rename to: " }, function(new_name)
				if not new_name then
					utils.notify("Rename cancelled", "WARN")
				else
					vim.lsp.buf.rename(new_name, { bufnr = args.buf })
					utils.notify("Rename successfully")
				end
			end)
		end, "Rename")
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "vtsls" then
			utils.map("n", utils.L("co"), utils.action("source.organizeImports"), "[TS] Organize imports")
			utils.map("n", utils.L("cv"), utils.command("typescript.selectTypeScriptVersion"), "[TS] Select ts version")
		end
		utils.map("n", "<s-k>", vim.lsp.buf.hover)
	end,
})

-- Navic
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.api.nvim_buf_line_count(0) > 10000 then
			vim.b.navic_lazy_update_context = true
		end
	end,
})

-- Dashboard

-- Auto save session
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		local except = {
			"ministarter",
			"snacks_dashboard",
		}
		if vim.tbl_contains(except, vim.bo.ft) then
			return
		end
		local default_session = "session-" .. os.date("%Y%m%d-%H%M%S")
		local session_name = MiniSessions.get_latest() or default_session
		MiniSessions.write(session_name)
	end,
})

--Treesitter
-- Auto-install and start parsers for unknown filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
	desc = "Enable Treesitter",
	callback = function(event)
		local bufnr = event.buf
		local filetype = vim.bo[bufnr].filetype
		-- Skip if no filetype
		if filetype == "" then
			return
		end
		-- Set values to ignore ft
		---@diagnostic disable-next-line: unused-local
		local ignore_fts = {}
		local ts = require("nvim-treesitter")
		local already_installed = ts.get_installed("parsers")
		-- Get parser name based on filetype
		local parser_name = vim.treesitter.language.get_lang(filetype)
		if not parser_name then
			utils.notify("No treesitter parser found for filetype: " .. filetype, "WARN", "Treesitter")
			return
		end

		-- Try to get existing parser
		local parser_configs = require("nvim-treesitter.parsers")
		if not parser_configs[parser_name] then
			return -- Parser not available, skip silently
		end

		local parser_exists = pcall(vim.treesitter.get_parser, bufnr, parser_name)

		if not parser_exists then
			-- check if parser is already installed
			if vim.tbl_contains(already_installed, parser_name) then
				utils.notify("Parser for " .. parser_name .. " already installed.", "INFO", "Treesitter")
			else
				utils.notify("Installing missing parser for " .. parser_name, "INFO", "Treesitter")
				ts.install({ parser_name })
			end
		end
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		-- vim.defer_fn(function()
		-- 	vim.treesitter.start(bufnr, parser_name)
		-- end, 500)
	end,
})

-- MiniIndentScope
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"Trouble",
		"alpha",
		"dashboard",
		"fzf",
		"help",
		"lazy",
		"mason",
		"neo-tree",
		"notify",
		"snacks_dashboard",
		"snacks_notif",
		"snacks_terminal",
		"snacks_win",
		"toggleterm",
		"trouble",
	},
	desc = "Disable indentscope in these filetypes",
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

-- Commentstring
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json" },
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

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

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "MiniNotify on yank",
	callback = function()
		if vim.fn.getreg('"') then
			local number_of_lines = vim.fn.getreg('"'):len()
			utils.notify("Yanked " .. number_of_lines .. " lines", "INFO")
		end
	end,
})

-- Minigit
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniGitCommandSplit",
	callback = function(au_data)
		if au_data.data.git_subcommand ~= "blame" then
			return
		end

		-- Align blame output with source
		local win_src = au_data.data.win_source
		vim.wo.wrap = false
		vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
		vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })

		-- Bind both windows so that they scroll together
		vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
	end,
})

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "MiniDiffUpdated",
-- 	callback = function(data)
-- 		local summary = vim.b[data.buf].minidiff_summary
-- 		local t = {}
-- 		if summary == nil then
-- 			return
-- 		end
-- 		if summary.add > 0 then
-- 			table.insert(t, mininvim.icons.git_add .. summary.add)
-- 		end
-- 		if summary.change > 0 then
-- 			table.insert(t, mininvim.icons.git_edit .. summary.change)
-- 		end
-- 		if summary.delete > 0 then
-- 			table.insert(t, mininvim.icons.git_remove .. summary.delete)
-- 		end
-- 		vim.b[data.buf].minidiff_summary_string = table.concat(t, " ")
-- 	end,
-- })

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function(arg)
		utils.map("n", utils.L("ug"), require("mini.diff").toggle_overlay, "UI toggle git overlay", {
			buffer = arg.buf,
		})
		utils.map("n", utils.L("uG"), require("mini.diff").toggle, "UI toggle git", {
			buffer = arg.buf,
		})
	end,
})

-- Chezmoi

local get_chezmoi_dirs = function()
	local home = assert(os.getenv("HOME") or os.getenv("USERPROFILE"), "HOME or USERPROFILE must be set")
	return home:gsub("\\", "/") .. "/.local/share/chezmoi/*"
end
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = get_chezmoi_dirs(),
	callback = function()
		vim.schedule(require("chezmoi.commands.__edit").watch)
	end,
})
