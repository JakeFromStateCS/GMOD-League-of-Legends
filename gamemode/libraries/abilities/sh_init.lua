--[[
	League Wars
	Ability Loader
]]--
LW.Abilities = {};

LW.Abilities.Config = {};
LW.Abilities.Config.Path = "lw/gamemode/abilities/";
LW.Abilities.Stored = {};
LW.Abilities.IDLookUP = {};


--[[-------------------------------------------------------------------------
LW.Abilities:HandleFile( String/path, String/file ):
	Handles the file includes and cslua
---------------------------------------------------------------------------]]
function LW.Abilities:HandleFile( path, file )
	if( SERVER ) then
		AddCSLuaFile( path .. file );
	end;
	include( path .. file );
end;


--[[-------------------------------------------------------------------------
LW.Abilities:Load():
	Loads the abillities from our folder
	Defined in the Config.Path
---------------------------------------------------------------------------]]
function LW.Abilities:Load()
	local path = self.Config.Path;
	local files, folders = file.Find( path .. "*.lua", "LUA" );
	for _,file in pairs( files ) do
		self:HandleFile( path, file );
	end;
end;


--[[-------------------------------------------------------------------------
LW.Abilities:Register( Table/ABILITIY ):
	Called by each file in the abilities folder
	Used to register an ability for use on champions
---------------------------------------------------------------------------]]
function LW.Abilities:Register( ABILITY )
	if( ABILITY.Name ) then
		local id = #self.IDLookUP + 1;
		LW.Debug:Print(
			LW.Debug.Colors.white,
			"Registered Ability:",
			LW.Debug.Colors.yellow,
			ABILITY.Name,
			LW.Debug.Colors.white,
			" id: " .. id
		);
		ABILITY.id = id
		self.Stored[ABILITY.Name] = ABILITY;
		self.IDLookUP[id] = ABILITY.Name
	end;
end;

function LW.Abilities:Get( name )
	
	return self.Stored[name] or nil
	
end;

function LW.Abilities:GetNameByID( id )
	
	return self.IDLookUP[id]
	
end;

function LW.Abilities:GetByID( id )

	local name = self.IDLookUP[id]
	return self:Get(name)
	
end;

--[[-------------------------------------------------------------------------
	Server:
		KeyPressed:
			Get client champion table
			Get spell index based on key pressed
			Lookup spell table

		Global key table:
			{
				[KEY_Q] = 1,
				[KEY_W] = 2,
				[KEY_E] = 3,
				[KEY_R] = 4
			}
---------------------------------------------------------------------------]]

function LW.Abilities:OnCast( ply, spellID, pos, ang )	

	local name = self:GetNameByID( spellID )
	self.Stored[name].OnCast( ply, pos, ang )

	player_manager.RunClass( ply, "CastSpell", spellID );

end;

LW.Abilities:Load();
