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

require("mini.deps").setup({
	path = {
		package = path_package,
	},
})

local now, later = MiniDeps.now, MiniDeps.later
local add = MiniDeps.add
local utils = require("config.utils")

vim.g.colorscheme = "kanagawa"
-- ###### Plugins
--
--
now(function()
	require("config.options")
	require("config.keymaps")
	require("config.mininvim")
	require("config.autocmds")
end)
now(function()
	require("mini.basics").setup({
		options = {
			basic = true,
			extra_ui = false,
			win_borders = "single",
		},
		mappings = {
			basic = true,
			windows = true,
			move_with_alt = true,
		},
	})
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

later(function()
	require("mini.bufremove").setup()
	require("mini.trailspace").setup()
	require("mini.move").setup()
	require("mini.fuzzy").setup()
	require("mini.colors").setup()
	require("mini.operators").setup()
	require("mini.bracketed").setup({
		treesitter = { suffix = "s" },
	})
	require("mini.extra").setup()
	add("nvim-lua/plenary.nvim")
	add("b0o/SchemaStore.nvim")
	add("justinsgithub/wezterm-types")
end)
later(function()
	require("mini.git").setup()
	require("mini.diff").setup({
		view = {
			style = "sign",
			signs = {
				add = mininvim.icons.git_signs.add,
				change = mininvim.icons.git_signs.change,
				delete = mininvim.icons.git_signs.delete,
			},
		},
		mappings = {
			reset = utils.L("gr"),
			textobject = "gh",
			goto_first = "[H",
			goto_last = "]H",
			goto_next = "]h",
			goto_prev = "[h",
		},
	})
end)
later(function()
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
			B = MiniExtra.gen_ai_spec.buffer(),
			D = MiniExtra.gen_ai_spec.diagnostic(),
			I = MiniExtra.gen_ai_spec.indent(),
			u = MiniAi.gen_spec.function_call(), -- u for "Usage"
			U = MiniAi.gen_spec.function_call({ name_pattern = "[%w_]" }),
			N = MiniExtra.gen_ai_spec.number(),
		},
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

	utils.map("n", utils.L("e"), function()
		local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
		if not ok then
			MiniFiles.open(nil, false)
		end
	end, " Open explore")
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
	require("mini.icons").setup({
		file = init_setup("file"),
		directory = init_setup("directory"),
		lsp = init_setup("lsp"),
	})
	later(MiniIcons.mock_nvim_web_devicons)
	later(MiniIcons.tweak_lsp_kind)
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
	utils.map({ "n", "x", "o" }, utils.L("j"), function()
		MiniJump2d.start(MiniJump2d.builtin_opts.query)
	end, " Start jumping around")
end)
now(function()
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
		search_method = "cover_or_nearest",
	})
