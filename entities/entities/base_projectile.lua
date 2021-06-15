AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	self:DrawShadow(false)

	self.lastTime = CurTime()
	
	local pos = self:GetPos()
	local dir = self:GetForward()
	self.spos = pos
	self.oldpos = pos
	self.nextpos = pos
	self.pos = pos
	self.dir = dir

	self.filter = {}

	if (IsValid(self:GetTarget())) then
		self.targeting = true
	end

	if (self.ProjHitPenetrate) then
		self.hits = {}
	end
	
	if (!self.ProjMaxDistance) then
		self.worldTimer = CurTime() + 6
	end
	
	if (CLIENT) then
		local snd = self.ProjSound
		if (snd) then
			if (istable(snd)) then
				self:EmitSound(table.Random(snd), 75)
			else
				self:EmitSound(snd, 75)
			end
		end
	end
	
	if (self.Init) then self:Init() end
end

function ENT:Think()
	local ct = CurTime()
	local dt = ct - self.lastTime
	local owner = self:GetOwner()

	if SERVER then
		if IsValid(owner) && !owner:Alive() then
			self:Remove()
		end	
	end
	
	if (self.targeting) then
		local target = self:GetTarget()
		local offset = (target:GetPos() + Vector(0, 0, 36)) - self.oldpos
		local normal = offset:GetNormal()
		local dist = offset:Length()
		local desired = util.Desired2D(offset, self.ProjSpeed)

		self.oldpos = self.nextpos
		self.nextpos = self.nextpos + desired * dt
	else
		self.oldpos = self.nextpos
		self.nextpos = self.oldpos + self.dir * self.ProjSpeed * dt

		local maxDist = self.ProjMaxDistance
		if (maxDist) then
			local dist = (self.spos - self.nextpos):Length()
			if (dist >= maxDist) then
				self.nextpos = self.spos + self.dir * maxDist
				self.pos = self.nextpos
				
				if (SERVER) then
					self:CheckCollision()
					self:Remove()
				end
				return
			end
		else
			if (SERVER) then
				if (util.IsInWorld(self.pos)) then
					self.worldTimer = CurTime() + 6
				else
					if (self.worldTimer && self.worldTimer <= CurTime()) then
						self:Remove()
						return
					end
				end
			end
		end
	end

	if (SERVER) then
		self:SetPos(self.nextpos)
	end

	self.pos = self.nextpos

	if (SERVER) then
		self:CheckCollision()
	end
	
	if (self.Update) then self:Update(dt) end
	
	self.lastTime = ct

	self:NextThink(ct)
	return true
end

function ENT:CheckCollision()
	local find = util.FindInDistOBB2D({
		startpos = self.oldpos,
		endpos = self.nextpos,
		width = self.ProjCollisionSize
	})

	if (!find) then return end

	for _, ent in ipairs(find) do
		if (self.targeting && !self.ProjHitBlocking && ent != self:GetTarget()) then continue end
		self:OnCollision(ent, remove)
	end
end

function ENT:OnCollision(ent, remove)
	if (!self.filter[ent]) then
		self.filter[ent] = true
	

		local owner, _team = self:GetOwner()
		if (IsValid(owner)) then
			_team = owner:Team()
		else 
			_team = self:Team()
		end

		if (_team == ent:Team()) then return end

		-- local ent = ent:GetHeroData()

		ent:GiveDamage(self.ProjHitDamage, DMG_AD, owner)

		if (self.OnCollisionEnter) then
			self:OnCollisionEnter(ent)
		end

		if (!self.ProjHitPenetrate) then
			self:Remove()
		end
	end
end

function ENT:Draw()
end

function ENT:OnRemove()
end