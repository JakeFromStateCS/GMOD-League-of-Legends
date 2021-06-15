surface.CreateFont( "csKillIcons", {
	font      = "csd",
	size      = 72,
	weight    = 500,
	antialias = true
})
-- surface.CreateFont( "hl2", {
-- 	font      = "HL2MPTypeDeath",
-- 	size      = 72,
-- 	weight    = 500,
-- 	antialias = true
-- })

shop_panel = nil
function shopMenu(p, key, args)
	local ply = LocalPlayer()

	if shop_panel != nil and args[1] == "close" then
		shop_panel:Remove()
		shop_panel = nil
		return false
	end

	if args[1] == "toggle" then
		if shop_panel != nil then
			shop_panel:Remove()
			shop_panel = nil
			return false
		end
	end

	if shop_panel != nil then return false end
	if args[1] == "close" then return false end
	local DermaPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
	shop_panel = DermaPanel
	local w, h = 340, 390
	DermaPanel:SetPos( 80,80 ) -- Position on the players screen
	DermaPanel:SetSize( w + 10, h ) -- Size of the frame
	DermaPanel:SetTitle( "Moba Shop" ) -- Title of the frame
	DermaPanel:SetVisible( true )
	DermaPanel:ShowCloseButton( false ) -- Show the close button?
	DermaPanel:MakePopup() -- Show the frame
	DermaPanel:SetKeyboardInputEnabled( ) -- Show the close button?

	myButton = vgui.Create("DButton", DermaPanel)
	myButton:SetText("x")
	myButton:SetPos( w - 10, 2 )
	myButton:SetSize( 16, 16 )
	myButton.DoClick = function()
		shop_panel:Remove()
		shop_panel = nil
		shop_open = false
	end

	local PropertySheet = vgui.Create( "DPropertySheet", DermaPanel )
	PropertySheet:SetPos( 5, 28 )
	PropertySheet:SetSize( w, h - 34)


end
concommand.Add("moba_shop", shopMenu)