end)
later(function()
	add("JoosepAlviste/nvim-ts-context-commentstring")
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
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
later(function()
	if vim.g.colorscheme == "gruvbox" then
		add("ellisonleao/gruvbox.nvim")
		require("gruvbox").setup({})
	end
	if vim.g.colorscheme == "kanagawa" then
		add("rebelot/kanagawa.nvim")
		require("kanagawa").setup({
			theme = "dragon",
			dimInactive = true,
		})
	end
	if vim.g.colorscheme == "catppuccin" then
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
	vim.cmd("colorscheme " .. vim.g.colorscheme)
end)
later(function()
	local MiniAnimate = require("mini.animate")

	MiniAnimate.setup({
		cursor = {
			enable = false,
		},
		scroll = {
			enable = false,
			timing = MiniAnimate.gen_timing.quadratic({
				duration = 200,
				unit = "total",
			}),
			subscroll = MiniAnimate.gen_subscroll.equal({
				predicate = function(total_scroll)
					return total_scroll > 1
				end,
			}),
		},
		resize = {
			enable = false,
			timing = MiniAnimate.gen_timing.linear({
				duration = 50,
				unit = "total",
			}),
		},
		open = { enable = true },
		close = { enable = true },
	})
end)
now(function()
	local miniclue = require("mini.clue")
	miniclue.setup({
		window = {
			config = {
				width = "auto",
				anchor = "SW",
				row = "auto",
				col = "auto",
			},
		},
		clues = {
			{ mode = "n", keys = "<leader>b", desc = " Buffers" },
			{ mode = "n", keys = "<leader>c", desc = " Code" },
			{ mode = "n", keys = "<leader>g", desc = "󰊢 Git" },
			{ mode = "n", keys = "<leader>f", desc = " Find" },
			{ mode = "n", keys = "<leader>w", desc = " Window" },
			{ mode = "n", keys = "<leader>n", desc = " Notify" },
			{ mode = "n", keys = "<leader>l", desc = " Lsp" },
			{ mode = "n", keys = "<leader>d", desc = " Debugger" },
			{ mode = "n", keys = "<leader>s", desc = " Sessions" },
			{ mode = "n", keys = "<leader>u", desc = " Ui" },
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows({ submode_resize = true }),
			miniclue.gen_clues.z(),
		},
		triggers = {
			{ mode = "n", keys = "<Leader>" }, -- Leader triggers
			{ mode = "x", keys = "<Leader>" },
			{ mode = "n", keys = "\\" }, -- mini.basics
			{ mode = "n", keys = "[" }, -- mini.bracketed
			{ mode = "n", keys = "]" },
			{ mode = "x", keys = "[" },
			{ mode = "x", keys = "]" },
			{ mode = "i", keys = "<C-x>" }, -- Built-in completion
			{ mode = "n", keys = "g" }, -- `g` key
			{ mode = "x", keys = "g" },
			{ mode = "n", keys = "'" }, -- Marks
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			{ mode = "n", keys = '"' }, -- Registers
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" }, -- Window commands
			{ mode = "n", keys = "z" }, -- `z` key
			{ mode = "x", keys = "z" },
		},
	})
end)
later(function()
	local MiniCompletion = require("mini.completion")
	MiniCompletion.setup({
		-- delay = {
		-- 	completion = 300,
		-- 	info = 200,
		-- 	signature = 100,
		-- },
		-- window = {
		-- 	info = { height = 25, width = 80, border = "rounded" },
		-- 	signature = { height = 25, width = 80, border = "rounded" },
		-- },
		lsp_completion = {
			source_func = "omnifunc",
			process_items = function(items, base)
				local default_process = MiniCompletion.default_process_items(items, base, {
					filtersort = "fuzzy",
					kind_priority = {
						Text = -1,
					},
				})
				return default_process
			end,
		},
	})

	require("mini.pairs").setup({
		modes = { insert = true, command = false, terminal = false },
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	})

	utils.map(
		{ "i" },
		"<cr>",
		function()
			if vim.fn.pumvisible() ~= 0 then
				local item_selected = vim.fn.complete_info()["selected"] ~= -1
				return item_selected and vim.keycode("<c-y>") or vim.keycode("<c-y><cr>")
			end
			return MiniPairs.cr()
		end,
		"Accept completion",
		{
			expr = true,
		}
	)
end)
later(function()
	_G.cursorword_blocklist = function()
		local curword = vim.fn.expand("<cword>")
		local filetype = vim.bo.filetype

		-- Add any disabling global or filetype-specific logic here
		local blocklist = {}
		if filetype == "lua" then
			blocklist = { "local", "require" }
		elseif filetype == "javascript" then
			blocklist = { "import" }
		end

		vim.b.minicursorword_disable = vim.tbl_contains(blocklist, curword)
	end

	-- Make sure to add this autocommand *before* calling module's `setup()`.
	vim.cmd("au CursorMoved * lua _G.cursorword_blocklist()")

	require("mini.cursorword").setup()
end)
later(function()
	local hi = require("mini.hipatterns")
	local hi_words = MiniExtra.gen_highlighter.words
	local M = {}
	---@type table<string, boolean>
	M.hl = {}
	hi.setup({
		highlighters = {
			fixme = hi_words({ "FIXME", "fixme" }, "MiniHiPatternsFixme"),
			todo = hi_words({ "TODO", "todo" }, "MiniHiPatternsTodo"),
			note = hi_words({ "NOTE", "note" }, "MiniHiPatternsNote"),
			bug = hi_words({ "BUG", "bug", "HACK", "hack", "hax" }, "MiniHiPatternsHack"),
			hex_color = hi.gen_highlighter.hex_color({ priority = 200 }),
			hex_shorthand = {
				pattern = "()#%x%x%x()%f[^%x%w]",
				group = function(_, _, data)
					---@type string
					local match = data.full_match
					local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
					local hex_color = "#" .. r .. r .. g .. g .. b .. b
					return hi.compute_hex_color_group(hex_color, "bg")
				end,
			},
			hsl_color = {
				pattern = "hsl%(%s*[%d%.]+%%?%s*[, ]%s*[%d%.]+%%?%s*[, ]%s*[%d%.]+%%?%s*%)",
				group = function(_, match)
					local h, s, l = match:match("([%d%.]+)%%?%s*[, ]%s*([%d%.]+)%%?%s*[, ]%s*([%d%.]+)%%?")
					h, s, l = tonumber(h), tonumber(s), tonumber(l)
					local hex = utils.hslToHex(h, s, l)
					return hi.compute_hex_color_group(hex, "bg")
				end,
			},
			rgb_color = {
				pattern = "rgb%(%d+,? %d+,? %d+%)",
				group = function(_, match)
					local r, g, b = match:match("rgb%((%d+),? (%d+),? (%d+)%)")
					r, g, b = tonumber(1), tonumber(2), tonumber(3)
					local hex = utils.rgbToHex(r, g, b)
					return hi.compute_hex_color_group(hex, "bg")
				end,
			},
			rgba_color = {
				pattern = "rgba%(%d+,? %d+,? %d+,? %d*%.?%d*%)",
				group = function(_, match)
					local r, g, b, a = match:match("rgba%((%d+),? (%d+),? (%d+),? (%d*%.?%d*)%)")
					r, g, b, a = tonumber(r), tonumber(g), tonumber(b), tonumber(a)
					if a == nil or a < 0 or a > 1 then
						return false
					end
					local hex = utils.rgbToHex(r, g, b, a)
					return hi.compute_hex_color_group(hex, "bg")
				end,
			},
			oklch_color = {
				pattern = "oklch%(%s*[%d%.]+%s+[%d%.]+%s+[%d%.]+%s*/?%s*[%d%.]*%%?%s*%)",
				group = function(_, match)
					local l, c, h, a = match:match("oklch%(%s*([%d%.]+)%s+([%d%.]+)%s+([%d%.]+)%s*/?%s*([%d%.]*)%%?%s*%)")
					l, c, h = tonumber(l), tonumber(c), tonumber(h)
					if a == "" or a == nil then
						a = 1
					else
						a = tonumber(a)
						if a > 1 then
							a = a / 100
						end
					end
					local hex = utils.oklchToHex(l, c, h, a)
					return hi.compute_hex_color_group(hex, "bg")
				end,
			},
			tailwind_color = {
				pattern = function()
					local ft = {
						"css",
						"html",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					}
					if not vim.tbl_contains(ft, vim.bo.filetype) then
						return
					end
					return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
				end,
				group = function(_, match)
					local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
					shade = tonumber(shade)
					local bg = vim.tbl_get(mininvim.tw_colors, color, shade)
					if bg == nil then
						return
					end
					local hl = "MiniHiPatternsTailwind" .. color .. shade
					if not M.hl[hl] then
						M.hl[hl] = true
						local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
						local fg = vim.tbl_get(mininvim.tw_colors, color, bg_shade)
						vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
					end
					return hl
				end,
				extmark_opts = { priority = 1000 },
			},
		},
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			M.hl = {}
		end,
	})
end)

later(function()
	local MiniIndentScope = require("mini.indentscope")
	MiniIndentScope.setup({
		-- symbol = "│",
		options = { try_as_border = true },
		draw = {
			animation = MiniIndentScope.gen_animation.cubic({
				easing = "in",
				duration = 300,
				unit = "total",
			}),
		},
	})
end)

later(function()
	require("mini.misc").setup()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_auto_root()
	--FIXME: There is a bug with wezterm
	-- MiniMisc.setup_termbg_sync()
end)

now(function()
	local MiniNotify = require("mini.notify")
	MiniNotify.setup({
		content = {
			format = function(notif)
				if notif.data.source == "lsp_progress" then
					return notif.msg
				end
				return MiniNotify.default_format(notif)
			end,
			sort = function(notif_arr)
				table.sort(notif_arr, function(a, b)
					return a.ts_update > b.ts_update
				end)
				return notif_arr
			end,
		},
		-- window = {
		-- 	config = function()
		-- 		local has_statusline = vim.o.laststatus > 0
		-- 		local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
		-- 		return {
		-- 			anchor = "SE",
		-- 			col = vim.o.columns,
		-- 			row = vim.o.lines - pad,
		-- 		}
		-- 	end,
		-- },
		lsp_progress = {
			enable = true,
			duration_last = 2000,
		},
	})

	vim.notify = MiniNotify.make_notify()

	utils.map("n", utils.L("nd"), MiniNotify.clear, "Notification Dismiss")
	utils.map("n", utils.L("nh"), MiniNotify.show_history, "Notification History")
end)

later(function()
	require("mini.pick").setup({
		options = {
			content_from_bottom = false,
			use_cache = true,
		},
		-- window = {
		--   config = function()
		--     local height = math.floor(0.618 * vim.o.lines)
		--     local width = math.floor(0.618 * vim.o.columns)
		--     return {
		--       anchor = 'NW',
		--       height = height,
		--       width = width,
		--       row = math.floor(0.5 * (vim.o.lines - height)),
		--       col = math.floor(0.5 * (vim.o.columns - width)),
		--     }
		--   end,
		-- },
		mappings = {
			choose_in_vsplit = "<c-v>",
			-- move_up = "<S-tab>",
			-- move_down = "<tab>",
			toggle_preview = "<c-k>",
			toggle_info = "?",
		},
	})
	vim.ui.select = MiniPick.ui_select

	local function find_config_files()
		local dir = vim.fn.stdpath("config")
		local files = vim.fn.glob(dir .. "/**/*", true, true)
		files = vim.tbl_filter(function(f)
			return vim.fn.isdirectory(f) == 0
		end, files)
		files = vim.tbl_map(function(f)
			return vim.fn.fnamemodify(f, ":~:.")
		end, files)
		MiniPick.start({
			source = {
				items = files,
				name = "Config files",
			},
		})
	end

	utils.map("n", utils.L("fe"), MiniExtra.pickers.explorer, "Find explorer")
	utils.map("n", utils.L("ff"), MiniPick.builtin.files, "Find files")
	utils.map({ "n", "v" }, utils.L("fw"), function()
		local getMode = vim.api.nvim_get_mode().mode
		if getMode == "v" then
			MiniPick.builtin.grep({
				pattern = vim.fn.expand("<cword>"),
			})
		elseif getMode == "n" then
			MiniPick.builtin.grep_live()
		end
	end, "Find word (Grep)")
	utils.map("n", utils.L("fr"), MiniExtra.pickers.registers, "Find registers")
	utils.map("n", utils.L("fc"), MiniExtra.pickers.commands, "Find commands")
	utils.map("n", utils.L("fh"), MiniPick.builtin.help, "Find help")
	utils.map("n", utils.L("fk"), MiniExtra.pickers.keymaps, "Find keymaps")
	utils.map("n", utils.L("fb"), MiniPick.builtin.buffers, "Find buffers")
	utils.map("n", utils.L("fq"), function()
		MiniExtra.pickers.list({ scope = "quickfix" })
	end, "Find quickfix list")
	utils.map("n", utils.L("fC"), find_config_files, "Find Config files")
	utils.map("n", utils.L("fd"), function()
		MiniExtra.pickers.diagnostic(nil, { scope = "current" })
	end, "Find Diagnostics in buffer")
	utils.map("n", utils.L("fD"), function()
		MiniExtra.pickers.diagnostic(nil, { scope = "all" })
	end, "Find Diagnostics")
	utils.map("n", utils.L("fm"), MiniExtra.pickers.marks, "Find marks")
	-- utils.map("n", utils.L("fH"), MiniExtra.pickers.history, "Find history")
	utils.map("n", utils.L("fv"), MiniExtra.pickers.visit_paths, "Find visit paths")
	utils.map("n", utils.L("fl"), MiniExtra.pickers.buf_lines, "Find buffer line")
	utils.map("n", utils.L("ft"), MiniExtra.pickers.colorschemes, "Find colorschemes")
	utils.map("n", utils.L("fT"), function()
		MiniExtra.pickers.hipatterns({
			scope = "all",
			highlighters = {
				"todo",
				"fixme",
				"note",
				"bug",
			},
		})
	end, "Find task comment")
	-- utils.map("n", utils.L("fV"), MiniExtra.pickers.visit_labels, "Find visit labels")
	-- LSP =======================================================================
	utils.map("n", utils.L("lr"), function()
		MiniExtra.pickers.lsp({ scope = "references" })
	end, "LSP references")
	utils.map("n", utils.L("ld"), function()
		MiniExtra.pickers.lsp({ scope = "definition" })
	end, "LSP definitions")
	utils.map("n", utils.L("lt"), function()
		MiniExtra.pickers.lsp({ scope = "type_definition" })
	end, "LSP type definitions")
	utils.map("n", utils.L("li"), function()
		MiniExtra.pickers.lsp({ scope = "implementation" })
	end, "LSP implementations")
	utils.map("n", utils.L("lD"), function()
		MiniExtra.pickers.lsp({ scope = "declaration" })
	end, "LSP declarations")
	utils.map("n", utils.L("ls"), function()
		MiniExtra.pickers.lsp({ scope = "document_symbol" })
	end, "LSP symbols")
	utils.map("n", utils.L("lS"), function()
		MiniExtra.pickers.lsp({ scope = "workspace_symbol" })
	end, "LSP workspace symbols")
end)

now(function()
	local starter = require("mini.starter")
	starter.setup({
		items = {
			starter.sections.sessions(1, true),
			starter.sections.recent_files(3, true, false),
			starter.sections.builtin_actions(),
		},

		header = function()
			return [[
					Meow! Here's your Neovim
           __..--''``---....___   _..._    __
 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
///_.-' _..--.'_    \                    `( ) ) // //
/ (_..-' // (< _     ;_..__               ; `' / ///
 / // // //  `-._,_)' // / ``--...____..-' /// / //
    ]]
		end,
		footer = function()
			return "It's - " .. os.date("%x %X")
		end,
	})
	utils.map("n", utils.L("h"), MiniStarter.open, "Open Dashboard")
end)
later(function()
	add({
		source = "kevinhwang91/nvim-ufo",
		depends = {
			"kevinhwang91/promise-async",
		},
	})
	vim.api.nvim_create_autocmd("BufReadPost", {
		callback = function()
			vim.o.foldcolumn = "auto"
			require("ufo").setup({
				open_fold_hl_timeout = 150,
				preview = {
					win_config = {
						border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
						winhighlight = "Normal:Folded",
						winblend = 0,
					},
				},
				-- provider_selector = {},
				fold_virt_text_handler = function(virt_text, lnum, endLnum, width, truncate)
					local newVirtText = {}
					local suffix = (" 󱞡 %d "):format(endLnum - lnum)
					local sufWidth = vim.fn.strdisplaywidth(suffix)
					local targetWidth = width - sufWidth
					local curWidth = 0
					for _, chunk in ipairs(virt_text) do
						local chunkText = chunk[1]
						local chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if targetWidth > curWidth + chunkWidth then
							table.insert(newVirtText, chunk)
						else
							chunkText = truncate(chunkText, targetWidth - curWidth)
							local hlGroup = chunk[2]
							table.insert(newVirtText, { chunkText, hlGroup })
							chunkWidth = vim.fn.strdisplaywidth(chunkText)
							-- str width returned from truncate() may less than 2nd argument, need padding
							if curWidth + chunkWidth < targetWidth then
								suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
							end
							break
						end
						curWidth = curWidth + chunkWidth
					end
					table.insert(newVirtText, { suffix, "MoreMsg" })
					return newVirtText
				end,
			})
			utils.map({ "n" }, "zO", require("ufo").openAllFolds, "Open all folds")
			utils.map({ "n" }, "zC", require("ufo").closeAllFolds, "Close all folds")
			utils.map({ "n" }, "<s-k>", require("ufo").peekFoldedLinesUnderCursor, "Peek Folded Lines")
		end,
	})
end)
later(function()
	add("stuckinsnow/import-size.nvim")
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		callback = function()
			require("import-size").setup()
		end,
	})
end)
later(function()
	add({
		source = "folke/lazydev.nvim",
	})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "lua" },
		callback = function()
			require("lazydev").setup({
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					{ path = "snacks.nvim", words = { "Snacks" } },
					{ path = "lazy.nvim", words = { "LazyVim" } },
					{ path = "wezterm-types", mods = { "wezterm" } },
				},
			})
		end,
	})
