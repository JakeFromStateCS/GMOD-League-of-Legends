function LW:ClientMoveUpdate(cmd)
	--todo: make a method to make sure client has a champ
	local maxSpeed = client:GetMoveSpeed()
	local waypoint = client:GetWaypoint();
	if (client:GetState() == STATE_MOVE && client._waypoint) then
		local offset = client._waypoint - client:GetPos()
		local dist = offset:Length()
		local normal = offset:GetNormal()
		local viewAng = normal:Angle():Forward():Angle()
		local desired = util.Desired2D(offset, maxSpeed)
		local velSpeed = desired:Length()
		local cVelSpeed = client:GetVelocity():Length()
		
		if (velSpeed <= 6 && cVelSpeed == 0 and dist >= 50) then
			cmd:SetViewAngles(client._oldViewAng)
			client._state = STATE_IDLE
			client._waypoint = nil
		else
			cmd:SetViewAngles(viewAng)
			cmd:SetForwardMove(velSpeed)
		end
	elseif (client:GetState() == STATE_CHASE && client._target) then
		local offset = client._target:GetPos() - client:GetPos()
		local dist = offset:Length2D()
		local normal = offset:GetNormal()
		local viewAng = normal:Angle():Forward():Angle()
		local desired = util.Desired2D(offset, maxSpeed)
		local velSpeed = desired:Length()

		if (dist > hero.BaseAttackRange) then
			cmd:SetForwardMove(velSpeed)
			cmd:SetViewAngles(viewAng)
		else
			client._state = STATE_ATTACK
		end
	elseif (client:GetState() == STATE_CHANNEL) then
		cmd:SetViewAngles(client._viewAng)
	elseif (client:GetState() == STATE_ATTACK && IsValid(client._target)) then
		local offset = client._target:GetPos() - client:GetPos()
		local dist = offset:Length2D()
		local viewAng = offset:GetNormal():Angle():Forward():Angle()

		cmd:SetViewAngles(viewAng)
	end
end