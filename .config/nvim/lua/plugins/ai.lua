return {
	"folke/sidekick.nvim",
	opts = {
		cli = {
			tools = {
				antigravity = {
					cmd = { "agy" },
				},
			},
		},
	},
	{
		"carlos-algms/agentic.nvim",
		opts = {
			provider = "antigravity",
			acp_providers = {
				["antigravity"] = {
					name = "Antigravity",
					command = "agy",
					args = { "acp" },
					initial_model = "gemini-3.8-flash",
				},
			},
			default_provider = "antigravity",
		},
		keys = {
			{
				"<leader>ay",
				function()
					require("agentic").toggle()
				end,
				desc = "Toggle Antigravity Chat (ACP)",
				mode = { "n", "v" },
			},
			{
				"<leader>av",
				function()
					require("agentic").add_selection_or_file_to_context()
				end,
				desc = "Add context to Agentic",
				mode = { "n", "v" },
			},
			{
				"<leader>an",
				function()
					require("agentic").new_session()
				end,
				desc = "New Agentic Session",
				mode = { "n", "v" },
			},
			{
				"<leader>ar",
				function()
					require("agentic").restore_session()
				end,
				desc = "Agentic Restore Session",
				mode = { "n" },
			},
			{
				"<leader>ae",
				function()
					require("agentic").add_current_line_diagnostics()
				end,
				desc = "Add line diagnostic to Agentic",
				mode = { "n" },
			},
			{
				"<leader>aE",
				function()
					require("agentic").add_buffer_diagnostics()
				end,
				desc = "Add buffer diagnostics to Agentic",
				mode = { "n" },
			},
		},
	},
}
