local ABILITY = {};
ABILITY.Name = "Summon: Tibbers";
ABILITY.Key = KEY_R;
ABILITY.Texture = "lw/champions/anna/r.png"
ABILITY.Cooldown = 2;
ABILITY.ManaCost = 70;
ABILITY.Levels = {
	6,
	11,
	16,
	18
};

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