local colorscheme = "gruvbox"
local add = MiniDeps.add

if colorscheme == "gruvbox" then
	add("ellisonleao/gruvbox.nvim")
	require("gruvbox").setup({
		contrast = "",
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
if colorscheme == "mini" then
	vim.cmd.colorscheme("miniwinter")
else
	vim.cmd.colorscheme(colorscheme)
end
