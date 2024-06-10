-- author:  lmcanavals
-- date:    2024-05-25

if vim.g.debug then print "after.plugin.lualine" end

local hide_if_narrow = function()
	return vim.fn.winwidth(0) > 80
end

require 'lualine'.setup {
	options = {
		component_separators = '',
		section_separators = '',
		theme = 'catppuccin-mocha',
	},
	sections = {
		lualine_b = {
			'branch',
			{
				'diff',
				cond = hide_if_narrow,
			},
		},
		lualine_c = {
			'filename',
			{ 'filesize', cond = hide_if_narrow },
			{
				function()
					local msg = ''
					local clients = vim.lsp.get_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						if not client.is_stopped() then
							msg = msg .. client.name .. " "
						end
					end
					return msg
				end,
				color = { fg = 'peru', gui = 'bold' },
				cond = hide_if_narrow,
				icon = '󱩼',
			},
			'diagnostics',
		},
		lualine_x = {
			{
				function()
					local msg = require 'noice'.api.status.mode.get()
					local _, endindex = string.find(msg, 'recording @')
					if endindex ~= nil then
						return '󰑊 ' .. string.sub(msg, endindex, endindex + 1)
					else
						return ''
					end
				end,
				cond = require 'noice'.api.status.mode.has,
				color = { fg = 'tomato' },
			},
			'encoding',
			'fileformat',
			'filetype',
		},
	},
}

-- vim: set ts=2:sw=2:noet:sts=2:
