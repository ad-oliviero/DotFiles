local autocmd = vim.api.nvim_create_autocmd
local opt = vim.opt

autocmd("InsertEnter",
  { callback = function() vim.cmd [[norm zz]] end })
autocmd("VimLeave", {
  callback = function() vim.opt.guicursor = 'a:ver25' end
})
autocmd("BufEnter", {
  callback = function() vim.opt.readonly = false end
})

-- open the file in the last position
if vim.fn.has('autocmd') then
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function() vim.cmd [[exe "normal! g'\""]] end
  })
end

opt.list = true
-- opt.spl = {'it', 'en_us'}
-- opt.spell = true

vim.g.codeium_disable_bindings = true
