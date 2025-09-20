local utils = require("utils")

---@module "lazy"
---@type LazySpec
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	opts = function()
		---@type snacks.config
		local opt = {
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true, style = "fancy" },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = {
				enabled = true,
				folds = {
					git_hl = true,
					open = true,
				},
			},
			toggle = { map = vim.keymap.set },
			words = { enabled = true },
			explorer = {
				enabled = false,
			},
			scratch = {
				enabled = false,
			},
			animate = {
				fps = 120,
				duration = 200,
				easing = "inOutQuad",
			},
			image = {
				enabled = true,
			},
			terminal = {
				enabled = true,
				win = {
					border = "rounded",
				},
			},
			lazygit = { enabled = true },
			picker = {
				enabled = true,
			},
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
			dashboard = {
				preset = {
					header = [[
					Meow! Here's your Neovim
           __..--''``---....___   _..._    __
 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
///_.-' _..--.'_    \                    `( ) ) // //
/ (_..-' // (< _     ;_..__               ; `' / ///
 / // // //  `-._,_)' // / ``--...____..-' /// / //
]],
					---@type snacks.dashboard.Item
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
					section = {
						{ section = "header" },
						{ section = "keys", gap = 1, padding = 1 },
					},
				},
			},
		}
		local source_names = { "files", "explorer", "grep", "grep_word", "grep_buffers" }
		local sources = opt.picker.sources or {}
		for _, name in ipairs(source_names) do
			sources[name] = {
				hidden = true,
				ignored = true,
				exclude = { ".git", "node_modules" },
			}
		end
		opt.picker.sources = sources
		return opt
	end,
	keys = {
		-- Dashboard
		{
			utils.L("h"),
			function()
				Snacks.dashboard.open()
			end,
			desc = "Open dashboard",
		},
		-- Terminal
		{
			"<leader>tt",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Toggle terminal",
		},
		{
			"<leader>ta",
			function()
				Snacks.terminal.toggle("opencode", {
					win = {
						position = "right",
					},
				})
			end,
			desc = "Terminal (opencode)",
		},
		{
			"<leader>tf",
			function()
				Snacks.terminal.toggle(nil, {
					win = {
						position = "float",
						width = 0.7,
					},
				})
			end,
			desc = "Terminal (float)",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit.open()
			end,
			desc = "Open lazygit",
		},
		-- Pickers
		{ "<leader>l", group = "LSP", desc = "Find LSP" },
		{
			"<leader>li",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "LSP implementations",
		},
		{
			"<leader>ld",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "LSP definitions",
		},
		{
			"<leader>lt",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "LSP type definitions",
		},
		{
			"<leader>lD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "LSP declarations",
		},
		{
			"<leader>ls",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP document symbols",
		},
		{
			"<leader>lS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP workspace symbols",
		},
		{
			"<leader>lr",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "LSP references",
		},
		{
			"<leader>lc",
			function()
				Snacks.picker.lsp_config()
			end,
			desc = "LSP config",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Find Help",
		},
		{
			"<leader>ft",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Find theme",
		},
		{
			"<leader>fm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Find marks",
		},
		{
			"<leader>fw",
			function()
				local mode = vim.fn.mode(true)
				-- In visual mode, grep for the selection
				if mode:find("[vV\22]") then
					Snacks.picker.grep_word()
				else
					Snacks.picker.grep()
				end
			end,
			desc = "Find word/selection (grep)",
			mode = { "n", "v" },
		},
		{
			mode = { "n" },
			"<leader>fr",
			function()
				Snacks.picker.registers()
			end,
			desc = "Find registers",
		},
		{
			mode = { "n" },
			"<leader>fc",
			function()
				Snacks.picker.commands()
			end,
			desc = "Find commands",
		},
		{
			mode = { "n" },
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Find keymaps",
		},
		{
			mode = { "n" },
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find buffers",
		},
		{
			mode = { "n" },
			"<leader>fl",
			function()
				Snacks.picker.lines({
					buf = vim.api.nvim_get_current_buf(),
				})
			end,
			desc = "Find lines in buffer",
		},
		{
			mode = { "n" },
			"<leader>fp",
			function()
				Snacks.picker.projects({
					cwd = vim.fn.expand("~/projects"),
				})
			end,
			desc = "Find projects",
		},
		{
			"<leader>fv",
			function()
				Snacks.picker.recent({ filter = { cwd = true } })
			end,
			desc = "Find visited path",
		},
		{
			mode = { "n", "x" },
			"<leader>fg",
			function()
				local mode = vim.fn.mode(true)
				local grug = require("grug-far")
				local inBuffer = vim.fn.expand("%:p")
				-- In visual mode, grep for the selection
				if mode:find("[vV\22]") then
					grug.with_visual_selection({
						prefills = {
							paths = inBuffer,
						},
					})
				else
					grug.open({
						prefills = {
							paths = inBuffer,
						},
					})
				end
			end,
			desc = "Find & Grug in current buffer",
		},
		{
			"<leader>fd",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Find diagnostics (buffer)",
		},
		{
			"<leader>fD",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Find diagnostics (workspace)",
		},
		{
			"<leader>fC",
			function()
				Snacks.picker.files({
					cwd = vim.fn.stdpath("config"),
				})
			end,
			desc = "Find config files",
		},
		{
			"<leader>fP",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Find Plugins",
		},
		{
			"<leader>nh",
			function()
				Snacks.picker.notifications()
			end,
			desc = "notification history",
		},
		-- Notifications
		{
			"<leader>nc",
			function()
				local all_notif = Snacks.notifier.get_history()
				for _, notification in ipairs(all_notif) do
					Snacks.notifier.hide(notification.id)
				end
			end,
			desc = "notifications clear",
		},
	},
}
