local meta = FindMetaTable("Entity")

function meta:SetTeam(t)
	self:SetDTInt(0, t)
end

function meta:Team()
	return self:GetDTInt(0)
end

function meta:SetTarget(t)
	self:SetDTEntity(0, t)
end

function meta:GetTarget()
	return self:GetDTEntity(0)
end

function meta:Alive()
	if !IsValid(self) then return false end
	return self:Health() > 0
end

function meta:GiveDamage(damage, damagetype, attacker, hitpos)
	if (!IsValid(attacker)) then attacker = self end
	
	local dmginfo = DamageInfo()
	dmginfo:SetDamage(damage)
	dmginfo:SetAttacker(attacker)
	dmginfo:SetDamageForce(Vector())
	dmginfo:SetDamageType(damagetype)
	self:TakeDamageInfo(dmginfo)

	return dmginfo
end