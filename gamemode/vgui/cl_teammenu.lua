local SKIN = {}
SKIN.PrintName = "Black and Orange"
SKIN.Author = ""
SKIN.DermaVersion	= 1

SKIN.colOutline	= Color( 0, 0, 0, 20 )

SKIN.colPropertySheet = Color( 255, 127, 0, 255 )
SKIN.colTab	 = SKIN.colPropertySheet
SKIN.colTabText	 = Color( 0, 0, 0, 255 )
SKIN.colTabInactive	 = Color( 3, 3, 3, 200 )
SKIN.colTabShadow	 = Color( 255, 255, 255, 255 )
SKIN.fontButton	 = "Default"
SKIN.fontTab	 = "Default"
SKIN.bg_color = Color( 0, 0, 0, 180 )
SKIN.bg_color_sleep = Color( 0, 0, 0, 230 )
SKIN.bg_color_dark	 = Color( 15, 15, 15, 255 )
SKIN.bg_color_bright	 = Color( 255, 127, 0, 255 )
SKIN.listview_hover	 = Color( 200, 100, 0, 255 )
SKIN.listview_selected	 = Color( 0, 0, 0, 210 )
SKIN.control_color = Color( 200, 100, 0, 255 )
SKIN.control_color_highlight	= Color( 222, 111, 0, 255 )
SKIN.control_color_active = Color( 188, 88, 0, 225 )
SKIN.control_color_bright = Color( 0, 0, 0, 255 )
SKIN.control_color_dark = Color( 8, 8, 8, 220 )
SKIN.text_bright	 = Color( 255, 255, 255, 255 )
SKIN.text_normal	 = Color( 255, 255, 255, 255 )
SKIN.text_dark	 = Color( 255, 255, 255, 255 )
SKIN.text_highlight	 = Color( 0, 0, 0, 20 )
SKIN.colCategoryText	 = Color( 0, 155, 155, 255 )
SKIN.colCategoryTextInactive	= Color( 255, 255, 255, 255 )
SKIN.fontCategoryHeader	 = "TabLarge"
SKIN.colTextEntryTextHighlight	= Color( 0, 0, 2, 255 )
SKIN.colTextEntryTextHighlight	= Color( 0, 0, 2, 255 )
SKIN.colCategoryText	 = Color( 255, 255, 255, 255 )
SKIN.colCategoryTextInactive	= Color( 200, 200, 200, 255 )
SKIN.fontCategoryHeader	 = "TabLarge"
SKIN.tooltip	 = Color( 255, 127, 0, 255 )

// Or any of the functions

function SKIN:DrawSquaredBox( x, y, w, h, color )

surface.SetDrawColor( color )
surface.DrawRect( x, y, w, h )

surface.SetDrawColor( self.colOutline )
surface.DrawOutlinedRect( x, y, w, h )

end

function SKIN:PaintFrame( panel )

	local color = self.bg_color

	self:DrawSquaredBox( 0, 0, panel:GetWide(), panel:GetTall(), color )

	surface.SetDrawColor( 0, 0, 0, 75 )
	surface.DrawRect( 0, 0, panel:GetWide(), 21 )

	surface.SetDrawColor( self.colOutline )
	surface.DrawRect( 0, 21, panel:GetWide(), 1 )

end

derma.DefineSkin( "black_orange", "A black and orange skin", SKIN )

hook.Add("ForceDermaSkin", "Foreskin", function()
	print("FORCING DERMA SKIN")
	return "black_orange"
end)

function Menu()
	local w = 440
	local h = 208
	local padding = 4
	
	local f = vgui.Create("DFrame")
	f:SetSize( w, h)
	f:SetPos( (ScrW()/2) - (w/2), (ScrH()/2) - (h/2) )
	f:SetTitle("Select a Team")
	f:SetDraggable(false)
	f:ShowCloseButton(true)
	f:MakePopup()

	f.Think = function()
		LW.input:SetCursorPos(gui.MouseX(), gui.MouseY())
	end

	local pbtn = vgui.Create( "DButton", f )
	pbtn:SetText( "" )
	pbtn:SetPos( 25, 32 )
	pbtn:SetSize( 180, 160 )

	pbtn.Paint = function ()
		surface.SetDrawColor( team.GetColor(TEAM_PURPLE) )
		surface.DrawRect( 0, 0, pbtn:GetWide(), pbtn:GetTall() )

		surface.SetFont( "DefaultBold_28" )
		surface.SetTextColor( 255, 255, 255, 155 )
		surface.SetTextPos( 32, 32 ) 
		surface.DrawText( "Purple" )

		surface.SetFont( "HudFont" )
		surface.SetTextPos( 32, 100 ) 
		surface.DrawText( #team.GetPlayers(TEAM_PURPLE) .. " players")
	
	end

	pbtn.DoClick = function ()
	    RunConsoleCommand("lw_team", TEAM_PURPLE)
	    RunConsoleCommand("lw_hero_menu")
	    f:Close()
	end

	local bbtn = vgui.Create( "DButton",  f )
	bbtn:SetText( "" )
	bbtn:SetPos( 240, 32 )
	bbtn:SetSize( 180, 160 )
	bbtn.Paint = function ()
		surface.SetDrawColor( team.GetColor(TEAM_BLUE) )
		surface.DrawRect( 0, 0, pbtn:GetWide(), pbtn:GetTall() )

		surface.SetTextColor( 255, 255, 255, 155 )
		surface.SetTextPos( 36, 32 ) 
		surface.SetFont( "DefaultBold_28" )
		surface.DrawText( "Blue" )

		surface.SetFont( "HudFont" )
		surface.SetTextPos( 36, 100 ) 
		surface.DrawText( #team.GetPlayers(TEAM_BLUE) .. " players")

	end
	bbtn.DoClick = function ()
	    RunConsoleCommand("lw_team", TEAM_BLUE)
	    RunConsoleCommand("lw_hero_menu")
	    f:Close()
	end

end
concommand.Add("lw_team_menu", Menu)