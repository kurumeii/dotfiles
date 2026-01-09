MiniDeps.add({
	source = "xvzc/chezmoi.nvim",
})
require("chezmoi").setup({
	edit = {
		watch = true,
	},
	events = {
		on_open = {
			notification = {
				enable = true,
				msg = "Opened a chezmoi-managed file",
				opts = {},
			},
		},
		on_watch = {
			notification = {
				enable = true,
				msg = "This file will be automatically applied",
				opts = {},
			},
		},
		on_apply = {
			notification = {
				enable = true,
				msg = "Successfully applied",
				opts = {},
			},
		},
	},
})

-- Chezmoi
local get_chezmoi_dirs = function()
	local home = assert(os.getenv("HOME") or os.getenv("USERPROFILE"), "HOME or USERPROFILE must be set")
	return home:gsub("\\", "/") .. "/.local/share/chezmoi/*"
end
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = get_chezmoi_dirs(),
	callback = function()
		if vim.wo.diff then
			return
		end
		vim.schedule(function()
			local modules = { "chezmoi.commands.__edit", "chezmoi.commands.edit", "chezmoi.commands" }
			for _, mod_name in ipairs(modules) do
				local ok, mod = pcall(require, mod_name)
				if ok and type(mod.watch) == "function" then
					mod.watch()
					return
				end
			end
		end)
	end,
})
