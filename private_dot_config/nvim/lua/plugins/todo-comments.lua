return {
	"folke/todo-comments.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>fT",
			function()
				Snacks.picker.todo_comments({
					keywords = { "TODO", "FIX", "HACK", "NOTE" },
				})
			end,
			desc = "Find Task (TODO, FIX, HACK, NOTE)",
		},
	},
}
