LW = ( LW || GM || GAMEMODE );

client = ( client || NULL )
sw = ScrW() sh = ScrH()

include( "libraries/sh_init.lua" );
include( "shared.lua" );

function GM:InitPostEntity()
	client = LocalPlayer()
	-- client.isRecalling = false
	-- client.moveAttack = false
	-- client.damageTaken = 0
	-- client.cooldown = {}
	-- client.channeling = {time = 0, sec = 0, key = 0}

	-- for i = 1, 4 do
	-- 	client.cooldown[i] = {}
	-- 	client.cooldown[i].cooldown = 0
	-- 	client.cooldown[i].sec = 0
	-- end

	LW:SendResolution(sw, sh)
	LW.input:Init()
	LW.cam:Init()
end

function GM:CalcView()
	return LW.cam:CamView()
end

function GM:InputMouseApply(cmd, x, y)
	LW.input:CursorUpdate(x, y)
	return true
end

function GM:PostDrawOpaqueRenderables()
	LW:WaypointRender()
	-- LW:RecallRender()
	--LW:FogUpdate()

	-- renderSkillMarker()
end

local rangeMat = Material("lw/si/si_range.png")
local localBMat, localHMat = Material("lw/si/si_localbase.png"), Material("lw/si/si_localhead.png")
local globalBMat, globalHMat = Material("lw/si/si_globalbase.png"), Material("lw/si/si_globalhead.png")
function renderSkillMarker()
	local pressing, key = LW.input:PressingSpell()
	if (!pressing) then return end

	cam.IgnoreZ(true)

	local mypos = client:GetPos()
	local abl = client:GetHeroData().abilities[key]

	if (abl.maker_g) then
		local pos = util.ScreenToVector().HitPos
		local ang = Angle(0,util.ScreenToAimAngle2D(), 0)
		local w = 40 * 2
		local d = 120
		local dc = d / 2

		local dist = (client:GetPos() - pos):Length2D()
		if (dist < d) then
			cam.Start3D2D(mypos, ang, 1)
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(globalHMat)
					surface.DrawTexturedRectRotated(dc, 0, w, d, -90)
			cam.End3D2D()
		else
			cam.Start3D2D(mypos, ang, 1)
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(globalBMat)
					surface.DrawTexturedRectRotated(dc, 0, w, d, -90)
			cam.End3D2D()

			cam.Start3D2D(pos, ang, 1)
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(globalHMat)
				surface.DrawTexturedRectRotated(dc, 0, w, d, -90)
			cam.End3D2D()
		end
	elseif (abl.maker_w) then
		local ang = Angle(0,util.ScreenToAimAngle2D(), 0)
		local w = abl.maker_w * 2
		local d = abl.maker_d
		local dc = d / 2
		local hs = 70
		local hss = 17 -- 70 / 4 = 17.5

		cam.Start3D2D(mypos, ang, 1)
			--base
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(localBMat)
			surface.DrawTexturedRectRotated(dc - hss, 0, w, d - (hs / 2), -90)

			--tip
			surface.SetMaterial(localHMat)
			surface.DrawTexturedRectRotated(d, 0, w, hs, -90)
		cam.End3D2D()
	elseif (abl.maker_r) then
		local r = abl.maker_r * 2
		local c = -r / 2
		cam.Start3D2D(mypos, Angle(), 1)		
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(rangeMat)
			surface.DrawTexturedRect(c, c, r, r)
		cam.End3D2D()
	elseif (abl.maker_c) then
		abl:maker_c()
	end
end

hook.Add("PreDrawHalos", "PlayerOutlined", function()
	local pos = util.ScreenToVector().HitPos
	local find = util.FindInSphere2D(pos, 50, client._selfTarget && nil || client)[1]
	if (!find) then return end

	local col = Color(0, 255, 100)
	local isEnemy = find:Team() != client:Team()
	if (isEnemy) then
		col = Color(200, 10, 0)
	end

	if (!client:Alive() || !find:Alive()) then
		return
	end

	halo.Add({find}, col, 2, 2, 6)
end)

