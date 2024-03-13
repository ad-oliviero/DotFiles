local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup

autocmd("InsertEnter", {
	callback = function()
		vim.cmd([[norm zz]])
	end,
})
autocmd("VimLeave", {
	callback = function()
		vim.opt.guicursor = "a:ver25"
	end,
})
autocmd("BufEnter", {
	callback = function()
		vim.opt.readonly = false
	end,
})

-- open the file in the last position
if vim.fn.has("autocmd") then
	autocmd("BufReadPost", {
		callback = function()
			vim.cmd([[exe "normal! g'\""]])
		end,
	})
end

-- autocmd("FileType", {
--   desc = "Start knap's autopreview for .tex files",
--   pattern = "tex",
--   group = autogroup('tex_autopreview', { clear = true }),
--   callback = function() require("knap").toggle_autopreviewing() end
-- })
