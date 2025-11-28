local colorscheme = "kanagawa"
local add = MiniDeps.add

if colorscheme == "gruvbox" then
	add("ellisonleao/gruvbox.nvim")
	require("gruvbox").setup()
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
		flavour = "mocha",
		dim_inactive = {
			enabled = true,
		},
		transparent_background = false,
		auto_integrations = true,
	})
end

vim.cmd("colorscheme " .. colorscheme)
