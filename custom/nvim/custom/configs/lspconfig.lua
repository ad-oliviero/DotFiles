local configs = require("plugins.configs.lspconfig")
local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"
-- pacman -S clangd pyright vscode-html-languageserver vscode-css-languageserver
local servers = {"clangd", "pyright", "rust_analyzer", "lua_ls", "dartls", "html", "cssls", "eslint"}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
