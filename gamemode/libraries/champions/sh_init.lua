/*
	League Wars
	Champion
	Shared
*/

LW.Champions = {};
LW.Champions.Config = {};
LW.Champions.Config.Path = "lw/gamemode/champions/";
LW.Champions.Stored = {};

function LW.Champions:Load()
	LW.Debug:Print(
		LW.Debug.Colors.white,
		" ====================\n",
		LW.Debug.Colors.orange,
		"      Champions\n",
		LW.Debug.Colors.white,
		"===================="
	);
	local files, folders = file.Find( self.Config.Path .. "*", "LUA" );
	for _,file in pairs( files ) do
		if( SERVER ) then
			AddCSLuaFile( self.Config.Path .. file );
		end;
		include( self.Config.Path .. file );
	end;
end;

function LW.Champions:Register( CHAMPION )
	if( CHAMPION.Name ) then
		LW.Debug:Print(
			LW.Debug.Colors.white,
			" - " .. CHAMPION.Name .. " " .. #CHAMPION.Abilities .. " Abilities"
		);
		self.Stored[CHAMPION.Name] = CHAMPION;

		player_manager.RegisterClass( CHAMPION.Name, CHAMPION, "champion_base" );
	end;
end;

function LW.Champions:GetData( name )
	return self.Stored[name];
end;

function LW.Champions:GetStat( name, stat )
	local champion = self:GetData( name );
	local base = string.Split( name, " " );
	local value = 0;
	if( #base > 1 ) then
		local data = champion.BaseStats[base[1]];
		value = data[base[2]];
	else
		value = champion.BaseStats[base[1]];
	end;
	return value;
end;

function LW.Champions:GetMaxHealth( name )
	return self:GetStat( name, "Health Base" );
end;

function LW.Champions:GetMana( name )
	return self:GetStat( name, "Mana Base" );
end;

LW.Champions:Load();