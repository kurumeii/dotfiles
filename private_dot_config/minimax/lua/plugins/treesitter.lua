local utils = require("config.utils")
require("nvim-treesitter").setup()

require("nvim-treesitter").install(mininvim.tree_sitters_ensured_install)

-- Enable tree-sitter after opening a file for a target language
local filetypes = {}
for _, lang in ipairs(mininvim.tree_sitters_ensured_install) do
	vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
end

vim.api.nvim_create_autocmd("FileType", {
	desc = "Install Treesitter",
	pattern = filetypes,
	callback = function(ev)
		vim.treesitter.start(ev.buf)
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function()
		require("nvim-treesitter-textobjects").setup({
			move = {
				enable = true,
				set_jumps = true,
			},
		})
		local ts_text_object = require("nvim-treesitter-textobjects.move")
		utils.map({ "n", "x", "o" }, "]f", function()
			ts_text_object.goto_next_start("@function.outer", "textobjects")
		end, "Next function start")
		utils.map({ "n", "x", "o" }, "]F", function()
			ts_text_object.goto_next_end("@function.outer", "textobjects")
		end, "Next function end")
		utils.map({ "n", "x", "o" }, "[f", function()
			ts_text_object.goto_previous_start("@function.outer", "textobjects")
		end, "Previous function start")
		utils.map({ "n", "x", "o" }, "[F", function()
			ts_text_object.goto_previous_end("@function.outer", "textobjects")
		end, "Previous function end")
	end,
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function()
		local tsc = require("treesitter-context")
		tsc.setup({
			mode = "cursor",
			max_lines = 3,
		})
	end,
})
