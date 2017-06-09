if ( SERVER ) then
	AddCSLuaFile("sh_config_cc.lua")
	AddCSLuaFile("cc/cl_vgui.lua")

	include("sh_config_cc.lua")
	include("cc/sv_cc.lua")
	include("cc/sv_hooks.lua")
end

if ( CLIENT ) then
	include("sh_config_cc.lua")
	include("cc/cl_vgui.lua")
end