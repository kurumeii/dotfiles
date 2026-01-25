local utils = require("config.utils")
require("mini.files").setup({
	windows = {
		preview = true,
		width_focus = 30,
		width_preview = 30,
	},
	mappings = {
		go_out_plus = "h",
		synchronize = "<c-s>",
		show_help = "?",
	},
	content = {
		filter = function(fs_entry)
			return utils.toggle_dotfiles(vim.g.mini.show_dotfiles, fs_entry)
		end,
	},
})

utils.map("n", utils.L("e"), function()
	local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
	if not ok then
		MiniFiles.open(nil, false)
	end
end, "Open explore")

utils.map("n", utils.L("E"), function()
	local ok = pcall(MiniFiles.open, nil, false)
	if not ok then
		MiniFiles.open(nil, false)
	end
end, "Open explore (home)")

-- Mini Files
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local MiniFiles = require("mini.files")
		utils.map("n", ".", function()
			vim.g.mini.show_dotfiles = not vim.g.mini.show_dotfiles
			MiniFiles.refresh({
				content = {
					filter = function(fs_entry)
						return utils.toggle_dotfiles(vim.g.mini.show_dotfiles, fs_entry)
					end,
				},
			})
		end, "Toggle hidden files", { buffer = args.buf })
		utils.map_split(args.buf, "<C-w>s", "horizontal", false)
		utils.map_split(args.buf, "<C-w>v", "vertical", false)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesActionRename",
	callback = function(event)
		local Snacks = require("snacks.rename")
		if Snacks then
			Snacks.on_rename_file(event.data.from, event.data.to)
		else
			utils.rename_file(event.data.from, event.data.to)
		end
	end,
})
