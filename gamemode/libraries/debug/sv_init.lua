
-- :=) --
concommand.Add( "test", function(ply, cmd, args)
	ply.spectate = true	
	ply:KillSilent()
	ply:Spectate(OBS_MODE_CHASE)

	ply:SetNWString("hero", nil)
	player_manager.ClearPlayerClass(ply)

	-- ply:SetClassID( 0 )

end );

concommand.Add("fuck", function()
	game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
end)


concommand.Add("tower_spawn", function(ply, _, args)
	if (!args[1]) then return end
	
	local ent = ents.Create("base_lw_tower")
	ent:SetTeam(args[1])
	ent:SetPos(ply:GetPos() + Vector(0, 0, 64))
	ent:Spawn()
end)

concommand.Add("tower_remove", function(ply, _, args)
		for k, v in pairs(ents.FindByClass("base_lw_tower")) do
		v:Remove()
	end
end)


concommand.Add("minion", function(ply, _, args)
	local pos = ply:GetEyeTrace().HitPos
	local minion = ents.Create("base_mob")
	minion:SetTeam(TEAM_BLUE)
	minion:SetPos(ply:GetPos())
	minion:Spawn()
end)
