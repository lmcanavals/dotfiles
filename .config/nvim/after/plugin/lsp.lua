-- author:  lmcanavals
-- date:    2021-07-26
-- updated: 2023-07-14

if vim.g.debug then print "after.plugin.lsp" end

local nvim_lsp = require 'lspconfig'
local vks = vim.keymap.set
local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.bashls.setup {
	capabilities = capabilities,
	filetypes = { "sh", "bash", "zsh" }
}
nvim_lsp.clangd.setup {
	capabilities = capabilities,
}
nvim_lsp.denols.setup {
	capabilities = capabilities,
	init_options = {
		lint = true
	},
}
nvim_lsp.gopls.setup {
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}
nvim_lsp.lua_ls.setup {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
nvim_lsp.pyright.setup {
	capabilities = capabilities,
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vks("n", "]d", vim.diagnostic.goto_next)
vks("n", "[d", vim.diagnostic.goto_prev)
vks("n", "<space>k", vim.diagnostic.open_float)
vks("n", "<space>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vks('n', 'gD', vim.lsp.buf.declaration, opts)
		vks('n', 'gd', vim.lsp.buf.definition, opts)
		vks('n', 'K', vim.lsp.buf.hover, opts)
		vks('n', 'gi', vim.lsp.buf.implementation, opts)
		vks('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vks('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vks('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vks('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vks('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vks('n', '<space>rn', vim.lsp.buf.rename, opts)
		vks({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vks('n', 'gr', vim.lsp.buf.references, opts)
		vks('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- vim: set ts=2:sw=2:noet:sts=2:
