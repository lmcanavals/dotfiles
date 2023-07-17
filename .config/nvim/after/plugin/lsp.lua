-- author:  lmcanavals
-- date:    2021-07-26
-- updated: 2023-07-14

if vim.g.debug then print "after.plugin.lsp" end

local nvim_lsp = require 'lspconfig'

local on_attach = function(_, bufnr) -- unused param: client
	local function bsk(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function bso(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	--Enable completion triggered by <c-x><c-o>
	bso("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- See `:help vim.lsp.*` for documentation on any of the functions below
	local mappings = {
		["<space>wa"] = "lsp.buf.add_workspace_folder()",
		["<space>ca"] = "lsp.buf.code_action()",
		["gD"]        = "lsp.buf.declaration()",
		["gd"]        = "lsp.buf.definition()",
		["<space>="]  = "lsp.buf.format()",
		["K"]         = "lsp.buf.hover()",
		["gi"]        = "lsp.buf.implementation()",
		["gr"]        = "lsp.buf.references()",
		["<space>wr"] = "lsp.buf.remove_workspace_folder()",
		["<space>rn"] = "lsp.buf.rename()",
		["<C-k>"]     = "lsp.buf.signature_help()",
		["<space>D"]  = "lsp.buf.type_definition()",
		["]d"]        = "diagnostic.goto_next()",
		["[d"]        = "diagnostic.goto_prev()",
		["<space>q"]  = "diagnostic.set_loclist()",
		["<space>e"]  = "diagnostic.show_line_diagnostics()",
		["<space>k"]  = "diagnostic.open_float()",
	}
	for m, c in pairs(mappings) do
		bsk("n", m, "<cmd>lua vim." .. c .. "<CR>", { noremap = true, silent = true })
	end
	--"<space>wl"
	--"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.bashls.setup {
}
nvim_lsp.clangd.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
nvim_lsp.denols.setup {
	on_attach = on_attach,
	capabilities = capabilities,

	init_options = {
		lint = true
	},
}
nvim_lsp.gopls.setup {
	on_attach = on_attach,
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
	on_attach = on_attach,
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
	on_attach = on_attach,
	capabilities = capabilities,
}

-- vim: set ts=2:sw=2:noet:sts=2:
