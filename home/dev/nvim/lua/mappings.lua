local map = vim.keymap.set

map("n", "<A-up>", ":m .-2<CR>==", { desc = "Move line up" })
map("n", "<A-down>", ":m .+1<CR>==", { desc = "Move line down" })

map("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

map("n", "<C-h>", "<C-w>h", { desc = "Switch Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch Window up" })

map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "File Save" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- global lsp mappings
map("n", "<leader>f", function()
	-- vim.lsp.buf.format({ async = true })
	require("conform").format()
end, { desc = "Lsp formatting" })

map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Lsp prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Lsp next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "Buffer New" })

map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Buffer Goto next" })
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Buffer Goto prev" })
map("n", "<leader><tab>", "<cmd>BufferLineMoveNext<CR>", { desc = "Buffer Move next" })
map("n", "<leader><S-tab>", "<cmd>BufferLineMovePrev<CR>", { desc = "Buffer Move prev" })


map("n", "<leader>x", function()
end, { desc = "Buffer Close" })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Nvimtree Focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Help page" })

map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
-- map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Telescope Pick hidden term" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "Telescope Find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

map("n", "<leader>h", function()
	require("nvchad.term").new({ pos = "sp", size = 0.3 })
end, { desc = "Terminal New horizontal term" })

map("n", "<leader>v", function()
	require("nvchad.term").new({ pos = "vsp", size = 0.3 })
end, { desc = "Terminal New vertical term" })

map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
end, { desc = "Terminal Toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm", size = 0.2 })
end, { desc = "Terminal New horizontal term" })

map({ "n", "t" }, "<A-i>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })

map("t", "<ESC>", function()
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_close(win, true)
end, { desc = "Terminal Close term in terminal mode" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "Whichkey query lookup" })

-- blankline
map("n", "<leader>cc", function()
	local config = { scope = {} }
	config.scope.exclude = { language = {}, node_type = {} }
	config.scope.include = { node_type = {} }
	local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

	if node then
		local start_row, _, end_row, _ = node:range()
		if start_row ~= end_row then
			vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
			vim.api.nvim_feedkeys("_", "n", true)
		end
	end
end, { desc = "Blankline Jump to current context" })
