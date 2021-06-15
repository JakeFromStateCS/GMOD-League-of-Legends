util.AddNetworkString("lw_resolution")
util.AddNetworkString("lw_cast")
util.AddNetworkString("lw_cooldown")
util.AddNetworkString("lw_channeling")
util.AddNetworkString("lw_dmg")
util.AddNetworkString("lw_recall")
util.AddNetworkString("lw_recall_inform")
util.AddNetworkString("lw_mobspawn")
util.AddNetworkString( "LW Movement Check" );

hook.Add("PlayerPostThink", "CastUpdate", function(ply)
	if (ply.isChanneling && ply.channelTime < CurTime()) then
		local champ = client:GetChampion()
		local abilities = client:GetAbilities()
		--local key = ply.ablKey
		--local abldata = hero_manager.getAbilities(ply:GetHero())[key]
		--local cooldown = hero_manager.getCooldown(ply:GetHero(), key)
		if (ply:Alive()) then
			abldata.onCast(ply, ply.temp.pos, ply.temp.ang)
			ply.cooldown[key] = CurTime() + cooldown

			net.Start("lw_cooldown")
				net.WriteInt(key, 4)
				net.WriteFloat(CurTime())
				net.WriteFloat(cooldown)
			net.Send(ply)
		end

		ply.isChanneling = false
	end
end)

local function cast(ply, key, targetPos, ang2D)
	local hero = ply:GetHeroData()
	local abldata = hero_manager.getAbilities(ply:GetHero())[key]
	local cooldown = hero_manager.getCooldown(ply:GetHero(), key)
	local channeling = abldata.channeling
	if abldata.manaCost >= ply:GetMana() then return end
	if (abldata.onCast) then
		if (channeling) then
			net.Start("lw_channeling")
				net.WriteInt(key, 4)
				net.WriteFloat(CurTime())
				net.WriteFloat(channeling)
			net.Send(ply)

			ply.channelTime = CurTime() + channeling
			ply.ablKey = key
			ply.temp = {
				pos = targetPos,
				ang = ang2D
			}
			ply.isChanneling = true
			
			player_manager.RunClass(ply, "castSpell", key)
		end
	end
end

net.Receive("lw_cast", function(_, ply)
	if (!ply:Alive()) then return end
	if (ply.isChanneling) then return end

	local spellID = net.ReadInt(4)
	local pos = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
	local ang2D = Angle(0, net.ReadFloat(), 0)

	--if (ply.cooldown[key] >= CurTime()) then return end

	--cast(ply, key, targetPos, ang2D)
	LW.Abilities:OnCast(ply, spellID, pos, ang2D)

	ply:CancelRecall()
end)

net.Receive("lw_resolution", function(_, ply)
	local sw, sh = net.ReadInt(16), net.ReadInt(16)

	ply.sw = sw
	ply.sh = sh

	print(ply:Nick() .. "'s Resolution " .. ply.sw .. "x" .. ply.sh)
end)

net.Receive("lw_recall", function(_, ply)
	ply.isRecalling = true
	--print(ply)

	--tell clients who is recalling
	net.Start("lw_recall_inform")
		net.WriteInt(ply:EntIndex(), 32)
		net.WriteBool(true) 
	net.Broadcast()
end)

net.Receive("lw_mobspawn", function(_, ply)
	local targetPos = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
	local point = net.ReadBool()
	if (point) then
		local point = ents.Create("point_mob")
		point:SetPos(targetPos)
		point:SetAngles(Angle())
		point:Spawn()
		print("a")
	else
		local mob = ents.Create("base_mob")
		mob:SetPos(targetPos)
		mob:SetAngles(Angle())
		mob:Spawn()
	end
end)

net.Receive( "LW Movement Check", function( _, ply )
	local state = net.ReadInt( 4 );

	net.Start( "LW Movement Check" );
		net.WriteInt( state, 4 );
	net.Send( ply );

	ply:SetState( state );
	ply.stopMove = false
end );

