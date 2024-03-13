local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ui = {

}
local utils = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },
"folke/which-key.nvim",
    "hrsh7th/nvim-cmp",
    {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          visual = "s",
          visual_line = "S",
          delete = "sd",
          change = "sr",
        },
        aliases = {
          ["i"] = "]", -- Index
          ["r"] = ")", -- Round
          ["b"] = "}", -- Brackets
        },
        move_cursor = false,
      })
    end,
  },

}
local langs = {

}

require("lazy").setup{
ui,utils,langs,
  require("plugins.configs.lazy").opts,
}
