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
		config = function()
			local ts = require("nvim-treesitter")
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
			local already_installed = ts.get_installed("parsers")
			local parsers_to_install = vim
				.iter(ensure_install)
				:filter(function(parser)
					return not vim.tbl_contains(already_installed, parser)
				end)
				:totable()
			ts.install(parsers_to_install)

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

					-- Get parser name based on filetype
					local parser_name = vim.treesitter.language.get_lang(filetype)
					if not parser_name then
						utils.notify(vim.inspect("No treesitter parser found for filetype: " .. filetype), "WARN", "Treesitter")
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
							vim.notify("Parser for " .. parser_name .. " already installed.", vim.log.levels.INFO)
						else
							vim.notify("Installing parser for " .. parser_name, vim.log.levels.INFO)
							ts.install({ parser_name })
						end
					end

					vim.treesitter.start(bufnr, parser_name)
					-- vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
					-- vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
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
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			enable_close_on_slash = true,
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
