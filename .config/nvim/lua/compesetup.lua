-- author: lmcanavals
-- date:   2021-07-26

local fn = vim.fn
local map  = vim.api.nvim_set_keymap

require'compe'.setup {
	enabled          = true;
	autocomplete     = true;
	debug            = false;
	min_length       = 1;
	preselect        = "enable";
	throttle_time    = 80;
	source_timeout   = 200;
	incomplete_delay = 400;
	max_abbr_width   = 100;
	max_kind_width   = 100;
	max_menu_width   = 100;
	documentation    = true;
	source = {
		path     = true;
		nvim_lsp = true;
	};
}

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = fn.col('.') - 1
	return col == 0 or fn.getline('.'):sub(col, col):match('%s')
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
	if fn.pumvisible() == 1 then
		return t "<C-n>"
	elseif check_back_space() then
		return t "<Tab>"
	else
		return fn['compe#complete']()
	end
end
_G.s_tab_complete = function()
	if fn.pumvisible() == 1 then return t "<C-p>" else return t "<S-Tab>" end
end

map("i", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
map("s", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

