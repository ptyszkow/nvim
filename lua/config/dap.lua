local dap = require("dap")

-- Python setup
dap.adapters.python = {
	type = "executable",
	command = "python3",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = function()
			-- 1. Check for venv in workspace
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			end

			-- 2. Fallback to system python
			return vim.fn.exepath("python3") or "python"
		end,
	},
}
-- .NET / C# setup
dap.adapters.netcoredbg = {
	type = "executable",
	command = "netcoredbg",
	args = { "--interpreter=vscode" },
	options = { detached = false },
}

dap.configurations.cs = {
	{
		type = "netcoredbg",
		name = "Launch - console_test (net9.0)",
		request = "launch",
		program = function()
			return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/console_test.dll", "file")
		end,
	},
	{
		type = "netcoredbg",
		name = "Attach to process",
		request = "attach",
		processId = function()
			local output = vim.fn.system("ps -aux | grep dotnet")
			print("Available dotnet processes:\n" .. output)
			return tonumber(vim.fn.input("Process ID: "))
		end,
	},
}
-- Keybindings
vim.keymap.set("n", "<F5>", function()
	dap.continue()
end)
vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end)
vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end)
vim.keymap.set("n", "<F12>", function()
	dap.step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
	dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
