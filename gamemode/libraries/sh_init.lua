--[[
	League Wars
	Library Loader
	Please do not touch
	Unless you're into that kind of thing
	Also fucking up a bunch of necessary stuff

	Load Order:
		core,
		meta
]]--

LW.Libraries = {};
LW.Libraries.Config = {};
LW.Libraries.Config.Path = "lw/gamemode/libraries/";
LW.Libraries.LoadOrder = {
	"core",
	"meta"
};

function LW.Libraries:HandleFile( path, file )
	local prefix = string.sub( file, 1, 2 );
	local fullPath = path .. file;
	if( SERVER ) then
		if( prefix ~= "sv" ) then
			AddCSLuaFile( fullPath );
		end;
		if( prefix ~= "cl" ) then
			include( fullPath );
		end;
	elseif( CLIENT ) then
		if( prefix ~= "sv" ) then
			include( fullPath );
		end;
	end;
end;

function LW.Libraries:HandleFolder( path )
	local fullPath = self.Config.Path .. path .. "/";
	local files, folders = file.Find( fullPath .. "*", "LUA" );
	for _,folder in pairs( folders ) do
		self:HandleFolder( path .. "/" .. folder );
	end;
	for _,file in pairs( files ) do
		self:HandleFile( fullPath, file );
	end;
end;

function LW.Libraries:Load()
	--Load the core essentials
	for _,folder in pairs( self.LoadOrder ) do
		self:HandleFolder( folder );
	end;

	local files, folders = file.Find( self.Config.Path .. "*", "LUA" );
	for _,folder in pairs( folders ) do
		if( !table.HasValue( self.LoadOrder, folder ) ) then
			self:HandleFolder( folder );
		end;
	end;
end;

LW.Libraries:Load();