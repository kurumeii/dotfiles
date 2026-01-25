vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<c-a>", "ggVG")
vim.keymap.set("v", "p", [["_dP]])
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "<s-n>", "<s-n>zzzv")
-- vim.keymap.set("n", "<c-d>", "<c-d>zz")
-- vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "]t", ":tabnext<CR>")
vim.keymap.set("n", "[t", ":tabprevious<CR>")
vim.keymap.set("n", "<leader>wq", "<Cmd>q<Cr>", {
	desc = "Window quit",
})
