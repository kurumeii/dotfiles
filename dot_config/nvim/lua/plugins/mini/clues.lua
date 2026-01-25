local miniclue = require("mini.clue")
miniclue.setup({
	window = {
		config = {
			width = "auto",
			anchor = "SW",
			row = "auto",
			col = "auto",
		},
	},
	clues = {
		{ mode = "n", keys = "<leader>a", desc = "+ Agents" },
		{ mode = "n", keys = "<leader>b", desc = "+ Buffers" },
		{ mode = "n", keys = "<leader>c", desc = "+ Code" },
		{ mode = "n", keys = "<leader>cs", desc = "+ Code spell" },
		{ mode = "n", keys = "<leader>d", desc = "+ Debugger" },
		{ mode = "n", keys = "<leader>f", desc = "+ Find" },
		{ mode = "n", keys = "<leader>g", desc = "+ Git" },
		{ mode = "n", keys = "<leader>l", desc = "+ Lsp" },
		{ mode = { "n", "x", "i" }, keys = "<leader>o", desc = "+ MiniOperators" },
		{ mode = "n", keys = "<leader>n", desc = "+ Notify" },
		{ mode = "n", keys = "<leader>s", desc = "+ Sessions" },
		{ mode = "n", keys = "<leader>p", desc = "+ Package" },
		{ mode = "n", keys = "<leader>t", desc = "+ Terminal" },
		{ mode = "n", keys = "<leader>w", desc = "+ Window" },
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows({ submode_resize = true }),
		miniclue.gen_clues.z(),
	},
	triggers = {
		{ mode = "n", keys = "<Leader>" }, -- Leader triggers
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "\\" }, -- mini.basics
		{ mode = "n", keys = "[" }, -- mini.bracketed
		{ mode = "n", keys = "]" },
		{ mode = "x", keys = "[" },
		{ mode = "x", keys = "]" },
		{ mode = "i", keys = "<C-x>" }, -- Built-in completion
		{ mode = "n", keys = "g" }, -- `g` key
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "'" }, -- Marks
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' }, -- Registers
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" }, -- Window commands
		{ mode = "n", keys = "z" }, -- `z` key
		{ mode = "x", keys = "z" },
	},
})
