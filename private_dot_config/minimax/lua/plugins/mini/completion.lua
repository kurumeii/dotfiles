local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
	lsp_completion = {
		source_func = "omnifunc",
		process_items = function(items, base)
			local default_process = MiniCompletion.default_process_items(items, base, {
				filtersort = "fuzzy",
				kind_priority = {
					Text = -1,
					Snippet = 2,
				},
			})
			return default_process
		end,
	},
})

-- utils.map(
-- 	{ "i" },
-- 	"<cr>",
-- 	function()
-- 		if vim.fn.pumvisible() ~= 0 then
-- 			local item_selected = vim.fn.complete_info()["selected"] ~= -1
-- 			return item_selected and vim.keycode("<c-y>") or vim.keycode("<c-y><cr>")
-- 		end
-- 		return MiniPairs.cr()
-- 	end,
-- 	"Accept completion",
-- 	{
-- 		expr = true,
-- 	}
-- )
