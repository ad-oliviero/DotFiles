local plugins = {
  {
    "hrsh7th/nvim-cmp",
    config = function(_, opts)
      table.insert(opts.sources, { name = "codeium" })
      require("cmp").setup(opts)
    end,
    dependencies = {
      {
        "Exafunction/codeium.nvim",
        config = function()
          require("codeium").setup({})
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
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

return plugins
