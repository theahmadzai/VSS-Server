/*---------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                 Vice Super Stunt
----------------------------------------------------------------------------------------------------------------------------------------------------------*/

const ICOL_WHITE    = "\x000300";
const ICOL_BLACK    = "\x000301";
const ICOL_BLUE     = "\x000302";
const ICOL_GREEN    = "\x000303";
const ICOL_RED      = "\x000304";
const ICOL_BROWN    = "\x000305";
const ICOL_PURPLE   = "\x000306";
const ICOL_ORANGE   = "\x000307";
const ICOL_YELLOW   = "\x000308";
const ICOL_LGREEN   = "\x000309";
const ICOL_CYAN     = "\x000310";
const ICOL_LCYAN    = "\x000311";
const ICOL_LBLUE    = "\x000312";
const ICOL_PINK     = "\x000313";
const ICOL_GREY     = "\x000314";
const ICOL_LGREY    = "\x000315";
const ICOL          = "\x0003";
const ICOL_BOLD     = "\x0002";
const ICOL_ULINE    = "\x0031";

const VSS_NICK = "VSS-Server";
const VSS_BPASS = "javedhamza420";
const VSS_SERVER = "94.23.157.172";
const VSS_PORT = 6667;	
const VSS_CHAN = "#VSS";
const VSS_CPASS = "";

class VSSLIST
{
	Name = null;
	Level = 1;
}

function VSSLIST::AddNick( szNick, iAdmin )
{
	Name = szNick;
	Level = iAdmin;
}

function ActivateEcho()
{
    print( "[Loaded] - VSS-Server IRC-Echo.");
	print( "[Confirming] - VSS-Echo bot details..." );
	VSS_BOT <- NewSocket( "VSSProcess" );

	VSS_BOT.Connect( VSS_SERVER, VSS_PORT );
	VSS_BOT.SetNewConnFunc( "VSSLogin" );
	print( "[Confirmed] - Bot details!" );
	
	VSS_NICKS <- array( 50, null );
}

function DisconnectBots()
{
	print( "[Disconnecting] - VSS-Bots from IRC..." );
	
	VSS_BOT.Send( "QUIT " + VSS_NICK + "\n" );
	VSS_BOT.Delete();
	
	print( VSS_NICK + " has Successfully Disconnected From IRC." );
}

function VSSLogin()
{
	print( "[Attempting] - to set user, nick and mode...." );
	VSS_BOT.Send( "USER " + VSS_NICK + " 0 * :[r2] > Vice Super Stunt < [r2]\n" );
	VSS_BOT.Send( "NICK " + VSS_NICK + "\n" );
	VSS_BOT.Send( "MODE " + VSS_NICK + " +B\n" );
	print( "Task completed successfully." );
}

function VSSProcess( sz )
{
  local raw = split( sz, "\r\n" ), a, z = raw.len(), line;
	
	for ( a = 0; a < z; a++ )
	{
		line = raw[ a ];
		
		local VSS_PING = GetTok( line, " ", 1 ), VSS_EVENT = GetTok( line, " ", 2 ), VSS_CHANEVENT = GetTok( line, " ", 3 ), 
		Count = NumTok( line, " " ), Nick, Command, Prefix, Text;
		if ( VSS_PING ) VSS_BOT.Send( "PONG " + VSS_PING + "\n" );
		
		if ( VSS_EVENT == "001" )
		{
			if ( VSS_BOT )
			{
				VSS_BOT.Send( "PRIVMSG NickServ IDENTIFY " + VSS_BPASS + "\n" ); 
				VSS_BOT.Send( "MODE " + VSS_NICK + " +B\n" );
				VSS_BOT.Send( "JOIN " + VSS_CHAN + " " + VSS_CPASS + "\n" ); 
				
			    EchoMessage( ICOL_LGREEN + "-> VSS Channel has Successfully Connected to the Server." );
                Message( "-> VSS Channel has now re-connected to the server." );                                                               
				print( "Successfully Joined " + VSS_CHAN + "!" );
			}
		}
		else if ( VSS_EVENT == "353" ) VSSSortNicks( sz );
		else if ( ( VSS_EVENT == "MODE" ) || ( VSS_EVENT == "NICK" ) || ( VSS_EVENT == "JOIN" ) || ( VSS_EVENT == "PART" ) || ( VSS_EVENT == "QUIT" ) ) VSS_BOT.Send( "NAMES :" + VSS_CHAN + "\n" );
		if ( VSS_CHANEVENT == VSS_CHAN )
		{
			Nick = GetTok( line, "!", 1 ).slice( 1 );
			Command = GetTok( line, " ", 4 );
			Prefix = Command.slice( 1, 2 );
			Command = Command.slice( 1 );
			
		  if ( NumTok( line, " " ) > 4 ) Text = GetTok( line, " ", 5, Count );
		  else Command = split( Command, "\r\n" )[ 0 ];

		  /*
		  if ( ( Prefix == "!" ) && ( Count > 4 ) ) VSSIrcCommand( Nick, Command.tolower(), Text );
		  else if ( ( Prefix == "!" ) && ( Count == 4 ) ) VSSIrcCommand( Nick, Command.tolower(), null );
		  */
		  if (Nick && Command && Text) { VSSIrcCommand( Nick, Command, Text ); }
		  else if (Nick && Command) { VSSIrcCommand( Nick, Command, null ); }
		}
	}
}

