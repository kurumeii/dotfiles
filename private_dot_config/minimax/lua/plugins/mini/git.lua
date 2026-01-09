---@diagnostic disable: need-check-nil
local utils = require("config.utils")
local blame_enabled = true
local style = {
	sign = "sign",
	num = "number",
}
local au_group = vim.api.nvim_create_augroup("MiniGitBlameGroup", { clear = true })
local ns_id = vim.api.nvim_create_namespace("MiniGitBlame")

require("mini.git").setup()
require("mini.diff").setup({
	view = {
		style = style.sign,
		signs = {
			add = mininvim.icons.git_signs.add,
			change = mininvim.icons.git_signs.change,
			delete = mininvim.icons.git_signs.delete,
		},
	},
	mappings = {
		reset = utils.L("gr"),
		textobject = "gh",
		goto_first = "[H",
		goto_last = "]H",
		goto_next = "]h",
		goto_prev = "[h",
	},
})

vim.opt.updatetime = 500

local function clear_blame()
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

-- Diff current buffer against a commit
local function diff_this()
	-- 1. Get git info and calculate file path
	local buf_data = MiniGit.get_buf_data(0)
	if not buf_data or not buf_data.root then
		vim.notify("Not in a git repository.", vim.log.levels.WARN, { title = "Git" })
		return
	end

	local root = buf_data.root
	local file_path_from_root = buf_data.file

	if not file_path_from_root then
		local abs_file_path = vim.api.nvim_buf_get_name(0)
		if not abs_file_path or abs_file_path == "" then
			vim.notify("Buffer has no file path.", vim.log.levels.WARN, { title = "Git" })
			return
		end
		local normalized_root = root:gsub("[\\/]", "/")
		local normalized_abs_path = abs_file_path:gsub("[\\/]", "/")

		if normalized_abs_path:find(normalized_root, 1, true) == 1 then
			file_path_from_root = normalized_abs_path:sub(#normalized_root + 2)
		else
			vim.notify("File is not inside the git repository: " .. root, vim.log.levels.WARN, { title = "Git" })
			return
		end
	end

	if not file_path_from_root or file_path_from_root == "" then
		vim.notify("Could not determine file path relative to git root.", vim.log.levels.WARN, { title = "Git" })
		return
	end

	-- 4. Create the final diff view
	local function create_diff_view(old_content, hash)
		local original_win = vim.api.nvim_get_current_win()
		local original_buf = vim.api.nvim_get_current_buf()

		-- Create a temporary buffer in a new vertical split
		vim.cmd("vnew")
		local new_buf = vim.api.nvim_get_current_buf()

		-- Set content and options
		local ft = vim.api.nvim_get_option_value("filetype", { buf = original_buf })
		vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.split(old_content, "\n", { plain = true }))
		vim.api.nvim_set_option_value("filetype", ft, { buf = new_buf })
		vim.api.nvim_set_option_value("readonly", true, { buf = new_buf })
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = new_buf })

		-- Set name and start diff
		local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(original_buf), ":t")
		vim.api.nvim_buf_set_name(new_buf, string.format("%s@%s", file_name, hash:sub(1, 7)))
		vim.cmd("diffthis")

		-- Switch back and start diff on original window
		vim.api.nvim_set_current_win(original_win)
		vim.cmd("diffthis")
	end

	-- 3. Get content of the selected commit
	local function on_commit_selected(selection)
		if not selection then
			return
		end
		local hash = selection:match("^(%S+)")
		if not hash then
			return
		end

		local get_content_cmd = { "git", "-C", root, "show", hash .. ":" .. file_path_from_root }
		vim.system(get_content_cmd, { text = true }, function(content_obj)
			vim.schedule(function()
				local old_content = ""
				if content_obj.code == 0 then
					old_content = content_obj.stdout
				elseif not (content_obj.stderr and content_obj.stderr:match("exists on disk, but not in")) then
					vim.notify(
						"Could not get file content from git: " .. (content_obj.stderr or ""),
						vim.log.levels.ERROR,
						{ title = "Git" }
					)
					return
				end
				create_diff_view(old_content, hash)
			end)
		end)
	end

	-- 2. Get commit log and show picker
	local get_log_cmd = { "git", "-C", root, "log", "--pretty=format:%h	%s	%ar", "--", file_path_from_root }
	vim.system(get_log_cmd, { text = true }, function(log_obj)
		vim.schedule(function()
			if log_obj.code ~= 0 or log_obj.stdout == "" then
				vim.notify("Could not get commit history for this file.", vim.log.levels.WARN, { title = "Git" })
				return
			end
			local commits = vim.split(log_obj.stdout, "\n", { trimempty = true })
			if #commits == 0 then
				vim.notify("No commits found for this file.", vim.log.levels.INFO, { title = "Git" })
				return
			end
			table.insert(commits, 1, "HEAD	Current HEAD")
			vim.ui.select(commits, { prompt = "Diff against commit:" }, on_commit_selected)
		end)
	end)
