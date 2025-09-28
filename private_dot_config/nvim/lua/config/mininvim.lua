_G.mininvim = {
	icons = {
		mode_prepend = " ",
		clock = "󰥔",
		git_branch = "",
		error = "󰅙 ",
		warn = "󰀨 ",
		info = "󰋼 ",
		hint = "󰌵 ",
		lsp = "",
		no_lsp = "󱏎",
		edit = "󰏫 ",
		git_signs = {
			add = "▎",
			change = "▎",
			delete = "",
		},
		git_add = "󰐖 ",
		git_edit = "󱗜 ",
		git_remove = "󰍵 ",
		spinner = {
			"",
			"",
			"",
			"",
			"",
			"",
		},
		recording = " ",
		groups = {
			brewer = {
				files = { "Brewfile" },
				glyph = "󰂘",
				type = "file",
				hl = "MiniIconsYellow",
			},
			chezmoi = {
				files = { ".chezmoiignore", ".chezmoiremove", ".chezmoiroot", ".chezmoiversion" },
				glyph = "",
				type = "file",
				hl = "MiniIconsGrey",
			},
			bash = {
				files = {
					".zshrc",
					".zprofile",
					".zshenv",
					".zlogin",
					".zlogout",
					"zsh.tmpl",
					".bashrc",
					".bash_profile",
					".bash_aliases",
					".bash_logout",
					"bash.tmpl",
				},
				glyph = "",
				type = "file",
				hl = "MiniIconsGrey",
			},
			json = {
				files = { ".json", ".jsonc", ".bak" },
				glyph = "",
				type = "file",
				hl = "MiniIconsYellow",
			},
			eslint = {
				files = {
					".eslintrc.js",
					".eslintrc.json",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.cjs",
					".eslintrc.mjs",
					".eslintrc.ts",
					".eslintrc",
					"eslint.config.js",
					"eslint.config.json",
					"eslint.config.yaml",
					"eslint.config.yml",
					"eslint.config.cjs",
					"eslint.config.mjs",
					"eslint.config.ts",
				},
				glyph = "󰱺",
				type = "file",
				hl = "MiniIconsPurple",
			},
			prettier = {
				files = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yaml",
					".prettierrc.yml",
					".prettierrc.json5",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					".prettierrc.ts",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
					"prettier.config.ts",
				},
				glyph = "",
				type = "file",
				hl = "MiniIconsYellow",
			},
			yarn = {
				files = { "yarn.lock", ".yarnrc.yml", ".yarnrc.yaml" },
				glyph = "",
				type = "file",
				hl = "MiniIconsBlue",
			},
			ts = {
				files = {
					"tsconfig.json",
					"tsconfig.build.json",
					"tsconfig.app.json",
					"tsconfig.server.json",
					"tsconfig.web.json",
					"tsconfig.client.json",
				},
				glyph = "",
				type = "file",
				hl = "MiniIconsAzure",
			},
			node = {
				files = { ".node-version", "package.json", ".npmrc" },
				glyph = "",
				type = "file",
				hl = "MiniIconsGreen",
			},
			vite = {
				files = { "vite.config.ts", "vite.config.js" },
				glyph = "",
				type = "file",
				hl = "MiniIconsYellow",
			},
			pnpm = {
				files = { "pnpm-lock.yaml", "pnpm-workspace.yaml" },
				glyph = "",
				type = "file",
				hl = "MiniIconsYellow",
			},
			docker = {
				files = { ".dockerignore" },
				glyph = "󰡨",
				type = "file",
				hl = "MiniIconsBlue",
			},
			react_router = {
				files = { "react-router.config.ts", "react-router.config.js" },
				glyph = "",
				type = "file",
				hl = "MiniIconsRed",
			},
			bun = {
				files = { "bun.lockb", "bun.lock" },
				glyph = "",
				type = "file",
				hl = "MiniIconsGrey",
			},
			vscode = {
				type = "directory",
				files = { ".vscode" },
				glyph = "",
				hl = "MiniIconsBlue",
			},
			cspell = {
				type = "directory",
				files = { "cspell" },
				glyph = "󰓆",
				hl = "MiniIconsPurple",
			},
			config = {
				type = "directory",
				files = { "config", "configs" },
				glyph = "",
				hl = "MiniIconsGrey",
			},
			app = {
				type = "directory",
				files = { "app", "application" },
				glyph = "󰀻",
				hl = "MiniIconsRed",
			},
			routes = {
				type = "directory",
				files = { "routes", "route", "router", "routers" },
				glyph = "󰑪",
				hl = "MiniIconsGreen",
			},
			server = {
				type = "directory",
				files = { "server", "servers", "api" },
				glyph = "󰒋",
				hl = "MiniIconsCyan",
			},
			web = {
				type = "directory",
				files = { "web", "client", "frontend" },
				glyph = "󰖟",
				hl = "MiniIconsBlue",
			},
			database = {
				type = "directory",
				files = { "database", "db", "databases" },
				glyph = "󰆼",
				hl = "MiniIconsOrange",
			},
		},
	},
	utils = {
		-- Central LSP config merger
		---@overload fun(cfg: table): table                   -- global merge
		---@overload fun(server: string, cfg: table): table    -- server specific merge
		---@param a string|table
		---@param b? table
		lsp = function(a, b)
			local server, cfg
			if type(a) == "string" then
				server, cfg = a, b or {}
			else
				server, cfg = "*", a or {}
			end
			_G.mininvim._lsp_configs = _G.mininvim._lsp_configs or { ["*"] = {} }
			vim.tbl_deep_extend("force", _G.mininvim._lsp_configs[server] or {}, cfg)
			vim.lsp.config(server, cfg)
		end,

		-- (helpers removed per preference)
	},
}
