local ABILITY = {};
ABILITY.Name = "Test SPell";
ABILITY.Key = KEY_R;
ABILITY.Texture = "lw/champions/anna/r.png"
ABILITY.Cooldown = 2;
ABILITY.ManaCost = 70;

ABILITY.OnCast = function( )
	
end;

LW.Abilities:Register( ABILITY );