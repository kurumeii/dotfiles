return {
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		build = "cargo build --release",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.default",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
			"folke/lazydev.nvim",
			"nvim-mini/mini.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
			},
			appearance = {
				nerd_font_variant = "normal",
			},
			completion = {
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						columns = {
							{ "kind_icon", "label", gap = 1 },
							{ "kind", "label_description", gap = 1 },
							-- { "source_name" },
						},
						treesitter = { "lsp" },
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = false, -- README: Should work with AI autocomplete
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev", "buffer" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			cmdline = {
				enabled = true,
				keymap = { preset = "cmdline" },
				completion = {
					list = { selection = { preselect = false } },
					menu = {
						auto_show = function()
							return vim.fn.getcmdtype() == ":"
						end,
					},
					ghost_text = { enabled = true },
				},
			},
			snippets = { preset = "mini_snippets" },
			fuzzy = {
				implementation = "prefer_rust",
				sorts = {
					"exact",
					-- defaults
					"score",
					"sort_text",
				},
			},
			signature = {
				enabled = true,
				window = {
					show_documentation = false,
				},
			},
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
