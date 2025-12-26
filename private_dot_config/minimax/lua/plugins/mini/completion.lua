local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
	delay = { completion = 100, info = 100, signature = 50 },
	window = {
		info = { height = 25, width = 80 },
		signature = { height = 25, width = 80 },
	},
	mappings = {
		scroll_down = "<c-f>",
		scroll_up = "<c-b>",
	},
	lsp_completion = {
		source_func = "omnifunc",
		process_items = function(items, base)
			return MiniCompletion.default_process_items(items, base, {
				filtersort = "fuzzy",
				kind_priority = { Text = -1, Snippet = 2 },
			})
		end,
	},
})

-- Force noinsert so cycling through the menu doesn't override current text
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
