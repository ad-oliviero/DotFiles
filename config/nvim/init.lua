-- CONFIG_PATH = os.getenv('HOME')..'/.config/nvim/'
local modules = {'plugins', 'autocmds', 'options', 'keymaps'}

for _, m in ipairs(modules) do require(m) end
