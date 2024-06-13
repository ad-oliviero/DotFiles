local map = vim.keymap.set
local lspconfig = require("lspconfig")
local servers = { "clangd", "pyright", "rust_analyzer", "lua_ls", "dartls", "html", "cssls", "eslint", "nil_ls" }
local capabilities = vim.lsp.protocol.make_client_capabilities()
local on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = desc }
	end

	map("n", "gD", vim.lsp.buf.declaration, opts("Lsp Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Lsp Go to definition"))
	map("n", "K", vim.lsp.buf.hover, opts("Lsp hover information"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Lsp Go to implementation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Lsp Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Lsp Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Lsp Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("Lsp List workspace folders"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Lsp Go to type definition"))

	map("n", "<leader>ra", function()
		require("nvchad.renamer")()
	end, opts("Lsp NvRenamer"))

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Lsp Code action"))
	map("n", "gr", vim.lsp.buf.references, opts("Lsp Show references"))
end

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

require("conform").setup(options)

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
