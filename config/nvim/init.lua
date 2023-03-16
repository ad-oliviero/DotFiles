-- some of the configuration is 'inspired' (copied) from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
----- NeoVim Settings -----
--- Indentation ---
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.preserveindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
--- System Integration ---
vim.opt.guicursor = 'n-c-sm:hor20,i-ci-ve:ver25,r-v-cr-o:block'
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.whichwrap = vim.opt.whichwrap + '<,>,[,]'
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
vim.opt.pumheight = 10
vim.opt.showtabline = 2
vim.opt.tabstop = 2
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.syntax = 'on'
vim.opt.lcs = {tab = '——', space = '·', extends = '◣', precedes = '◢'}
vim.opt.list = true
--- Completion ---
vim.opt.spl = {'it', 'en_us'}
vim.opt.spell = true
vim.cmd [[set tags+=$HOME/Dev/tags]]
vim.opt.cot = 'menuone,noselect'
vim.opt.wim = 'longest,list'
--- Automation ---
vim.api.nvim_create_autocmd("InsertEnter",
                            {callback = function() vim.cmd [[norm zz]] end})
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function() vim.opt.guicursor = 'a:ver25' end
})
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function() vim.opt.readonly = false end
})
local highlight_sp_cmd = {'ExtraWhitespace', 'ctermbg=red', 'guibg=red'}
vim.api.nvim_create_autocmd("Colorscheme", {
    callback = function() vim.cmd.highlight(highlight_sp_cmd) end
})
vim.cmd.highlight(highlight_sp_cmd)
vim.cmd [[match ExtraWhitespace /\s\+$/]]
if vim.fn.has('autocmd') then
    vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function() vim.cmd [[exe "normal! g'\""]] end
    })
end
local compilecmd = "!exec echo 'Compile command not set, use :Setmk to set it'"
vim.api.nvim_create_autocmd("filetype *", {
    callback = function()
        vim.keymap.set({'n', 'i'}, '<C-c>', function()
            vim.cmd(compilecmd)
        end)
    end
})
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'},
                            {pattern = '*.conf', command = 'set filetype=conf'})
function setmk(cmd) compilecmd = ':w | !echo ""; ' .. cmd end
vim.cmd('command! -nargs=1 Setmk :lua setmk(<f-args>)')
vim.api.nvim_create_autocmd("filetype python",
                            {callback = function() setmk("python ./%") end})
vim.api.nvim_create_autocmd("filetype c",
                            {callback = function() setmk("make debug") end})
-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight',
                                                    {clear = true})
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = '*'
})
--- Custom Shortcuts ---
vim.keymap.set('n', 'n', 'nzzzv') -- center searched word on screen
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<F2>', ':NERDTreeToggle<CR>')
vim.keymap.set({'n', 'i'}, '<A-i>', '<ESC>:Format<CR>')
vim.keymap.set({'n', 'i'}, '<C-d>', '<ESC>viw') -- select word with ctrl+d
vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<CR>') -- reload configuration
vim.keymap.set('n', '<C-q>', ':tabn<CR>') -- switch tabs
vim.keymap.set('n', '<C-S-q>', ':tabp<CR>')
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==') -- move line
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('n', '<A-down>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-up>', ':m .-2<CR>==')
vim.keymap.set('i', '<C-s>', '<ESC>:wa<CR>a') -- save with ctrl+s
vim.keymap.set('n', '<C-s>', ':wa<CR>')
vim.keymap.set({'n', 'v', 'i'}, '<A-c>',
               function() vim.fn['nerdcommenter#Comment']('n', 'Toggle') end)
vim.keymap.set({'n', 'v', 'i'}, '<C-A-c>',
               function() vim.fn['nerdcommenter#Comment']('n', 'Invert') end)
vim.keymap.set({'n', 'v', 'i'}, '<S-A-c>',
               function() vim.fn['nerdcommenter#Comment']('n', 'Comment') end)
local password_used = false
vim.api.nvim_create_user_command('W', function()
    local path = vim.api.nvim_buf_get_name(0)
    local options = {cmdarg = vim.v.cmdarg, cmdbang = vim.v.cmdbang, range = ''}
    local tempfile = vim.fn['tempname']()
    vim.cmd(string.format('%swrite%s %s %s', options.range,
                          options.cmdbang and '!' or '', options.cmdarg,
                          tempfile))
    local password = ''
    if not password_used then
        vim.fn['inputsave']()
        password = vim.fn['inputsecret'](
                       string.format('[sudo] %s password: ', os.getenv('USER')))
    end
    local result = (string.format(
                       '%ssudo -p \'\' -sS dd if=%s of=%s bs=1048576 status=none',
                       not password_used and
                           string.format('printf \'%s\\n\' | ', password) or '',
                       tempfile, path))
    password = '' -- deleting the password for security reasons
    password_used = true
    if result == 0 then vim.cmd [[redraw]] end
    vim.cmd(string.format('silent call delete(%s)', tempfile))
end, {})

