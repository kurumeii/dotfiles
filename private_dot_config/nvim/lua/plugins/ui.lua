---@type LazySpec[]
return {
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		init = function()
			vim.g.navic_silence = true
			LazyVim.lsp.on_attach(function(client, buffer)
				if client.supports_method("textDocument/documentSymbol") then
					require("nvim-navic").attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = " ",
				highlight = true,
				depth_limit = 3,
				-- icons = LazyVim.config.icons.kinds,
				lazy_update_context = true,
			}
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			local icons = LazyVim.config.icons
			opts.options = vim.tbl_extend("force", opts.options, {
				globalstatus = false,
			})
			opts.sections.lualine_b = {
				"branch",
				{
					"diff",
					symbols = {
						added = icons.git.added,
						modified = icons.git.modified,
						removed = icons.git.removed,
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
						error = icons.diagnostics.Error,
						warn = icons.diagnostics.Warn,
						info = icons.diagnostics.Info,
						hint = icons.diagnostics.Hint,
					},
				},
			}
			opts.sections.lualine_c = {
				LazyVim.lualine.root_dir(),
				{
					"filename",
					file_status = true,
					newfile_status = true,
					path = 4,
				},
				"%=",
			}
			opts.sections.lualine_x = {
				{
					"lsp_status",
					icon = icons.kinds.Module,
					symbols = {
						separator = ",",
					},
					ignore_lsp = {
						"copilot",
					},
				},
				LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
					local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
					if #clients > 0 then
						local status = require("copilot.status").data.status
						return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
					end
				end),
				Snacks.profiler.status(),
				-- {
				-- 	require("lazy.status").updates,
				-- 	cond = require("lazy.status").has_updates,
				-- 	color = function()
				-- 		return { fg = Snacks.util.color("Special") }
				-- 	end,
				-- },
			}
			opts.sections.lualine_y = {
				{ "progress" },
			}
			opts.inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			}
			opts.winbar = {
				lualine_c = {
					"navic",
					color_correction = nil,
					navic_opts = nil,
				},
			}
		end,
	},
}
