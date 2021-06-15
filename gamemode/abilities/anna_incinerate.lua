local ABILITY = {};
ABILITY.Name = "Incinerate";
ABILITY.Key = KEY_W;
ABILITY.Texture = "lw/champions/anna/w.png"
ABILITY.Cooldown = 2;
ABILITY.ManaCost = 70;
ABILITY.OnCast = function( ply, pos, ang2D )
	if SERVER then
		local ent = ents.Create("projectile_ezreal_essenceflux")
		ent:SetPos(ply:GetForwardPos(pos))
		ent:SetAngles(ang2D)
		ent:SetOwner(ply)
		ent:Spawn()
	end	
end;

LW.Abilities:Register( ABILITY );