end)
now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	local ts = require("nvim-treesitter")
	ts.setup({
		install_dir = vim.fn.stdpath("data") .. "/treesitter",
	})

	local ensure_install = {
		"lua",
		"luadoc",
		"luap",
		"vim",
		"vimdoc",
		"bash",
		"diff",
		"html",
		"css",
		"scss",
		"powershell",
		"javascript",
		"typescript",
		"tsx",
		"regex",
		"jsdoc",
		"json",
		"jsonc",
		"query",
		"git_rebase",
		"gitcommit",
		"git_config",
		"markdown",
		"markdown_inline",
		"toml",
		"xml",
		"yaml",
	}
	local isnt_installed = function(lang)
		return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
	end
	local to_install = vim.tbl_filter(isnt_installed, ensure_install)
	if #to_install > 0 then
		require("nvim-treesitter").install(to_install)
	end

	-- Enable tree-sitter after opening a file for a target language
	local filetypes = {}
	for _, lang in ipairs(ensure_install) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end

	vim.api.nvim_create_autocmd("FileType", {
		desc = "Install Treesitter",
		pattern = filetypes,
		callback = function(ev)
			vim.treesitter.start(ev.buf)
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end,
	})
end)

later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter-textobjects",
		checkout = "main",
	})
	vim.api.nvim_create_autocmd({ "BufReadPost" }, {
		callback = function()
			require("nvim-treesitter-textobjects").setup({
				mode = {
					enable = true,
					set_jumps = true,
				},
			})
			local ts_text_object = require("nvim-treesitter-textobjects.move")
			utils.map({ "n", "x", "o" }, "]f", function()
				ts_text_object.goto_next_start("@function.outer", "textobjects")
			end, "Next function start")
			utils.map({ "n", "x", "o" }, "]F", function()
				ts_text_object.goto_next_start("@function.outer", "textobjects")
			end, "Next function end")
			utils.map({ "n", "x", "o" }, "[f", function()
				ts_text_object.goto_previous_start("@function.outer", "textobjects")
			end, "Previous function start")
			utils.map({ "n", "x", "o" }, "[F", function()
				ts_text_object.goto_previous_start("@function.outer", "textobjects")
			end, "Previous function end")
		end,
	})
