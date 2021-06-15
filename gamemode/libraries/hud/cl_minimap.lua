--minimap
local mapMins = Vector(-1536, -1536, 1)
local mapMaxs = Vector(1536, 1536, 1)
local overlayMat = Material("lw/map/boss_overlay.png")
function renderMinimap()
	local w,h = 300, 300
	local sW,sH = ScrW(), ScrH()
	local padding = 5
	local pos = {
		x = sW - w - padding,
		y = sH - h - padding
	}

	draw.RoundedBox(4, pos.x - 5, pos.y - 5, w + 10, h + 10, Color(0, 0, 0, 200))
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(overlayMat)
	surface.DrawTexturedRect(pos.x, pos.y, w, h)

	local mx, my = LW.input:GetCursorPos()
	if (mx > pos.x && my > pos.y) then
		LW.input.minimap = Vector(mapMaxs.y + (pos.y - my) * 10, mapMaxs.x + (pos.x - mx) * 10) -- reverse
	else
		LW.input.minimap = nil
	end

	local players = player.GetAll()
	for i, ply in ipairs(players) do
		local col = ply == client and Color(0, 255, 0) or Color(255, 0, 0)
		local vdiff = client:GetPos() - ply:GetPos()

		local scale = 10

		local clientPos = ply:GetPos()
		local posx = mapMaxs.y - clientPos.y
		local posy = mapMaxs.x - clientPos.x

		local circleSize = 24
		local circleCenter = circleSize / 2
		draw.RoundedBox(14, pos.x + (posx / scale) - circleCenter, pos.y + (posy / scale) - circleCenter,
			circleSize, circleSize, col)
	end

end