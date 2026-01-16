local utils = require("config.utils")
local MiniTabline = require("mini.tabline")

MiniTabline.setup({
	show_icons = true,
	format = function(buf_id, label)
		local buf_name = vim.api.nvim_buf_get_name(buf_id)
		local icon = MiniIcons.get("file", buf_name)
		local is_edited = vim.bo[buf_id].modified and mininvim.icons.edit or ""
		local hasErrors = vim.diagnostic.get(buf_id, { severity = "ERROR" })
		if #hasErrors > 0 then
			icon = mininvim.icons.error
		else
			local hasWarnings = vim.diagnostic.get(buf_id, { severity = "WARN" })
			if #hasWarnings > 0 then
				icon = mininvim.icons.warn
			end
		end
		return string.format(" %s %s %s", icon, label, is_edited)
	end,
})

utils.map("n", "<S-l>", function()
	MiniBracketed.buffer("forward")
end, "Next Buffer")
utils.map("n", "<S-h>", function()
	MiniBracketed.buffer("backward")
end, "Prev Buffer")
utils.map("n", utils.L("bd"), MiniBufremove.wipeout, "Delete Buffer")
utils.map("n", utils.L("bw"), MiniBufremove.wipeout, "Wipeout Closed Buffer")
utils.map("n", utils.L("ba"), function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted then
			MiniBufremove.delete(buf, true)
		end
	end
end, "Delete all buffer")
utils.map("n", utils.L("bL"), function()
	utils.delete_buffers_in_direction("right")
end, "Delete Buffers to the Right")
utils.map("n", utils.L("bH"), function()
	utils.delete_buffers_in_direction("left")
end, "Delete Buffers to the Left")
utils.map("n", utils.L("bo"), function()
	local listed_buffers = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buflisted then
			table.insert(listed_buffers, bufnr)
		end
	end

	local current_bufnr = vim.api.nvim_get_current_buf()

	for _, bufnr in ipairs(listed_buffers) do
		if bufnr ~= current_bufnr then
			MiniBufremove.delete(bufnr)
		end
	end
end, "Delete Others")
