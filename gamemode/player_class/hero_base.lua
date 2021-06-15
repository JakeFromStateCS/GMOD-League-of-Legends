AddCSLuaFile()

DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 
PLAYER.respawnTime = 1

function PLAYER:Initialize()
	local this = self
	local ply = this.Player

	--initializing hero cooldown
	ply.cooldown = {}
	for i = 1, 4 do
		ply.cooldown[i] = 0
	end
	ply.ablQueue = {}
	
	ply._attackDelay = 0
	ply._animDelay = 0
	
	ply:SetNWInt("mana", self.baseMana)
	ply:SetNWString("hero", self.DisplayName)
	timer.Create("regenUpdate"..ply:UniqueID() , 1, 0, function()
		if not IsValid(ply) then return end
		if not ply:Alive() then return end
		ply:SetHealth(math.Clamp(ply:Health() + self.baseHealthRegen, 0, self.baseHealth))
		this:addMana(self.baseManaRegen)
	end)
end

function PLAYER:PlayerDisconnected()	
	
end

function PLAYER:PlayerDeath()
	self.Player:SetState(STATE_IDLE)
end

function PLAYER:addMana(amt)
	local mana = math.Clamp(self.Player:GetNWInt("mana") + amt, 0, self.baseMana)
	self.Player:SetNWInt("mana", mana)
end

function PLAYER:setMana(amt)
	self.Player:SetNWInt("mana", amt)
end

function PLAYER:castSpell(key)
	local spell = self.abilities[key]
	self:addMana(-spell.manaCost)
end

function PLAYER:OnHeroSpawn()
	local ply = self.Player

	ply:SetModel(self.Model)
	ply:Give(self.Weapon)
	ply:RemoveAllAmmo()
	ply:SetWalkSpeed(self.WalkSpeed)
	ply:SetRunSpeed(self.RunSpeed)
	ply:SetMaxHealth(self.baseHealth)
	ply:SetHealth(self.baseHealth)
	ply:SetNWInt("mana", self.baseMana)

	
end

player_manager.RegisterClass("hero_base", PLAYER, "player_default")
