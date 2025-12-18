local MiniStatusline = require("mini.statusline")

--- @param mode 'percent' | 'line'
local function get_location(mode)
	if mode == "percent" then
		local current_line = vim.api.nvim_win_get_cursor(0)[1]
		local total_lines = vim.api.nvim_buf_line_count(0)
		if current_line == 1 then
			return "TOP"
		elseif current_line == total_lines then
			return "BOTTOM"
		else
			return "%p%%"
		end
	else
		return "%l|%v"
	end
end
local function custom_fileinfo(args)
	args = args or {}
	local filetype = vim.bo.filetype
	filetype = MiniIcons.get("filetype", filetype) .. " " .. filetype
	if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
		return filetype
	end

	local encoding = vim.bo.fileencoding or vim.bo.encoding
	-- local format = vim.bo.fileformat
	local get_size = function()
		local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
		if size < 1024 then
			return string.format("%dB", size)
		elseif size < 1048576 then
			return string.format("%.2fKiB", size / 1024)
		else
			return string.format("%.2fMiB", size / 1048576)
		end
	end

	return string.format("%s%s[%s] %s", filetype, filetype == "" and "" or " ", encoding, get_size())
end
local function active_mode()
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 75 })
	mode = mode:upper()

	local git = MiniStatusline.section_git({ icon = mininvim.icons.git_branch, trunc_width = 40 })
	local diff = MiniStatusline.section_diff({ icon = "", trunc_width = 100 })
	local diagnostics = MiniStatusline.section_diagnostics({
		icon = "",
		signs = {
			ERROR = mininvim.icons.error,
			WARN = mininvim.icons.warn,
			INFO = mininvim.icons.info,
			HINT = mininvim.icons.hint,
		},
		trunc_width = 75,
	})
	local lsp = MiniStatusline.section_lsp({ icon = mininvim.icons.lsp, trunc_width = 75 })
	local function get_copilot_status()
		if vim.fn.exists("*copilot#Enabled") == 1 and vim.fn["copilot#Enabled"]() == 1 then
			return mininvim.icons.groups.copilot.glyph .. " "
		end
		return ""
	end
	local copilot = get_copilot_status()
	MiniStatusline.section_fileinfo = custom_fileinfo
	local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 150 })
	local location = get_location("percent")
	local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
	local filename = MiniStatusline.section_filename({ trunc_width = 250 })
	filename = vim.fn.expand("%:h:t") .. "/" .. vim.fn.expand("%:t")
	local eol = vim.bo.fileformat == "unix" and mininvim.icons.os.linux or mininvim.icons.os.win
	-- local code_context = navic.is_available() and navic.get_location()
	return MiniStatusline.combine_groups({
		{ hl = mode_hl, strings = { mode } },
		{
			hl = "MiniStatuslineDevinfo",
			strings = { git, diff, diagnostics },
		},
		"%<", -- Mark general truncate point
		{
			hl = "MiniStatuslineFileName",
			strings = { filename },
		},
		"%=", -- End left alignment
		{ hl = "MiniStatuslineFileinfo", strings = { eol, copilot, lsp, fileinfo } },
		{ hl = mode_hl, strings = { search, location } },
	})
end

MiniStatusline.setup({
	content = {
		active = active_mode,
	},
})
