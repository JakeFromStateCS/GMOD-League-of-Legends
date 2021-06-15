AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.health = 100

function ENT:Initialize()
	print("Spawned mob")
	self:SetModel("models/mossman.mdl")
	self:SetModelScale(0.55, 0)
	self:SetCollisionBounds(Vector(-4,-4, 0), Vector(4, 4, 64))
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetHealth(self.health)


	if (SERVER) then
		self.loco:SetAcceleration(300)
		self.loco:SetDeceleration(300)
		self.loco:SetStepHeight(18)
		self:SetMoveSpeed(80)
		self:SetMaxHealth(self.health)
		self:StartActivity(ACT_IDLE)

		self.targetPos = Vector()
	end
end

function ENT:RunBehaviour()
	while (true) do
		if (self.targetPos) then
			self:StartActivity(ACT_WALK)
			self:MoveToPos(self.targetPos, {repath = nil, maxage = 0.25, draw = false})
		end

		coroutine.yield()
	end
end

function ENT:Think()
	if (CLIENT) then return end

	self:NextThink(CurTime())
	return true
end

function ENT:SetMoveSpeed(speed)
	self.loco:SetDesiredSpeed(speed)
end