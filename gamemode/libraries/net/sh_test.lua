/*
	League Wars
	Net Testing
*/

--test new net code

if( SERVER ) then
	/*
	LW.Net:Start("test")
		LW.Net:Write(1)
		LW.Net:Write(2)
	LW.Net:Send( player.GetAll()[2] );	
	*/
else	

	function TestNet( testArg1, testArg2 )
		--print( testArg1, testArg2 );
	end;
	LW.Net:Register( "test", TestNet );
end;