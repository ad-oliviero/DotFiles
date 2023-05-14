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
    use 'ellisonleao/gruvbox.nvim'
    use {
        'hoob3rt/lualine.nvim',
        requires = {'nvim-tree/nvim-web-devicons', opt = true}
    }
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end
    }
    use {
        'folke/noice.nvim',
        requires = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"}
    }
    -- utils
    use 'terrortylor/nvim-comment'
    use 'kyazdani42/nvim-tree.lua'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'folke/which-key.nvim'
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
    use 'Exafunction/codeium.vim'
    -- automation
    use 'sbdchd/neoformat'
    -- other
    use {
        'akinsho/flutter-tools.nvim',
        requires = {'nvim-lua/plenary.nvim', 'stevearc/dressing.nvim'}
    }
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
    ensure_installed = {'python', 'lua', 'c', 'cpp', 'rust', 'dart'},
    highlight = {enable = true},
    indent = {enable = true}
}

local cmp = require('cmp')

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
lspconfig.clangd.setup {
    capabilities = capabilities,
    includeDirs = {'.', './build'}
}
lspconfig.rust_analyzer.setup {capabilities = capabilities}
lspconfig.pyright.setup {capabilities = capabilities}
lspconfig.lua_ls.setup {capabilities = capabilities}

require('nvim-tree').setup()
require('nvim-autopairs').setup()
require('flutter-tools').setup()
require('which-key').setup()
require('noice').setup {
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true
        }
        -- signature = {enabled = false}
    },
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false -- add a border to hover docs and signature help
    }
}
vim.g.codeium_disable_bindings = true
vim.keymap.set('i', '<C-space>',
               function() return vim.fn['codeium#Accept']() end, {expr = true})
vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end,
               {expr = true})
vim.g.mkdp_command_for_global = true
vim.g.mkdp_open_to_the_world = true