function LW:Update()
	if (IsValid(client)) then
		if (sw != ScrW() || sh != ScrH()) then
			sw = ScrW() sh = ScrH()
			self:SendResolution(sw, sh)
		end
	end

	if (LW.cam.Update) then LW.cam:Update() end
	if (LW.input.Update) then LW.input:Update() end

	if (node.Update) then node.Update() end
end


function LW:PlayerBindPress( client, bind, pressed )
	local val = LW.input:BindPress( client, bind, pressed );
	if( val ) then
		return val;
	end;
end;


function LW:WaypointEffect(pos)
	effect_Waypoint = {
		pos = pos,
		size = 32,
		mat = "effects/select_ring"
	}
end

function LW:WaypointRender()
	if (effect_Waypoint) then
		local pos = effect_Waypoint.pos
		local size = effect_Waypoint.size
		local mat = effect_Waypoint.mat
		if (effect_Waypoint.size == 0) then effect_Waypoint = nil return end
		
		local max = 100
		
		cam.Start3D2D(pos, Angle(), 1)
			render.SetMaterial(Material(mat, "noclamp smooth"))
			local col = client.moveAttack and Color(255, 0, 0) or Color(0, 255, 0)
			render.DrawQuadEasy(Vector(), Vector(0, 0, 1), size, size, col, 0)
			render.DrawQuadEasy(Vector(), Vector(0, 0, 1), math.Clamp(size - 10, 0, max), math.Clamp(size - 10, 0, max), col, 0)
			render.DrawQuadEasy(Vector(), Vector(0, 0, 1), math.Clamp(size - 20, 0, max), math.Clamp(size - 20, 0, max), col, 0)
		cam.End3D2D()
		
		effect_Waypoint.size = math.Clamp(effect_Waypoint.size - 100 * FrameTime(), 0, max)
	end
end

function LW:RecallRender()
	local col = Color(0, 0, 255, 155)
	
	for k,v in pairs(player.GetAll()) do
		local pos = v:GetPos()
		if !v.isRecalling then continue end
		-- render.SetMaterial(Material("cable/redlaser")) 	
		render.SetMaterial( Material( "color" ) )
		render.DrawBeam(pos, pos + Vector(0, 0, 1000), 64, 1, 1, col)
	end

end

function LW:SendResolution(w, h)
	client.sw = w
	client.sh = h

	net.Start("lw_resolution")
		net.WriteInt(w, 16)
		net.WriteInt(h, 16)
	net.SendToServer()
end

function GM:CreateClientsideRagdoll(ent, rag)
	timer.Simple(3, function()
		if IsValid(rag) then
			rag:Remove()
		end
	end)
end

--helper render method
function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function LW:FogUpdate()
	render.SetStencilEnable(true)
	render.ClearStencil()
	
	render.SetStencilWriteMask(3)
	render.SetStencilTestMask(3)
	
	render.SetStencilReferenceValue(1)
	
	local mapz = 1
	local pos = Vector(client:GetPos().x, client:GetPos().y, mapz)
	local fogpos = Vector(0, 0, mapz)
	local mapsize = 5000
	cam.IgnoreZ(true)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_REPLACE)
	render.SetStencilCompareFunction(STENCIL_NEVER) // invisible stencil
		cam.Start3D2D(fogpos, Angle(), 1)
			draw.NoTexture()
			surface.SetDrawColor(0, 0, 0, 1)
			surface.DrawRect(-mapsize / 2, -mapsize / 2, 5000, 5000)
		cam.End3D2D()
		
	render.SetStencilFailOperation(STENCIL_ZERO)
	render.SetStencilZFailOperation(STENCIL_ZERO) // cut stencil

		cam.Start3D2D(pos, Angle(), 1)
			draw.NoTexture()
			surface.SetDrawColor(0, 0, 0, 1)
			draw.Circle(0, 0, 360, 32)
		cam.End3D2D()

	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilCompareFunction(STENCIL_EQUAL) // cuted ignore stencil
	
		cam.Start3D2D(fogpos, Angle(), 1)
			draw.NoTexture()
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(-mapsize / 2, -mapsize / 2, 5000, 5000)
		cam.End3D2D()
		cam.IgnoreZ(false)
	render.SetStencilEnable(false)
end