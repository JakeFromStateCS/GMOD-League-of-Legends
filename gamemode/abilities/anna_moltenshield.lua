local ABILITY = {};
ABILITY.Name = "Molten Shield";
ABILITY.Key = KEY_E;
ABILITY.Texture = "lw/champions/anna/e.png"
ABILITY.Cooldown = 2;
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