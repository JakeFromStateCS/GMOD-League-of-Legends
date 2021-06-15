/*
	League Wars
	Champion PMeta
	Shared

	Champion Specific pMeta functions
*/

local pMeta = FindMetaTable( "Player" );

-- if( SERVER ) then

	function pMeta:SetStat( stat, value )
		self:SetNWInt( stat, value );
	end;

	function pMeta:SetMana( value )
		self:SetStat( "Mana", value );
	end;

	function pMeta:SetAttackDamage( value )
		self:SetStat( "Attack Damage", value );
	end;

	function pMeta:SetAttackSpeed( value )
		self:SetStat( "Attack Speed", value );
	end;

	function pMeta:SetArmor( value )
		self:SetStat( "Armor", value );
	end;

	function pMeta:SetArmorPen( value )
		self:SetStat( "Armor Penetration", value );
	end;

	function pMeta:SetMagicResist( value )
		self:SetStat( "Magic Resistance", value );
	end;

	function pMeta:SetMagicPen( value )
		self:SetStat( "Magic Penetration", value );
	end;

	function pMeta:SetHero( name )
		local data = LW.Champions:GetData( name );
		self:SetNWString( "Hero", name );
	end;

	function pMeta:UpdateStats( data )
		self:SetHealth( data.Health.Base );
		self:SetMana( data.Mana.Base );
		self:SetWalkSpeed( data.Movement.Speed );
		self:SetRunSpeed( data.Movement.Speed );
	end;

	function pMeta:SetRespawnTime( time )
		self:SetNWFloat( "Respawn Time", time );
	end;
-- end;

function pMeta:GetStat( stat )
	return self:GetNWInt( stat )
end;

function pMeta:GetMana()
	return self:GetStat( "Mana" );
end;

function pMeta:GetMoveSpeed()
	return self:GetStat( "Movement Speed" );
end;

function pMeta:GetBaseHealth()
	return self:GetStat( "Health Base" );
end;

function pMeta:GetAttackRange()
	return self:GetStat( "Attack Range" );
end;

function pMeta:SetAttackDamage( value )
	return self:GetStat( "Attack Damage" );
end;

function pMeta:SetAttackSpeed( value )
	return self:GetStat( "Attack Speed" );
end;

function pMeta:SetArmorPen( value )
	return self:GetStat( "Armor Penetration" );
end;

function pMeta:SetMagicResist( value )
	return self:GetStat( "Magic Resistance" );
end;

function pMeta:SetMagicPen( value )
	return self:GetStat( "Magic Penetration" );
end;

function pMeta:GetChampion()
	local class = player_manager.GetPlayerClass( self );
	return LW.Champions:GetData(class)
end;

function pMeta:GetAbilities()
	local class = player_manager.GetPlayerClass( self );
	return LW.Champions:GetData(class).Abilities
end;


function pMeta:GetBaseStat(str)
	return LW.Champions:GetStat(str)
end;