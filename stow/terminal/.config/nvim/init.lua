function setup_optglobals()
  local o = vim.opt
  local g = vim.g
  g.mapleader = ' '
  o.mouse = "a"
  -- o.textwidth = 80
  -- o.mousescroll = "ver:10,hor:2"

  o.cindent = true            -- auto indent, c-style
  o.shiftwidth = 2            -- tab size stuff
  o.smarttab = true           -- tab size stuff
  o.softtabstop = 2           -- tab size stuff

  g.loaded_netrw = 1          -- nvim-tree stuff
  g.loaded_netrwPlugin = 1    -- nvim-tree stuff

  o.clipboard = 'unnamedplus' -- copy to system clipboard
  o.spell = true
  o.spl = { 'it', 'en_us' }   -- set spelling languages
  o.undofile = true
  o.updatetime = 250          -- hover update time
  -- o.whichwrap:append('<>[]hl') -- go to next line with arrows or h or l
  vim.diagnostic.config({
    virtual_text = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
    update_in_insert = false,
    severity_sort = true,
  })
  if not vim.g.vscode then                       -- yes, for some things I still "need" vscode
    o.number = true                              -- show line numbers
    -- o.shortmess:append('sI')                  -- disable nvim default initial page
    o.signcolumn = 'yes'                         -- default space for small error and warning messages
    o.winborder = 'single'                       -- set border for all windows
    vim.cmd.set 'completeopt+=noselect,noinsert' -- don't auto { select the first option, insert whatever is selected }
    o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  end
  g.vimtex_view_method = "sioyek"
end

function addplugin(url, name, cfg)
  vim.pack.add({ url })
  if cfg ~= nil then
    if name == nil or string.len(name) == 0 then
      error('\'name\' should not be null or empty!')
    end
    require(name).setup(cfg)
  end
end

