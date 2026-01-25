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
MiniDeps.later(MiniIcons.mock_nvim_web_devicons)
if vim.g.mini.completion then
	MiniDeps.later(MiniIcons.tweak_lsp_kind)
end
