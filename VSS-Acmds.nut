//===============================================[ADMIN CMDS]=============================================================

/* function AdminCommands( player, cmd, text )
     {
	else if ( cmd == "banip" )
	{

		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <ID>", player );
			else
			{
				local plr = GetPlayer( GetTok( text, " ", 1 ) );
				if( !plr ) PrivMessage( "Unkown Player / Invalid ID", player );
				else
				{	
					local ip = plr.IP;
	
					ClientMessageToAll( "[Admin] " + player.Name + " Has BANNED Player " + plr.Name, 255, 0, 0 );
					ClientMessage( "You Have Been BANNED from this Server ", plr, 255, 0, 0 );
					BanIP( ip );	
					PrivMessage("IP Banned!", player );
				}
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );

	}

	else if ( cmd == "goto" )
	{


		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <Nick/ID>", player );
			else
			{
				local plr = GetPlayer( GetTok( text, " ", 1 ) );
				if( !plr ) PrivMessage( "Unkown Player / Invalid ID", player );
				else
				{
					MessagePlayer( "You have Teleported To: " + plr.Name, player );
					player.pos = plr.pos;
				}
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );

	}

	else if ( cmd == "get" )
	{


		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <Nick/ID>", player );
			else
			{
				local plr = GetPlayer( GetTok( text, " ", 1 ) );
				if( !plr ) PrivMessage( "Unkown Player / Invalid ID", player );
				else
				{
					MessagePlayer( "You have Teleported: " + plr.Name, player );
					plr.pos = player.pos;
				}
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );

	}

	else if ( cmd == "ann" )
	{

		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <text>", player );
			else
			{
				AnnounceAll( text, 0 );	
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );

	}

	else if ( cmd == "kick" )
	{

		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <Nick/ID>", player );
			else
			{
				local plr = GetPlayer( GetTok( text, " ", 1 ) );
				if( !plr ) PrivMessage( "Unkown Player / Invalid ID", player );
				else
				{
					MessagePlayer( "You have Kicked " + plr.Name, player );
					ClientMessageToAll( "[Admin] " + player.Name + " Has Kicked Player " + plr.Name, 255, 0, 0 );
					KickPlayer( plr );
				}
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );

	}

	else if ( cmd == "getip" )
	{

		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <Nick/ID>", player );
			else
			{
				local plr = GetPlayer( GetTok( text, " ", 1 ) );
				if( !plr ) PrivMessage( "Unkown Player / Invalid ID", player );
				else
				{
					MessagePlayer( plr.Name + "'s Ip is: " + plr.IP, player );
				}
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );

	}

	else if ( cmd == "unbanip" )
	{

		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <IP>", player );
			else
			{		
				UnbanIP( text );	
				PrivMessage("IP Un-Banned!", player );
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );

	}

	else if ( cmd == "mute" )
	{
		try
		{

		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <Nick/ID>", player );
			else
			{
				local plr = GetPlayer( GetTok( text, " ", 1 ) );
				if( !plr ) PrivMessage( "Unkown Player / Invalid ID", player );
				else if ( player.IsMuted ) PrivMessage( "Player is already muted", player );
				else
				{
					MessagePlayer( "You have Muted " + plr.Name, player );
					ClientMessageToAll( "[Admin] " + player.Name + " Has Muted Player " + plr.Name, 255, 0, 0 );
					player.IsMuted = true;
				}
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );
	}
	catch(e) print( "Mute cmd Error: " + e );
		}
		

	else if ( cmd == "unmute" )
	{

		if( stats[ player.ID ].admin >= 3 ) 
		{

		if ( !text ) PrivMessage( "Syntax, /c " + cmd + " <Nick/ID>", player );
			else
			{
				local plr = GetPlayer( GetTok( text, " ", 1 ) );
				if( !plr ) PrivMessage( "Unkown Player / Invalid ID", player );
				else if ( !player.IsMuted ) PrivMessage( "Player is already Un muted", player );
				else
				{
					MessagePlayer( "You have Muted " + plr.Name, player );
					ClientMessageToAll( "[Admin] " + player.Name + " Has Un-Muted Player " + plr.Name, 255, 0, 0 );
					player.IsMuted = false;
				}
			}
		}
		else PrivMessage("Your level is not higher enough to use this Admin command!", player );
	}





else if ( cmd == "addprop" )
	{
		        if ( GetLogged( player ) == "true" )
			    {
					if ( player.IsSpawned )
					{
						if ( text )
						{
							local TextSplit = split( text, " " );
							
							local Name = TextSplit[ 0 ], Cost = TextSplit[ 1 ];
							
							local x = player.Pos.x, y = player.Pos.y, z = player.Pos.z;
							
							QuerySQL( db, "INSERT INTO Properties ( Name, Cost, Owner, Shared, Pos ) values ( '" + Name + "', '" + Cost + "', 'None', 'None', '" + x + " " + y + " " + z + "' )" );
							
							local Pos = Vector( x.tofloat(), y.tofloat(), z.tofloat() );
							
							CreatePickup( 407, Pos );
							
							PrivMessage( "New Property - Name: " + Name + ", Cost: " + Cost, player );
						}
						else PrivMessage( "Usage: /c " + cmd + " <prop name> <cost>", player );
					}
					else PrivMessage( "Error - You haven't spawned.", player );
				}
			else PrivMessage( "Error - You are not logged in.", player );
	}

//==============================================================================================================================