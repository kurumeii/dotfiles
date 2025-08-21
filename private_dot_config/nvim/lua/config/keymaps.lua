local map = vim.keymap.set
map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "[t", "<cmd>tabprev<cr>", { desc = "Previous tab" })
map("n", "<c-a>", "ggVG", {
	noremap = true,
	desc = "Visual select all",
})