end)

later(function()
	add({ source = "nvim-treesitter/nvim-treesitter-context" })
	vim.api.nvim_create_autocmd({ "BufReadPost" }, {
		callback = function()
			local tsc = require("treesitter-context")
			tsc.setup({
				mode = "cursor",
				max_lines = 3,
			})
		end,
	})
end)
later(function()
	add("windwp/nvim-ts-autotag")
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			--FIXME: Legacy errors
			require("nvim-ts-autotag").setup({
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			})
		end,
	})
end)
later(function()
	add("neovim/nvim-lspconfig")
	add({
		source = "mason-org/mason.nvim",
		depends = {
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	})
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
	require("mason-tool-installer").setup({
		ensure_installed = {
			"tailwindcss",
			"vtsls",
			"lua_ls",
			"stylua",
			"cspell",
			"marksman",
			"markdownlint-cli2",
			"biome",
			"prettierd",
			"eslint-lsp",
			"css_variables",
			"cssls",
			"stylelint",
			"prismals",
			"powershell_es",
			"yamlfix",
			"jsonls",
			"yamlls",
			"taplo",
			"js-debug-adapter",
		},
	})
	require("mason-lspconfig").setup({
		ensure_installed = {},
	})

	---@type lsp.ClientCapabilities
	local capabilities = vim.tbl_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("mini.completion").get_lsp_capabilities(),
		{
			textDocument = {
				completion = {
					completionItem = {
						snippetSupport = true,
					},
				},
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		}
	)

	mininvim.utils.lsp({
		capabilities = capabilities,
	})

	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = mininvim.icons.error,
				[vim.diagnostic.severity.WARN] = mininvim.icons.warn,
				[vim.diagnostic.severity.INFO] = mininvim.icons.info,
				[vim.diagnostic.severity.HINT] = mininvim.icons.hint,
			},
		},
		virtual_text = {
			source = "if_many",
			spacing = 2,
			format = function(diagnostic)
				local diagnostic_message = {
					[vim.diagnostic.severity.ERROR] = diagnostic.message,
					[vim.diagnostic.severity.WARN] = diagnostic.message,
					[vim.diagnostic.severity.INFO] = diagnostic.message,
					[vim.diagnostic.severity.HINT] = diagnostic.message,
				}
				return diagnostic_message[diagnostic.severity]
			end,
		},
	})
	utils.map("n", utils.L("ca"), vim.lsp.buf.code_action, "Code action")
	utils.map("n", utils.L("cd"), vim.diagnostic.open_float, "Code show diagnostic")
	utils.map("n", "<s-k>", vim.lsp.buf.hover, "Definition")
