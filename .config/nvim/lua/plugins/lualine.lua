return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.options.component_separators = ""
			opts.options.section_separators = ""
			table.insert(opts.sections.lualine_b, {
				function()
					local msg = ""
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
				color = { fg = "peru", gui = "bold" },
				icon = "",
			})
		end,
	},
}
