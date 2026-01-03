local dap = require("dap")
local dapui = require("dapui")
local utils = require("config.utils")

require("mason-nvim-dap").setup({
	ensure_installed = {},
	automatic_installation = false,
})

require("nvim-dap-virtual-text").setup({
	enabled = true,
})
dapui.setup()

for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
	dap.adapters[adapter] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
				"${port}",
			},
		},
	}
end

-- VSCode-like configurations for JS/TS
local js_languages = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

for _, language in ipairs(js_languages) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			request = "launch",
			name = 'Start Chrome with "localhost"',
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			userDataDir = "${workspaceFolder}/.vscode/pwa-chrome-debug",
		}
	}
end

-- Keymaps
utils.map("n", "<F5>", dap.continue, "Debug: Start/Continue")
utils.map("n", "<F1>", dap.step_into, "Debug: Step Into")
utils.map("n", "<F2>", dap.step_over, "Debug: Step Over")
utils.map("n", "<F3>", dap.step_out, "Debug: Step Out")
utils.map("n", "<leader>cb", dap.toggle_breakpoint, "Debug: Toggle Breakpoint")
utils.map("n", "<leader>cB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Debug: Set Breakpoint")

-- Dap UI setup
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close
