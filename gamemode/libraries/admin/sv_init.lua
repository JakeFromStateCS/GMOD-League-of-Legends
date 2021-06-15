/*
	Temporary Admin Mod
*/

local pMeta = FindMetaTable( "Player" );

LW.Admin = {};
LW.Admin.Users = {
	"STEAM_0:1:14870977",
	"STEAM_0:0:18986981",
	"STEAM_0:1:20456822"
};

function pMeta:IsAdmin()
	if( table.HasValue( LW.Admin.Users, self:SteamID() ) ) then
		return true;
	end;
	return false;
end;

function pMeta:IsSuperAdmin()
	if( table.HasValue( LW.Admin.Users, self:SteamID() ) ) then
		return true;
	end;
	return false;
end;