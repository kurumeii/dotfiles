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
	},
	content = {
		filter = utils.filter_show,
	},
})

utils.map("n", utils.L("e"), function()
	local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
	if not ok then
		MiniFiles.open(nil, false)
	end
end, " Open explore")

-- Mini Files
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local MiniFiles = require("mini.files")
		utils.map("n", "gh", function()
			vim.g.show_dotfiles = not vim.g.show_dotfiles
			MiniFiles.refresh({
				content = {
					filter = function(fs_entry)
						if vim.g.show_dotfiles then
							return true
						end
						return not vim.startswith(fs_entry.name, ".")
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
