require("mini.pairs").setup({
	modes = { insert = true, command = false, terminal = false },
	-- Skip if the next character is alphanumeric or a closer
	skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
	skip_unbalanced = true,
	markdown = true,
})
