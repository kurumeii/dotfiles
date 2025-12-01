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
