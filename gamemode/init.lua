LW = ( LW || GM || GAMEMODE );

AddCSLuaFile( "libraries/sh_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "libraries/sh_init.lua" );
include( "shared.lua" );

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(TEAM_PURPLE);

	player_manager.SetPlayerClass( ply, "Anna" );
	player_manager.RunClass( ply, "Init" );
end;

function GM:PlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" );
end;

function GM:PlayerDeath( ply )
	player_manager.RunClass( ply, "Death" );
end;

function GM:PlayerDeathThink( ply )
	player_manager.RunClass( ply, "DeathUpdate" );
end;

function GM:PlayerDeathSound( ply )
	-- player_manager.RunClass( ply, "DeathSound" );
	-- return true;
end;

function GM:PlayerConnect( ply )
	
end;

function GM:PlayerDisconnected( ply )	
	player_manager.RunClass( ply, "Disconnected" );
end;


concommand.Add("lw_team", function(ply, cmd, args)
	if #args <= 0 then return false end
	ply:SetTeam(args[1])
end)

concommand.Add("lw_set_hero", function(ply, cmd, args)
	if #args <= 0 then return false end
	ply:UnSpectate()
	ply.spectate = false
	ply:KillSilent()	
	player_manager.SetPlayerClass(ply, args[1])
	ply:Spawn()
	player_manager.RunClass(ply, "Init")

end)

function GM:ShowSpare1(ply)
	ply:ConCommand("lw_team_menu")
end