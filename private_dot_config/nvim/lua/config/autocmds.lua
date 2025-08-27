local utils = require("utils")

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local MiniFiles = require("mini.files")
		utils.map({ "n" }, "//", function()
			utils.show_dotfiles = not utils.show_dotfiles
			local new_filter = utils.show_dotfiles and utils.filter_show or utils.filter_hide
			MiniFiles.refresh({ content = { filter = new_filter } })
		end, "Toggle hidden files", { buffer = args.buf })
		utils.map_split(args.buf, "<C-w>s", "horizontal", false)
		utils.map_split(args.buf, "<C-w>v", "vertical", false)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesActionRename",
	callback = function(e)
		require("snacks.rename").on_rename_file(e.data.from, e.data.to)
		utils.notify("Renamed " .. e.data.from .. " to " .. e.data.to .. " successfully")
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(args)
		utils.map("i", "<C-S>", vim.lsp.buf.signature_help, "Signature help", {
			buffer = args.buf,
		})
		utils.map("n", utils.L("cr"), function()
			vim.ui.input({ prompt = "Rename to: " }, function(new_name)
				if not new_name then
					utils.notify("Rename cancelled", "WARN")
				else
					vim.lsp.buf.rename(new_name, { bufnr = args.buf })
					utils.notify("Rename successfully")
				end
			end)
		end, "Rename")
		if utils.has_lsp("vtsls") then
			utils.map("n", utils.L("co"), utils.action["source.organizeImports"], "[TS] Organize imports")
			utils.map("n", utils.L("cv"), function()
				utils.execute({ command = "typescript.selectTypeScriptVersion" })
			end, "[TS] Select ts version")
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.api.nvim_buf_line_count(0) > 10000 then
			vim.b.navic_lazy_update_context = true
		end
	end,
})
