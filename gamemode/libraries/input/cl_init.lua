LW.input = LW.input || {}
LW.input.keyPressed = LW.input.keyPressed || {}
LW.input.keyDowned = LW.input.keyDowned || {}
LW.input.keyDelay = LW.input.keyDelay || {}
LW.input.keyUptoCast = true
LW.input.Chat = false;
LW.input.castableKeys = {
	[1] = KEY_Q, [2] = KEY_W, [3] = KEY_E, [4] = KEY_R
}

LW.input.indexByCastKeys = {
	[KEY_Q] = 1, [KEY_W] = 2, [KEY_E] = 3, [KEY_R] = 4
}

function LW.input:Init()
	self.cursorPos = Vector(ScrW() / 2, ScrH() / 2)
end

function LW.input:PressingSpell()
	for index,key in pairs( self.castableKeys ) do
		if( self.keyPressed[key] ) then
			-- print( key );
			--Code cooldowns
			return true, self.indexByCastKeys[index];
		end;
	end;	

	return false
end

local function spell(i, key)
	local pos = util.ScreenToVector().HitPos
	local ang = util.ScreenToAimAngle2D()

	-- client._oldViewAng = Angle(0, ang, 0)

	-- print( "Cast key " .. tostring(key) )
	net.Start("lw_cast")
		net.WriteInt(i, 4)
		net.WriteFloat(pos.x)
		net.WriteFloat(pos.y)
		net.WriteFloat(pos.z)
		net.WriteFloat(ang)
	net.SendToServer()
end

function LW.input:Update()

	if (client:IsTyping() || gui.IsGameUIVisible()) then return end
	local champ = client:GetChampion()

	for i = 1, 4 do
		local key = self.castableKeys[i]
		local spellData = LW.Abilities:Get(champ.Abilities[i])

		self:KeyPressed(key, function(pressed)
			local tenary = pressed && spell(spellData.id, i) || spell(spellData.id, i)			
		end)
	end

	self:KeyDown(MOUSE_LEFT, 0, false, function(pressed, reset)
		if (!pressed || !self.minimap) then return end

		LW.cam.view.pos = self.minimap + LW.cam.view.ang:Forward() * -350
	end)
	
	self:KeyDown(MOUSE_RIGHT, 0.25, true, function(pressed, reset)
		if (node && node.devmode) then return end
		if (client._state == STATE_CHANNEL) then return end

		if (pressed) then
			local pos = util.ScreenToVector().HitPos
		
			local target = util.FindInSphere2D(pos, 50, client)[1]	

			if client.moveAttack then
				target = util.FindInSphere2D(client:GetPos(), client:GetAttackRange(), client)[1]
			end

			if (target && target:Team() != client:Team()) then
				client._target = target
				
				if (client._state != STATE_ATTACK) then
					client._state = STATE_CHASE
				end
			else
				local pos = self.minimap || pos
				local offset = pos - client:GetPos()
				local normal = offset:GetNormal()
				local viewAng = normal:Angle():Forward():Angle()

				client._target = nil

				client._oldViewAng = viewAng
				client:SetWaypoint(pos)
				client:SetState(STATE_MOVE)


				if (!tobool(reset)) then LW:WaypointEffect(pos) end
			end
		end
	end)
	
	self:KeyPressed(KEY_SPACE, function(pressed)
		if (!pressed) then
			LW.cam.view.fixed = false
			return
		end

		LW.cam.view.fixed = true
	end)

	self:KeyDown( KEY_Y, 0, true, function( pressed, reset )
		if( !reset ) then
			LW.cam.view.fixed = !LW.cam.view.fixed;
		end;
	end );

	self:KeyDown( KEY_ENTER, 0, true, function( pressed, reset )
		if( !reset ) then
			self.Chat = !self.Chat;
			if( self.Chat ) then
				chat.Open( 1 );
			else
				chat.Close();
			end;
		end;
	end );

	self:KeyDown(KEY_LSHIFT, 0.1, false, function(pressed, reset)
		
		client.moveAttack = pressed
		--chat.AddText("move attack")
	end)

	self:KeyPressed(KEY_S, function(pressed)
		if (!pressed) then return end

		client._state = STATE_IDLE
		client._waypoint = nil
		client._target = nil
	end)

	self:KeyPressed(KEY_B, function(pressed)
		if (!pressed) then return end

		net.Start("lw_recall")
		net.SendToServer()

	end)
end

function LW.input:BindPress( client, bind, pressed )
	if( string.find( bind, "messagemode" ) ) then
		return true;
	end;
end;

local mouseSpeed = 0.4
function LW.input:CursorUpdate(x, y)
	self.cursorPos = self.cursorPos + Vector(x, y) * mouseSpeed
	self:SetCursorPos(self.cursorPos.x, self.cursorPos.y)
end

function LW.input:SetCursorPos(x, y)
	self.cursorPos.x = math.Clamp(x, 0, ScrW())
	self.cursorPos.y = math.Clamp(y, 0, ScrH())
end

function LW.input:GetCursorPos()
	return self.cursorPos.x, self.cursorPos.y
end

function LW.input:KeyPressed(key, callback)
	if (input.IsButtonDown(key) && !self.keyPressed[key]) then
		self.keyPressed[key] = true
		return callback(true)
	elseif (!input.IsButtonDown(key) && self.keyPressed[key]) then
		self.keyPressed[key] = false
		return callback(false)
	end
end

function LW.input:KeyDown(key, delay, reset, callback)
	if (!self.keyDelay[key]) then self.keyDelay[key] = 0 end

	local oldKeyDelay = self.keyDelay[key]
	if (input.IsButtonDown(key) && self.keyDelay[key] <= CurTime()) then
		self.keyDowned[key] = true
		self.keyDelay[key] = CurTime() + delay
		
		return callback(true, oldKeyDelay)
	elseif (!input.IsButtonDown(key) && self.keyDowned[key]) then
		self.keyDowned[key] = false
		if (reset) then self.keyDelay[key] = 0 end
		
		return callback(false)
	end
end

-- IF you can using reqiure nodes (concommand: node_devmode 1) 0 is off
-- Lookup code in modules/node.lua
/*
local a, b, nodes = node.FindInBox(client:GetPos(), pos) -- Find sphere
print(a, b, nodes)
if (a) then

	client.path = path(a, b, nodes, true, function(node, neighbor) 
		local MAX_DIST = 34
		if (neighbor.walkable == node.walkable and 
			distance(node.x, node.y, neighbor.x, neighbor.y) < MAX_DIST) then
			return true
		end
		
		return false
	end)

	PrintTable(client.path)
end
*/