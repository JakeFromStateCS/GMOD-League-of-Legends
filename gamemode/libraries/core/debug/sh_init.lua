/*
	League Wars
	sh_debug.lua
*/

LW.Debug = {};
LW.Debug.Config = {};
LW.Debug.Config.Enabled = false;
LW.Debug.Colors = {
	red = Color( 255, 100, 100 ),
	blue = Color( 100, 100, 255 ),
	green = Color( 100, 255, 100 ),
	yellow = Color( 255, 255, 100 ),
	purple = Color( 255, 100, 255 ),
	orange = Color( 255, 155, 100 ),
	white = Color( 255, 255, 255 ),
	black = Color( 0, 0, 0 )
};
LW.Debug.Config.PrintRealm = false;

function LW.Debug:Print( ... )
	if( !self.Config.Enabled ) then return end
	if( self.Config.PrintRealm ) then
		local realm = "Shared";
		if( SERVER and not CLIENT ) then
			realm = "Server";
		elseif( CLIENT and not SERVER ) then
			realm = "Client";
		end;
		MsgC(
			self.Colors.orange,
			realm,
			self.Colors.white,
			": "
		);
	end;
	local args = { ... };
	for i=1, #args, 2 do
		local col = Color( 255, 255, 255 );
		local msg = "";
		if( type( args[i] ) == "table" ) then
			col = args[i];
			msg = args[i+1];
		elseif( type( args[i] ) == "string" ) then
			msg = args[i];
		end;
		MsgC(
			col,
			msg .. " "
		);
	end;
	MsgC(
		"\n"
	);
end;

--[[
	LW.Debug:Print(
		LW.Debug.Colors.red,
		"Test",
		
	);
]]--