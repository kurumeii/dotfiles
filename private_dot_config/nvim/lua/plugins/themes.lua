---@type LazySpec[]
return {
	-- add gruvbox
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			dim_inactive = true,
		},
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		opts = {
			theme = "dragon",
		},
	},
	-- This one actually set the theme so must be at the end
	{
		"LazyVim/LazyVim",
		---@type LazyVimOptions
		opts = {
			colorscheme = "kanagawa",
		},
	},
}
