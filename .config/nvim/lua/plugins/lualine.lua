return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.options.component_separators = ""
			opts.options.section_separators = ""
			opts.sections.lualine_y = {
				{
					function()
						local msg = ""
						local i = 0
						local clients = vim.lsp.get_clients()
						if next(clients) == nil then
							return msg
						end
						for _, client in ipairs(clients) do
							if not client.is_stopped() then
								msg = msg .. (i == 0 and "" or " ") .. client.name
								i = i + 1
							end
						end
						return msg
					end,
					color = { fg = "gold", gui = "italic,bold" },
					icon = "󰒋",
				},
			}
			opts.sections.lualine_z = {
				{ "progress", padding = { left = 1, right = 0 } },
				{ "location", padding = { left = 0, right = 1 } },
			}
		end,
	},
}
