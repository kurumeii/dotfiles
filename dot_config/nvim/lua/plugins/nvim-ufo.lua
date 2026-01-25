local add = require("mini.deps").add
add("lbrayner/vim-rzip")
add({
	source = "kevinhwang91/nvim-ufo",
	depends = {
		"kevinhwang91/promise-async",
	},
})
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		vim.o.foldcolumn = "auto"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		local ufo = require("ufo")
		local utils = require("config.utils")
		ufo.setup({
			open_fold_hl_timeout = 150,
			preview = {
				win_config = {
					border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
			},
			provider_selector = function(_, filetype)
				local ftMap = {
					kdl = "treesitter",
					python = "indent",
				}
				return ftMap[filetype] or { "lsp", "indent" }
			end,
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
		utils.map({ "n" }, "zO", ufo.openAllFolds, "Open all folds")
		utils.map({ "n" }, "zC", ufo.closeAllFolds, "Close all folds")
		utils.map("n", "zi", ufo.inspect, "Ufo: inspect", { noremap = true })
		utils.map({ "n" }, "zk", function()
			local winid = ufo.peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end, "Peek Folded Lines")
	end,
})
