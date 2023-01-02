----- NeoVim Settings -----
    --- Indentation ---
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.preserveindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
--- System Integration ---
vim.cmd[[set gcr=n-c-sm:hor20,i-ci-ve:ver25,r-v-cr-o:block]] -- cursor shape
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
      --- History ---
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.fileencoding = 'utf-8'
      --- Visuals ---
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.lazyredraw = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.pumheight=10
vim.opt.showtabline = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.syntax = 'on'
vim.opt.lcs = 'tab:——,space:·,extends:◣,precedes:◢'
vim.opt.list = true
    --- Completion ---
vim.opt.spl = 'it,en_us'
vim.opt.spell = true
vim.cmd[[set tags+=$HOME/Dev/tags]]
vim.opt.cot = 'menu,menuone,noselect'
vim.opt.wim = 'longest,list'

----- Plugin Settings -----
  --- Loading Plugins ---
local ensure_packer = function() -- https://github.com/wbthomason/packer.nvim#bootstrapping @Iron-E and @khuedoan
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd[[packadd packer.nvim]]
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'morhetz/gruvbox'
	use 'jiangmiao/auto-pairs'
	use 'preservim/nerdtree'
	use 'preservim/nerdcommenter'
	use 'lervag/vimtex'
	use 'tpope/vim-surround'
	use 'vim-airline/vim-airline'
	use 'neovim/nvim-lspconfig'
	use 'lukas-reineke/lsp-format.nvim'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	if packer_bootstrap then
		require('packer').sync()
	end
end)
vim.cmd[[colo gruvbox]]

----- Plugin Settings -----
    --- LaTex/VimTex ---
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = 'abdmg'
vim.opt.conceallevel = 1

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
