AddCSLuaFile()

ENT.Base = "base_projectile"

ENT.ProjHitEffect = "ezreal_ms_hit"
ENT.ProjHitDummy = DUMMY_EZREAL
ENT.ProjHitDamage = 2

ENT.ProjSpeed = 700
ENT.ProjCollisionSize = 1

function ENT:Init()
	if (CLIENT) then
		self.emt = ParticleEmitter(self:GetPos())
		self.emt:SetNearClip(24, 32)
		self.emtTime = 0
	end
end

function ENT:Draw()
	local ptc = self.emt:Add("sprites/glow04_noz", self.pos)
	ptc:SetColor(255, 255, 0)
	ptc:SetDieTime(0.05)
	ptc:SetLifeTime(0)
	ptc:SetStartSize(16)
	ptc:SetEndSize(0)
	ptc:SetStartAlpha(255)
	ptc:SetEndAlpha(0)
	ptc:SetAirResistance(0)
end