function LevelTag(lvl) {
	lvl = (lvl ? lvl:0);
	switch (lvl) {
	case 2:
		return "Collaborator>";
	case 3:
		return "Moderator>";
	case 4:
		return "Admin>";
	case 5:
		return "Manager>";
	case 6:
		return "Owner>";
	default:
		return "IRC>";
	}
}
function lLevelTag(lvl) {
	lvl = (lvl ? lvl:0);
	switch (lvl) {
	case 2:
		return "11";
	case 3:
		return "7";
	case 4:
		return "3";
	case 5:
		return "4";
	case 6:
		return "12";
	default:
		return "5";
	}
}

function VSSIrcCommand( user, cmd, text )
{
	local NickInfo = FindNick( user ), level, tLevel;
	
	if ( NickInfo ) level = NickInfo.Level.tointeger();
	if (cmd) {
		if (cmd.slice(0,1)  == "." && cmd.len() > 1) {
			if(user=="VSS-IRC")ClientMessageToAll("TIP: "+text,240,210,190);
			else
			{
				local msg = "** " + LevelTag(level) + " " + user + ": " + cmd.slice(1);
				if (text) msg = msg + " " + text;
				EchoMessage(lLevelTag(level) + msg);
				Message(msg);
			}
		}
	}
	
	if ( cmd == "!say" )
	{
		if ( !text ) EchoMessage( ICOL_RED + " Error - Syntax: " + cmd + " <text> " );
		else
		{
		    if ( level == 6 ) { EchoMessage( ICOL_BLUE + "Owner> " + user + ": " + text ); Message( "Owner> " + user + ": " + text ); }
            else if ( level == 5 ) { EchoMessage( ICOL_RED + "Manager> " + user + ": " + text ); Message( "Manager> " + user + ": " + text ); }
            else if ( level == 4 ) { EchoMessage( ICOL_GREEN + "Admin> " + user + ": " + text ); Message( "Admin> " + user + ": " + text ); }
			else if ( level == 3 ) { EchoMessage( ICOL_PURPLE + "Moderator> " + user + ": " + text ); Message( "Moderator> " + user + ": " + text ); }
			else { EchoMessage( ICOL_BROWN + user + ": " + text ); Message( "IRC> " + user + ": " + text ); }
		}
	}
	else if ( ( cmd == "!admin" ) || ( cmd == "!admins" ) )
	{
		local b = null;
		foreach(a,val in players)
		{
			local plr = FindPlayer( players[a].tointeger() );
			if ( plr )
			{
				local lvl =  GetLevel( plr );
				
				if ( lvl >= 2 )
				{
					if ( b ) b = b + " - " + plr.Name + " ";
					else b = plr.Name + " ";
				}
			}
			
		}
		if ( b ) { EMessage( "> Admins online: " + b ); EchoMessage( ICOL_BLUE + "> Admins online: " + b ); }
		else EchoMessage( ICOL_RED + "Administrators are not Online." );
	}
	else if ( ( cmd == "!cmds" ) || ( cmd == "!commands" ) )
    	 {
   		EchoNotice( user, ICOL_ORANGE + " !hp, !arm, !say, !irc, !me, !players, !admins, !rules, !script, !info, !ping, !server ." );
     	}
		else if ( ( cmd == "!acmds" ) || ( cmd == "!admincmds" ) )
    	 {
		if ( level < 2 ) EchoNotice( user, ICOL_RED + "[Error] - Your level is not high enough to use that command." );
   		else EchoNotice( user, ICOL_LGREEN + " !getip, !exe, !kick, !ban, !ann, !freeze, !unfreeze, !annall, !slap, !drown, !kill, !warn,!unwarn." );
     	}

   
       
	else if ( cmd == "!ping" )
    {
		if ( !text ) EchoNotice( user,"Error - Invalid format." );
        else 
        {
			local plr = FindPlayer( GetTok( text, " ", 1 ) );
			if ( !plr ) EchoNotice( user, "Error - Invalid player." );
			else EMessage( "" + plr.Name + "'s Ping: " + plr.Ping + ". " );
		}
	}
    
	
	else if  ( cmd == "!server" ) 
    {
		EchoMessage(  ICOL_PURPLE + "Server Name: " + GetServerName() );
        EchoMessage(  ICOL_ORANGE + "Game-Mode: " + GetGamemodeName() );
        EchoMessage(  ICOL_LGREEN + "Map: " + GetMapName() );
        EchoMessage(  ICOL_PINK + "Player Slots: " + GetMaxPlayers() );
   	}
        
    else if  ( cmd == "!script" ) 
	{
   		EchoMessage(  ICOL_PURPLE + "The server is scripted by :- JaVeD" );
        EchoMessage(  ICOL_ORANGE + "Script Version: v0.3e" );
   	}
    
    else if  ( cmd == "!info" ) 
	{
   		EchoMessage(  ICOL_PURPLE + "Forum:" );
        EchoMessage(  ICOL_ORANGE + "http://Vcmp.RPGKillerS.Com" );
   	}
    
      else if ( cmd == "!arm" )
    {
		if ( !text ) EchoNotice(user,"Error - Require Syntax: "+cmd+" <Nick/ID>");
		else 
		{
			local plr = FindPlayer( GetTok( text, " ", 1 ) );
			if ( !plr ) EchoNotice(user,"Error - Invalid Nick/ID");
			EchoMessage("7["+plr.ID+"]10 "+plr+" Armour:[ "+plr.Armour+"'% ]");
			Message("["+plr.ID+"] "+plr.Name+" Armour:[ "+plr.Armour+"'% ]");
 		}
 	}
    else if ( cmd == "!hp" ) 
	{
		if ( !text ) EchoNotice(user,"Error - Require Syntax: "+cmd+" <Nick/ID>");
		else 
		{
			local plr = FindPlayer( GetTok( text, " ", 1 ) );
			if ( !plr ) EchoNotice(user,"Error - Invalid Nick/ID");
			EchoMessage("7["+plr.ID+"]6 "+plr+" Health:[ "+plr.Health+"'% ]");
			Message("["+plr.ID+"] "+plr+" Health:[ "+plr.Health+"'% ]");
		}
	}
	               else if ( cmd == "!ann" )
	    {
	    if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID/all> <Message> ");
	    else if (GetTok( text, " ", 1 ).tolower() =="all")
		{
			local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
			AnnounceAll( msg );
		    EchoMessage( ICOL_LGREEN + "Sent Announcement:[ " + msg + " ] to all players" );
		}
		else 
		{
		    local plr = FindPlayer( GetTok( text, " ", 1 ) );
		    if ( !plr ) EchoNotice( user, "Unknow player." );
		    else
			   {
			   local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
		       Announce( msg, plr, 0 );
			   EchoMessage( ICOL_LGREEN + "Sent Announcement:[ " + msg + " ] to:[ " + plr.Name + " ]" );
			   }
		    }
	    }
		else if ( cmd == "!annall" )
	    {
	    if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
	    else if ( !text ) EchoNotice( user, ICOL_RED + "Error Syntax: " + cmd +  " <Message>");
	    else {
	        local msg = GetTok( text, " ", 2,NumTok( text, " "));
		    AnnounceAll( text, 0);
		    EchoMessage( ICOL_LGREEN + " " + user + " Sent Announcement to all players in game. Message:[ " + text + " ]" );
		    }
	    }
      
	else if ( cmd == "!freeze" )
	{
		if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
		    local plr = FindPlayer( GetTok( text, " ", 1 ) );
		    if ( !plr ) EchoNotice( user, "Error - Unknow player." );
		    else
			{
				local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
			    if ( !msg ) EchoNotice( user, "Error - Invalid format." );
                else 
				{
					EchoMessage( ICOL_LGREEN + "Freezed Player:[ "  + plr.Name +  " ]. Reason:[ " + msg + " ]" );
					Message( "Admin " + user + " has frozen "  + plr.Name +  ". Reason: " + msg + "." );
                    plr.IsFrozen = true;
                }
			}
		}
	}
	else if ( cmd == "!weather" )
	{
		if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <value>");
	    else 	SetWeather(text.tointeger());
	}

	else if ( cmd == "!mute" )
	{
		if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
            local plr = FindPlayer( GetTok( text, " ", 1 ) );
          	if (!plr) EchoNotice( user, " Error - Unknown player" );
		    else
		    {
				local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
			    if ( !msg ) EchoNotice( user, "Error - Invalid format." );
                else 
				{
                    EchoMessage( ICOL_LGREEN + "Muted Player:[ "  + plr.Name +  " ]. Reason:[ " + msg + " ]" );
					Message( "Admin " + user + " has muted "  + plr.Name +  " ]. Reason: " + msg + "." );
                    plr.IsMuted = true;
                }
			}
		}
	}
    
	else if ( cmd == "!unmute" )
    {
   		if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
   		else if ( !text ) EchoNotice( user, ICOL_RED + " Error - Syntax: !unmute <Nick/ID>" );
    	else 
        { 
            local plr = FindPlayer( GetTok( text, " ", 1 ) );
          	if (!plr) EchoNotice( user, " Error - Unknown Player" );
            EchoMessage( ICOL_BROWN + " Admin " + user + " has Un-Muted Player:[ " + plr.Name + " ]" );
			Message( "Admin " + user + " has un-muted " + plr.Name + "." );
          	plr.IsMuted = false;
     	}
	}
    else if ( cmd == "!slap" )
    {	 
		if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
		else 
		{
            local plr = FindPlayer( GetTok( text, " ", 1 ) );
            if ( !plr ) EchoNotice( user, "Error - Invalid player." );
            EMessage( "Admin " + user + " has slapped " + plr.Name + "." );
            plr.Health -= 20;
        }
    }
    else if ( cmd == "!kick" )
	{
	    if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
		    local plr = FindPlayer( GetTok( text, " ", 1 ) );
		    if ( !plr ) EchoNotice( user, "Error - Unknown player." );
		    else
		    {
			   local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
			   if ( !msg ) EchoNotice( user, "Error - Invalid format" );
               else 
			   {
					//EchoMessage( ICOL_LGREEN + "Kicked player:[ "  + plr.Name +  " ]. Reason:[ " + msg + " ]" );
					//Message( "Admin " + user + " has kicked "  + plr.Name +  ". Reason: " + msg + "." );
                   			Kick( plr, user, msg );
                }
			}
		}
	}
	else if ( cmd == "!warn" )
	{
	    if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
		    local plr =FindPlayer(GetTok( text, " ", 1 ));
			local reason = GetTok( text, " ", 2, NumTok( text, " " ) );
			if(plr)
			{
				if(reason)
				{	
					EMessage( "Admin "+user+" has warned "+plr.Name+". Reason: "+ reason +".");
					Setwarning(plr,Getwarning(plr)+1);
					QuerySQL( db, "INSERT INTO Warning (Name, IP, Reason, Admin) values ( '" + plr.Name + "', '" + plr.IP + "', '"+reason+"', '"+user+"' )" );
					pinfo[plr.ID].warnings++;
					if(Getwarning(plr)>17)
					{
						EMessage( "Auto-Banned: " + plr.Name + ". Reason: Exceeded the number of warn limits.");
						QuerySQL( db, "INSERT INTO Bans (Name, IP, Reason, Admin) values ( '" + plr.Name + "', '" + plr.IP + "', 'Exceeded the number of warn limits.', 'Auto' )" );
						Kick( plr, "auto", "Banned" );
					}
					else if (pinfo[plr.ID].warnings >3) Kick(plr,"auto","Exceeded the number of warn limits.");
				}
				else EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
			}
			else EchoNotice( user, "Error - Unknown player." );
		}
	}
	
	else if ( cmd == "!unwarn" )
	{
	    if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
		    local plr =FindPlayer(GetTok( text, " ", 1 ));
			if(plr)
			{
				ClientMessageToAll( "Admin "+user+" has unwarned "+plr.Name+".",159,204,280);
				Setwarning(plr,Getwarning(plr)-1);
				local q = QuerySQL( db, "SELECT Name FROM Warning WHERE IP LIKE '" + plr.IP + "'" );
				if(q) 
				{
					QuerySQL( db, "DELETE FROM Warning WHERE IP LIKE '" + plr.IP + "'" );
					EMessage( ICOL_CYAN + "Admin " + user + " has unwarrned:[ " + plr.Name + " ]" );
				}
				else EchoNotice(user, ICOL_RED +"Error - that player is not warned!");
				if(pinfo[plr.ID].warnings>0)
				pinfo[plr.ID].warnings--;
			}
			else EchoNotice( user, ICOL_RED + "Error - Unknown Player");
		}
	}
	
    else if ( cmd == "!getip" )
    {
		if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
		else if ( !text ) EchoNotice( user,"Error - Invalid format" );
        else 
        {
			local plr = FindPlayer( GetTok( text, " ", 1 ) );
			if ( !plr ) EchoNotice( user, ICOL_RED +  "Error - Unknown player." );
			else EchoMessage( ICOL_RED +  "Name: [ " + plr + " ] IP: [ " + plr.IP + " ]" );
		}
	}
    
	else if ( cmd == "!ban" )
	{
	    if ( level < 3 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
		    local plr = FindPlayer( GetTok( text, " ", 1 ) );
			local Reason = GetTok( text, " ", 2, NumTok( text, " " ) );
		    if ( !plr ) EchoNotice( user, "Error - Unknown player." );
			else if ( !Reason ) EchoNotice( user, "Error - Syntax: " + cmd + " <Nick/ID> <Reason>" );
		    else
		    {
				local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
			    if ( !msg ) EchoNotice( user, "Error - Invalid format." );
                else 
				{
					//EMessage( ICOL_RED + "Banned Player:[ "  + plr.Name +  " ]. Reason:[ " + msg + " ]" );
					QuerySQL( db, "INSERT INTO Bans (Name, IP, Reason, Admin) values ( '" + plr.Name + "', '" + plr.IP + "', '" + Reason + "', '" + user + "' )" );
					Kick( plr,user,msg )
                }
			}
		}
	}
    
	else if ( cmd == "!drown" )
	{
	    if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
		    local plr = FindPlayer( GetTok( text, " ", 1 ) );
		    if ( !plr ) EchoNotice( user, "Error - Unknown player." );
		    else
		    {
				local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
			    if ( !msg ) EchoNotice( user, "Error - Invalid format." );
                else 
				{
                    EchoMessage( ICOL_LGREEN + "Drowned Player:[ "  + plr.Name +  " ]. Reason:[ " + msg + " ]" );
					Message( "Admin " + user + " has drowned "  + plr.Name +  ". Reason: " + msg + "." );
                    plr.Pos = Vector( 283.521 , -1574.3 , 7.19846 );
                }
			}
		}
	}
    
    else if ( cmd == "!kill" )
	{
	    if ( level < 2 ) EchoNotice( user, ICOL_RED + "Error - Your level is not high enough to use that command." );
        else if ( !text ) EchoNotice( user, ICOL_RED + "Error - Syntax: " + cmd + " <Nick/ID> <Reason> ");
	    else 
		{
		    local plr = FindPlayer( GetTok( text, " ", 1 ) );
		    if ( !plr ) EchoNotice( user, "Error - Unknown player." );
		    else
		    {
				local msg = GetTok( text, " ", 2, NumTok( text, " " ) );
			    if ( !msg ) EchoNotice( user, "Error - Invalid format." );
                else 
				{
					EchoMessage( ICOL_LGREEN + "Killed Player:[ "  + plr.Name +  " ]. Reason:[ " + msg + " ]" );
					Message( "Admin " + user + " has killed "  + plr.Name +  ". Reason: " + msg + "." );
                    plr.Pos = plr.Pos
                    plr.Health = 0;
                                                                }
			   }
		    }
	    }
    else if ( cmd == "!unfreeze" )
   	{
   		if ( level < 2 ) EchoNotice( user, ICOL_RED + " Error - Your Level is not Enough." );
   		else if ( !text ) EchoNotice( user, ICOL_RED + " Error - Syntax: !unfreeze <Nick/ID>" );
  		else 
        { 
            local plr = FindPlayer( GetTok( text, " ", 1 ) );
          	if (!plr) EchoNotice( user, " Error - Unknown Player" );
			EchoMessage( ICOL_BLUE + "Admin " + user + " has un-frozen " + plr.Name + "." );            Message( " **Admin " + user + " has Un-Frozen Player: [ " + plr.Name + " ] " );
            plr.IsFrozen = false;
        }        	
    }
    else if ( cmd == "!rules" )
	{
        EchoMessage( ICOL_BROWN + "RULES: No deathmatching, No cheating(Armour, Hp, Speed etc), No insulting, Cops are not allowed in any way to team with the criminals, No spamming. These are the basic rules, more at http://VSS.forum.st/" ); Message( "RULES: No deathmatching, No cheating(Armour, Hp, Speed etc), No insulting, Cops are not allowed in any way to team with the criminals, No spamming. These are the basic rules, more at http://VSS.forum.st/" );
	}
	else if ( cmd == "!players" ) 
	{
		local b = null,c=0;
		foreach(a,val in players)
		{
			local plr = FindPlayer( players[a].tointeger() );
			if ( plr ) 
			{
				if ( b ) b=b+", ["+plr.ID+"] "+plr.Name
				else b = "["+plr.ID+"] "+plr.Name
				c++;
			}
			
		}
		if ( b ) EchoMessage( "2-> 12Players: 5[" + c + "/" + GetMaxPlayers() + "] " + " - " + b  );
		else EchoMessage( "4>Players: [ There are no players. ]" );
	}
	else if ( cmd == "!me" )
	{
		if ( !text ) EchoMessage( ICOL_RED + " Error - Syntax: " + cmd + " <text> " );
		else EchoMessage( user + " " + text );	
	}
				
    else if ( cmd == "!irc" )
	{
		{ EchoMessage( ICOL_GREEN + "> VSS IRC Channel: #LUnet > #VSS. "); Message( " > VSS IRC Channel: #LUnet > #VSS. " ); }
	}
}

