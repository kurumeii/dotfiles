require("mini.deps").add("mfussenegger/nvim-lint")
local lint = require("lint")
local cspell_util = require("config.lint.cspell")
local utils = require("config.utils")
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
