---@type LazySpec[]
return {
	-- add gruvbox
	{ "ellisonleao/gruvbox.nvim" },
	-- This one actually set the theme so must be at the end
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},
}
