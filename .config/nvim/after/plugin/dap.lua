-- author:  lmcanavals
-- date:    2024-05-31

if vim.g.debug then print "after.plugin.dap" end

local dap = require 'dap'
local ui = require 'dapui'
local vks = vim.keymap.set

ui.setup()
--require 'dap-go'.setup()

vks('n', '<F7>', dap.toggle_breakpoint, { desc = "[F7] DAP toggle breakpoint" })
vks('n', '<F8>', dap.toggle_breakpoint, { desc = "[F8] DAP run to cursor" })
vks('n', '<F9>', dap.toggle_breakpoint, { desc = "[F9] DAP continue" })
vks('n', '<F10>', dap.toggle_breakpoint, { desc = "[F10]DAP step over" })
vks('n', '<F11>', dap.toggle_breakpoint, { desc = "[F11]DAP step in" })
vks('n', '<F12>', dap.toggle_breakpoint, { desc = "[F12]DAP step out" })

-- vim: set ts=2:sw=2:noet:sts=2:
