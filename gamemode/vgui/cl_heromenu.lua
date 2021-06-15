function shopMenu(p, key, args)
	local DermaPanel = vgui.Create( "DFrame" )

	local w, h = 656, 380
	DermaPanel:SetPos(80,80)
	DermaPanel:SetSize(w + 10, h)
	DermaPanel:SetTitle("Choose a hero")
	DermaPanel:SetVisible(true)
	DermaPanel:ShowCloseButton(false)
	DermaPanel:MakePopup()
	DermaPanel:Center()
	DermaPanel:SetKeyboardInputEnabled() -- Show the close button?

	myButton = vgui.Create("DButton", DermaPanel)
	myButton:SetText("x")
	myButton:SetPos( w - 10, 2 )
	myButton:SetSize( 16, 16 )
	myButton.DoClick = function()
		DermaPanel:Remove()
	end
	
	local hs = {
		test1 = "lol",
		test2 = "lol",
		test3 = "lol",
		test4 = "lol",
		test5 = "lol",
		test6 = "lol",
		test7 = "lol",
		test8 = "lol",
		test9 = "lol",
		test0 = "lol",
		test20 = "lol",
		tes5t30 = "lol",
		test320 = "lol",
		test230 = "lol",
		test330 = "lol",
		tes24t30 = "lol",
		tes2tw30 = "lol",
		tes2t30 = "lol",
		te4st330 = "lol",
		test430 = "lol",
		tes2t11 = "lol"
	}

	local heros = hero_manager.getHeros()

	local pmenu = vgui.Create("DModelSelect", DermaPanel )
	pmenu:SetSize(w, h - 32)
	pmenu:SetPos(8, 26)
	pmenu:SetSpacing(5)
	pmenu:EnableHorizontal( true )
	pmenu:EnableVerticalScrollbar(false)
	pmenu:SetPadding(4)

	pmenu.Paint = function() end
	
	local iconW, iconH = 124, 64 
	for k, item in pairs(heros) do 
			
		local dbutton = vgui.Create("DButton", pmenu)
		local dW, dH = 74, 74
		dbutton:SetSize(iconW, iconH)
		dbutton:SetText("") 
		dbutton.Paint = function()
  
			surface.SetDrawColor(Color(41, 140, 206, 255))
			surface.DrawRect(0, 0, iconW, iconH)	

			draw.DrawText(k, "DefaultBold_24", 12, 36, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		end

		dbutton:SetTooltip(k)
		dbutton.DoClick = function()
			RunConsoleCommand("lw_set_hero", k)
			DermaPanel:Remove()
		end
		pmenu:AddItem(dbutton)
		
	end

end
concommand.Add("lw_hero_menu", shopMenu)
