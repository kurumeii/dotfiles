-- MiniDeps.add("rafamadriz/friendly-snippets")
local lang_patterns = {
	jsx = { "javascript/javascript.json", "javascript/react.json" },
	tsx = { "javascript/javascript.json", "javascript/react.json" },
}

local snippets, config_path = require("mini.snippets"), vim.fn.stdpath("config")
snippets.setup({
	snippets = {
		snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
		snippets.gen_loader.from_lang({
			lang_patterns = lang_patterns,
		}),
		snippets.start_lsp_server(),
	},
	mappings = {
		expand = "<c-j>",
	},
	expand = {
		select = function(snip, ins)
			local select = snippets.default_select
			select(snip, ins)
		end,
	},
})
