AddCSLuaFile()

SWEP.PrintName = ""
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Weight = 0
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.ViewModelFOV		= 50

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.Act)
end

function SWEP:Deploy()
	return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()
end

function SWEP:Think()
end