end)

now(function()
	add("stevearc/conform.nvim")
	vim.api.nvim_create_autocmd("BufReadPre", {
		callback = function()
			require("conform").setup({
				notify_on_error = true,
				default_format_opts = {
					timeout_ms = 1000,
					lsp_format = "fallback",
					stop_after_first = true,
				},
				format_after_save = function(buf)
					return {
						bufnr = buf,
						async = true,
					}
				end,
				formatters_by_ft = {
					markdown = { "markdownlint-cli2" },
					lua = { "stylua" },
					json = { "biome" },
					yaml = { "yamlfix" },
					javascript = { "biome", "prettierd" },
					typescript = { "biome", "prettierd" },
					typescriptreact = { "biome", "prettierd" },
					javascriptreact = { "biome", "prettierd" },
					css = { "biome", "prettierd" },
					scss = { "biome", "prettierd" },
				},
				formatters = {
					biome = {
						require_cwd = true,
					},
					stylua = {},
					yamlfix = {},
					["markdown-toc"] = {
						condition = function(_, ctx)
							for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
								if line:find("<!%-%- toc %-%->") then
									return true
								end
								return false
							end
						end,
					},
					["markdownlint-cli2"] = {
						condition = function(_, ctx)
							local diag = vim.tbl_filter(function(d)
								return d.source == "markdownlint"
							end, vim.diagnostic.get(ctx.buf))
							return #diag > 0
						end,
					},
				},
			})
			utils.map("n", utils.L("cf"), require("conform").format, "Format buffer (Conform)")
		end,
	})
end)
later(function()
	add("akinsho/bufferline.nvim")
	require("bufferline").setup({
		options = {
			always_show_bufferline = true,
			show_close_icon = false,
			show_buffer_close_icons = false,
			separator_style = "thick", -- slant | padded_slant | slope | padded_slope | thick | thin
			---@diagnostic disable-next-line: missing-fields
			groups = {
				options = {
					toggle_hidden_on_enter = true,
				},
			},
			diagnostics = "nvim_lsp",
			close_command = function(n)
				MiniBufremove.delete(n)
			end,
			diagnostics_indicator = function(_, _, diag)
				local icons = mininvim.icons
				local ret = (diag.error and icons.error .. diag.error .. " " or "")
					.. (diag.warning and icons.warn .. diag.warning or "")
				return vim.trim(ret)
			end,
			get_element_icon = function(o)
				return MiniIcons.get("filetype", o.filetype)
			end,
		},
	})
	utils.map("n", utils.L("bp"), utils.C("BufferLineTogglePin"), "Toggle Pin")
	utils.map("n", utils.L("bP"), utils.C("BufferLineGroupClose ungrouped"), "Delete Non-Pinned Buffers")
	utils.map("n", utils.L("bR"), utils.C("BufferLineCloseRight"), "Delete Buffers to the Right")
	utils.map("n", utils.L("bL"), utils.C("BufferLineCloseLeft"), "Delete Buffers to the Left")
	utils.map("n", utils.L("bd"), MiniBufremove.delete, "Delete Buffer")
	utils.map("n", utils.L("bD"), utils.C("BufferLineCloseOthers"), "Delete Others Buffer")
	utils.map("n", "<S-l>", utils.C("BufferLineCycleNext"), "Next Buffer")
	utils.map("n", "<S-h>", utils.C("BufferLineCyclePrev"), "Prev Buffer")
	utils.map("n", utils.L("bh"), utils.C("BufferLineMovePrev"), "Move buffer prev")
	utils.map("n", utils.L("bl"), utils.C("BufferLineMoveNext"), "Move buffer next")
	utils.map("n", utils.L("ba"), function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buflisted then
				MiniBufremove.delete(buf, true)
			end
		end
	end, "Delete all buffer")
	utils.map("n", utils.L("bw"), MiniBufremove.wipeout, "Wipeout Buffer")
end)
later(function()
	local MiniStatusline = require("mini.statusline")

	--- @param mode 'percent' | 'line'
	local function get_location(mode)
		if mode == "percent" then
			local current_line = vim.api.nvim_win_get_cursor(0)[1]
			local total_lines = vim.api.nvim_buf_line_count(0)
			if current_line == 1 then
				return "TOP"
			elseif current_line == total_lines then
				return "BOTTOM"
			else
				return "%p%%"
			end
		else
			return "%l|%v"
		end
	end
	local function custom_fileinfo(args)
		args = args or {}
		local filetype = vim.bo.filetype
		filetype = MiniIcons.get("filetype", filetype) .. " " .. filetype
		if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
			return filetype
		end

		local encoding = vim.bo.fileencoding or vim.bo.encoding
		-- local format = vim.bo.fileformat
		local get_size = function()
			local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
			if size < 1024 then
				return string.format("%dB", size)
			elseif size < 1048576 then
				return string.format("%.2fKiB", size / 1024)
			else
				return string.format("%.2fMiB", size / 1048576)
			end
		end

		return string.format("%s%s[%s] %s", filetype, filetype == "" and "" or " ", encoding, get_size())
	end
	local function active_mode()
		local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 75 })
		mode = mode:upper()

		local git = MiniStatusline.section_git({ icon = mininvim.icons.git_branch, trunc_width = 40 })
		local diff = MiniStatusline.section_diff({ icon = "", trunc_width = 100 })
		local diagnostics = MiniStatusline.section_diagnostics({
			icon = "",
			signs = {
				ERROR = mininvim.icons.error,
				WARN = mininvim.icons.warn,
				INFO = mininvim.icons.info,
				HINT = mininvim.icons.hint,
			},
			trunc_width = 75,
		})
		local lsp = MiniStatusline.section_lsp({ icon = mininvim.icons.lsp, trunc_width = 75 })
		MiniStatusline.section_fileinfo = custom_fileinfo
		local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 150 })
		local location = get_location("percent")
		local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
		local filename = MiniStatusline.section_filename({ trunc_width = 250 })
		filename = vim.fn.expand("%:h:t") .. "/" .. vim.fn.expand("%:t")
		-- local code_context = navic.is_available() and navic.get_location()
		return MiniStatusline.combine_groups({
			{ hl = mode_hl, strings = { mode } },
			{
				hl = "MiniStatuslineDevinfo",
				strings = { git, diff, diagnostics },
			},
			"%<", -- Mark general truncate point
			{
				hl = "MiniStatuslineFileName",
				strings = { filename },
			},
			"%=", -- End left alignment
			{ hl = "MiniStatuslineFileinfo", strings = { lsp, fileinfo } },
			{ hl = mode_hl, strings = { search, location } },
		})
	end

	MiniStatusline.setup({
		content = {
			active = active_mode,
		},
	})
