local utils = require("utils")
---@module 'lazy'
---@type LazySpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		opts = {
			install_dir = vim.fn.stdpath("data") .. "/treesitter",
		},
		config = function(_, opts)
			local ts = require("nvim-treesitter")
			ts.setup(opts)
			local ensure_install = {
				"lua",
				"luadoc",
				"luap",
				"vim",
				"vimdoc",
				"bash",
				"diff",
				"html",
				"css",
				"scss",
				"powershell",
				"javascript",
				"typescript",
				"tsx",
				"regex",
				"jsdoc",
				"json",
				"jsonc",
				"query",
				"git_rebase",
				"gitcommit",
				"git_config",
				"markdown",
				"markdown_inline",
				"toml",
				"xml",
				"yaml",
			}
			ts.install(ensure_install)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		branch = "main",
		opts = {
			mode = {
				enable = true,
				set_jumps = true,
			},
		},
		keys = function()
			local ts_text_object = require("nvim-treesitter-textobjects.move")
			return {
				mode = { "n", "x", "o" },
				{
					"]f",
					function()
						ts_text_object.goto_next_start("@function.outer", "textobjects")
					end,
					desc = "Next function start",
				},
				{
					"]F",
					function()
						ts_text_object.goto_next_end("@function.outer", "textobjects")
					end,
					desc = "Next function end",
				},
				{
					"[f",
					function()
						ts_text_object.goto_previous_start("@function.outer", "textobjects")
					end,
					desc = "Previous function start",
				},
				{
					"[F",
					function()
						ts_text_object.goto_previous_end("@function.outer", "textobjects")
					end,
					desc = "Previous function end",
				},
				{
					"]c",
					function()
						ts_text_object.goto_next_start("@class.outer", "textobjects")
					end,
					desc = "Next class start",
				},
				{
					"]C",
					function()
						ts_text_object.goto_next_end("@class.outer", "textobjects")
					end,
					desc = "Next class end",
				},
				{
					"[c",
					function()
						ts_text_object.goto_previous_start("@class.outer", "textobjects")
					end,
					desc = "Previous class start",
				},
				{
					"[C",
					function()
						ts_text_object.goto_previous_end("@class.outer", "textobjects")
					end,
					desc = "Previous class end",
				},
				{
					"]a",
					function()
						ts_text_object.goto_next_start("@parameter.inner", "textobjects")
					end,
					desc = "Next parameter start",
				},
				{
					"]A",
					function()
						ts_text_object.goto_next_end("@parameter.inner", "textobjects")
					end,
					desc = "Next parameter end",
				},
				{
					"[a",
					function()
						ts_text_object.goto_previous_start("@parameter.inner", "textobjects")
					end,
					desc = "Previous parameter start",
				},
				{
					"[A",
					function()
						ts_text_object.goto_previous_end("@parameter.inner", "textobjects")
					end,
					desc = "Previous parameter end",
				},
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost" },
		opts = function()
			local tsc = require("treesitter-context")
			Snacks.toggle({
				name = "Treesitter Context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
			return { mode = "cursor", max_lines = 3 }
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
