local utils = require("utils")
return {
	{
		"nvim-mini/mini.nvim",
		priority = 2,
		lazy = fals,
		config = function()
			require("mini.keymap").setup()
			require("mini.trailspace").setup()
			require("mini.move").setup()
			require("mini.bufremove").setup()
			require("mini.basics").setup({
				options = {
					basic = true,
					extra_ui = false,
					win_borders = "shadow",
				},
				mappings = {
					windows = true,
					move_with_alt = true,
				},
			})
			local MiniExtra = require("mini.extra")
			local ai = require("mini.ai")
			ai.setup({
				n_lines = 500,
				custom_textobjects = {
					L = MiniExtra.gen_ai_spec.line(), -- Line
					-- Tweak function call to not detect dot in function name
					f = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
					-- Function definition (needs treesitter queries with these captures)
					F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@loop.outer", "@conditional.outer" },
						i = { "@block.inner", "@loop.inner", "@conditional.inner" },
					}),
					B = MiniExtra.gen_ai_spec.buffer(),
					D = MiniExtra.gen_ai_spec.diagnostic(),
					I = MiniExtra.gen_ai_spec.indent(),
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
					N = MiniExtra.gen_ai_spec.number(),
				},
			})
			local MiniBracketed = require("mini.bracketed")
			MiniBracketed.setup({
				treesitter = { suffix = "s" },
			})
			require("mini.files").setup({
				windows = {
					preview = true,
					width_focus = 30,
					width_preview = 30,
				},
				options = {
					use_as_default_explorer = true,
				},
				mappings = {
					go_out_plus = "h",
					synchronize = "<c-s>",
				},
				content = {
					filter = utils.filter_show,
				},
			})
			---@param type 'file' | 'directory'
			local init_setup = function(type)
				local result = {}
				for _, group in pairs(mininvim.icons.groups) do
					if group.type == type then
						for _, fname in ipairs(group.files) do
							result[fname] = { glyph = group.glyph, hl = group.hl }
						end
					end
				end
				return result
			end
			local MiniIcons = require("mini.icons")
			MiniIcons.setup({
				file = init_setup("file"),
				directory = init_setup("directory"),
			})
			MiniIcons.mock_nvim_web_devicons()

			require("mini.jump").setup({
				mappings = {
					forward = "f",
					backward = "F",
					repeat_jump = ";",
				},
			})
			local MiniJump2d = require("mini.jump2d")
			MiniJump2d.setup({
				labels = "abcdefghijklmnopqrstuvwxyz",
				view = {
					dim = true,
					n_steps_ahead = 2,
				},
				mappings = {
					start_jumping = "<leader>j",
				},
			})
			local MiniSessions = require("mini.sessions")
			MiniSessions.setup({
				autoread = false,
				autowrite = true,
				force = {
					delete = true,
					write = true,
				},
				directory = vim.fn.stdpath("data") .. "/sessions",
			})
			require("mini.surround").setup({
				mappings = {
					add = "sa", -- Add surrounding
					delete = "sd", -- Delete surrounding
					find = "sf", -- Find surrounding (to the right)
					find_left = "sF", -- Find surrounding (to the left)
					highlight = "sh", -- Highlight surrounding
					replace = "sr", -- Replace surrounding
					update_n_lines = "sn", -- Update `n_lines`
				},
			})
			require("mini.pairs").setup({
				modes = { insert = true, command = false, terminal = false },
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				skip_ts = { "string" },
				skip_unbalanced = true,
				markdown = true,
			})
			-- END OF PLUGINS

			-- KEYMAPS
			utils.map("n", "<s-l>", function()
				MiniBracketed.buffer("forward")
			end, "Next buffer")
			utils.map("n", "<s-h>", function()
				MiniBracketed.buffer("backward")
			end, "Previous buffer")
			utils.map(
				{ "n", "x", "o" },
				"<leader>j",
				function()
					MiniJump2d.start(MiniJump2d.builtin_opts.query)
				end,
				"Start jumping arround",
				{
					icon = "",
				}
			)
			utils.map(
				"n",
				utils.L("e"),
				function()
					local MiniFiles = require("mini.files")
					local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
					if not ok then
						MiniFiles.open(nil, false)
					end
				end,
				"Open explore",
				{
					icon = "",
				}
			)

			utils.map({ "n" }, utils.L("ss"), function()
				local default_sessions = "session-" .. os.date("%Y%m%d-%H%M%S")
				vim.ui.input({ prompt = "Enter session name: ", default = default_sessions }, function(input)
					if input == nil or input == "" then
						utils.notify("Name is required for session", "WARN")
						return
					end
					MiniSessions.write(input)
					utils.notify("Session " .. input .. " saved", "INFO")
				end)
			end, "Save session")

			utils.map({ "n" }, utils.L("sd"), function()
				local ok, err = pcall(function()
					MiniSessions.select("delete")
				end)
				if not ok then
					utils.notify("Error: " .. tostring(err), "ERROR")
				end
				-- notify('Session deleted', 'INFO')
			end, "Delete session")

			utils.map({ "n" }, utils.L("sl"), function()
				MiniSessions.select()
			end, "Load session")
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	{
		"rafamadriz/friendly-snippets",
		event = "InsertEnter",
		config = function()
			local lang_patterns = {
				jsx = { "javascript/javascript.json", "javascript/react-es7.json" },
				tsx = { "javascript/javascript.json", "javascript/typescript.json", "javascript/react-ts.json" },
			}
			local snippets, config_path = require("mini.snippets"), vim.fn.stdpath("config")
			snippets.setup({
				snippets = {
					snippets.gen_loader.from_lang({
						lang_patterns = lang_patterns,
					}),
					snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
					-- snippets.start_lsp_server(),
				},
				mappings = {
					expand = "",
				},
				expand = {
					select = function(snip, ins)
						local select = snippets.default_select
						select(snip, ins)
					end,
				},
			})
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
