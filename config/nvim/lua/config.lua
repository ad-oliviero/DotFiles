local lspconfig = require('lspconfig')
local lspformat = require('lsp-format')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local cmp = require('cmp')
local feedkey = function(key, mode) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true) end
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
lspformat.setup {}
for _, lsp in ipairs({'clangd', 'rust_analyzer', 'pyright'}) do
	lspconfig[lsp].setup {
		on_attach = lspformat.on_attach,
		capabilities = capabilities
	}
end
cmp.setup({
	snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({select = true}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, {"i", "s"}),
		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, {"i", "s"})
	}),
	sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}}, {{name = 'buffer'}})
})
cmp.setup.filetype('gitcommit', {sources = cmp.config.sources({{name = 'cmp_git'}}, {{name = 'buffer'}})})
cmp.setup.cmdline({'/', '?'}, {mapping = cmp.mapping.preset.cmdline(), sources = {{name = 'buffer'}}})
cmp.setup.cmdline(':', {mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})})
