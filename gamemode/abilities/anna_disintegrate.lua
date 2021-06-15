local ABILITY = {};
ABILITY.Name = "Disintegrate";
ABILITY.Key = KEY_Q;
ABILITY.Cooldown = 2;
ABILITY.Texture = "lw/champions/anna/q.png"
ABILITY.ManaCost = 70;
ABILITY.OnCast = function( ply, pos, ang2D )
	if SERVER then
		local ent = ents.Create("projectile_ezreal_mysticshot")
		ent:SetPos(ply:GetForwardPos(pos))
		ent:SetAngles(ang2D)
		ent:SetOwner(ply)
		ent:Spawn()
	end	
end;

LW.Abilities:Register( ABILITY );