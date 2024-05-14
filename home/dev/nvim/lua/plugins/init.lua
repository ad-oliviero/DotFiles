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

local base = {
	"nvim-lua/plenary.nvim",
}

local ui = {
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "User FilePost",
		config = function(_, opts)
			require("colorizer").setup(opts)

			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	},
}
local utils = {
	{

		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			lsp_fallback = true,
			formatters_by_ft = {
				lua = { "stylua" },
				nil_ls = { "alejandra" },
				sh = { "shfmt" },
			},
			-- format_on_save = {
			--   -- These options will be passed to conform.format()
			--   timeout_ms = 500,
			--   lsp_fallback = true,
			-- },
		},
		config = function(_, opts)
			require("conform").setup(opts)
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
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "User FilePost",
		opts = {
			indent = { char = "│", highlight = "IblChar" },
			scope = { char = "│", highlight = "IblScopeChar" },
		},
		config = function(_, opts)
			-- dofile(vim.g.base46_cache .. "blankline")

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			require("ibl").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "lua", "vim", "vimdoc" },

			highlight = {
				enable = true,
				use_languagetree = true,
			},

			indent = { enable = true },
		},
		config = function(_, opts)
			-- dofile(vim.g.base46_cache .. "syntax")
			-- dofile(vim.g.base46_cache .. "treesitter")
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- {
			-- 	"Exafunction/codeium.nvim",
			-- 	config = function()
			-- 		require("codeium").setup()
			-- 	end,
			-- },
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("luasnip").config.set_config(opts)
					-- vscode format
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = "your path!" })
					require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

					-- snipmate format
					require("luasnip.loaders.from_snipmate").load()
					require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

					-- lua format
					require("luasnip.loaders.from_lua").load()
					require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

					vim.api.nvim_create_autocmd("InsertLeave", {
						callback = function()
							if
								require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
								and not require("luasnip").session.jump_active
							then
								require("luasnip").unlink_current()
							end
						end,
					})
				end,
			},

			-- autopairing of (){}[] etc
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)

					-- setup cmp for autopairs
					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
		opts = function()
			return require("plugins.configs.cmp")
		end,
		config = function(_, opts)
			require("cmp").setup(opts)
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				line = "<leader>\\",
				block = "<leader>|",
			},
			opleader = {
				line = "<leader>\\",
				block = "<leader>|",
			},
		},
		mappings = { basic = true },
		init = function()
			vim.g.comment_maps = true
		end,
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			return require("plugins.configs.nvimtree")
		end,
		config = function(_, opts)
			-- dofile(vim.g.base46_cache .. "nvimtree")
			require("nvim-tree").setup(opts)
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "Telescope",
		opts = function()
			return require("plugins.configs.telescope")
		end,
		config = function(_, opts)
			-- dofile(vim.g.base46_cache .. "telescope")
			local telescope = require("telescope")
			telescope.setup(opts)
		end,
	},

	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		config = function(_, opts)
			-- dofile(vim.g.base46_cache .. "whichkey")
			require("which-key").setup(opts)
		end,
	},
}
local specific = {
	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "│" },
			},

			on_attach = function(bufnr)
				local function opts(desc)
					return { buffer = bufnr, desc = desc }
				end

				local gs = package.loaded.gitsigns
				local map = vim.keymap.set

				map("n", "<leader>rh", gs.reset_hunk, opts("Reset Hunk"))
				map("n", "<leader>ph", gs.preview_hunk, opts("Preview Hunk"))
				map("n", "<leader>gb", gs.blame_line, opts("Blame Line"))
			end,
		},
		config = function(_, opts)
			-- dofile(vim.g.base46_cache .. "git")
			require("gitsigns").setup(opts)
		end,
	},
	{
		"akinsho/flutter-tools.nvim",
		config = function()
			require("flutter-tools").setup()
		end,
	},
	"frabjous/knap",
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}

require("lazy").setup({
	base,
	ui,
	utils,
	specific,
	require("plugins.configs.lazy").opts,
})

require("gruvbox").setup({
  palette_overrides = {
    dark0 = "#3c3836",
    light0 = "#fbf1c7",
  },
})

--------------- additional plugin configurations ---------------
local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup
local g = vim.g

g.mkdp_command_for_global = true
g.mkdp_open_to_the_world = true

vim.cmd([[colorscheme gruvbox]])
g.codeium_disable_bindings = true

-- KNAP
g.knap_settings = {
	texoutputext = "pdf",
	textopdf = "latexmk -synctex=1 -pdf -quiet -pdflatex -interaction=batchmode -file-line-error %srcfile%",
	textopdfviewerlaunch = "zathura %outputfile%",
	textopdfviewerrefresh = "kill -HUP %pid%",
}

autocmd("FileType", {
	desc = "Start knap's autopreview for .tex files",
	pattern = "tex",
	group = autogroup("tex_autopreview", { clear = true }),
	callback = function()
		require("knap").toggle_autopreviewing()
	end,
})