function EMessage( text )
{
	Message( text );
	EchoMessage( text );
}

function EchoMessage( text )
{
	VSS_BOT.Send( "PRIVMSG " + VSS_CHAN + " " + text + "\n" );
}
function EchoNotice( nick, text )
{
	VSS_BOT.Send( "NOTICE " + nick + " " + text + "\n" );
}

function VSSSortNicks( szList )
{
	local a = NumTok( szList, " " );
	local NickList = GetTok( szList, " ", 6, a ), i = 1;
	
	VSS_NICKS <- array( 50, null );
	
	while( GetTok( NickList, " ", i ) != "366" )
	{
		local levelnick = GetTok( NickList, " ", i ), nick = levelnick.slice( 1 ), level = levelnick.slice( 0, 1 );
		
		if ( level == ":" ) { level = nick.slice( 0, 1 ); nick = nick.slice( 1 ); }
				
		if ( level == "+" ) AddNewNick( nick, 2 );
		else if ( level == "%" ) AddNewNick( nick, 3 );
		else if ( level == "@" ) AddNewNick( nick, 4 );
		else if ( level == "&" ) AddNewNick( nick, 5 );
		else if ( level == "~" ) AddNewNick( nick, 6 );
		else AddNewNick( nick, 1 );
		i ++;
	}
}

