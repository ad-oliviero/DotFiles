local modules = {'options', 'plugins', 'keymaps', 'autocmds'}
if _G.reloading then
    for _, m in ipairs(modules) do package.loaded[m] = nil end
    _G.reloading = false
end
for _, m in ipairs(modules) do require(m) end
