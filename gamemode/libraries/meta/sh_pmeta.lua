local meta = FindMetaTable("Player")

function meta:SetState(num)
	self:SetNWInt("state", num)
end

function meta:GetState()
	return self:GetNWInt("state") or STATE_IDLE
end

function meta:SetWaypoint(pos)
	if( SERVER ) then
		self:SetNWVector( "waypoint", pos );
	else
		self.__waypoint = pos;
	end;
end

function meta:GetWaypoint()
	--Will default to 0,0,0 if not set
	if( SERVER ) then
		return self:GetNWVector( "waypoint" );
	else
		return self.__waypoint;
	end;
end

function meta:SetAnimDelay(delay)
	self:SetDTFloat(0, delay)
end

function meta:GetAnimDelay()
	return self:GetDTFloat(0)
end

function meta:SetAttackDelay(delay)
	self:SetDTFloat(1, delay)
end

function meta:GetAttackDelay()
	return self:GetDTFloat(1)
end

function meta:SetAttacked(attack)
	self:SetDTBool(0, attack)
end

function meta:GetAttacked()
	return self:GetDTBool(0)
end

function meta:GetPredictedPos()
	local ping = math.min(self:Ping(), 250) / 1100
	return math.max(0.04, ping) * self:GetVelocity():GetNormal() * self:GetVelocity():Length()
end

function meta:GetCenterPos()
	local pos = self:GetShootPos() + self:GetPredictedPos()
	pos.z = pos.z / 1.5
	return pos
end

function meta:GetForwardPos()
	return self:GetCenterPos() + self:GetAimVector()
end

function meta:GetMana()
	return self:GetNWInt("mana")
end

if (SERVER) then
	function meta:GiveDamage(damage, damagetype, attacker, hitpos)
		if (!IsValid(attacker)) then attacker = self end
		
		self:CancelRecall()	

		local dmginfo = DamageInfo()
		dmginfo:SetDamage(damage)
		dmginfo:SetAttacker(attacker)
		dmginfo:SetDamageForce(Vector())
		dmginfo:SetDamageType(damagetype)
		self:TakeDamageInfo(dmginfo)

		if attacker:IsPlayer() then
			net.Start("lw_dmg")
				net.WriteInt(self:EntIndex(), 32)
				net.WriteFloat(damage, 32)
			net.Broadcast()
		end

		return dmginfo
	end

	function meta:CustomGesture(gesture)
		if (!gesture) then return end
		
		umsg.Start("gesture") -- dafuck usermessages :(
			umsg.Entity(self)
			umsg.Short(gesture)
		umsg.End()
		
		self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, gesture, true)
	end

	function meta:CustomGestureReset()
		umsg.Start("gesture_reset")
			umsg.Entity(self)
		umsg.End()
		
		self:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
	end

	--hack's idea
	function meta:CancelRecall()
		if !self.isRecalling then return end
		net.Start("lw_recall_inform")
			net.WriteInt(self:EntIndex(), 32)
			net.WriteBool(false)
		net.Broadcast()
	end

else
	function meta:CustomGesture(gesture)
		self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, gesture, true)
	end
	
	function meta:CustomGestureReset()
		self:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
	end
	
	usermessage.Hook("gesture", function(um)
		local ent = um:ReadEntity()
		local gesture = um:ReadShort()
		
		if (IsValid(ent)) then
			ent:CustomGesture(gesture)
		end
	end)
	
	usermessage.Hook("gesture_reset", function(um)
		local ent = um:ReadEntity()
		
		if (IsValid(ent)) then
			ent:CustomGestureReset()
		end
	end)
end