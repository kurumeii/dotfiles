local utils = require("config.utils")
vim.opt.updatetime = 500
require("mini.git").setup()
require("mini.diff").setup({
	view = {
		style = "sign",
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

local ns_id = vim.api.nvim_create_namespace("MiniGitBlame")

local function get_relative_time(timestamp)
	local current_time = os.time()
	local diff = os.difftime(current_time, timestamp)

	local minutes = math.floor(diff / 60)
	local hours = math.floor(minutes / 60)
	local days = math.floor(hours / 24)
	local months = math.floor(days / 30)
	local years = math.floor(days / 365)

	if minutes < 1 then
		return "just now"
	elseif minutes < 60 then
		return string.format("%d mins ago", minutes)
	elseif hours < 24 then
		return string.format("%d hours ago", hours)
	elseif days < 30 then
		return string.format("%d days ago", days)
	elseif months < 12 then
		return string.format("%d months ago", months)
	else
		return string.format("%d years ago", years)
	end
end

local function clear_blame()
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end
local function show_blame()
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
	local cmd = string.format("git -C %s blame -L %d,%d --porcelain %s", root, line, line, file)

	-- Run asynchronously (optional but better for performance)
	-- or synchronously (easier) like below:
	local output = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 or output == "" then
		return
	end

	-- Parse Output
	local author = output:match("author (.-)\n")
	local date_ts = output:match("author%-time (.-)\n")
	local summary = output:match("summary (.-)\n")
	local hash = output:match("^(%S+)")
	if hash and hash:match("^0+$") then
		local text = "  Not committed yet"

		-- Ensure we are still on the same line
		if vim.api.nvim_win_get_cursor(0)[1] ~= line then
			return
		end

		vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, 0, {
			virt_text = { { text, "Comment" } },
			hl_mode = "combine",
		})
		return
	end
	if author and date_ts and summary then
		if vim.api.nvim_win_get_cursor(0)[1] ~= line then
			return
		end

		-- Calculate relative time
		local rel_time = get_relative_time(tonumber(date_ts))
		-- Format your text here
		local text = string.format(" (%s) %s -> %s", rel_time, author, summary)

		vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, 0, {
			virt_text = { { text, "Comment" } },
			hl_mode = "combine",
		})
	end
end

local au_group = vim.api.nvim_create_augroup("MiniGitBlameGroup", { clear = true })

-- Show blame when cursor holds still
vim.api.nvim_create_autocmd("CursorHold", {
	group = au_group,
	callback = function()
		clear_blame()
		show_blame()
	end,
})

-- Clear blame immediately when moving
vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
	group = au_group,
	callback = clear_blame,
})
