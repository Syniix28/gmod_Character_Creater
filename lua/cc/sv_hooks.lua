--------------------------
util.AddNetworkString("CC_OpenPanel")

hook.Add("PlayerInitialSpawn", "CC_OpenPanel", function(ply)
	if ( ply:HasCharacter() ) then
		timer.Simple(1, function()
			local Tbl = ply:GetCharacterData()
			ply:SetModel( Tbl.Model )
		end)
	else
		timer.Simple(1, function()
			net.Start("CC_OpenPanel")
			net.Send(ply)
		end)
	end
end)

hook.Add("Initialize", "CC_CreateDir", function()
	if ( !file.Exists("cc_data", "DATA") ) then
		file.CreateDir("cc_data")
	end
end)

hook.Add( "PlayerSay", "CC_ChatCMD", function( ply, msg, group )
	if ( !CC_Config.SetNameCommands ) then return end
    if ( !table.HasValue(CC_Config.CanUseCommand, ply:GetUserGroup()) ) then DarkRP.notify(ply, 2, 4, CC_Config.Text.NoPermission) return "" end 
    local cmd = string.Explode( " ", msg )
    if ( cmd[1] == CC_Config.CommandName || cmd[1] == CC_Config.CommandNameQuick ) then
        if ( cmd[2] && cmd[3] && cmd[4] ) then
        	if ( cmd[3] == "" ) then DarkRP.notify(ply, 1, 4, CC_Config.Text.InvalidArguments) return "" end
            local target = DarkRP.findPlayer( tostring(cmd[2]) )
            if ( target ) then
            	ply:setRPName(cmd[3].." "..cmd[4])
                return ""
            end
            return ""
        else
            DarkRP.notify(ply, 1, 4, CC_Config.Text.InvalidArguments)
            return ""
        end
    end
end)

concommand.Add("debug_cc", function(ply)
	if ( table.HasValue(CC_Config.CanUseCommand, ply:GetUserGroup()) ) then
		net.Start("CC_OpenPanel")
		net.Send(ply)
	end
end)