end)
later(function()
	require("mini.visits").setup()
	MiniVisits.list_paths(nil, {
		sort = MiniVisits.gen_sort.z(),
		filter = MiniVisits.gen_filter.this_session(),
	})
end)
later(function()
	add({
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
end)

later(function()
	add("mfussenegger/nvim-lint")
	local lint = require("lint")
	local cspell_util = require("config.lint.cspell")
	local opts = {
		linters_by_ft = {
			markdown = { "markdownlint-cli1" },
			css = { "stylelint", "biome" },
			scss = { "stylelint", "biome" },
			javascriptreact = { "biome" },
			typescriptreact = { "biome" },
			typescript = { "biome" },
			javascript = { "biome" },
		},
		---@type table<string,table>
		linters = {
			selene = {
				condition = function(ctx)
					return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
				end,
			},
		},
	}
	for name, linter in ipairs(opts.linters) do
		if type(linter) == "table" and type(lint.linters[name]) == "table" then
			lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
			if type(linter.prepend_args) == "table" then
				lint.linters[name].args = lint.linters[name].args or {}
				vim.list_extend(lint.linters[name].args, linter.prepend_args)
			end
		else
			lint.linters[name] = linter
		end
	end
	lint.linters_by_ft = opts.linters_by_ft
	local file = cspell_util.config_path()
	if not file then
		return nil
	else
		lint.linters_by_ft = {
			["*"] = { "cspell" },
		}
		lint.linters.cspell = function()
			local default_config = require("lint.linters.cspell")
			local config = vim.deepcopy(default_config)
			config.args = {
				"lint",
				"--no-color",
				"--no-progress",
				"--no-summary",
				type(cspell_util.config_path()) == "string" and "--config=" .. cspell_util.config_path() or "",
				function()
					return "stdin://" .. vim.api.nvim_buf_get_name(0)
				end,
			}
			return config
		end
	end
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
		callback = utils.debounce(200, function()
			local names = lint._resolve_linter_by_ft(vim.bo.ft)
			-- create a copy w/o modified the original
			names = vim.deepcopy(names)
			-- Fallback
			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end
			-- Global linter
			vim.list_extend(names, lint.linters_by_ft["*"] or {})
			-- Filter out linters that don't exist or don't match the condition.
			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				if not linter then
					utils.notify_once("Linter not found: " .. name, "ERROR", "nvim-lint")
				end
				---@diagnostic disable-next-line: undefined-field
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			if #names > 0 then
				lint.try_lint(names)
			end
		end),
	})
end)
later(function()
	add("folke/snacks.nvim")
	require("snacks").setup({
		statuscolumn = {
			enabled = true,
			folds = {
				git_hl = false,
				open = true,
			},
		},
	})
end)
