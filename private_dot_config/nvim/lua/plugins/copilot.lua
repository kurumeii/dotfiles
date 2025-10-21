vim.g.ai_cmp = true
---@module "lazy"
---@type LazySpec[]
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = not vim.g.ai_cmp,
				auto_trigger = true,
				hide_during_completion = vim.g.ai_cmp,
				keymap = {
					accept = false, -- handled by nvim-cmp / blink.cmp
					-- next = "<M-]>",
					-- prev = "<M-[>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = { "giuxtaposition/blink-cmp-copilot" },
		opts = {
			sources = {
				default = { "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
	},
	{
		"folke/sidekick.nvim",
		---@module "sidekick"
		---@type sidekick.config
		opts = {
			nes = {
				---@type sidekick.diff.Opts
				diff = {
					inline = "chars",
				},
			},
			cli = {
				---@type sidekick.win.Opts
				win = {
					split = {
						width = 80,
					},
				},
			},
		},
		lazy = true,
		keys = {
			{ "<leader>a", desc = "Sidekick" },
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if require("sidekick").nes_jump_or_apply() then
						return -- jumped or applied
					end

					-- if you are using Neovim's native inline completions
					if vim.lsp.inline_completion.get() then
						return
					end

					-- any other things (like snippets) you want to do on <tab> go here.

					-- fall back to normal tab
					return "<tab>"
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({
						filter = { installed = true },
					})
				end,
				desc = "Sidekick: Toggle",
			},
			{
				"<leader>ag",
				desc = "Sidekick: gemini",
				function()
					require("sidekick.cli").toggle({
						name = "gemini",
					})
				end,
			},
			{
				"<leader>ad",
				desc = "Sidekick: Detach cli",
				function()
					require("sidekick.cli").close()
				end,
			},
			{
				"<leader>at",
				desc = "Sidekick: Send this message",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
			},
		},
	},
}
