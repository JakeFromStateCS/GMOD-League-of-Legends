AddCSLuaFile()

ENT.Base = "base_mob"

function ENT:Initialize()
	self:SetModel("models/Roller_Spikes.mdl")
	self:SetHealth(100)
end

if SERVER then return end

function ENT:Draw()	
	self:DrawModel()


end