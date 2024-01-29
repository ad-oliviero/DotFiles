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
}

return plugins
