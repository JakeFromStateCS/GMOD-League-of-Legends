AddCSLuaFile()

ENT.Base = "base_projectile"

ENT.ProjSound = {
	"lw/champions/ezreal/ezreal_essenceflux_fly_1.wav",
	"lw/champions/ezreal/ezreal_essenceflux_fly_2.wav",
	"lw/champions/ezreal/ezreal_essenceflux_fly_3.wav"
}

ENT.ProjHitDummy = DUMMY_EZREAL

ENT.ProjSpeed = 350
ENT.ProjCollisionSize = 32
ENT.ProjHitDamage = 150

function ENT:Init()
	if (CLIENT) then
		self.emt = ParticleEmitter(self.pos)
		self.emt:SetNearClip(64, 128)
		self.emtTime = 0
	end
end

function ENT:Draw()
	local test = self.spos.x - self.pos.x
	local test2 = self.spos.y - self.pos.y
	local ptc = self.emt:Add("sprites/glow04_noz", self.pos)
	ptc:SetColor(55, 150, 200)
	ptc:SetDieTime(0.1)
	ptc:SetLifeTime(0)
	ptc:SetStartSize(50)
	ptc:SetEndSize(5)
	ptc:SetStartAlpha(255)
	ptc:SetEndAlpha(255)
	ptc:SetAirResistance(0)

end