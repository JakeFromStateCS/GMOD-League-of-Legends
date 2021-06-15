AddCSLuaFile()

ENT.Base = "base_projectile"

ENT.ProjSound = {
	"lw/champions/ezreal/ezreal_essenceflux_fly_1.wav",
	"lw/champions/ezreal/ezreal_essenceflux_fly_2.wav",
	"lw/champions/ezreal/ezreal_essenceflux_fly_3.wav"
}

ENT.ProjHitPenetrate = true
ENT.ProjHitEffect = "ezreal_ef_hit"
ENT.ProjHitDummy = DUMMY_EZREAL
ENT.ProjHitDamage = 120

ENT.ProjSpeed = 600
ENT.ProjCollisionSize = 25
ENT.ProjMaxDistance = 250

function ENT:Init()
	if (CLIENT) then
		self.emt = ParticleEmitter(self.pos)
		self.emt:SetNearClip(64, 128)
		self.emtTime = 0
	end

end

function ENT:Draw()
	local ang = self.dir:Angle()
	local this = self

	local ptc = self.emt:Add("sprites/glow04_noz", self.pos)
	ptc:SetColor(0, 0, 255)
	ptc:SetDieTime(0.25)
	ptc:SetLifeTime(0)
	ptc:SetStartSize(30)
	ptc:SetEndSize(0)
	ptc:SetStartAlpha(0)
	ptc:SetEndAlpha(255)
	ptc:SetAirResistance(10)	
	

	ptc = self.emt:Add("sprites/tp_beam001", self.pos)
	ptc:SetColor(255, 255, 255)
	ptc:SetVelocity(VectorRand() * 20)
	ptc:SetDieTime(0.15)
	ptc:SetLifeTime(0)
	ptc:SetStartSize(10)
	ptc:SetEndSize(2)
	ptc:SetStartAlpha(0)
	ptc:SetEndAlpha(155)
	ptc:SetAirResistance(100)

	timer.Simple(0.45, function()
		if this == NULL then return end
		ptc = this.emt:Add("sprites/heatwave", this.pos)
		ptc:SetColor(0, 0, 200)
		ptc:SetDieTime(0.3)
		ptc:SetLifeTime(0)
		ptc:SetStartSize(10)
		ptc:SetEndSize(150)
		ptc:SetStartAlpha(0)
		ptc:SetEndAlpha(255)
		ptc:SetAirResistance(10)			

	end)

	self.emtTime = CurTime() + 0.05

end