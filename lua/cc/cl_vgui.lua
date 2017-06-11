surface.CreateFont( "CC_Title", {
	font = "Arial",
	size = 23,
	weight = 1500,
} )

surface.CreateFont( "CC_Text", {
	font = "Arial",
	size = 23,
	weight = 1500,
} )

surface.CreateFont( "CC_ConfirmButton", {
	font = "Arial",
	size = 25.5,
	weight = 1500,
} )

surface.CreateFont( "CC_TextEntry", {
	font = "Arial",
	size = 20,
	weight = 1000,
} )

local blur = Material("pp/blurscreen")
local function DrawBlur(panel)
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor(255, 255, 255, 200)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * 5)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end

local bw, bh = 800, 500
net.Receive("CC_OpenPanel", function(len, ply)
	if ( LocalPlayer():HasCharacter() ) then return end
	local Base = vgui.Create("DFrame")
	Base:SetSize(bw,bh)
	Base:Center()
	Base:SetTitle("")
	Base:ShowCloseButton(true)
	Base:SetDraggable(true)
	Base.Paint = function(self, w, h)
		DrawBlur(self)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(0,161,255,255)
		surface.DrawRect(0,0,w,25)

		surface.DrawRect(25,25+37.5,w-275-50,25)
		surface.DrawRect(25,25+37.5+70,w-275-50,25)
		surface.DrawRect(25,25+37.5+140,w-275-50,25)

		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(0,23,w,2)
		surface.DrawRect(25,48+37.5,w-275-50,2)
		surface.DrawRect(25,48+37.5+70,w-275-50,2)
		surface.DrawRect(25,48+37.5+140,w-275-50,2)

		draw.SimpleText(CC_Config.Text.MenuTitle,"CC_Title",5,1,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		draw.SimpleText(CC_Config.Text.NameTitle,"CC_Text",30,25+38.5,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		draw.SimpleText(CC_Config.Text.SexTitle,"CC_Text",30,25+37.5+71,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		draw.SimpleText(CC_Config.Text.ModelTitle,"CC_Text",30,25+37.5+141,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	end
	Base:MakePopup()

	local PPanelModels = vgui.Create("DPanel", Base)
	PPanelModels:SetPos(25, 25+37.5+170)
	PPanelModels:SetSize(bw-275-50, 25+37.5+175-40)

	local Scroll = vgui.Create( "DScrollPanel", PPanelModels )
	Scroll:SetSize( bw-275-50, 25+37.5+175-40 )
	Scroll:SetPos( 0, 0 )

	local List	= vgui.Create( "DIconLayout", Scroll )
	List:SetSize( bw-275-50, 25+37.5+175-40 )
	List:SetPos( 0, 0 )
	List:SetSpaceY( 0 )
	List:SetSpaceX( 0 )

	local PModel = vgui.Create("DPanel", Base)
	PModel:SetPos( bw-275, 25+37.5 )
	PModel:SetSize( 250, 400 )
	PModel.Paint = function(self, w, h)
		surface.SetDrawColor(0,0,0,210)
		surface.DrawRect(0,0,w,h)
	end

	local MModel = vgui.Create("DModelPanel", PModel)
	MModel:SetSize(250, 400)
	MModel:SetModel(LocalPlayer():GetModel())
	MModel:SetFOV(45)
	local pnl = baseclass.Get("DModelPanel")
	MModel.Paint = function(self,w,h)
	 	surface.SetDrawColor(0,0,0,10)
 		surface.DrawRect( 0, 0, w, h )

 		surface.SetDrawColor(255,255,255,255)
 		surface.DrawRect(0,0,w,2)
 		surface.DrawRect(0,h-2,w,2)

 		surface.DrawRect(0,0,2,h)
 		surface.DrawRect(w-2,0,2,h)

	 	pnl.Paint(self, w, h)
	end
	function MModel:LayoutEntity( Entity ) return end

	local PName = vgui.Create("DTextEntry", Base)
	PName:SetPos(25, 25+37.5+30)
	PName:SetSize(bw-275-50, 35)
	PName:SetFont("CC_TextEntry")
	PName:SetText("")

	local PSex = vgui.Create("DComboBox", Base)
	PSex:SetPos(25, 25+37.5+100)
	PSex:SetSize(bw-275-50, 35)
	PSex:SetFont("CC_TextEntry")
	PSex:SetValue(CC_Config.Sex.Sex)
	PSex:AddChoice(CC_Config.Sex.Male)
	PSex:AddChoice(CC_Config.Sex.Female)
	PSex.OnSelect = function( panel, index, value, data )
		if index == 1 then
			List:Clear(true)
			MModel:SetModel( CC_Config.MaleModels[1] )
			for k,v in pairs(CC_Config.MaleModels) do
				local modelicon = List:Add( "SpawnIcon")
				modelicon:SetModel( v )
				modelicon:SetTooltip(false)
				modelicon.OnMousePressed = function()
					MModel:SetModel( v )
				end
			end
		elseif index == 2 then
			List:Clear(true)
			MModel:SetModel( CC_Config.FemaleModels[1] )
			for k,v in pairs(CC_Config.FemaleModels) do
				local modelicon = List:Add( "SpawnIcon")
				modelicon:SetModel( v )
				modelicon:SetTooltip(false)
				modelicon.OnMousePressed = function()
					MModel:SetModel( v )
				end
			end
		end
	end
	
	local DCreateCharacterButton = vgui.Create("DButton", Base)
	DCreateCharacterButton:SetPos(25,25+37.5+175+157.5+40)
	DCreateCharacterButton:SetSize(bw-275-50,30-2.5)
	DCreateCharacterButton:SetText("")
	DCreateCharacterButton.Paint = function(self, w, h)
		if ( DCreateCharacterButton:IsHovered() ) then
			surface.SetDrawColor(0,150,31,255)
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor(255,255,255,255)
			surface.DrawRect(0,h-2,w,2)

			draw.SimpleText(CC_Config.Text.CreateButton,"CC_ConfirmButton",w/2,1,Color(255,255,255,255),TEXT_ALIGN_CENTER)
		else
			surface.SetDrawColor(0,127,31,255)
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor(255,255,255,255)
			surface.DrawRect(0,h-2,w,2)

			draw.SimpleText(CC_Config.Text.CreateButton,"CC_ConfirmButton",w/2,1,Color(255,255,255,255),TEXT_ALIGN_CENTER)
		end
	end

	local delay = 0
	DCreateCharacterButton.DoClick = function()
		if CurTime() < delay then return end
		if ( PName:GetValue() == "" ) then net.Start("CC_Error") net.WriteString("Name") net.SendToServer() return end
		if ( !PSex:GetSelected() ) then net.Start("CC_Error") net.WriteString("Sex") net.SendToServer() return end
		if ( !MModel:GetModel() ) then return end

		local Tbl = {}
		Tbl.Name = PName:GetValue()
		Tbl.Sex = PSex:GetSelected()
		Tbl.Model = MModel:GetModel()

		net.Start("CC_NewCharacter")
		net.WriteTable(Tbl)
		net.SendToServer()

		delay = CurTime() + 1
	end

	net.Receive("CC_CreationSuccessfull", function(len, ply)
		Base:Remove()
	end)
end)	