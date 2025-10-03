vim.g.ai_cmp = true
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
}
