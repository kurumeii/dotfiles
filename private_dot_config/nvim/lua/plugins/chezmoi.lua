---@module "lazy"
---@type LazySpec[]
return {
	{
		-- highlighting for chezmoi files template files
		"alker0/chezmoi.vim",
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = 1
			vim.g["chezmoi#source_dir_path"] = os.getenv("HOME") .. "/.local/share/chezmoi"
		end,
	},
	{
		"xvzc/chezmoi.nvim",
		cmd = "ChezmoiEdit",
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			-- run chezmoi edit on file enter
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
				callback = function()
					vim.schedule(require("chezmoi.commands.__edit").watch)
				end,
			})
		end,
		opts = {
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
			},
		},
		keys = {
			{
				"<leader>fz",
				desc = "Find Chezmoi config",
				function()
					local results = require("chezmoi.commands").list({
						args = {
							"--path-style",
							"absolute",
							"--include",
							"files",
							"--exclude",
							"externals",
						},
					})
					local items = {}
					for _, czFile in ipairs(results) do
						table.insert(items, {
							text = czFile,
							file = czFile,
						})
					end
					Snacks.picker.pick({
						items = items,
						confirm = function(picker, item)
							picker:close()
							require("chezmoi.commands").edit({
								targets = { item.text },
								args = { "--watch" },
							})
						end,
					})
				end,
			},
		},
	},
}
