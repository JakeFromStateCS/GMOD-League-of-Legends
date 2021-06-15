/*
	League Wars
	Net Library
	Shared

	Usage:
		LW.Net:Start( "MoveTo" );
			LW.Net:Write( Vector( 10, 10, 10 ) );
		LW.Net:Send();
*/

LW.Net = LW.Net or {};
LW.Net.Config = {};
LW.Net.Stored = {};
LW.Net.Types = {
	["Player"] = "Entity",
	["number"] = "Float",
	["string"] = "String",
	["boolean"] = "Bool"
};
LW.Net.NetMsg = "LeagueWars-NetMsg";
LW.Net.Cached = {};
LW.Net.CurrentMsg = "";

if( SERVER ) then
	util.AddNetworkString( LW.Net.NetMsg );
end;


--[[-------------------------------------------------------------------------
LW.Net:Register( String/netMsg, Function/func ):
	This function allows us to create new net messages
---------------------------------------------------------------------------]]
function LW.Net:Register( netMsg, func )
	self.Stored[netMsg] = func;
end;


--[[-------------------------------------------------------------------------
LW.Net:Start( String/netMsg ):
	This function starts the net message
	Used much the same as the net library
	Only this one does not require multiple networked strings
	All of the net messages are done with a single
	Networked string.
---------------------------------------------------------------------------]]
function LW.Net:Start( netMsg )
	net.Start( self.NetMsg );
		--This is the type of netmsg we're sending
		--They're all encapsulated in one though
		net.WriteString( netMsg );
		self.CurrentMsg = netMsg;
end;


--[[-------------------------------------------------------------------------
LW.Net:Write( Misc/val ):
	Writes any type to the cache for sending
	We must cache the types and values so
	When the client tries to receive the values
	It knows what type of values it is going to
	Be reading.
---------------------------------------------------------------------------]]
function LW.Net:Write( val )
	local valType = type( val );
	if( self.Types[valType] ) then
		valType = self.Types[valType];
	end;
	if( self.Cached[self.CurrentMsg] == nil ) then
		self.Cached[self.CurrentMsg] = {};
	end;
	table.insert(
		self.Cached[self.CurrentMsg],
		{
			valType,
			val
		}
	);
end;


--[[-------------------------------------------------------------------------
LW.Net:Send( Entity/target ):
	This functions essentially the same
	As the default net.Send.
	The difference is that it uses our cached values
	To let the client know what value types it will
	Be reading
---------------------------------------------------------------------------]]
function LW.Net:Send( target )

	local cache = self.Cached[self.CurrentMsg];
	local count = #cache;

	print("Size: " .. count)
	net.WriteString( self.CurrentMsg );	
	net.WriteFloat( count ); -- got to dynamically allocate bitsize of int

	for i=1, count do
		local data = cache[i];
		local valType = data[1];
		local val = data[2];

		local funcName = "Write" .. valType;
		local func = net[funcName];
		if( func ) then
			--We let the receiver know what type we're
			--About to send them
			net.WriteString( valType );
			func( val );
		end;
	end;
	target = target or player.GetAll();
	if( SERVER ) then
		net.Send( target );
	else
		net.SendToServer();
	end;

	--Clear our cache
	self.Cached[self.CurrentMsg] = nil;
	self.CurrentMsg = "";
end;


--[[-------------------------------------------------------------------------
LW.Net:Receive():
	First this function reads the Net Message name
	Essentially, the function we're going to call
	Then the function gets the number of arguments
	Being sent.
	After it gets the number, it for loops
	Then reads the value type, reads that type,
	Then stores the value into the values table

	From there, it calls our target function
	Using the values read as the arguments
	For the function.
---------------------------------------------------------------------------]]
function LW.Net:Receive()
	local netMsg = net.ReadString();
	local callFunc = LW.Net.Stored[netMsg];
	if( callFunc ) then
		local valCount = net.ReadFloat(); --then flo
		local values = {};
		print("DEV:" .. valCount)
		for i=1, valCount do
			local valType = net.ReadString();
			local func = net["Read" .. valType];
			if( func ) then
				local val = func();
				if( val ) then
					table.insert( values, val );
				end;
			end;
		end;
		callFunc( unpack( values ) );
	end;
end;
net.Receive( LW.Net.NetMsg, LW.Net.Receive );