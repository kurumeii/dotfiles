local lint = require("lint")
local valid_config_file = {
	"biome.json",
	"biome.jsonc",
}

local function config_path()
	for idx, config_file in pairs(valid_config_file) do
		local path = vim.fn.getcwd() .. "/" .. config_file ---@type string
		if vim.uv.fs_stat(path) then
			return path
		elseif idx == #valid_config_file then
			return nil
		end
	end
end

if config_path() == nil then
	return nil
else
	local should_use = {
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
		typescript = { "biome" },
		javascript = { "biome" },
		css = { "biome" },
		scss = { "biome" },
	}
	for ft, linters in pairs(should_use) do
		if type(lint.linters_by_ft[ft]) == "table" then
			for _, l in ipairs(linters) do
				local found = false
				for _, existing in ipairs(lint.linters_by_ft[ft]) do
					if existing == l then
						found = true
						break
					end
				end
				if not found then
					table.insert(lint.linters_by_ft[ft], l)
				end
			end
		else
			lint.linters_by_ft[ft] = vim.deepcopy(linters)
		end
	end
	-- Merge or set the biome linter definition
	local default = require("lint.linters.biomejs")
	if type(lint.linters.biome) == "table" then
		lint.linters.biome = vim.tbl_deep_extend("force", default, lint.linters.biome)
	else
		lint.linters.biome = default
	end
end
