local utils = require("utils")
---@type LazySpec
return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-mini/mini.nvim",
	},
	keys = {
		{ utils.L("bp"), utils.C("BufferLineTogglePin"), desc = "Toggle Pin" },
		{ utils.L("bP"), utils.C("BufferLineGroupClose ungrouped"), desc = "Delete Non-Pinned Buffers" },
		{ utils.L("bR"), utils.C("BufferLineCloseRight"), desc = "Delete Buffers to the Right" },
		{ utils.L("bL"), utils.C("BufferLineCloseLeft"), desc = "Delete Buffers to the Left" },
		{
			utils.L("bd"),
			function()
				Snacks.bufdelete.delete()
			end,
			desc = "Delete Buffer",
		},
		{ utils.L("bD"), utils.C("BufferLineCloseOthers"), desc = "Delete Others Buffer" },
		{ "<S-l>", utils.C("BufferLineCycleNext"), desc = "Next Buffer" },
		{ "<S-h>", utils.C("BufferLineCyclePrev"), desc = "Next Buffer" },
		{ utils.L("bh"), utils.C("BufferLineMovePrev"), desc = "Move buffer prev" },
		{ utils.L("bl"), utils.C("BufferLineMoveNext"), desc = "Move buffer next" },
		{
			utils.L("ba"),
			function()
				Snacks.bufdelete.all()
			end,
			desc = "Delete all buffer",
		},
	},
	---@module 'bufferline'
	---@type bufferline.Options
	opts = {
		options = {
			always_show_bufferline = false,
			show_close_icon = false,
			show_buffer_close_icons = false,
			-- separator_style = "slant",
			groups = {
				options = {
					toggle_hidden_on_enter = true,
				},
			},
			diagnostics = "nvim_lsp",
			close_command = function(n)
				Snacks.bufdelete.delete(n)
			end,
			diagnostics_indicator = function(_, _, diag)
				local icons = mininvim.icons
				local ret = (diag.error and icons.error .. diag.error .. " " or "")
					.. (diag.warning and icons.warn .. diag.warning or "")
				return vim.trim(ret)
			end,
			get_element_icon = function(o)
				return require("mini.icons").get("filetype", o.filetype)
			end,
		},
	},
}
