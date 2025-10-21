vim.g.colorscheme = "gruvbox"

---@module 'lazy'
---@type LazySpec[]
return {
	-- add gruvbox
	{
		"ellisonleao/gruvbox.nvim",
		enabled = vim.g.colorscheme == "gruvbox",
		priority = 1000,
		---@module 'gruvbox'
		---@type GruvboxConfig
		opts = {
			overrides = {
				SignColumn = { bg = "#ff9900" },
			},
		},
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		enabled = vim.g.colorscheme == "kanagawa",
		---@module 'kanagawa'
		---@type KanagawaConfig
		opts = {
			theme = "dragon",
			dimInactive = true,
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = vim.g.colorscheme == "catppuccin",
		priority = 1000,
		---@module 'catppuccin'
		---@type CatppuccinOptions
		opts = {
			flavour = "mocha",
			dim_inactive = {
				enabled = true,
			},
			transparent_background = false,
			auto_integrations = true,
		},
	},
}
