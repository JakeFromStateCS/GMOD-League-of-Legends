AddCSLuaFile()

ENT.Base = "base_projectile"

ENT.ProjSound = {
	"lw/champions/ezreal/ezreal_mysticshot_fly_1.wav",
	"lw/champions/ezreal/ezreal_mysticshot_fly_2.wav",
	"lw/champions/ezreal/ezreal_mysticshot_fly_3.wav"
}

ENT.ProjHitEffect = "ezreal_ms_hit"
ENT.ProjHitDummy = DUMMY_EZREAL
ENT.ProjHitDamage = 200

ENT.ProjSpeed = 700
ENT.ProjMaxDistance = 300
ENT.ProjCollisionSize = 25

function ENT:Init()
	if (CLIENT) then
		self.emt = ParticleEmitter(self:GetPos())
		self.emt:SetNearClip(24, 32)
		self.emtTime = 0
	end
end

function ENT:Draw()
	local test = self.spos.x - self.pos.x
	local test2 = self.spos.y - self.pos.y
	local ptc = self.emt:Add("sprites/glow04_noz", self.pos)
	ptc:SetColor(math.Rand(180, 230), 255, 255)
	ptc:SetDieTime(0.25)
	ptc:SetLifeTime(0)
	ptc:SetStartSize(25)
	ptc:SetEndSize(0)
	ptc:SetStartAlpha(255)
	ptc:SetEndAlpha(255)
	ptc:SetAirResistance(0)
	
	if (self.emtTime < CurTime()) then
		ptc = self.emt:Add("sprites/glow04_noz", self.pos + VectorRand():GetNormal() * 4)
		ptc:SetColor(255, 255, math.Rand(0, 230))
		ptc:SetVelocity(self:GetUp() * -80)
		ptc:SetDieTime(math.Rand(0.5, 3))
		ptc:SetLifeTime(0)
		local size = math.Rand(1, 8)
		ptc:SetStartSize(size)
		ptc:SetEndSize(0)
		ptc:SetStartAlpha(255)
		ptc:SetEndAlpha(0)
		ptc:SetAirResistance(math.Rand(80, 120))
		
		self.emtTime = CurTime() + math.Rand(0.01, 0.02)
	end
end