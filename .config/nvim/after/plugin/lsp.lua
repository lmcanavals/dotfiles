-- author:  lmcanavals
-- date:    2021-07-26

if vim.g.debug then print "after.plugin.lsp" end

local nvim_lsp = require 'lspconfig'
local vks = vim.keymap.set
local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.bashls.setup {
	capabilities = capabilities,
	filetypes = { 'sh', 'bash', 'zsh' }
}
nvim_lsp.cmake.setup{}
nvim_lsp.clangd.setup { -- installs along with clang
	capabilities = capabilities,
}
nvim_lsp.denols.setup {
	capabilities = capabilities,
	init_options = {
		lint = true
	},
}
nvim_lsp.gopls.setup { -- install via pacman
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
nvim_lsp.jdtls.setup {}
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
require 'lspconfig'.pylsp.setup {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = { 'W391' },
					maxLineLength = 80,
				}
			}
		}
	}
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vks('n', '<space>]', vim.diagnostic.goto_next, { desc = "next diagnostic" })
vks('n', '<space>[', vim.diagnostic.goto_prev, { desc = "previous diagnostic" })
vks('n', '<space>k', vim.diagnostic.open_float, { desc = "expand diagnostic" })
vks('n', '<space>q', vim.diagnostic.setloclist, { desc = "set loclist" })

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vks('n', 'gD', vim.lsp.buf.declaration,
			{ buffer = ev.buf, desc = "[g]o to [D]eclaration" })
		vks('n', 'gd', vim.lsp.buf.definition,
			{ buffer = ev.buf, desc = "[g]o to [d]efinition" })
		vks('n', 'K', vim.lsp.buf.hover,
			{ buffer = ev.buf, desc = "[K] hover" })
		vks('n', 'gi', vim.lsp.buf.implementation,
			{ buffer = ev.buf, desc = "[g]o to [i]plementation" })
		vks('n', '<C-k>', vim.lsp.buf.signature_help,
			{ buffer = ev.buf, desc = "[C-k] signature_help" })
		vks('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
			{ buffer = ev.buf, desc = "Add workspace folder" })
		vks('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
			{ buffer = ev.buf, desc = "Remove workspace folder" })
		vks('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { buffer = ev.buf, desc = "List workspace folders" })
		vks('n', '<space>D', vim.lsp.buf.type_definition,
			{ buffer = ev.buf, desc = "Type [D]efinition" })
		vks('n', '<space>rn', vim.lsp.buf.rename,
			{ buffer = ev.buf, desc = "[r]e[n]ame" })
		vks({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action,
			{ buffer = ev.buf, desc = "[c]ode [a]ction" })
		vks('n', 'gr', vim.lsp.buf.references,
			{ buffer = ev.buf, desc = "[g]o to [r]eferences" })
		vks('n', '<space>=', function()
				vim.lsp.buf.format { async = true }
			end,
			{ buffer = ev.buf, desc = "LSP format" })
	end,
})

-- vim: set ts=2:sw=2:noet:sts=2:
