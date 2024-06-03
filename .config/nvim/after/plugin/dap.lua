-- author:  lmcanavals
-- date:    2024-05-31

if vim.g.debug then print "after.plugin.dap" end

local dap = require 'dap'
local dapui = require 'dapui'
local vks = vim.keymap.set

dapui.setup()
--require 'dap-go'.setup()

-- adapters
dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-vscode',
	name = 'lldb'
}

-- configurations
dap.configurations.cpp = {
	{
		name = 'Launch',
		type = 'lldb',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		args = {},

		-- 💀
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		-- runInTerminal = false,
	},
}

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vks('n', '<F12>b', dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
vks('n', '<F12>u', dap.run_to_cursor, { desc = "DAP run to cursor" })
vks('n', '<F12>c', dap.continue, { desc = "DAP continue" })
vks('n', '<F12>r', dap.restart, { desc = "DAP restart" })
vks('n', '<F12>l', dap.step_over, { desc = "DAP step over" })
vks('n', '<F12>j', dap.step_into, { desc = "DAP step into" })
vks('n', '<F12>k', dap.step_out, { desc = "DAP step out" })
vks('n', '<F12>h', dap.step_back, { desc = "DAP step back" })

-- vim: set ts=2:sw=2:noet:sts=2:
