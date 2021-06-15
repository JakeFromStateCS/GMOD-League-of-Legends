local ABILITY = {};
ABILITY.Name = "Mystic Shot";
ABILITY.Key = KEY_Q;
ABILITY.Cooldown = 2;
ABILITY.ManaCost = 70;
ABILITY.OnCast = function( client, targetPos, ang2D )
	
end;

LW.Abilities:Register( ABILITY );