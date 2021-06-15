AddCSLuaFile()

ENT.Type = "anim"

ENT.Range = 200

function ENT:Initialize()
	self:SetModel("models/lw/lol/lol_orderturretangel.mdl")
	self:SetModelScale(0.5, 0)
	self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 64))
	self:SetHealth(1000)

	if CLIENT then
		-- self.boneID = self:LookupBone("LookupBone")
		-- self.bonePos = self:GetBonePosition(self.boneID)

		for i=1, self:GetBoneCount() do
			print(self:GetBoneName(i))
		end
	end

	if SERVER then
		self:SetMaxHealth(1000)		
	end
end

function ENT:Think()
	if (CLIENT) then return end

	local find = util.FindInSphere2D(self:GetPos(), self.Range, self:Team())[1]
	if (find) then
		-- local ent = ents.Create("lw_projectile_tower")
		-- ent:SetTarget(find)
		-- ent:SetTeam(self:Team())
		-- ent:SetPos(self:GetPos() + Vector(0, 0, -26))
		-- ent:Spawn()

		-- local viewAng = (find:GetPos() - self:GetPos()):Angle()
		-- self:SetAngles(Angle(0, viewAng.y, 0))
	end

	-- self:SetPos(self:GetPos() + Vector(3, 0, 0))
	self:NextThink(CurTime() + 1.5)
	return true
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)

	if(self:Health() <= 0) then return end

	local newHP = self:Health() - dmg:GetDamage()
	self:SetHealth(newHP)

	if(self:Health() <= 0) then
	  self:Remove()
	end
end

function ENT:DrawHealthBar(x, y)
	local w,h = 200, 12
	local barW = self:Health() / self:GetMaxHealth() * w
	surface.SetDrawColor(Color(55, 55, 55, 155))
	surface.DrawRect(x - w/2, y - 150, w, h)	

	surface.SetDrawColor(Color(200, 50, 50, 255))
	surface.DrawRect((x - w/2) + 2, (y - 150) + 2, barW - 4, h - 4)

	draw.DrawText("" .. self:Health(), "DefaultBold_26", x, y , Color(255, 255, 255), TEXT_ALIGN_CENTER)

end

function ENT:Draw()
	self:DrawModel()
	cam.Start3D2D(self:GetPos() - Vector(0, 0, 32), Angle(), 1)
		surface.SetDrawColor(0, 0, 255, 50)
		draw.NoTexture()
		draw.Circle(0, 0, self.Range, 64)
	cam.End3D2D()

	-- could draw in 3d space but idk
	-- local yaw = (LW.cam.view.pos - self:GetPos()):Angle().yaw + 90
	-- cam.Start3D2D(self:GetPos() + Vector(0, 0, 102), Angle(0, yaw, 90), 1)
	-- 	local w,h = 100, 6
	-- 	local barW = self:Health() / self:GetMaxHealth() * w
	-- 	surface.SetDrawColor(Color(255, 0, 0, 255))
	-- 	surface.DrawRect(-(w/2), 0, barW, h)
	-- cam.End3D2D()
end