function setup_plugins()
  addplugin('https://github.com/windwp/nvim-autopairs', 'nvim-autopairs', {})
  addplugin('https://github.com/ibhagwan/fzf-lua')
  addplugin('https://github.com/folke/which-key.nvim')
  addplugin('https://github.com/lervag/vimtex')
  addplugin('https://github.com/neovim/nvim-lspconfig')
  addplugin('https://github.com/wakatime/vim-wakatime')
  addplugin('https://github.com/MunifTanjim/nui.nvim')

  addplugin('https://github.com/kylechui/nvim-surround', 'nvim-surround', {
    keymaps = {
      visual = 's',
      visual_line = 'S',
      delete = 'sd',
      change = 'sr',
    },
    aliases = {
      ['i'] = ']', -- Index
      ['r'] = ')', -- Round
      ['b'] = '}', -- Brackets
    },
    move_cursor = false,
  })
  if not vim.g.vscode then
    -- addplugin('https://github.com/echasnovski/mini.pick', 'mini.pick', {})
    addplugin('https://github.com/sphamba/smear-cursor.nvim', 'smear_cursor', {})
    addplugin('https://github.com/wojciech-kulik/xcodebuild.nvim', 'xcodebuild', {})
    addplugin('https://github.com/MeanderingProgrammer/render-markdown.nvim', 'render-markdown', {})
    addplugin('https://github.com/rmagatti/auto-session', 'auto-session', {})
    addplugin('https://github.com/akinsho/bufferline.nvim', 'bufferline', {})

    addplugin('https://github.com/Shatur/neovim-ayu')
    require 'ayu'.colorscheme()
    addplugin('https://github.com/ellisonleao/gruvbox.nvim', 'gruvbox', { transparent_mode = true })
    addplugin('https://github.com/karb94/neoscroll.nvim', 'neoscroll', { performance_mode = true })

    addplugin('https://github.com/nvim-tree/nvim-tree.lua', 'nvim-tree', {
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })
    addplugin('https://github.com/stevearc/conform.nvim', 'conform', {
      formatters_by_ft = {
        css = { 'prettier' },
        html = { 'prettier' },
        nix = { 'alejandra' },
        python = { 'isort', 'black' },
        swift = { 'swift-format' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
      },
      format_on_save = {
        timeout_ms = 300,
        lsp_format = "fallback",
      },
    })
    addplugin({ src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('1.*') }, 'blink.cmp',
      { keymap = { preset = 'enter' } })

    addplugin('https://github.com/mason-org/mason.nvim', 'mason', {})
    local servers = {
      'lua_ls',
      'pyright',
      'rust_analyzer',
      'texlab',
      -- 'denols',
    }
    -- some lang servers are not available for arm, they must be installed manually
    if not (vim.fn.systemlist('uname -m')[1] == 'aarch64' or vim.fn.systemlist('uname -m')[1] == 'arm64') then
      vim.list_extend(servers, {
        'clangd',
        'hyprls',
        'qmlls',
      })
    else
      vim.lsp.enable({
        'clangd',
        'hyprls',
        'qmlls',
      })
    end
    addplugin('https://github.com/mason-org/mason-lspconfig.nvim', 'mason-lspconfig', { ensure_installed = servers })
    -- mason-lspconfig does not let me to set ensure_installed formatters
    local registry = require('mason-registry')
    for _, pkg_name in ipairs { 'isort', 'black', 'prettier' } do
      local ok, pkg = pcall(registry.get_package, pkg_name)
      if ok then
        if not pkg:is_installed() then
          pkg:install()
        end
      end
    end
    addplugin('https://github.com/numToStr/Comment.nvim', 'Comment', {
      toggler = {
        line = '<leader>\\',
        block = '<leader>|',
      },
      opleader = {
        line = '<leader>\\',
        block = '<leader>|',
      },
      mappings = { extra = false }
    })
  end
end

function setup_mappings()
  local map = vim.keymap.set
  map('n', '<leader>so', ':update<CR> :source<CR>', { desc = 'Reload the config' })
  map('n', '<C-,>', ':e $MYVIMRC<CR>', { desc = 'Open config to edit' })
  map('n', '<leader>h', ':FzfLua helptags<CR>', { desc = 'Help fzf menu' })
  -- opened file navigation
  map('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
  map('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer' })
  map('n', '<leader>x', ':bdelete<CR>', { desc = 'Delete Buffer' })
  map('n', '<leader>b', ':FzfLua buffers<CR>', { desc = 'Buffers fzf menu' })
  map('n', '<leader>ff', ':FzfLua files<CR>', { desc = 'Files fzf menu' })
  map('n', '<leader>wk', ':WhichKey<CR>', { desc = 'Show WhichKey' })

  -- move lines like in vscode
  map('n', '<A-up>', ':m .-2<CR>==', { desc = 'Move line up' })
  map('n', '<A-down>', ':m .+1<CR>==', { desc = 'Move line down' })
  map('v', '<A-down>', ':m \'>+1<CR>gv=gv', { desc = 'Move line down' })
  map('v', '<A-up>', ':m \'<-2<CR>gv=gv', { desc = 'Move line up' })

  map('n', '<C-S>', ':w<CR>', { desc = 'Write to File' }) -- yes, i don't care

  -- diagnostics
  map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

  -- dev
  if not vim.g.vscode then
    -- map('n', '<leader>lf', require 'conform'.format, { desc = 'Format file' })
    map('n', '<leader>r', function()
      vim.cmd('w')
      vim.cmd('make')
    end, { desc = 'Call make' })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'python',
      callback = function()
        vim.o.makeprg = 'python3 %';
      end,
    })
    map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Invoke LSP code action' })
  end
end

function setup_automation()
  local autocmd = vim.api.nvim_create_autocmd
  if vim.fn.has('autocmd') then -- open file in the last position
    autocmd('BufReadPost', {
      callback = function()
        vim.cmd [[normal! g`']]
        vim.schedule(function() -- center the line as soon as it is possible
          vim.cmd([[normal! zz]])
        end)
      end,
    })
  end
  vim.filetype.add({ -- *.conf files in the hypr directory are of hyprlang type
    pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
  })
  autocmd('CursorHold', { -- automatically show diagnostic on hover
    callback = function()
      local opts = {
        focusable = false,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })

  vim.opt.updatetime = 250
end

setup_optglobals()
setup_plugins()
setup_mappings()
setup_automation()
