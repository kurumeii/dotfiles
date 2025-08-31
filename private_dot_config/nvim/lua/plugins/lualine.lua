---@type Lazyspec
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
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
	},
	opts = {
		options = {
			component_separators = { left = "", right = "" },
			-- section_separators = { left = '', right = '' },
		},
		sections = {
			lualine_a = {
				{
					"filename",
					file_status = true,
					newfile_status = true,
					path = 4,
				},
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
				-- {
				--   'filename',
				--   file_status = true,
				--   newfile_status = true,
				--   path = 1,
				-- },
				"%=",
			},
			lualine_x = {
				{
					require("noice").api.statusline.mode.get,
					cond = require("noice").api.statusline.mode.has,
					color = { fg = "#ff9e64" },
				},
				{
					"lsp_status",
					icon = mininvim.icons.lsp,
					symbols = {
						separator = ",",
					},
				},
				{
					"filetype",
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
	},
}