----- Plugin Settings -----
--- Loading Plugins ---
local ensure_packer =
    function() -- https://github.com/wbthomason/packer.nvim#bootstrapping @Iron-E and @khuedoan
        local fn = vim.fn
        local install_path = fn.stdpath('data') ..
                                 '/site/pack/packer/start/packer.nvim'
        if fn.empty(fn.glob(install_path)) > 0 then
            fn.system({
                'git', 'clone', '--depth', '1',
                'https://github.com/wbthomason/packer.nvim', install_path
            })
            vim.cmd [[packadd packer.nvim]]
            return true
        end
        return false
    end
local packer_bootstrap = ensure_packer()
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- use 'morhetz/gruvbox'
    use 'srcery-colors/srcery-vim'
    use 'jiangmiao/auto-pairs'
    use 'preservim/nerdtree'
    use 'preservim/nerdcommenter'
    use 'lervag/vimtex'
    use {
        'iamcco/markdown-preview.nvim',
        run = function() vim.fn['mkdp#util#install']() end
    }
    use 'kylechui/nvim-surround'
    use 'godlygeek/tabular'
    use 'preservim/vim-markdown'
    use 'tpope/vim-surround'
    use 'vim-airline/vim-airline'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'neovim/nvim-lspconfig'
    use 'folke/neodev.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'MunifTanjim/prettier.nvim'
    use 'lukas-reineke/lsp-format.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'windwp/nvim-ts-autotag'
    if packer_bootstrap then require('packer').sync() end
end)
-- vim.cmd.color [[gruvbox]]
vim.cmd.color [[srcery]]

--- LaTex/VimTex ---
vim.g.tex_flavor = 'xelatex'
vim.g.vimtex_view_general_viewer = 'zathura'
vim.g.vimtex_quickfix_mode = 0
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'},
                            {pattern = '*.tex', command = 'set filetype=tex'})
--- Markdown Preview ---
-- vim.g.mkdp_auto_start = 1
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 1
vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_filetypes = 'markdown'
vim.g.mkdp_page_title = '${name}'
vim.g.mkdp_theme = 'dark'
--- NerdCommenter ---
vim.g.NERDCreateDefaultMappings = 1
vim.g.NERDSpaceDelims = 1
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDAltDelims_c = 1
vim.g.NERDAltDelims_cpp = 1
--- Lsp and Completion ---
local lspconfig = require('lspconfig')
local lspformat = require('lsp-format')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local cmp = require('cmp')
local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true),
                          mode, true)
end
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match('%s') == nil
end
lspformat.setup {}
for _, lsp in ipairs({'clangd', 'rust_analyzer', 'pyright'}) do
    lspconfig[lsp].setup {
        on_attach = lspformat.on_attach,
        capabilities = capabilities
    }
end
local configs = require('lspconfig/configs')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.emmet_ls.setup({
    -- on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
        'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss',
        'less'
    },
    init_options = {
        html = {
            options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true
            }
        }
    }
})

local null_ls = require('null-ls')
local group = vim.api.nvim_create_augroup('lsp_format_on_save', {clear = false})
local event = 'BufWritePre' -- or 'BufWritePost'
local async = event == 'BufWritePost'
null_ls.setup({
    on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
            vim.keymap.set('n', '<Leader>f', function()
                vim.lsp.buf.format({bufnr = vim.api.nvim_get_current_buf()})
            end, {buffer = bufnr, desc = '[lsp] format'})

            -- format on save
            vim.api.nvim_clear_autocmds({buffer = bufnr, group = group})
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                    vim.lsp.buf.format({bufnr = bufnr, async = async})
                end,
                desc = '[lsp] format on save'
            })
        end

        if client.supports_method('textDocument/rangeFormatting') then
            vim.keymap.set('x', '<Leader>f', function()
                vim.lsp.buf.format({bufnr = vim.api.nvim_get_current_buf()})
            end, {buffer = bufnr, desc = '[lsp] format'})
        end
    end
})
require('prettier').setup({
    bin = 'prettier',
    filetypes = {
        'css', 'graphql', 'html', 'javascript', 'javascriptreact', 'json',
        'less', 'markdown', 'scss', 'typescript', 'typescriptreact', 'yaml'
    }
})

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
    sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}},
                                 {{name = 'buffer'}})
})
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({{name = 'cmp_git'}}, {{name = 'buffer'}})
})
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = 'buffer'}}
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

--- Treesitter ---
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
        'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'help',
        'vim'
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = {enable = true},
    indent = {enable = true, disable = {'python'}},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>'
        }
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner'
            }
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer'
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer'
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer'
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer'
            }
        },
        swap = {
            enable = true,
            swap_next = {['<leader>a'] = '@parameter.inner'},
            swap_previous = {['<leader>A'] = '@parameter.inner'}
        }
    }
}
require('nvim-ts-autotag').setup()
