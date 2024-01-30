local M = {}

M.disabled = {
  n = {
    ["<leader>fm"] = "",
    ["<leader>/"] = ""
  },
  v = {
    ["<leader>/"] = ""
  }
}

M.general = {
  n = {
    ["<leader>f"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },
  },
}

M.comment = {
  plugin = true,

  n = {
    ["<leader>\\"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
    ["<leader>|"] = {
      function()
        require("Comment.api").toggle.blockwise.current()
      end,
      "Toggle comment",
    },
  },

  v = {
    ["<leader>\\"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
    ["<leader>|"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },

}

return M
