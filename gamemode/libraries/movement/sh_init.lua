/*
function GM:SetupMove(ply, mv, cmd)
	if (CLIENT && !ply:Alive()) then
		client._state = STATE_IDLE
	end

	--kill the target once it's dead
	if (CLIENT && IsValid(client._target) && !client._target:Alive()) then
		client._state = STATE_IDLE
		client._target = nil
	end

	ply:SetState(cmd:GetImpulse())

	if (ply:GetState() == STATE_ATTACK) then
		local target = player.GetByID(mv:GetSideSpeed())
		if (!IsValid(target)) then
			target = ents.GetByIndex(mv:GetSideSpeed())
		end
		if (!target:Alive()) then return end

		if (IsFirstTimePredicted()) then
			LW:StartAnimation(ply, target)
		end
	else
		LW:StopAnimation(ply)
	end
end

function GM:Move(ply, mv)
	mv:SetSideSpeed(0)
	mv:SetUpSpeed(0)
	
	if (ply:GetState() == STATE_MOVE || ply:GetState() == STATE_CHASE) then
		local viewNormal = mv:GetMoveAngles():Forward()
		mv:SetVelocity(viewNormal * mv:GetForwardSpeed())
	end

	if (ply:IsBot()) then
	--	mv:SetVelocity((Vector() - mv:GetOrigin()):GetNormal() * 100)
	end
end

function GM:FinishMove(ply, mv)
	if (ply:GetState() == STATE_IDLE || ply:GetState() == STATE_ATTACK ||
			ply:GetState() == STATE_CHANNEL) then
		local vel = mv:GetVelocity()
		local velSpeed = vel:Length()

		if (velSpeed > 0) then
			mv:SetVelocity(vel * 0.2)
		end
	end
end

function LW:StartAnimation(ply, target)
	if (ply:GetAttackDelay() > CurTime()) then return end

	local hero = ply:GetHeroData()
	if (ply:GetAnimDelay() == 0) then
		if (hero.IsRangedAttack) then
			if (SERVER) then
				ply:ResetLuaAnimation("leesin_sw")
			end
		else
			if (SERVER) then
				ply:ResetLuaAnimation("leesin_dr")
			end
		end

		ply:SetAnimDelay(CurTime())
	end

	local dt = CurTime() - ply:GetAnimDelay()

	if (!ply:GetAttacked() && dt > hero.BaseAnimDelay - 0.1) then
		LW:DoAttack(ply, target)
		ply:SetAttacked(true)
	end

	if (dt > hero.BaseAnimDelay + 1) then
		ply:SetAnimDelay(0)
		ply:SetAttacked(false)

		if (CLIENT) then
			client._state = STATE_CHASE
		end
	end
end

function LW:StopAnimation(ply)
	if (ply:GetAnimDelay() != 0) then
		ply:SetAnimDelay(0)
		ply:SetAttacked(false)
		ply:StopAllLuaAnimations()
	end
end

function LW:DoAttack(ply, target)
	local hero = ply:GetHeroData()
	if (hero.IsRangedAttack) then
		if (SERVER) then
			local ent = ents.Create("projectile_ezreal_rising")
			ent:SetTarget(target)
			ent.ProjHitDamage = hero.BaseAttackDamage
			ent:SetPos(ply:GetForwardPos())
			ent:SetAngles(ply:GetAngles())
			ent:SetOwner(ply)
			ent:Spawn()

			ply:EmitSound("lw/champions/ezreal/ezreal_defattack_shoot_" .. math.random(3) .. ".wav", 100, 100, 0.25)
		end
	else
		if (SERVER) then
			target:GiveDamage(hero.BaseAttackDamage, DMG_AD, ply)
			ply:EmitSound("lw/champions/leesin/leesin_dragonsrage_hit_" .. math.random(4) .. ".wav", 100, 100, 0.25)
			ply:EmitSound("lw/champions/leesin/leesin_dragonsrage_vo_" .. math.random(4) .. ".wav", 100, 100, 0.25)
		end
	end

	ply:SetAttackDelay(CurTime() + hero.BaseAttackDelay)
end
*/