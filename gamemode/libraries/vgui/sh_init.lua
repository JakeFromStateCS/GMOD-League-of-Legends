/*
	League Wars
	Vgui
	sh_init.lua
*/

LW.Vgui = LW.Vgui or {};
LW.Vgui.Config = {};
LW.Vgui.Config.Path = "lw/gamemode/vgui/";

function LW.Vgui:Load()
	local files, folders = file.Find( self.Config.Path .. "*", "LUA" );
	for _,file in pairs( files ) do
		LW.Libraries:HandleFile( self.Config.Path, file );
	end;
end;

LW.Vgui:Load();