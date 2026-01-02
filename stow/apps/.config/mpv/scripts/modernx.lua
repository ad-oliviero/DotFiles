local home = os.getenv("HOME")
local script_path = home .. "/.config/mpv/ModernX/modernx.lua"

local f = io.open(script_path, "r")
if f ~= nil then
	io.close(f)
	dofile(script_path)
else
	print("Error: Could not find ModernX script at " .. script_path)
end
