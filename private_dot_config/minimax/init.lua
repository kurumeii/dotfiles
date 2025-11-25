-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"

if not vim.uv.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"--branch",
		"stable",
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.desps").setup({
	path = {
		package = path_package,
	},
})

local now, later = MiniDeps.now, MiniDeps.later
local add = MiniDeps.add
local utils = require("config.utils")

-- ###### Plugins
--
--
now(function()
	require("config.options")
	require("config.keymaps")
end)
now(function()
	require("mini.keymap").setup()
	local map_combo = require("mini.keymap").map_combo
	local mode = { "i", "t", "c", "s", "x" }
	map_combo(mode, "jk", "<bs><bs><esc>")
	map_combo(mode, "kj", "<bs><bs><esc>")
	map_combo(mode, "qq", "<BS><BS><C-\\><C-n>")
	map_combo(mode, "qk", "<BS><BS><C-\\><C-n>")
end)
now(function()
	require("mini.basics").setup({
		options = {
			basic = true,
			extra_ui = false,
			win_borders = "shadow",
		},
		mappings = {
			windows = true,
			move_with_alt = true,
		},
	})
end)
later(function()
	require("mini.extra").setup()
	local MiniAi = require("mini.ai")
	MiniAi.setup({
		n_lines = 500,
		custom_textobjects = {
			L = MiniExtra.gen_ai_spec.line(), -- Line
			-- Tweak function call to not detect dot in function name
			f = MiniAi.gen_spec.function_call({ name_pattern = "[%w_]" }),
			-- Function definition (needs treesitter queries with these captures)
			F = MiniAi.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
			o = MiniAi.gen_spec.treesitter({
				a = { "@block.outer", "@loop.outer", "@conditional.outer" },
				i = { "@block.inner", "@loop.inner", "@conditional.inner" },
			}),
			B = MiniExtra.gen_MiniAi_spec.buffer(),
			D = MiniExtra.gen_MiniAi_spec.diagnostic(),
			I = MiniExtra.gen_MiniAi_spec.indent(),
			u = MiniAi.gen_spec.function_call(), -- u for "Usage"
			U = MiniAi.gen_spec.function_call({ name_pattern = "[%w_]" }),
			N = MiniExtra.gen_MiniAi_spec.number(),
		},
	})
end)
later(function()
	require("mini-trailspace").setup()
	require("mini.move").setup()
	require("mini.fuzzy").setup()
	require("mini.colors").setup()
	require("mini.operators").setup()
end)
later(function()
	require("mini.bracketed").setup({
		treesitter = { suffix = "s" },
	})
end)
now(function()
	require("mini.files").setup({
		windows = {
			preview = true,
			width_focus = 30,
			width_preview = 30,
		},
		options = {
			use_as_default_explorer = true,
		},
		mappings = {
			go_out_plus = "h",
			synchronize = "<c-s>",
		},
		content = {
			filter = utils.filter_show,
		},
	})

	utils.map(
		"n",
		utils.L("e"),
		function()
			local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
			if not ok then
				MiniFiles.open(nil, false)
			end
		end,
		"Open explore",
		{
			icon = "",
		}
	)
end)
now(function()
	---@param icon_type 'file' | 'directory' | "lsp"
	local init_setup = function(icon_type)
		local result = {}
		for name, group in pairs(mininvim.icons.groups) do
			if group.type == icon_type then
				if icon_type == "lsp" then
					local lsp_kind = name
					result[lsp_kind] = { glyph = group.glyph, hl = group.hl }
				elseif type(group.files) == "table" then
					for _, fname in ipairs(group.files) do
						result[fname] = { glyph = group.glyph, hl = group.hl }
					end
				end
			end
		end
		return result
	end
	local MiniIcons = require("mini.icons")
	MiniIcons.setup({
		file = init_setup("file"),
		directory = init_setup("directory"),
		lsp = init_setup("lsp"),
	})
	MiniIcons.mock_nvim_web_devicons()
	later(function()
		MiniIcons.tweak_lsp_kind("append")
	end)
end)
later(function()
	require("mini.jump").setup({
		mappings = {
			forward = "f",
			backward = "F",
			repeat_jump = ";",
		},
	})
	local MiniJump2d = require("mini.jump2d")
	MiniJump2d.setup({
		labels = "abcdefghijklmnopqrstuvwxyz",
		view = {
			dim = true,
			n_steps_ahead = 2,
		},
		mappings = {
			start_jumping = "<leader>j",
		},
	})
end)
later(function()
	local MiniSessions = require("mini.sessions")
	MiniSessions.setup({
		autoread = false,
		autowrite = true,
		force = {
			delete = true,
			write = true,
		},
		directory = vim.fn.stdpath("data") .. "/sessions/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
	})

	utils.map({ "n" }, utils.L("ss"), function()
		local default_sessions = "session-" .. os.date("%Y%m%d-%H%M%S")
		vim.ui.input({ prompt = "Enter session name: ", default = default_sessions }, function(input)
			if input == nil or input == "" then
				utils.notify("Name is required for session", "WARN")
				return
			end
			MiniSessions.write(input)
			utils.notify("Session " .. input .. " saved", "INFO")
		end)
	end, "Save session")
	utils.map({ "n" }, utils.L("sd"), function()
		local ok, err = pcall(function()
			MiniSessions.select("delete")
		end)
		if not ok then
			utils.notify("Error: " .. tostring(err), "ERROR")
		end
	end, "Delete session")
	utils.map({ "n" }, utils.L("sl"), function()
		MiniSessions.select()
	end, "Load session")
end)
later(function()
	require("mini.surround").setup({
		mappings = {
			add = "sa", -- Add surrounding
			delete = "sd", -- Delete surrounding
			find = "sf", -- Find surrounding (to the right)
			find_left = "sF", -- Find surrounding (to the left)
			highlight = "sh", -- Highlight surrounding
			replace = "sr", -- Replace surrounding
			update_n_lines = "sn", -- Update `n_lines`
		},
	})
end)
later(function()
	require("mini.pairs").setup({
		modes = { insert = true, command = false, terminal = false },
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	})
end)
later(function()
	add("JoosepAlviste/nvim-ts-context-commentstring")
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "json" },
		callback = function()
			vim.bo.commentstring = "// %s"
		end,
	})
	require("mini.comment").setup({
		options = {
			custom_commentstring = function()
				return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
			end,
		},
	})
end)
later(function()
	add("rafamadriz/friendly-snippets")
	local lang_patterns = {
		jsx = { "javascript/javascript.json", "javascript/react-es7.json" },
		tsx = { "javascript/javascript.json", "javascript/typescript.json", "javascript/react-ts.json" },
	}

	local snippets, config_path = require("mini.snippets"), vim.fn.stdpath("config")
	snippets.setup({
		snippets = {
			snippets.gen_loader.from_lang({
				lang_patterns = lang_patterns,
			}),
			snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
			-- snippets.start_lsp_server(),
		},
		mappings = {
			expand = "",
		},
		expand = {
			select = function(snip, ins)
				local select = snippets.default_select
				select(snip, ins)
			end,
		},
	})
end)