end

-- Toggle for blame annotations
local function toggle_blame()
	blame_enabled = not blame_enabled
	if not blame_enabled then
		clear_blame()
	end
	local msg = blame_enabled and "Blame annotations enabled" or "Blame annotations disabled"
	vim.notify(msg, vim.log.levels.INFO, { title = "Git" })
end

local function toggle_diff_style()
	local config = MiniDiff.config
	if config.view.style == style.sign then
		config.view.style = style.num
		vim.notify("Diff style set to: number", vim.log.levels.INFO, { title = "Git" })
	else
		config.view.style = style.sign
		vim.notify("Diff style set to: sign", vim.log.levels.INFO, { title = "Git" })
	end
	MiniDiff.setup(config)
end

-- Show blame when cursor holds still
vim.api.nvim_create_autocmd("CursorHold", {
	group = au_group,
	callback = function()
		if not blame_enabled then
			return
		end
		clear_blame()
		if not MiniGit then
			return
		end
		local buf_data = MiniGit.get_buf_data(0)
		if not buf_data or not buf_data.root then
			return
		end

		-- Use the root path found by mini.git for safety
		local root = buf_data.root
		-- INTEGRATION END

		local file = vim.fn.expand("%")
		local line = vim.fn.line(".")
		local cmd_list = { "git", "-C", root, "blame", "-L", string.format("%d,%d", line, line), "--porcelain", file }

		vim.system(cmd_list, { text = true }, function(obj)
			vim.schedule(function()
				-- If we moved away, don't show stale blame
				if vim.api.nvim_win_get_cursor(0)[1] ~= line then
					return
				end

				if obj.code ~= 0 or obj.stdout == "" then
					return
				end

				local output = obj.stdout
				-- Parse Output
				local author = output:match("author (.-)\n")
				local date_ts = output:match("author%-time (.-)\n")
				local summary = output:match("summary (.-)\n")
				local hash = output:match("^(%S+)")
				if hash and hash:match("^0+$") then
					local text = "  Not committed yet"

					vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, 0, {
						virt_text = { { text, "Comment" } },
						hl_mode = "combine",
					})
					return
				end

				if author and date_ts and summary then
					-- Calculate relative time
					local rel_time = utils.get_relative_time(tonumber(date_ts))
					-- Format your text here
					local text = string.format(" (%s) %s -> %s", rel_time, author, summary)

					vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, 0, {
						virt_text = { { text, "Comment" } },
						hl_mode = "combine",
					})
				end
			end)
		end)
	end,
})

-- Clear blame immediately when moving
vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
	group = au_group,
	callback = clear_blame,
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

utils.map("n", utils.L("gb"), toggle_blame, "Git toggle git Blame")
utils.map("n", utils.L("gd"), diff_this, "Git diff against commit")
utils.map("n", utils.L("gh"), MiniDiff.toggle_overlay, "Git toggle git overlay")
utils.map("n", utils.L("gt"), toggle_diff_style, "Git toggle diff Style")
utils.map("n", utils.L("gu"), function()
	MiniExtra.pickers.git_hunks()
end, "Git unstaged hunks")
utils.map("n", utils.L("gs"), function()
	MiniExtra.pickers.git_hunks({
		scope = "staged",
	})
end, "Git staged hunks")
utils.map("n", utils.L("gc"), function()
	MiniExtra.pickers.git_commits({
		path = vim.api.nvim_buf_get_name(0),
	})
end, "Git commit current buffer")
