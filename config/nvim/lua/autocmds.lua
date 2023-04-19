vim.api.nvim_create_autocmd("InsertEnter",
                            {callback = function() vim.cmd [[norm zz]] end})
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function() vim.opt.guicursor = 'a:ver25' end
})
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function() vim.opt.readonly = false end
})
local highlight_sp_cmd = {'ExtraWhitespace', 'ctermbg=red', 'guibg=red'}
vim.api.nvim_create_autocmd("Colorscheme", {
    callback = function() vim.cmd.highlight(highlight_sp_cmd) end
})
vim.cmd.highlight(highlight_sp_cmd)
vim.cmd [[match ExtraWhitespace /\s\+$/]]
if vim.fn.has('autocmd') then
    vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function() vim.cmd [[exe "normal! g'\""]] end
    })
end
vim.cmd [[
  augroup AutoFormat
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]]

vim.api.nvim_create_autocmd('VimLeave', {
    callback = function() vim.cmd [[mksession! ./.nvim-session]] end
})

function LoadSession()
    vim.cmd [[source ./.nvim-session]]
    print('Session Loaded!')
end

vim.cmd [[command! LoadSession lua LoadSession()]]
