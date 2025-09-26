return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_y = {
					{
						function()
							local names = {}
							local clients = vim.lsp.get_clients({ buffer = 0 })
							if next(clients) == nil then
								return ""
							end
							for _, client in ipairs(clients) do
								if not client.is_stopped(client) then
									names[client.name] = true
								end
							end
							local name_list = {}
							for name, _ in pairs(names) do
								table.insert(name_list, name)
							end

							return table.concat(name_list, " ")
						end,
						color = { gui = "italic,bold" },
						icon = "󰒋",
					},
				},
				lualine_z = {
					{ "progress", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
			},
		},
	},
}
