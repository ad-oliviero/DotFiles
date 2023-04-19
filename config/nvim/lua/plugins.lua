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
ensure_packer()

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- visuals
    use 'srcery-colors/srcery-vim'
    use {
        'hoob3rt/lualine.nvim',
        requires = {'nvim-tree/nvim-web-devicons', opt = true}
    }
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    -- utils
    use 'terrortylor/nvim-comment'
    use 'kyazdani42/nvim-tree.lua'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    -- completion
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'windwp/nvim-autopairs'
    -- automation
    use 'sbdchd/neoformat'
end)

-- Plugin Settings
require('nvim_comment').setup {
    create_mappings = false,
    hook = function()
        local ft = vim.api.nvim_buf_get_option(0, 'filetype')
        if ft == 'c' or ft == 'cpp' then
            vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')
        end
    end
}
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''},
        disabled_filetypes = {statusline = {}, winbar = {}},
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {},
        lualine_b = {
            {
                'buffers',
                show_modified_status = true,
                buffers_color = {
                    active = 'lualine_b_normal',
                    inactive = 'lualine_b_inactive'
                },
                symbols = {
                    modified = ' ●',
                    alternate_file = '',
                    directory = ''
                }
            }
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
require('nvim-treesitter.configs').setup {
    ensure_installed = {'python', 'lua', 'c', 'cpp', 'rust'},
    highlight = {enable = true},
    indent = {enable = true}
}

local cmp = require 'cmp'

cmp.setup {
    snippet = {expand = function(args) vim.fn['vsnip#anonymous'](args.body) end},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert
        }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert
        }),
        ['<CR>'] = cmp.mapping.confirm({select = true})
    },
    sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}}, {
        {name = 'buffer'}, {name = 'path'}, {name = 'spell'}
    })
}
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
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.clangd.setup {capabilities = capabilities}
lspconfig.rust_analyzer.setup {capabilities = capabilities}
lspconfig.pyright.setup {capabilities = capabilities}
lspconfig.lua_ls.setup {capabilities = capabilities}

require('nvim-tree').setup()
require('nvim-autopairs').setup()
