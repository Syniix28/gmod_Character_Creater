util.AddNetworkString("CC_NewCharacter")
util.AddNetworkString("CC_Error")
util.AddNetworkString("CC_CreationSuccessfull")

local meta = FindMetaTable("Player")
function meta:CreateCharacter(Name, Sex, Model)
	if ( !Name or !Sex or !Model or game.SinglePlayer() ) then return end
	local path = "cc_data/"..self:SteamID64()..".txt"
	if ( file.Exists("cc_data", "DATA") ) then
		local Tbl = {}
		Tbl.Name = Name
		Tbl.Sex = Sex
		Tbl.Model = Model

		file.Write(path, util.TableToJSON(Tbl))
	end
end

function meta:DeleteCharacter()
	local path = "cc_data/"..self:SteamID64()..".txt"
	if ( file.Exists(path, "DATA") ) then
		file.Delete(path)
	end
end

net.Receive("CC_NewCharacter", function(len, ply)
	local Tbl = net.ReadTable()
	if ( !Tbl.Name or !Tbl.Sex or !Tbl.Model ) then return end
	if ( Tbl.Sex == CC_Config.Sex.Male ) then
		for k, v in pairs(CC_Config.MaleModels) do
			if ( v == Tbl.Model ) then
				DarkRP.storeRPName(ply, Tbl.Name)

				ply:CreateCharacter(Tbl.Name, Tbl.Sex, Tbl.Model)
				ply:SetModel(Tbl.Model)

				net.Start("CC_CreationSuccessfull")
				net.Send(ply)
				DarkRP.notify(ply, 0, 3, CC_Config.Text.CreationSuccess)
			end
		end
	elseif ( Tbl.Sex == CC_Config.Sex.Female ) then
		for k, v in pairs(CC_Config.FemaleModels) do
			if ( v == Tbl.Model ) then
				DarkRP.storeRPName(ply, Tbl.Name)

				ply:CreateCharacter(Tbl.Name, Tbl.Sex, Tbl.Model)
				ply:SetModel(Tbl.Model)

				net.Start("CC_CreationSuccessfull")
				net.Send(ply)
				DarkRP.notify(ply, 0, 3, CC_Config.Text.CreationSuccess)
			end
		end
	end
end)

net.Receive("CC_Error", function(len, ply)
	local Error = net.ReadString()
	if ( Error == "Name" ) then
		DarkRP.notify(ply, 1, 3, CC_Config.Text.ErrorName)
	elseif( Error == "Sex" ) then
		DarkRP.notify(ply, 1, 3, CC_Config.Text.ErrorSex)
	end
end)
