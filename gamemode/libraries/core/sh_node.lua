AddCSLuaFile() -- making lol lol lol lol lol shit

node = node || {}
node.temp = node.temp || {}

node.devmode = node.devmode || false
node.gridCursor = node.gridCursor || Vector(0, 0)

if (SERVER) then
	util.AddNetworkString("node_send")
	util.AddNetworkString("node_save")
	
	net.Receive("node_send", function()
		local ply = net.ReadEntity()
		local pos = net.ReadVector()
		local walkable = net.ReadBool()
		
		if (node.Find(pos)) then
			ply:SendLua("surface.PlaySound('buttons/button8.wav')")
			ply:ChatPrint("Error: Current position already node valid!!")
			return
		end
		
		local nData = node.Add(pos, walkable)
		
		net.Start("node_send")
			net.WriteTable(nData)
		net.Broadcast()
		
		ply:SendLua("surface.PlaySound('buttons/lever6.wav')")
		ply:ChatPrint("Success!!")
	end)
	
	function node.Add(pos, walkable)
		local id = #node.temp + 1
		node.temp[id] = {}
		node.temp[id].id = id
		node.temp[id].x = pos.x
		node.temp[id].y = pos.y
		node.temp[id].walkable = walkable
		
		return node.temp[id]
	end
else
	net.Receive("node_send", function()
		local nData = net.ReadTable()
		
		node.temp[nData.id] = nData
	end)
	
	function node.SendToServer(pos, walkable)
		pos.z = 0
		if (!walkable) then walkable = false end
		
		net.Start("node_send")
			net.WriteEntity(client)
			net.WriteVector(pos)
			net.WriteBool(walkable)
		net.SendToServer()
	end
end

function node.Find(pos)
	for k, v in ipairs(node.temp) do
		if (v.x == pos.x && v.y == pos.y) then return v.id end
	end
	
	return false
end

function node.FindInBox(startPos, endPos)
	local start, goal
	-- print(node)
	local nodes = node.temp
	for k, v in ipairs(nodes) do
		local nodepos = Vector(v.x, v.y)
		local dist = (startPos - nodepos):Length2D()
		
		if (dist > 32) then continue end
		
		start = v.id
	end
	
	for k, v in ipairs(nodes) do
		local nodepos = Vector(v.x, v.y)
		local dist = (endPos - nodepos):Length2D()
		
		if (dist > 32) then continue end
		
		goal = v.id
	end
	
	if (!start || !goal) then return false end
	
	return nodes[start], nodes[goal], nodes
end

function node.Save()

end

function node.Load()

end

function node.Update()
	if (!node.devmode) then return end
	
	LW.input:KeyPressed(MOUSE_LEFT, function(pressed)
		if (pressed) then
			node.SendToServer(node.gridCursor, true)
		end
	end)
	
	LW.input:KeyPressed(MOUSE_RIGHT, function(pressed)
		if (pressed) then
			node.SendToServer(node.gridCursor)
		end
	end)
end

local mins = Vector(1, 1, 1) * 16
local maxs = Vector(1, 1, 0) * -16
function node.Draw()
	for k, v in ipairs(client.path || {}) do
		local nodePos = Vector(v.x, v.y)
		render.DrawWireframeBox(nodePos, Angle(), mins, maxs, Color(0, 255, 0), false)
	end
	
	if (!node.devmode) then return end
	
	local tr = util.ScreenToVector()
	local hitpos = tr.HitPos
	
	for k, v in ipairs(node.temp) do
		local nodePos = Vector(v.x, v.y)
		local dist = (hitpos - nodePos):Length2D()
		if (dist > 128) then continue end
		
		if (v.walkable) then
			render.DrawWireframeBox(nodePos, Angle(), mins, maxs, Color(100, 255, 255), false)
		else
			render.DrawWireframeBox(nodePos, Angle(), mins, maxs, Color(255, 0, 0), false)
		end
		
		cam.Start3D2D(nodePos + Vector(0, 0, 16), Angle(0, -90, 0), 1)
			draw.SimpleTextOutlined(v.id, "DefaultBold_12", 0, 0, Color(255, 255, 255), 1, 1, 2, Color(0, 0, 0))
		cam.End3D2D()
	end
	
	if (hitpos.y > node.gridCursor.y + 16) then
		node.gridCursor.y = node.gridCursor.y + 32
	elseif (hitpos.y < node.gridCursor.y - 16) then
		node.gridCursor.y = node.gridCursor.y - 32
	end
	
	if (hitpos.x > node.gridCursor.x + 16) then
		node.gridCursor.x = node.gridCursor.x + 32
	elseif (hitpos.x < node.gridCursor.x - 16) then
		node.gridCursor.x = node.gridCursor.x - 32
	end
	
	render.DrawWireframeBox(Vector(node.gridCursor.x, node.gridCursor.y), Angle(), mins, maxs, Color(255, 255, 255), false)
end

concommand.Add("node_devmode", function(ply, _, args)
	node.devmode = tobool(args[1])
end)