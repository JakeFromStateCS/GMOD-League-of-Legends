function util.Desired2D(o, s, a) -- deacceleration method
	o.z = 0
	local d = o:Length2D()
	if (!a) then a = 0.05 end
	
	return (math.min(s * (d / (s * a)), s) / d) * o
end

function util.Get2DPos( client )
	local pos = client:GetPos();
	local halfWidth = 0.5 * ScreenW();
	local halfHeight = 0.5 * ScreenH();
	local pos2d = {
		x = ( pos.x * halfWidth ) + halfWidth,
		y = ( pos.y * halfHeight ) + halfHeight
	};
	return pos2d;
end;

function player.GetAliveAll()
	local players = player.GetAll()
	for _, ply in ipairs(players) do
		if (ply:Alive()) then continue end

		table.RemoveByValue(players, ply)
	end

	return players
end

function ents.GetAllObjects()
	return ents.FindByClass("base_lw_tower")
end

function ents.FindByTable(tab)
	local temp = {}
	for _,v in pairs(tab) do
		table.Add(temp, ents.FindByClass(v))
	end
	return temp
end

function util.SortObjectsDistance(pos)
	local objs = player.GetAliveAll()
	table.Add(objs, ents.FindByTable({
		"base_lw_tower",
		"base_mob"
	}))
	--can findby class use a table like this
	-- PrintTable(ents.FindByTable({"base_mob", "base_lw_tower"})) ? let me check
	--nope

	table.sort(objs, function(a, b)
		local a_dist = (pos - a:GetPos()):Length2D()
		local b_dist = (pos - b:GetPos()):Length2D()

		return (a_dist < b_dist)
	end)

	return objs
end

function util.FindInSphere2D(pos, radius, filter) -- made by lol
	local objs = util.SortObjectsDistance(pos)
	local find = {}

	for _, obj in ipairs(objs) do
		if (!isnumber(filter) && filter == obj) then continue end
		if (isnumber(filter) && filter == obj:Team()) then continue end

		local dist = (pos - obj:GetPos()):Length2D()
		if (dist > radius) then continue end

		find[#find + 1] = obj
	end

	return find
end

-- Made By LOL
function util.IntersectCircleWithOBB2D(s, e, w, p, r)
	local d, _, l = util.DistanceToLine(Vector(s.x, s.y), Vector(e.x, e.y), Vector(p.x, p.y))
	local maxDist = (s - e):Length2D()
	if (d < w + r && l > -r && l < maxDist + r) then
		return true
	end

	return false
end

function util.FindInDistOBB2D(data)
	local find = {}
	local pos = data.startpos
	local players = util.SortObjectsDistance(pos)
	for _, ply in ipairs(players) do
		local hit = util.IntersectCircleWithOBB2D(pos, data.endpos, data.width, ply:GetPos(), 16)
		if (!hit) then continue end

		find[#find + 1] = ply
	end

	return find
end

-- awesome utils (gui.ScreenToVector shared version) recode by LOL
function util.ScreenToVector2(x, y, w, h, ang)
	-- Widescreen fixed :)
	local fov = (math.atan(math.tan((90 * math.pi) / 360) * ((w / h) / (4 / 3))) * 360) / math.pi
	
	local hw = w * 0.5
	local hh = h * 0.5
	local d = hw / math.tan(math.rad(fov) * 0.5)
	local forward = ang:Forward()
	local right = ang:Right()
	local up = ang:Up()

	return (forward * d + right * (x - hw) + up * (hh - y)):GetNormal()
end

-- Only working Predicted hooks
function util.ScreenToWorldPoint(ply)
	local cmd = ply:GetCurrentCommand()
	local camPos = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), cmd:GetUpMove())
	local cursorPos = Vector(cmd:GetMouseX(), cmd:GetMouseY(), 0)

	local filter = {}
	table.Add(filter, player.GetAll())

	local trData = {}
	trData.start = camPos
	trData.endpos = trData.start + util.ScreenToVector2(cursorPos.x, cursorPos.y, ply.sw, ply.sh, Angle(65, 0, 0)) * 10000
	trData.filter = filter
	
	return util.TraceHull(trData)
end

if (CLIENT) then
	function util.ScreenToVector(ignorePlayers)
		local filter = {}

		if (ignorePlayers) then
			table.Add(filter, player.GetAll())
		end

		local trData = {}
		trData.start = LW.cam.view.origin
		trData.endpos = trData.start + gui.ScreenToVector(LW.input:GetCursorPos()) * 10000
		trData.filter = filter
		trData.ignoreworld = false

		return util.TraceHull(trData)
	end

	function util.ScreenToAimAngle2D()
		local camPos = LW.cam.view.origin
		local aimVec = util.ScreenToVector(true).HitPos
		local myPos2D = Vector(client:GetPos().x, client:GetPos().y)

		return (aimVec - myPos2D):Angle().y
	end
end