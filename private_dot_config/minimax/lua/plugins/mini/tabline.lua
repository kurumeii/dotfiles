local utils = require("config.utils")
require("mini.tabline").setup({
	show_icon = true,
	format = function(buf_id, label)
		-- README: Buggy and ugly, turn off for now
		-- local parent = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_id), ":h:t") or ""
		local default_format = MiniTabline.default_format(buf_id, label)
		local suffix = vim.bo[buf_id].modified and mininvim.icons.edit or ""
		return default_format .. suffix
	end,
})

utils.map("n", "<S-l>", function()
	MiniBracketed.buffer("forward")
end, "Next Buffer")
utils.map("n", "<S-h>", function()
	MiniBracketed.buffer("backward")
end, "Prev Buffer")
utils.map("n", utils.L("bd"), MiniBufremove.delete, "Delete Buffer")
utils.map("n", utils.L("bw"), MiniBufremove.wipeout, "Wipeout Closed Buffer")
utils.map("n", utils.L("ba"), function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted then
			MiniBufremove.delete(buf, true)
		end
	end
end, "Delete all buffer")
utils.map("n", utils.L("bR"), function()
	utils.delete_buffers_in_direction("right")
end, "Delete Buffers to the Right")
utils.map("n", utils.L("bL"), function()
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
