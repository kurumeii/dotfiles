---@type Lazyspec
return {
	{
		"SmiteshP/nvim-navic",
		event = { "BufReadPre" },
		init = function()
			mininvim.utils.lsp({
				on_attach = function(client, bufnr)
					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, bufnr)
					end
				end,
			})
		end,
		opts = {
			highlight = true,
			depth_limit = 4,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"AndreM222/copilot-lualine",
		},
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			local lualine_require = require("lualine_require")
			lualine_require.require = require
			vim.o.laststatus = vim.g.lualine_laststatus
			local opt = {
				options = {
					theme = "auto",
					disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
					icons_enabled = true,
				},
				sections = {
					lualine_a = {
						"mode",
					},
					lualine_b = {
						{
							"branch",
							icon = mininvim.icons.git_branch,
						},
						{
							"diff",
							symbols = {
								added = mininvim.icons.git_add,
								modified = mininvim.icons.git_edit,
								removed = mininvim.icons.git_remove,
							},
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
						{
							"diagnostics",
							symbols = {
								error = mininvim.icons.error,
								warn = mininvim.icons.warn,
								info = mininvim.icons.info,
								hint = mininvim.icons.hint,
							},
						},
					},
					lualine_c = {
						{
							"filename",
							file_status = true,
							newfile_status = true,
							path = 1,
						},
						"%=",
					},
					lualine_x = {
						{
							function()
								return require("noice").api.status.command.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.command.has()
							end,
							color = function()
								return { fg = Snacks.util.color("Statement") }
							end,
						},
						{
							function()
								return require("noice").api.status.mode.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.mode.has()
							end,
							color = function()
								return { fg = Snacks.util.color("Constant") }
							end,
						},
						{
							function()
								return "  " .. require("dap").status()
							end,
							cond = function()
								return package.loaded["dap"] and require("dap").status() ~= ""
							end,
							color = function()
								return { fg = Snacks.util.color("Debug") }
							end,
						},
						{
							"lsp_status",
							icon = mininvim.icons.lsp,
							symbols = {
								separator = ",",
								spinner = mininvim.icons.spinner,
								done = "",
							},
							ignore_lsp = { "copilot", "mini.snippets" },
						},
						{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
						"fileformat",
						{
							"copilot",
							-- Default values
							symbols = {
								status = {
									icons = {
										enabled = " ",
										sleep = " ", -- auto-trigger disabled
										disabled = " ",
										warning = " ",
										unknown = " ",
									},
									hl = {
										enabled = "#50FA7B",
										sleep = "#AEB7D0",
										disabled = "#6272A4",
										warning = "#FFB86C",
										unknown = "#FF5555",
									},
								},
								spinners = "dots", -- has some premade spinners
								spinner_color = "#6272A4",
							},
							show_colors = false,
							show_loading = true,
						},
					},
					-- lualine_y = {
					--   'searchcount',
					-- },
					lualine_z = {
						{
							"datetime",
							style = "%R" .. " " .. mininvim.icons.clock,
						},
					},
				},
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},
				winbar = {
					lualine_c = {
						"navic",
						color_correction = nil,
						navic_opts = nil,
					},
				},
				extensions = { "lazy" },
			}
			return opt
		end,
	},
}
