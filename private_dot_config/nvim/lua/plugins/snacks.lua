---@type LazySpec
return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		explorer = {
			enabled = false,
		},
		scratch = {
			enabled = false,
		},
		picker = {
			sources = {
				explorer = {
					layout = {
						preset = "sidebar",
						preview = "main",
					},
					ignored = true,
					hidden = true,
				},
			},
		},
	},
	keys = function()
		local picker = require("snacks.picker")
		return {
			{
				"<leader>ff",
				function()
					picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fh",
				function()
					picker.help()
				end,
				desc = "Find Help",
			},
			{
				"<leader>ft",
				function()
					picker.colorschemes()
				end,
				desc = "Find theme",
			},
			{
				"<leader>fm",
				function()
					picker.marks()
				end,
				desc = "Find marks",
			},
			{
				"<leader>fw",
				function()
					local mode = vim.fn.mode(true)
					-- In visual mode, grep for the selection
					if mode:find("[vV\22]") then
						picker.grep_word()
					else
						picker.grep()
					end
				end,
				desc = "Find word/selection (grep)",
				mode = { "n", "v" },
			},
			{
				mode = { "n" },
				"<leader>fr",
				function()
					picker.registers()
				end,
				desc = "Find registers",
			},
			{
				mode = { "n" },
				"<leader>fc",
				function()
					picker.commands()
				end,
				desc = "Find commands",
			},
			{
				mode = { "n" },
				"<leader>fk",
				function()
					picker.keymaps()
				end,
				desc = "Find keymaps",
			},
			{
				mode = { "n" },
				"<leader>fb",
				function()
					picker.buffers()
				end,
				desc = "Find buffers",
			},
			{
				mode = { "n" },
				"<leader>fl",
				function()
					picker.lines({
						buf = vim.api.nvim_get_current_buf(),
					})
				end,
				desc = "Find lines in buffer",
			},
			{
				mode = { "n" },
				"<leader>fp",
				function()
					picker.projects({
						cwd = vim.fn.expand("~/projects"),
					})
				end,
				desc = "Find projects",
			},
		}
	end,
}
