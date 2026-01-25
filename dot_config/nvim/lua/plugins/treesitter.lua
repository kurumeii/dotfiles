local utils = require("config.utils")
local add = require("mini.deps").add
add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "main",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})
add({
	source = "nvim-treesitter/nvim-treesitter-textobjects",
	checkout = "main",
})
add({ source = "nvim-treesitter/nvim-treesitter-context" })

local ts = require("nvim-treesitter")
ts.setup()
-- Enable tree-sitter after opening a file for a target language
local filetypes = {}
for _, lang in ipairs(mininvim.tree_sitters_ensured_install) do
	vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
end

require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
	local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
	local filename = vim.fn.fnamemodify(filepath, ":t")
	return string.match(filename, ".*mise.*%.toml$") ~= nil
end, {
	force = true,
	all = true,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Install Treesitter",
	pattern = filetypes,
	callback = function(ev)
		vim.treesitter.start(ev.buf)
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
vim.api.nvim_create_autocmd("BufReadPre", {
	once = true,
	callback = function()
		ts.install(mininvim.tree_sitters_ensured_install)
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

		local tsc = require("treesitter-context")
		tsc.setup({
			mode = "cursor",
			max_lines = 3,
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
