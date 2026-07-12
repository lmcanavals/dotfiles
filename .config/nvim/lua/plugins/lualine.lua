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
							local clients = vim.lsp.get_clients({ buffer = 0 })
							if #clients == 0 then
								return ""
							end

							local names = {}
							for _, client in ipairs(clients) do
								if not client:is_stopped() then
									table.insert(names, client.name)
								end
							end

							return table.concat(names, " ")
						end,
						color = { gui = "italic,bold" },
						icon = "",
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
