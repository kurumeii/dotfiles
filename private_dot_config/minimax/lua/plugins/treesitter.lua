MiniDeps.add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "main",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})
MiniDeps.add({
	source = "nvim-treesitter/nvim-treesitter-textobjects",
	checkout = "main",
})

MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter-context" })

local ts = require("nvim-treesitter")
ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/treesitter",
})

local ensure_install = {
	"lua",
	"vim",
	"vimdoc",
	"bash",
	"diff",
	"html",
	"css",
	"powershell",
	"javascript",
	"typescript",
	"tsx",
	"regex",
	"jsdoc",
	"json",
	"jsonc",
	"query",
	"git_rebase",
	"gitcommit",
	"git_config",
	"markdown",
	"markdown_inline",
	"toml",
	"xml",
	"yaml",
}
local isnt_installed = function(lang)
	return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
end
local to_install = vim.tbl_filter(isnt_installed, ensure_install)
if #to_install > 0 then
	require("nvim-treesitter").install(to_install)
end

-- Enable tree-sitter after opening a file for a target language
local filetypes = {}
for _, lang in ipairs(ensure_install) do
	for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
		table.insert(filetypes, ft)
	end
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

MiniDeps.later(function()
	vim.api.nvim_create_autocmd({ "BufReadPost" }, {
		callback = function()
			require("nvim-treesitter-textobjects").setup({
				mode = {
					enable = true,
					set_jumps = true,
				},
			})
			local ts_text_object = require("nvim-treesitter-textobjects.move")
			local utils = require("config.utils")
			utils.map({ "n", "x", "o" }, "]f", function()
				ts_text_object.goto_next_start("@function.outer", "textobjects")
			end, "Next function start")
			utils.map({ "n", "x", "o" }, "]F", function()
				ts_text_object.goto_next_start("@function.outer", "textobjects")
			end, "Next function end")
			utils.map({ "n", "x", "o" }, "[f", function()
				ts_text_object.goto_previous_start("@function.outer", "textobjects")
			end, "Previous function start")
			utils.map({ "n", "x", "o" }, "[F", function()
				ts_text_object.goto_previous_start("@function.outer", "textobjects")
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
end)
