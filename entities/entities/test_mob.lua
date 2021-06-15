AddCSLuaFile()


ENT.Base = "base_nextbot"
ENT.Spawnable = true

function ENT:Initialize()

	self:SetModel("models/mossman.mdl")
	self:SetModelScale(0.75, 0)
	
	if (CLIENT) then return end

	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(900)		//default 400
	self.loco:SetDeceleration(900)		//default 400
	self.loco:SetStepHeight(18)			//default 18
	self.loco:SetJumpHeight(50)		//default 58

			self:StartActivity(ACT_RUN) -- run anim
			self.loco:SetDesiredSpeed(80) -- run speed	


	-- PrintTable(getmetatable(self))
	
end

-- Name: NEXTBOT:BehaveUpdate
-- Desc: Called to update the bot's behaviour
-- Arg1: number|interval|How long since the last update
-- Ret1:
--
/*
function ENT:BehaveUpdate(fInterval)

	if (!self.BehaveThread) then return end
	
	local ent = ents.FindInSphere( self:GetPos(), 120 )
	for k,v in pairs( ent ) do
		if v:IsPlayer() then
			self.loco:FaceTowards( v:GetPos() )
		end
	end
		
	local ok, message = coroutine.resume(self.BehaveThread)
	if (ok == false) then
		self.BehaveThread = nil
	end

end
*/

function ENT:RunBehaviour()
	while (true) do
		-- Find the player
		pos = Entity(1):GetPos()
		-- if the position is valid
		if (pos) then
					local opts = {	
				lookahead = 300,							
				tolerance = 20,							
				-- draw = true,
				maxage = 0.25,
				repath = 0.25	
			}
			
			self:MoveToPos(pos, opts) -- move to position (yielding)

		else
			-- some activity to signify that we didn't find shit
			self:StartActivity(ACT_RUN) -- walk anims
			self.loco:SetDesiredSpeed(80) -- walk speeds
			self:MoveToPos(self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200) -- walk to a random place within about 200 units (yielding)
		end

		coroutine.yield()

	end

end
