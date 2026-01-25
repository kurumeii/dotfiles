local colorscheme = "gruvbox-material"
local transparent = true
local add = MiniDeps.add

if colorscheme == "gruvbox" then
	add("ellisonleao/gruvbox.nvim")
	require("gruvbox").setup({
		contrast = "",
		transparent_mode = transparent,
	})
end
if colorscheme == "gruvbox-material" then
	add("f4z3r/gruvbox-material.nvim")
	require("gruvbox-material").setup({
		background = {
			transparent = transparent,
		},
	})
end
if colorscheme == "kanagawa" then
	add("rebelot/kanagawa.nvim")
	require("kanagawa").setup({
		theme = "dragon",
		dimInactive = true,
	})
end
if colorscheme == "catppuccin" then
	add({
		source = "catppuccin/nvim",
		name = "catppuccin",
	})
	require("catppuccin").setup({
		dim_inactive = {
			enabled = true,
		},
		transparent_background = false,
		auto_integrations = true,
		integrations = {
			mini = {
				enabled = true,
				indentscope_color = "rosewater",
			},
		},
	})
end
if colorscheme == "tokyonight" then
	add("folke/tokyonight.nvim")
	require("tokyonight").setup({
		style = "night",
	})
end
if colorscheme == "mini" then
	vim.cmd.colorscheme("miniwinter")
else
	vim.cmd.colorscheme(colorscheme)
end
