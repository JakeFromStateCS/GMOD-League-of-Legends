local function drawFilledCircle(x,y,radius,quality, color)
    local circle = {};
    local tmp = 0;
	local s,c;
    for i=1,quality do
        tmp = math.rad(i*360)/quality;
		s = math.sin(tmp);
		c = math.cos(tmp);
        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
    end
	surface.SetMaterial(Material("models/player/shared/ice_player"))
	surface.SetDrawColor(color)
	surface.DrawPoly(circle)
end

function renderSmartPings()
	local boxW, boxH = 300, 400
	local w, h = ScrW(), ScrH()
	local radius = 20
	
	if LocalPlayer():KeyDown(IN_WALK) then
		draw.DrawText( "dev pings", "HudFont", w/2, (h/2) + (boxH/2), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.RoundedBox( 0, (w/2) - (boxW/2) , (h/2) - (boxH/2) , boxW , boxH, Color(0, 0, 0, 155))
		
		drawFilledCircle(w/2, (h/2), radius, 10, Color(0, 0, 0, 155))
		surface.DrawCircle( w/2, (h/2), radius, Color(0, 0, 0, 155))
		
	end
	
	

end
hook.Add("HUDPaint", "renderSmartPings", renderSmartPings)