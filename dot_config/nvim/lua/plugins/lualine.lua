---@module 'mini.deps'
MiniDeps.add("akinsho/bufferline.nvim")
local utils = require("config.utils")
require("bufferline").setup({
	options = {
		always_show_bufferline = true,
		show_close_icon = false,
		show_buffer_close_icons = false,
		separator_style = "thin", -- slant | padded_slant | slope | padded_slope | thick | thin
		---@diagnostic disable-next-line: missing-fields
		groups = {
			options = {
				toggle_hidden_on_enter = true,
			},
		},
		diagnostics = "nvim_lsp",
		close_command = function(n)
			MiniBufremove.delete(n)
		end,
		diagnostics_indicator = function(_, _, diag)
			local icons = mininvim.icons
			local ret = (diag.error and icons.error .. diag.error .. " " or "")
				.. (diag.warning and icons.warn .. diag.warning or "")
			return vim.trim(ret)
		end,
		get_element_icon = function(o)
			return MiniIcons.get("filetype", o.filetype)
		end,
	},
})
utils.map("n", utils.L("bp"), utils.C("BufferLineTogglePin"), "Toggle Pin")
utils.map("n", utils.L("bP"), utils.C("BufferLineGroupClose ungrouped"), "Delete Non-Pinned Buffers")
utils.map("n", utils.L("bR"), utils.C("BufferLineCloseRight"), "Delete Buffers to the Right")
utils.map("n", utils.L("bL"), utils.C("BufferLineCloseLeft"), "Delete Buffers to the Left")
utils.map("n", utils.L("bd"), MiniBufremove.delete, "Delete Buffer")
utils.map("n", utils.L("bD"), utils.C("BufferLineCloseOthers"), "Delete Others Buffer")
utils.map("n", "<S-l>", utils.C("BufferLineCycleNext"), "Next Buffer")
utils.map("n", "<S-h>", utils.C("BufferLineCyclePrev"), "Prev Buffer")
utils.map("n", utils.L("bh"), utils.C("BufferLineMovePrev"), "Move buffer prev")
utils.map("n", utils.L("bl"), utils.C("BufferLineMoveNext"), "Move buffer next")
utils.map("n", utils.L("ba"), function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted then
			MiniBufremove.delete(buf, true)
		end
	end
end, "Delete all buffer")
utils.map("n", utils.L("bw"), MiniBufremove.wipeout, "Wipeout Buffer")
