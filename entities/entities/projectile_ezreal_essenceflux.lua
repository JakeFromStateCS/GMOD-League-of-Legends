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
	local pos = self.pos
	local ptc = self.emt:Add("sprites/glow04_noz", pos)
	ptc:SetColor(250, math.Rand(255, 200), 100)
	ptc:SetDieTime(0.05)
	ptc:SetLifeTime(0)
	ptc:SetStartSize(100)
	ptc:SetEndSize(0)
	ptc:SetStartAlpha(0)
	ptc:SetEndAlpha(255)
	ptc:SetAirResistance(10)
	
	if (self.emtTime < CurTime()) then
		local rept = 6
		for i = 0, rept do
			local hrz = ((rept / 2) - i) * 6
			local frd = math.sin(3.14 / rept * i) * 7
			pos = self.pos + ang:Right() * hrz + ang:Forward() * frd
			
			ptc = self.emt:Add("effects/yellowflare", pos)
			ptc:SetColor(250, math.Rand(240, 255), 120)
			ptc:SetVelocity(VectorRand() * 50)
			ptc:SetDieTime(0.1)
			ptc:SetLifeTime(0)
			ptc:SetStartSize(math.Rand(5, 20))
			ptc:SetEndSize(0)
			ptc:SetStartAlpha(0)
			ptc:SetEndAlpha(255)
			ptc:SetAirResistance(100)
			
			ptc = self.emt:Add("sprites/glow04_noz", pos)
			ptc:SetColor(250, math.Rand(200, 255), math.Rand(0, 100))
			ptc:SetVelocity(VectorRand() * 10 + ang:Forward() * -math.Rand(30, 40) * frd)
			ptc:SetDieTime(math.Rand(0.5, 1.5))
			ptc:SetLifeTime(0)
			ptc:SetStartSize(math.Rand(5, 20))
			ptc:SetEndSize(0)
			ptc:SetStartAlpha(255)
			ptc:SetEndAlpha(100)
			ptc:SetAirResistance(50)
		end
		
		self.emtTime = CurTime() + 0.05
	end
end