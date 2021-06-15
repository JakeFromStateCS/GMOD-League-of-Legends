surface.CreateFont("HudFont", {
	font = "Arial Bold",
	size = 32,
	weight = 100,	
	blursize = 0,
	shadow = true,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont("SpellFont", {
	font = "Arial Bold",
	size = 18,
	weight = 100,	
	blursize = 0,
	shadow = true,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont("HealthBarFont", {
	font = "Arial Bold",
	size = 24,
	weight = 100,	
	blursize = 0,
	shadow = true,
	scanlines = 0,
	antialias = true
} )

for i = 10, 40 do
	surface.CreateFont("DefaultBold_" .. i, {font = "Tahoma", size = i, weight = 600,	antialias = true})
end

local disables = {
	"CHudHealth",
	"CHudBattery",
	"CHudCrosshair",
	"CHudWeaponSelection",
	"CHudDamageIndicator"
}
function GM:HUDShouldDraw(name)
    return !table.HasValue(disables, name)
end

function GM:HUDDrawTargetID()
end



-- This is very shit performance...
local matHand1 = Material("lw/cursors/hand1.png", "smooth")
local matAttack = Material("lw/cursors/hoverenemy.png", "smooth")
function hudPaint()
	drawTraceDebug()
	local scW = ScrW()
	local scH = ScrH()
	local ply = LocalPlayer()

	if ply:GetClassID() > 0 then
		renderAbilityBar(scW, scH)
		renderManaAndHP(scW, scH)
		renderHero(ply, scW, scH)
		renderDebug(scW, scH)
	end

	for _,v in next, player.GetAll() do
		local newDraw = util.Get2DPos( v ) --turned this into a util method
		if v:Alive() and IsValid(v) then
			drawPlayerBar(v, newDraw.x , newDraw.y, 255)
		end		
	end	

	for _,v in ipairs(ents.FindByClass("base_mob")) do
		local min,max = v:WorldSpaceAABB()
		local dis = (ply:GetShootPos() - v:GetPos()):Length()
		local vec = (v:GetPos() + Vector(0, 0, 26)):ToScreen()		
		if v:Alive() then
			drawMobHealthBar(v, vec.x , vec.y - 32)
		end		
	end

	for _,v in ipairs(ents.FindByClass("base_lw_tower")) do
		local vec = (v:GetPos()):ToScreen()	
		v:DrawHealthBar(vec.x, vec.y)
	end

	renderMinimap()

	local pos = util.ScreenToVector().HitPos
	local hit = util.FindInSphere2D(pos, 50, client)[1]
	-- local tr = client:GetEyeTrace()
	-- local hit = tr.Entity

	local isEnemy = hit && client:Team() != hit:Team() && hit:Alive() || false
	
	local cursorPos = LW.input.cursorPos
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(isEnemy && matAttack || matHand1)
	surface.DrawTexturedRect(cursorPos.x - 8, cursorPos.y - 8, 48, 48)
end
hook.Add("HUDPaint", "renderAbilities", hudPaint)


function drawTraceDebug()
	local maxRange = 150;
	local pos = LocalPlayer():GetPos();
	local scrPos = pos:ToScreen();
	local hitPos = util.ScreenToVector().HitPos;
	local normal = ( hitPos - pos ):GetNormal();
	local dist = hitPos:Distance( pos );
	local range = math.Min( dist, maxRange );
	local jumpPos = Vector( 0, 0, 0 );--util.GetJumpPos( LocalPlayer(), normal, range, maxRange );
	local scrHit = jumpPos:ToScreen();
	local ang = util.ScreenToAimAngle2D();

	surface.SetDrawColor( Color( 0, 0, 255 ) );
	surface.DrawLine(
		scrPos.x,
		scrPos.y,
		scrHit.x,
		scrHit.y
	);
end;

function renderDebug(sW, sH)
	local w,h = 260, 150
	local x,y = 8, (sH - h) - 42
	draw.RoundedBox(0, x - 2, y - 2, w, h, Color(55, 55, 55, 155))
	draw.DrawText("Dev Info", "DefaultBold_30", x + 4, y, Color(0, 255, 25), TEXT_ALIGN_LEFT)

	draw.DrawText("STATE: " .. client:GetState(), "DefaultBold_22", x + 4, y + 32 , Color(255, 255, 255), TEXT_ALIGN_LEFT)
	draw.DrawText("wp: " .. tostring(client:GetWaypoint()), "DefaultBold_22", x + 4, y + 58 , Color(255, 255, 255), TEXT_ALIGN_LEFT)
	draw.DrawText("Target: " .. tostring(client._target), "DefaultBold_22", x + 4, y + 84 , Color(255, 255, 255), TEXT_ALIGN_LEFT)
	draw.DrawText("Team: " .. tostring(client:Team()), "DefaultBold_22", x + 4, y + 114 , Color(255, 255, 255), TEXT_ALIGN_LEFT)
end

function renderHero(ply, w, h)
	
	local barW, barH, hero = 200, 30, ply:GetNWString("hero") 
	surface.SetFont("HudFont")
	local tw,th = surface.GetTextSize(hero)	
	barW = tw + 8
	draw.RoundedBox(0, 0, h - barH, barW, barH, Color(55, 55, 55, 155))
	
	draw.SimpleText(hero , "HudFont", (tw/2) + 4, h - barH + 16 , Color(255,255,255), 1, 1)
end


function drawMobHealthBar(p, XOff, YOff)
	local w, h = 100, 14
	local x, y = XOff - ( w/2 ), YOff

	local health = p:Health()
	local MaxHP = p:GetMaxHealth()
	local bgcol = Color(55, 55, 55, 155)


	surface.SetDrawColor(bgcol)
	surface.DrawRect(x + 2,	y + 2, w - 4, h - 4)

	surface.SetDrawColor(Color(211, 69, 0, 255))
	surface.DrawRect(x + 4,	y + 4, health / MaxHP * w - 8, h - 8)

end

function drawPlayerBar(p, XOff, YOff)
	local ply = LocalPlayer()
	if not p then return end
	if not p or not p:IsValid() or not p:IsPlayer() then return end
	
	surface.SetFont("HealthBarFont")
	local tw,th = surface.GetTextSize(p:Nick())	

	local champ = p:GetChampion()
	local baseMana = champ.BaseStats.Mana.Base
	local baseHealth = champ.BaseStats.Health.Base

	local mana = math.Clamp(p:GetNWInt("mana"), 0, baseMana)
	local w, h = 100, 8

	local x, y = XOff - (w/2), YOff + 12
	
	local bgcol = Color(155,155,255,alpha)

	local col = Color(50,50,50,alpha)

	--mana bar over head
	draw.RoundedBox( 0, x , y, w , h, col) -- background box	
	draw.RoundedBox( 0, x + 2, y + 1 , (mana/baseMana*w-4), h-3, bgcol)

	--health bar over head
	local str = p:Nick()
	local tw,th = surface.GetTextSize( str )	
	local health = math.Clamp( p:Health(), 0, baseHealth )
	local MaxHP = math.max( health, baseHealth )
	
	local w, h = 100, 14
	local x, y = XOff - ( w/2 ), YOff
	
	local tCol = client:Team() == p:Team() and team.GetColor(client:Team()) or Color(211, 112, 112)
	local bgcol = Color( tCol.r, tCol.g, tCol.b )
	local col = Color( 50, 50, 50 )
	local hbW = ( health / MaxHP * w-4 )
	
	surface.SetDrawColor(col)
	surface.DrawRect(x,	y, w, h)

	if( health != p.smoothHP && p.smoothHP && !p.HealthDropping ) then
		p.HealthDropping = true
	elseif( p.HealthDropping && p.smoothHP <= health ) then
		p.HealthDropping = false
	end
	
	if( p.HealthDropping ) then
		p.smoothHP = math.Approach( p.smoothHP, health, 200 * FrameTime() )
		hbW = ( p.smoothHP / MaxHP * w-4 )
	end
	
	if( !p.smoothHP || !p.HealthDropping ) then
		p.smoothHP = health
	end

	surface.SetDrawColor( Color( 211, 69, 0, 255 ) )
	surface.DrawRect(x + 2,	y + 2, p.smoothHP / MaxHP * w - 4, h - 4)
	surface.SetDrawColor( bgcol )
	surface.DrawRect(x + 2,	y + 2, health / MaxHP * w - 4, h - 4)

	local lineAmt = 0.0055 * MaxHP
	for i=1, lineAmt do
		local x2 = i * ( w/lineAmt )
		local xPos = x + x2
		local y1 = y + 2
		local y2 = y1 + h - 4
		surface.SetDrawColor( Color( 55, 55, 55, 155 ) )
		surface.DrawLine( xPos, y1, xPos, y2 )
	end

	draw.SimpleText(str, "HealthBarFont", x + w/2, y + h/2 - 22, Color( 255, 255, 255), 1, 1)
end

function renderManaAndHP(w, h) 
	local barW, barH, offY = 220, 22, 96
	local halfbarW = barW / 2
	local halfW = w / 2

	local champ = client:GetChampion()
	local baseHealth = champ.BaseStats.Health.Base --wtf why no p:GetB

	local baseMana = champ.BaseStats.Mana.Base
	local yPos = h - barH - offY

	surface.SetDrawColor( Color( 0, 0, 0, 155 ) )
	surface.DrawRect(
		halfW - halfbarW,
		yPos,
		barW,
		barH
	)
	
	local hp = ( client:Health() / baseHealth ) * barW
	
	--hp
	surface.SetMaterial( Material("vgui/gradient_down") )
	surface.SetDrawColor( Color( 55, 255, 55, 155 ) )
	surface.DrawTexturedRect(
		halfW - halfbarW,
		yPos,
		hp,
		barH
	)
	
	local str = math.Clamp( client:Health(), 0, baseHealth ) .. " / " .. baseHealth
	local tw,th = surface.GetTextSize( str )
	
	draw.SimpleText(
		str,
		"SpellFont",
		halfW,
		yPos + 8,
		Color( 255, 255, 255, 255 ),
		1,
		1
	)
		
	local barH, offY = 12, 106
	--mana
	local mana = math.Round( client:GetNWInt("mana") or 0 )
	local maxMana = champ.BaseStats.Mana.Base
	local manaW = ( mana / maxMana ) * barW
	
	surface.SetDrawColor( Color( 0, 0, 0, 155 ) )
	surface.DrawRect(
		halfW - halfbarW,
		yPos + 20,
		barW,
		barH
	)
	
	-- draw.RoundedBox( 0, (w / 2) - (barW/2), h - barH - offY + 20 , manaW, barH, Color(55, 55, 255, 155))		
	surface.SetMaterial( Material("vgui/gradient_down") )
	surface.SetDrawColor( Color( 55, 55, 255, 155 ) )
	surface.DrawTexturedRect(
		halfW - halfbarW,
		yPos + 20,
		manaW,
		barH
	)
		
	local str = mana .. " / " .. maxMana
	local tw,th = surface.GetTextSize( str )	
	
	draw.SimpleText(
		str,
		"SpellFont",
		halfW,
		yPos + 27,
		Color( 255, 255, 255, 255 ),
		1,
		1
	)
end

--old render code
/*
local abilities = client:GetHeroData().Abilities

local offX, offY, spacing = -24, 38, 10
for i = 1, 4 do
	local data = abilities[i]

	local cooldown = cooldowns[i].cooldown
	local sec = cooldowns[i].sec
	local alpha =  cooldowns[i].alpha
	local time = cooldown - CurTime()
	local x = offX + (i * (slotW + spacing)) + halfW - 144

	local format = math.ceil(time)
	--slot

	if (time < 0.8) then
		format = Format("%.1f", time )
	end
	--cd overlay
	local p = 100 - ( ( 100 / sec ) * time )

	if (time > 0) then
		surface.SetDrawColor( Color( 70, 70, 70 ) )
		surface.SetMaterial(Material(ablData.icon, "noclamp smooth"))
		surface.DrawTexturedRect(x,	h - barH - 15 + offY, slotW, slotH)

		LW.cd:DrawBox(x, h - barH - 15 + offY, slotW, slotH, p,	Color(10, 120, 255, 230 ))
		draw.DrawText(format, "DefaultBold_22",	x + 22,	h - barH + 0 + offY, Color( 255, 255, 255, 255 ), 1, 1)

	else
		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.SetMaterial(Material(ablData.icon, "noclamp smooth"))
		
		surface.DrawTexturedRect(x,	h - barH - 15 + offY, slotW, slotH)
		
		
		if(alpha && alpha > 0) then
			cooldowns[i].alpha = math.Clamp(alpha - 500 * FrameTime(), 0, 255)
			surface.SetDrawColor(Color(200, 200, 200, alpha))
			surface.DrawRect(x, h - barH - 15 + offY, slotW, slotH)
		end
	end

	--key bg
	local tw,th = surface.GetTextSize( ablData.key )
	surface.SetDrawColor(Color( 0, 0, 0, 200 ))
	surface.DrawRect(x,	h - barH - 15 + offY, 16,16)

	--key text
	draw.DrawText(ablData.key, "DefaultBold_14", x + 8,	h - barH - 15 + offY, Color( 255, 200, 0, 255 ), TEXT_ALIGN_CENTER)
end


-- Channeling info
local channel = client.channeling
local dt = channel.time - CurTime()
local p = barW - ( ( barW / channel.sec ) * dt )
p = math.Clamp( p, 0, barW )

if( p < barW ) then
	local hero = client:GetHeroData()
	draw.DrawText(
		hero.abilities[channel.key].name,
		"DefaultBold_14",
		(w / 2) - (barW / 2) + 120,
		h - barH - 70,
		Color( 200, 200, 200, 255 ),
		1
	)
	surface.SetDrawColor( Color( 0, 200, 255 ) )
	surface.DrawRect(
		halfW - halfbarW,
		h - barH - 50,
		p,
		10
	)

end
*/

-- PrintTable(client:GetAbilities())
function renderAbilityBar(w, h)

	local barW, barH = 240, 102
	local halfbarW, halfbarH = barW / 2, barH / 2
	local halfW, halfH = w / 2, h / 2
	local slotW, slotH = 48, 48

	local spacing = 6
	local offX, offY = -14, 38
	--bg box
	draw.RoundedBox(6, halfW - halfbarW - 2, h - barH - 24 - 2,	barW + 4, barH + 4,	Color(55, 55, 55, 125))
	draw.RoundedBox(6, halfW - halfbarW, h - barH - 24,	barW, barH,	Color( 0, 0, 0, 125 ))	
	
	local abilities = client:GetAbilities()
	local keys = {"Q", "W", "E", "R"}
	for i = 1, 4 do
		local data = LW.Abilities:Get(abilities[i])
	
		local cooldown = data.Cooldown
		local x = offX + (i * (slotW + spacing)) + halfW - 144
	
		--slot
		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.SetMaterial(Material(data.Texture, "noclamp smooth"))
		
		surface.DrawTexturedRect(x,	h - barH - 15 + offY, slotW, slotH)
		

		--key bg
		local tw,th = surface.GetTextSize( keys[i] )
		surface.SetDrawColor(Color( 0, 0, 0, 200 ))
		surface.DrawRect(x,	h - barH - 15 + offY, 16,16)

		--key text
		draw.DrawText(keys[i], "DefaultBold_14", x + 8,	h - barH - 15 + offY, Color( 255, 200, 0, 255 ), TEXT_ALIGN_CENTER)
	end
end

function GM:RenderScreenspaceEffects()
	if (!client:Alive()) then
		DrawColorModify({
			["$pp_colour_contrast"] = 0.35,
			["$pp_colour_colour"] = 0,
		})
	end	
end