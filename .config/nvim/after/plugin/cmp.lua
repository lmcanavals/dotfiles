-- author:  lmcanavals
-- date:    2021-07-26

if vim.g.debug then print "after.plugin.cmp" end

local cmp = require 'cmp'

cmp.setup {
	snippet = {
		expand = function(args)
			require 'luasnip'.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert {
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = cmp.config.sources {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	{
		{ name = 'buffer' },
	}
}

require 'luasnip.loaders.from_vscode'.lazy_load()

-- vim: set ts=2:sw=2:noet:sts=2:
