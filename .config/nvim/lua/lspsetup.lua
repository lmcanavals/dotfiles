-- author: lmcanavals
-- date:   2021-07-26

local nvim_lsp = require'lspconfig'

local on_attach = function(client, bufnr)
	local function bsk(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function bso(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	--Enable completion triggered by <c-x><c-o>
	bso("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local mappings = {
		["<space>wa"] = "buf.add_workspace_folder()",
		["<space>ca"] = "buf.code_action()",
		["gD"]        = "buf.declaration()",
		["gd"]        = "buf.definition()",
		["<space>f"]  = "buf.formatting()",
		["K"]         = "buf.hover()",
		["gi"]        = "buf.implementation()",
		["gr"]        = "buf.references()",
		["<space>wr"] = "buf.remove_workspace_folder()",
		["<space>rn"] = "buf.rename()",
		["<C-k>"]     = "buf.signature_help()",
		["<space>D"]  = "buf.type_definition()",
		["]d"]        = "diagnostic.goto_next()",
		["[d"]        = "diagnostic.goto_prev()",
		["<space>q"]  = "diagnostic.set_loclist()",
		["<space>e"]  = "diagnostic.show_line_diagnostics()",
	}
	for m, c in pairs(mappings) do
		bsk("n", m, "<cmd>lua vim.lsp."..c.."<CR>", {noremap=true, silent=true})
	end
	--"<space>wl"
	--"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"
end

nvim_lsp.ccls.setup {
	init_options = {
		compilationDatabaseDirectory = "build";
		index = {
			threads = 0;
		};
		clang = {
			excludeArgs = {"-frounding-math"};
		};
	}
}
nvim_lsp.denols.setup {
	init_options = {
		lint = true
	},
}
nvim_lsp.gopls.setup {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}
nvim_lsp.pyright.setup {}

local servers = {"ccls", "denols", "gopls", "pyright"}
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {on_attach = on_attach}
end

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

