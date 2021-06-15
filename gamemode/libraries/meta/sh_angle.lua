local meta = FindMetaTable( "Angle" );

function meta:Conv2D()
	return Angle( 0, self.y, 0 );
end;