function AddNewNick( szName, iLevel )
{
	local i = FindFreeNickSlot();
	
	if ( i != -1 ) 
	{
		VSS_NICKS[ i ] = VSSLIST();
		VSS_NICKS[ i ].AddNick( szName, iLevel );
	}
}

function FindFreeNickSlot()
{
	for ( local i = 0; i < VSS_NICKS.len(); i++ )
	{
		if ( !VSS_NICKS[ i ] ) return i;
	}
	return -1;
}

function FindNick( szName )
{	
	for ( local i = 0; i < VSS_NICKS.len(); i++ )
	{
		if ( VSS_NICKS[ i ] )
		{
			if ( VSS_NICKS[ i ].Name == szName ) return VSS_NICKS[ i ];
		}
	}
	return null;
}

function GetTok(string, separator, n, ...)
{
	local m = vargv.len() > 0 ? vargv[0] : n,
		  tokenized = split(string, separator),
		  text = "";
	
	if (n > tokenized.len() || n < 1) return null;
	for (; n <= m; n++)
	{
		text += text == "" ? tokenized[n-1] : separator + tokenized[n-1];
	}
	return text;
}

function NumTok(string, separator)
{
	local tokenized = split(string, separator);
	return tokenized.len();
	local s = split(string, separator); 
    return s.len();
}
