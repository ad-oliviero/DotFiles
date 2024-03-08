local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup
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
  autocmd("BufReadPost", {
    callback = function() vim.cmd [[exe "normal! g'\""]] end
  })
end

opt.list = true
-- opt.spl = {'it', 'en_us'}
-- opt.spell = true

--- Some plugins settings ---

vim.g.codeium_disable_bindings = true

-- KNAP
vim.g.knap_settings = {
  texoutputext = "pdf",
  textopdf = "latexmk -synctex=1 -pdf -quiet -pdflatex -interaction=batchmode -file-line-error %srcfile%",
  textopdfviewerlaunch = "zathura %outputfile%",
  textopdfviewerrefresh = "kill -HUP %pid%"
}

autocmd("FileType", {
  desc = "Start knap's autopreview for .tex files",
  pattern = "tex",
  group = autogroup('tex_autopreview', { clear = true }),
  callback = function() require("knap").toggle_autopreviewing() end
})
