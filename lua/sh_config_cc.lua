CC_Config = {}
CC = {}	

CC_Config.Text = {
	MenuTitle = "Character Creater",
	NameTitle = "Full Name",
	SexTitle = "Sex",
	ModelTitle = "Model",

	CreateButton = "Create Character",

	CreationSuccess = "Your Character has been Successfully created!",
	ErrorName = "ERROR: No Name has been written!",
	ErrorSex = "ERROR: No Sex has been selected!",

	InvalidArguments = "[CC] Invalid Arguments",
	NoPermission = "[CC] You Dont have the Permissions to use this Command!",
}

CC_Config.Sex = {
	Sex = "Sex",
	Male = "Male",
	Female = "Female",
}

CC_Config.CanUseCommand = {
	"superadmin",
	"admin"
}

CC_Config.MaleModels = {
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl",
	"models/player/group02/male_02.mdl",
	"models/player/group02/male_04.mdl",
	"models/player/group02/male_06.mdl",
	"models/player/group02/male_08.mdl",
}

CC_Config.FemaleModels = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl",
}

CC_Config.SetNameCommands = true
CC_Config.CommandName = "!setName"
CC_Config.CommandNameQuick = "!sn"

CC_Config.DisableNameChangeCommands = true


/* 

	Ignore this

*/



local meta = FindMetaTable("Player")
function meta:HasCharacter()
	local path = "cc_data/"..self:SteamID64()..".txt"
	if ( file.Exists(path, "DATA") ) then
		return true
	else
		return false
	end
end

function meta:GetCharacterData()
	local path = "cc_data/"..self:SteamID64()..".txt"
	if ( !file.Exists(path, "DATA") ) then return end

	local Tbl = {}
	Tbl = util.JSONToTable(file.Read(path, "DATA"))
	return Tbl
end

hook.Add("DarkRPFinishedLoading", "CC_removeCommands", function()
	if ( CC_Config.DisableNameChangeCommands ) then
		DarkRP.removeChatCommand("name")
		DarkRP.removeChatCommand("rpname")
	end
end)