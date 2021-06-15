AddCSLuaFile();

DEFINE_BASECLASS( "player_default" );

local PLAYER = {};

function PLAYER:Init()
	self.Player.Cooldowns = {} --dont reset after every spawn Kappa
end;

function PLAYER:CastSpell(id)
	local ply = self.Player
	local spell = LW.Abilities:GetByID(id)

	local t = CurTime()
	ply.Cooldowns[id] = t

	/*
		dats what we want vs spells ids
		{
			[1] = 11121.0000,
			[2] = 11121,
			[3] = 11121,
			[4] = 11121,
		}
	*/
	
	-- local ab = ply:GetAbilities()
	-- for k,v in pairs(ab) do
	-- 	print( CurTime() - t )		
	-- end

end

function PLAYER:Spawn()
	local ply = self.Player;
	ply:SetRunSpeed( self.BaseStats.Movement.Speed );
	ply:SetModel( self.Model );
	ply:RemoveAllAmmo();
	ply:SetMaxHealth( self.BaseStats.Health.Base );
	ply:SetHealth( self.BaseStats.Health.Base );

	ply:SetMana( self.BaseStats.Mana.Base )

	print( "PLAYER:Spawn " .. ply:Nick() )

	-- ply:SetState( STATE_IDLE );
end;

function PLAYER:Death()
	local ply = self.Player;

	ply:SetRespawnTime( CurTime() + 3 );
end;

function PLAYER:DeathUpdate()
	local ply = self.Player;

	-- if ( ply:GetRespawnTime() < CurTime() ) then
		ply:Spawn();
	-- end;
end;

function PLAYER:KeyPress( ply, key )
	print("TESTING TO SEE IF THIS IS GETTING CALLED")
end


-- LOL : Im all moved movement scripts serverside
function PLAYER:CreateMove( cmd )
	local ply = self.Player;

	cmd:ClearMovement();
	cmd:ClearButtons();

	local moveSpeed = ply:GetRunSpeed();

	if ( ply:GetState() == STATE_MOVE ) then
		local offset = ( ply:GetWaypoint() - ply:GetPos() );
		local viewAngle = offset:Angle():Conv2D();
		local desiredSpeed = util.Desired2D( offset, moveSpeed ):Length();

		cmd:SetViewAngles( viewAngle );
		cmd:SetForwardMove( desiredSpeed );
	end;

	-- LW:ClientMoveUpdate(cmd)

end;

function PLAYER:StartMove( mv, cmd )
	local ply = self.Player;
end;

function PLAYER:Move( mv )
	-- local ply = self.Player;

	-- if ( ply:GetState() == STATE_MOVE ) then
	-- 	local clientSpeed = mv:GetForwardSpeed();
	-- 	local viewNormal = mv:GetMoveAngles():Forward();
	-- 	local vel = ( viewNormal * clientSpeed );

	-- 	mv:SetVelocity( vel );

	-- 	local velSpeed = mv:GetVelocity():Length();
	-- 	if ( !ply.stopMove && velSpeed > 0 ) then
	-- 		ply.stopMove = true;
	-- 	end;
	-- end;
end;

function PLAYER:FinishMove( mv )
	-- local ply = self.Player;

	-- local velSpeed = mv:GetVelocity():Length();
	-- if ( SERVER && ply:GetState() == STATE_MOVE && ply.stopMove && velSpeed == 0 ) then
	-- 	ply:SetState( STATE_IDLE );
	-- 	ply.stopMove = false;
	-- end;

	-- ply:SetNetworkOrigin( mv:GetOrigin() );

	-- print("H`")
end;


function PLAYER:Disconnected()	
	--remove projectiles / cleanup any shit that needs to be removed
end;

player_manager.RegisterClass( "champion_base", PLAYER, "player_default" );