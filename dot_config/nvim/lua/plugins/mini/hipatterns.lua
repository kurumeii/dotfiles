local hi = require("mini.hipatterns")
local utils = require("config.utils")
local hi_words = MiniExtra.gen_highlighter.words
local M = {}
---@type table<string, boolean>
M.hl = {}
hi.setup({
	highlighters = {
		fixme = hi_words({ "FIXME", "fixme" }, "MiniHiPatternsFixme"),
		todo = hi_words({ "TODO", "todo" }, "MiniHiPatternsTodo"),
		note = hi_words({ "NOTE", "note", "readme", "README" }, "MiniHiPatternsNote"),
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
				if not color then
					return
				end
				shade = tonumber(shade)
				local bg = vim.tbl_get(mininvim.tw_colors, color, shade)
				if bg == nil then
					return
				end
				local hl = "MiniHiPatternsTailwind" .. color .. shade
				if not M.hl[hl] then
					M.hl[hl] = true
					-- local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
					-- local fg = vim.tbl_get(mininvim.tw_colors, color, bg_shade)
					-- vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
					vim.api.nvim_set_hl(0, hl, { fg = "#" .. bg })
				end
				return hl
			end,
			extmark_opts = function(_, _, data)
				return {
					virt_text = { { "󰝤 ", data.hl_group } },
					virt_text_pos = "inline",
					priority = 1000,
				}
			end,
		},
	},
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		M.hl = {}
	end,
})
