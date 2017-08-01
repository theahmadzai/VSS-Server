/*---------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                Vice Super Stunt
----------------------------------------------------------------------------------------------------------------------------------------------------------*/

function CheckName( szParams )
    {
    local
        	FindName = QuerySQL( db, "SELECT * FROM Accounts WHERE Name='" + szParams + "'"),
			Name = GetSQLColumnData( FindName, 0 );
			FreeSQLQuery( FindName );
			
    if ( Name ) return Name;
    else return 0;
    }
	
function ChangePass( player, pass, pass2 )
{
 try
    {
	local 
	        FindPass  =   QuerySQL( db,"UPDATE Accounts SET Pass='" + pass + "' WHERE Name='" + player.Name + "'"),
			Pass      =   GetSQLColumnData( Pass );
		    FreeSQLQuery( FindPass );
			
	    MessagePlayer("You have Changed Your Password to [ " + pass2 + " ] ", player );
	}
	catch(e) print("ChangePass Function Error: " + e );
}

function ChangeName( player, text )
{
 try
    {
	SaveStats( player );
	local   
            FindName  =  QuerySQL( db, "UPDATE Accounts Set Name='" + text + "' WHERE Name='" + player.Name + "'"),
			Name      =  GetSQLColumnData( Name );
			FreeSQLQuery( FindName );
			
	    MessagePlayer("You have Changed Your Name to [ " + text + " ] ", player );
		MessagePlayer("Re-Join the Server with Name: " + text + ".", player );
		KickPlayer( player );
    }
	catch(e) print("ChangeName Function Error: " + e );
}

function SaveAllStats()
    {
	local
        	Player_Count = GetPlayers(),
			pPlayer;
			
	if ( !Player_Count ) return; 
	for ( local PlayerID = 0, PlayerCount = 0; PlayerID < GetMaxPlayers() && PlayerCount < Player_Count; PlayerID++ )
	    {
		if ( !( pPlayer = FindPlayer( PlayerID ) ) ) continue;
		
		    PlayerCount++;
			Stats[ pPlayer.ID ].Joins-=1;
            Stats[ pPlayer.ID ].SaveStats( pPlayer );
		    PrivMessage("Your Stats Saved Due to Reload Scripts!", pPlayer );
			SetCinematicBorder( pPlayer, false );
			AnnounceAll(" ");
        }
    }

function TheTimer()
    {
    if ( GetPlayers() >= 1 )
		{
		Timer ++;
	    local
        	Player_Count = GetPlayers(),
			pPlayer;
			
		if ( !Player_Count ) return; 	
	    for ( local PlayerID = 0, PlayerCount = 0; PlayerID < GetMaxPlayers() && PlayerCount < Player_Count; PlayerID++ )
	        {
            if ( !( pPlayer = FindPlayer( PlayerID ) ) ) continue;

		    PlayerCount++;
			if ( Stats[ pPlayer.ID ].Registered == true ) 
                {
	            Stats[ pPlayer.ID ].Seconds++; 
		        if ( Stats[ pPlayer.ID ].Seconds == 60 ) 
   	    	        {
    	    	        Stats[ pPlayer.ID ].Seconds = 0;
    	  	    	    Stats[ pPlayer.ID ].Minutes++;
			        }
    	        if ( Stats[ pPlayer.ID ].Minutes == 60 )
        	        {
            	        Stats[ pPlayer.ID ].Minutes = 0;
                	    Stats[ pPlayer.ID ].Hours++;
	                }			
                if ( Stats[ pPlayer.ID ].AutoMute == true )
                    {
				    Stats[ pPlayer.ID ].AutoMuteCount-=1;	
				    if ( Stats[ pPlayer.ID ].AutoMuteCount == 30 && Stats[ pPlayer.ID ].VIP >= 5 )
                        {	            
	                    if ( !pPlayer ) return 0;
                        else
                            { 	
	                            pPlayer.IsMuted = false;
						    	Stats[ pPlayer.ID ].AutoMute = false;
						    	Stats[ pPlayer.ID ].AutoMuteCount = 60;
	                            ClientMessage("You have been UnMuted, Don't Try to Spam Again!" pPlayer 255, 255, 255 );
		                    }
                        }
                    else if ( Stats[ pPlayer.ID ].AutoMuteCount == 0 )			
                        {	            
	                    if ( !pPlayer ) return 0;
                        else
                            { 	
	                            pPlayer.IsMuted = false;
						    	Stats[ pPlayer.ID ].AutoMute = false;
						     	Stats[ pPlayer.ID ].AutoMuteCount = 60;
	                            ClientMessage("You have been UnMuted, Don't Try to Spam Again!" pPlayer 255, 255, 255 );
		                    }	
                        }
                    }
                if ( Stats[ pPlayer.ID ].Muted == true )
                    {
					Stats[ pPlayer.ID ].MuteRem-=1;
                    if ( Stats[ pPlayer.ID ].MuteRem == 0 )			
                        {	            
	                    if ( !pPlayer ) return 0;
                        else
                            { 	
	                            pPlayer.IsMuted = false;
					    		Stats[ pPlayer.ID ].Muted = false;
						    	Stats[ pPlayer.ID ].MuteTime = 0;
	                            ClientMessage("You have been UnMuted!" pPlayer 255, 255, 255 );
		                    }	
                        }
                    }		
                if ( Stats[ pPlayer.ID ].Jailed == true )
                    {
					Stats[ pPlayer.ID ].JailTime-=1;
					Announce("\x10 \x10 \x10 \x10 \x10 ~y~ Jail Time ~w~" + Stats[ pPlayer.ID ].JailTime + " ~r~Seconds" pPlayer );
                    if ( Stats[ pPlayer.ID ].JailTime == 0 )			
                        {	            
	                    if ( !pPlayer ) return 0;
                        else
                            { 	
					    		Stats[ pPlayer.ID ].Jailed = false;
								onPlayerSpawn( pPlayer );
								Announce("\x10 \x10 ~p~ UnJailed!" pPlayer );
	                            ClientMessage("You have been Released from Jail!" pPlayer 255, 255, 255 );
		                    }	
                        }
                    }
                if ( Event == true )
                    {			
                    EventTime -=1;
                    if ( EventTime == 0 )
                        {						    		                    
                            ClientMessageToAll("Event Has been Auto Stopped, Event Time Over!" RandomColors[ rand() % RandomColors.len() ][0], RandomColors[ rand() % RandomColors.len() ][1], RandomColors[ rand() % RandomColors.len() ][2] ); 
	                   		AnnounceAll("\x10 \x10 \x10 \x10 \x10 ~r~ Event Over!");
	                		Event = false;
	                 		EventTime = 0;
			                EventReward = 0;                          
                        }
                    }						
                }											
    	    } 			
		while ( Timer == 30 )
	    	{
		    	//ClientMessageToAll( RandomMessages[ rand() % RandomMessages.len() ],RandomColors[ rand() % RandomColors.len() ][0], RandomColors[ rand() % RandomColors.len() ][1], RandomColors[ rand() % RandomColors.len() ][2] );
			    ClientMessageToAll( RandomMessages[ rand() % RandomMessages.len() ], rand() % 255, rand() % 255, rand () % 255 );  
				SetServerName( ServerNames[ rand() % ServerNames.len() ] );
				Timer = 0;
		    }	
		}
		else return 0;
	}
function WarnTime( pPlayer )
    {
	local pPlayer = FindPlayer( pPlayer );
	if ( !pPlayer ) return 0;
    else
        { 	
	    Stats[ pPlayer.ID ].Warned = false;
		}
    }	
function RCON( player )
    {
	if ( player.IsAdmin ) return "RCON ";
	else return "";
    }

function ArmourRank( player )
{ 
    {
    local ArmourRank = Stats[ player.ID ].Kills,AM;
	if (ArmourRank<=30) 
	    {
			AM = "10";
			player.Armour =10;
	    }
	else if (ArmourRank<=50) 
	    {
			AM = "20";
			player.Armour =20;
	    }
	else if (ArmourRank<=100)
	    {
			AM = "30";
			player.Armour =30;
	    }
	else if (ArmourRank<=150)
    	{
			AM = "40";
			player.Armour =40;
	    }
	else if (ArmourRank<=250)
    	{
			AM = "50";
			player.Armour =50;
	    }
	else if (ArmourRank<=350)
	    {
			AM = "60";
			player.Armour =60;
	    }
	else if (ArmourRank<=450)
     	{
			AM = "70";
			player.Armour =70;
	    }
	else if (ArmourRank<=550)
	    {
			AM = "80";
			player.Armour =80;
	    }
	else if (ArmourRank<=650)
	    {
			AM = "90";
			player.Armour =90;
	    }
	else if (ArmourRank>=750)
	    {
			AM = "100";
			player.Armour =100;
	    }
		PrivMessage(" " + AM + "% Armour From Your Killer Rank. ", player );
    }	
	return 0;
}

function KillerRank( player )
{
    {
	local Killz=Stats[ player.ID ].Kills,K;
	if (Killz<=30)
	    {
		    K = "Noob!";
			    return K; 
	    }
	else if (Killz<=50)
	    {
		    K = "Newbie";
			    return K;
	    }
	else if (Killz<=100)
	    {
			K = "New Killer";
			    return K;
	    }
	else if (Killz<=150)
	    {
			K = "Master Shooter";
			    return K;
	    }
	else if (Killz<=250)
	    {
			K = "Pro Shooter";
			    return K;
	    }
	else if (Killz<=350)
	    {
			K = "Elite Shooter";
			    return K;
	    }
	else if (Killz<=450)
	    {
			K = "Pyashco Shooter";
			    return K;
     	}
	else if (Killz<=550)
	    {
			K = "Extreme Shooter";
			    return K;
	    }
	else if (Killz<=650)
    	{
			K = "Wild Shooter";
			    return K;
	    }
	else if (Killz<=750)
    	{
			K = "Hawk Shooter";
			    return K;
	    }
	else if (Killz<=1000)
	    {
			K = "Rockstar Shooter";
			    return K;
	    }
	else if (Killz<=1250)
	    {
			K = "Professional Shooter";
			    return K;
	    }
	else if (Killz<=1500)
	    {
			K = "Real Shooter";
			    return K;
	    }
	else if (Killz<=1750)
	    {
			K = "Insane Shooter";
			    return K;
	    }
	else if (Killz<=10)
	    {
			K = "GodLike Shooter";
			    return K;
	    }
	else if (Killz<=2250)
	    {
			K = "Wolf Hunter";
			    return K;
	    }
	else if (Killz<=2500)
	    {
			K = "Night Hunter";
			    return K;
	    }
	else if (Killz<=3000)
	    {
			K = "BOSS!";
			    return K;
	    }
	else if (Killz<=5000)
	    {
			K = "DON!";
			    return K;
	    }
	else if (Killz>=5000)
	    {
			K = "The Best Of The Best";
			    return K;
	    }
	return 0;
	}
}	

function SpreeNote( player )
{
    {
	local BSpree=Stats[ player.ID ].BestSpree,S;
	if (BSpree<=4)
	    {
			S = "Noob!";
		        return S;
	    }
	else if (BSpree<=10)
	    {
			S = "Single Spree";
		        return S;
	    }
	else if (BSpree<=15)
	    {
			S = "Double Spree";
		        return S;
	    }
	else if (BSpree<=20)
	    {
			S = "Triple Spree";
		        return S;
	    }
	else if (BSpree<=25)
	    {
			S = "Big*BOSS Spree";
		        return S;
	    }
	else if (BSpree<=30)
	    {
			S = "GODLIKE";
		        return S;
	    }
	else if (BSpree<=35)
	    {
			S = "UnStopAble Spree";
		        return S;
	    }
	else if (BSpree<=40)
	    {
			S = "Hunter";
		        return S;
	    }
	else if (BSpree<=45)
	    {
			S = "Head Pawner";
		        return S;
	    }
	else if (BSpree>=50)
	    {
			S = "The Best Of The Best";
		        return S;
	    }
	return 0;
	}
}

function StunterRank( player )
{
    {
	local Stunts=Stats[ player.ID ].Stunt,S;
	if (Stunts<=30)
 	    {
			S = "Noob!";
		        return S;
	    }
	else if (Stunts<=50)
	    {
			S = "New Stunter";
		        return S;
	    }
	else if (Stunts<=100)
	    {
			S = "Best Stunter";
		        return S;
	    }
	else if (Stunts<=300)
	    {
	 		S = "Master Stunter";
		        return S;
	    }
	else if (Stunts<=500)
	    {
			S = "Pro Stunter";
		        return S;
	    }
	else if (Stunts>=1000)
	    {
			S = "The Best Of The Best";
		        return S;
	    }
	return 0;
	}
}	

function DrifterRank( player )
{
    {
	local Drifts=Stats[ player.ID ].Drift,D;
	if (Drifts<=30)
	    {
			D = "Noob!";
		        return D;
	    }
	else if (Drifts<=1000)
	    {
			D = "New Drifter";
		        return D;
	    }
	else if (Drifts<=2000)
	    {
			D = "Master Drifter";
		        return D;
	    }
	else if (Drifts<=3000)
	    {  
	 		D = "Pro Drifter";
		        return D;
	    }
	else if (Drifts<=4000)
	    {
			D = "Fire Tyres";
		        return D;
	    }
	else if (Drifts<=6000)
	    {
			D = "King Of The Street";
		        return D;
	    }
	else if (Drifts>=10000)
	    {
			D = "The Best Of The Best";
		        return D;
	    }
	return 0;
	}
}	

function Rank( player )
{
    {
	local Killz=Stats[ player.ID ].Kills, Stuntz=Stats[ player.ID ].Stunt, Driftz=Stats[ player.ID ].Drift,R;

	if ( ( Killz<=50 ) && ( Stuntz<=30 ) && ( Driftz<=500 ) )
	    {
		    R = "0";
		        return R;
	    }
	else if ( ( Killz<=100 ) && ( Stuntz<=50 ) && ( Driftz<=1500 ) )
	    {
		    R = "1";
		        return R;
	    }
	else if ( ( Killz<=200 ) && ( Stuntz<=100 ) && ( Driftz<=3000 ) )
	    {
		    R = "2";
		        return R;
	    }
	else if ( ( Killz<=400 ) && ( Stuntz<=300 ) && ( Driftz<=4000 ) )
	    {
			R = "3";
		        return R;
	    }
	else if ( ( Killz<=600 ) && ( Stuntz<=500 ) && ( Driftz<=6000 ) )
	    {
			R = "4";
		        return R;
	    }
	else if ( ( Killz>=1000 ) && ( Stuntz>=1000 ) && ( Driftz>=10000 ) )
	    {
			R = "5";
		        return R;
	    }
	return 0;
	}
}

function TopClanKills()
    {
        local 
        query = "SELECT ClanTag, ClanKills FROM ServerClans ORDER BY ClanKills DESC LIMIT 5", 
        q,
        name1, name2, name3, name4, name5,
        kills1, kills2, kills3, kills4, kills5, i = 1;
    
        q = QuerySQL( db, query );
        while( GetSQLColumnData( q, 0 ) )
        {
            switch(i)
            {
                    case 1:
                            name1 = GetSQLColumnData( q, 0 );
                            kills1 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 2:
                            name2 = GetSQLColumnData( q, 0 );
                            kills2 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 3:
                            name3 = GetSQLColumnData( q, 0 );
                            kills3 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 4:
                            name4 = GetSQLColumnData( q, 0 );
                            kills4 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 5:
                            name5 = GetSQLColumnData( q, 0 );
                            kills5 = GetSQLColumnData( q, 1 ); 
                            break;
            }
            GetSQLNextRow( q );
           i++;
		}
	
        FreeSQLQuery(q);
        Message("=====> Top 5 Clans <===== ");
		ClientMessageToAll("1 - " + name1 + " Clan Kills: " + kills1 + " ", 255,255,0 );
		ClientMessageToAll("2 - " + name2 + " Clan Kills: " + kills2 + " ", 255,255,0 );
		ClientMessageToAll("3 - " + name3 + " Clan Kills: " + kills3 + " ", 255,255,0 );
		ClientMessageToAll("4 - " + name4 + " Clan Kills: " + kills4 + " ", 255,255,0 );
		ClientMessageToAll("5 - " + name5 + " Clan Kills: " + kills5 + " ", 255,255,0 );
    }

function TopHeadShooters()
{
    local 
    query = "SELECT User, Head FROM BStats ORDER BY Head DESC LIMIT 5", 
    q,
    name1, name2, name3, name4, name5,
    kills1, kills2, kills3, kills4, kills5, i = 1;
    
    q = QuerySQL( db, query );
    while( GetSQLColumnData( q, 0 ) )
    {
    switch(i)
        {
                    case 1:
                            name1 = GetSQLColumnData( q, 0 );
                            kills1 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 2:
                            name2 = GetSQLColumnData( q, 0 );
                            kills2 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 3:
                            name3 = GetSQLColumnData( q, 0 );
                            kills3 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 4:
                            name4 = GetSQLColumnData( q, 0 );
                            kills4 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 5:
                            name5 = GetSQLColumnData( q, 0 );
                            kills5 = GetSQLColumnData( q, 1 ); 
                            break;
        }
            GetSQLNextRow( q );
            i++;
    }
    FreeSQLQuery(q);
    Message("=====> Top 5 Head Shooters <===== ");
    ClientMessageToAll("1 - " + name1 + " Head Shoots: " + kills1 + " ", 255,255,0 );
	ClientMessageToAll("2 - " + name2 + " Head Shoots: " + kills2 + " ", 255,255,0 );
	ClientMessageToAll("3 - " + name3 + " Head Shoots: " + kills3 + " ", 255,255,0 );
	ClientMessageToAll("4 - " + name4 + " Head Shoots: " + kills4 + " ", 255,255,0 );
	ClientMessageToAll("5 - " + name5 + " Head Shoots: " + kills5 + " ", 255,255,0 );
}

function TopKillers()
    {
        local 
        query = "SELECT Name, Kills FROM Accounts ORDER BY Kills DESC LIMIT 5", 
        q,
        name1, name2, name3, name4, name5,
        kills1, kills2, kills3, kills4, kills5, i = 1;
    
        q = QuerySQL( db, query );
        while( GetSQLColumnData( q, 0 ) )
        {
            switch(i)
            {
                    case 1:
                            name1 = GetSQLColumnData( q, 0 );
                            kills1 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 2:
                            name2 = GetSQLColumnData( q, 0 );
                            kills2 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 3:
                            name3 = GetSQLColumnData( q, 0 );
                            kills3 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 4:
                            name4 = GetSQLColumnData( q, 0 );
                            kills4 = GetSQLColumnData( q, 1 ); 
                            break;

                    case 5:
                            name5 = GetSQLColumnData( q, 0 );
                            kills5 = GetSQLColumnData( q, 1 ); 
                            break;
            }

            GetSQLNextRow( q );
            i++;
        }
        FreeSQLQuery(q);
        Message("=====> Top 5 Killers <===== ");
		ClientMessageToAll("1 - " + name1 + " Kills: " + kills1 + " ", 255,255,0 );
		ClientMessageToAll("2 - " + name2 + " Kills: " + kills2 + " ", 255,255,0 );
		ClientMessageToAll("3 - " + name3 + " Kills: " + kills3 + " ", 255,255,0 );
		ClientMessageToAll("4 - " + name4 + " Kills: " + kills4 + " ", 255,255,0 );
		ClientMessageToAll("5 - " + name5 + " Kills: " + kills5 + " ", 255,255,0 );
    }
	
function rotateRight(val, sbits)
{
	return (val >> sbits) | (val << (0x20 - sbits));
}

function e( string )
{
	local hp = [
		0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
		0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
	];

	local k = [
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
	];

	local
		w          = array( 64 ),
		i          = 0,
		s          = 0,
		len        = string.len(),
		word_array = array( 0 );

	for( i = 0; i < len - 3; i += 4 )
	{
		word_array.push( string[i] << 0x18 | string[i + 1] << 0x10 | string[i + 2] << 0x08 | string[i + 3] );
	}

	switch( len % 4 )
	{
		case 0:
			i = 0x80000000;
			break;
		case 1:
			i = string[len - 1] << 0x18 | 0x80000000;
			break;
		case 2:
			i = string[len - 2] << 0x18 | string[len - 1] << 0x10 | 0x08000;
			break;
		case 3:
			i = string[len - 3] << 0x18 | string[len - 2] << 0x10 | string[len - 1] << 0x08 | 0x80;
			break;
	}
	word_array.push( i );

	while( ( word_array.len() % 0x10 ) != 0x0E )
		word_array.push( 0 );

	word_array.push( len >> 0x10 );
	word_array.push( ( len << 0x03 ) & 0xFFFFFFFF );

	local s0, s1;
	for( s = 0; s < word_array.len(); s += 0x10 )
	{	
		for( i = 0x00; i < 0x10; i++ )
			w[i] = word_array[s + i];

		for( i = 0x10; i < 0x40; i++ )
		{
			s0   = rotateRight( w[i - 15], 7 ) ^ rotateRight( w[i - 15], 18 ) ^ ( w[i - 15] >> 3 );
			s1   = rotateRight( w[i - 2], 17 ) ^ rotateRight( w[i - 2], 19 ) ^ ( w[i - 2] >> 10 );
			w[i] = w[i - 0x10] + s0 + w[i - 7] + s1;
		}

		local a = hp[0],
		      b = hp[1],
		      c = hp[2],
		      d = hp[3],
		      e = hp[4],
		      f = hp[5],
		      g = hp[6],
		      h = hp[7];

		for( i = 0x00; i < 0x40; i++ )
		{
			s0        = ( rotateRight( a, 2 ) ^ rotateRight( a, 13 ) ^ rotateRight( a, 22 ) );
			local maj = ( ( a & b ) ^ ( a & c ) ^ ( b & c ) );
			local t2  = ( s0 + maj );
			s1        = ( rotateRight( e, 6 ) ^ rotateRight( e, 11) ^ rotateRight( e, 25 ) );
			local ch  = ( ( e & f ) ^ ( ( ~e ) & g ) );
			local t1  = ( h + s1 + ch + k[i] + w[i] );
			
			h = g;
			g = f;
			f = e;
			e = d + t1;
			d = c;
			c = b;
			b = a;
			a = t1 + t2;
		}

		hp[0] += a;
		hp[1] += b;
		hp[2] += c;
		hp[3] += d;
		hp[4] += e;
		hp[5] += f;
		hp[6] += g;
		hp[7] += h;
	}

	local hash = format(
	"%08x%08x%08x%08x%08x%08x%08x%08x",
		hp[0],
		hp[1],
		hp[2],
		hp[3],
		hp[4],
		hp[5],
		hp[6],
		hp[7]
	);
	
	return hash;
}

function FindpPlayer( sz )
{
	if ( IsNum( sz ) ) sz = sz.tointeger();
	return FindPlayer( sz );
}

function utils_gettok( string, separator, n, ... )
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

function GetaPlayer( szPlrName )
    {
    if ( szPlrName )
        {
        if ( IsNum( szPlrName ) )
            {
            szPlrName = FindPlayer( szPlrName.tointeger() );
            if ( szPlrName ) return lszPlrName;
            else return FindPlayer;
            }
	    else 
        {      
            szPlrName = FindPlayer( szPlrName ); 
            if ( szPlrName ) return szPlrName;
            else return NotFound;
        }
    }
    else return Done;
}
function GetPlayer( a )
{
    if ( a )
        {
        if ( IsNum( a ) )
          {
             local n = FindPlayer( a.tointeger() );
                  if ( n ) return n;
           }
	   else 
            {      
             local b = FindPlayer( a ); 
                 if ( b ) return b;
             }
        }
}

function FindPlr( text )
{
	if ( IsNum( text ) ) return FindPlayer( text.tointeger() );
	else return FindPlayer( text );
}

function SearchPlr( Text )
{
	if ( text )
		{
			local a = split( text, " ");
			
			local plr = null;
			if ( !IsNum( a[0] ) ) plr = FindPlayer( a[0] );
			else plr = FindPlayer( a[0].tointeger() );
			local plr = GetPlayer( text );
        }        
}	

function SetLogged( player, status )
{
    QuerySQL( db, format("UPDATE Accounts SET Logged='%s' WHERE Name='" + player.Name + "'", status ) );
}

function GetLogged( player )
{
    local log = GetSQLColumnData( QuerySQL( db, "SELECT Logged FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
	if ( log ) return log;
    else return 0;
}

function SetLevel( player, level )
{
    QuerySQL( db, "UPDATE Accounts Set Level='" + Admin.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetLevel( player )
{
    local lvl = GetSQLColumnData( QuerySQL( db, "SELECT Admin FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
	if ( lvl ) return lvl;
        else return 0;
}

function SetVLevel( player, vlevel )
{
    QuerySQL( db, "UPDATE Accounts Set VLevel='" + VIP.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetVLevel( player )
{
    local vlvl = GetSQLColumnData( QuerySQL( db, "SELECT VIP FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
	if ( vlvl ) return vlvl;
        else return 0;
}

function SetStatsNote( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET StatsNote='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetStatsNote( player )
{
    local Statsnote = GetSQLColumnData( QuerySQL( db, "SELECT StatsNote FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return Statsnote;
}

function SetKills( player, amount )
{
        QuerySQL( db, "UPDATE Accounts Set Kills='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetKills( player )
{
    local kills = GetSQLColumnData( QuerySQL( db, "SELECT Kills FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    if ( kills ) return kills;
    else return 0;
}

function SetDeaths ( player, amount )
{
    QuerySQL( db, "UPDATE Accounts Set Deaths='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetDeaths ( player )
{
    local deaths = GetSQLColumnData( QuerySQL( db, "SELECT Deaths FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return deaths;
}

		
				
function SetBestSpree( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET BestSpree='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetBestSpree( player )
{
    local bestSpree = GetSQLColumnData( QuerySQL( db, "SELECT BestSpree FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return bestSpree;
}

function SetStunt( player, amount )
{
        QuerySQL( db, "UPDATE Accounts Set Stunt='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetStunt( player )
{
    local stunt = GetSQLColumnData( QuerySQL( db, "SELECT Stunt FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    if ( stunt ) return stunt;
    else return 0;
}

function SetDrift( player, amount )
{
        QuerySQL( db, "UPDATE Accounts Set Drift='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetDrift( player )
{
    local drift = GetSQLColumnData( QuerySQL( db, "SELECT Drift FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    if ( drift ) return drift;
    else return 0;
}

function SetRespect( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Respect='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetRespect( player )
{
    local respect = GetSQLColumnData( QuerySQL( db, "SELECT Respect FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return respect;
}

function SetUnRespect( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET UnRespect='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetUnRespect( player )
{
    local unrespect = GetSQLColumnData( QuerySQL( db, "SELECT UnRespect FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return unrespect;
}

function SetCash( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Cash='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetCash ( player )
{
    local cash = GetSQLColumnData( QuerySQL( db, "SELECT Cash FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return cash;
}

function SetBankCash( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET BankCash='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetBankCash( player )
{
    local cash = GetSQLColumnData( QuerySQL( db, "SELECT BankCash FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
	if ( cash ) return cash;
        else return 0;
}

function SetCoins( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Coins='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetCoins( player )
{
    local Coins = GetSQLColumnData( QuerySQL( db, "SELECT Coins FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return Coins;
}

function SetScore( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Score='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetScore( player )
{
    local score = GetSQLColumnData( QuerySQL( db, "SELECT Score FROM Accounts WHERE Name='" + player.Name + "'"), 0 );
    return score;
}

function AddJoins( player )
{
    local joins = GetSQLColumnData( QuerySQL( db, "SELECT Joins From Accounts WHERE Name='" + player.Name + "'"), 0 );
    local add = joins += 1;
    QuerySQL( db, format("UPDATE Accounts SET Joins='" + add + "' WHERE Name='" + player.Name + "'") );
}

function LastActive( player )
{
local q = QuerySQL( db, "SELECT Name,LADate FROM Accounts WHERE Name='" +player.Name+"'");
if (GetSQLColumnData(q,0) == null)
{
QuerySQL( db, "INSERT INTO Accounts LADate VALUES '" + GetFullTime() +"'");
}
if (GetSQLColumnData(q,0) == player.Name)
{
QuerySQL( db, "UPDATE Accounts SET LADate='" + GetFullTime() + "' WHERE Name='" + player.Name + "'");
}
}

function FindLoc( text ) 
{
    local Location = QuerySQL( db, "SELECT Name FROM Gotoloc WHERE Name='" + text + "'");
    local Locname = GetSQLColumnData( Location, 0 );
    return Locname;
}

function JavedSecurity( player )
{
    local q = QuerySQL( db, "SELECT Name FROM RCON WHERE Name ='" + player.Name + "'");
    if ( ( GetSQLColumnData( q, 0 ) == player.Name )) return true;
	else MessagePlayer("You are not Server Owner to use this command!",player);
}	
	
function AddRcon( text )
{
   QuerySQL( db, "INSERT INTO RCON ( Name ) VALUES ( '" + text + "' )");
}

function CreateAdminStats( player )
{
    if ( GetLevel( player ) >= 3 )
	{
	    local AdminCheck = GetSQLColumnData( QuerySQL( db, "SELECT Name FROM AdminStats WHERE Name='" + player.Name + "'"), 0 );
		if ( AdminCheck ) return;
	    else QuerySQL( db, "REPLACE INTO AdminStats ( Name, AdminLevel, Bans, Kicks, Jails, Mutes, Warns ) VALUES ( '" + player.Name + "', '" + GetLevel( player ) + "', 0, 0, 0, 0, 0 )");
		print("Admin Stats Database Created for " + player.Name + ".");
	}
    else return 0;
}
	
function SetIsLocked( player, status )
{
    QuerySQL( db, format("UPDATE AdminStats SET IsLocked='%s' WHERE Name='" + player.Name + "'", status ) );
}

function GetIsLocked( player )
{
    local lock = GetSQLColumnData( QuerySQL( db, "SELECT IsLocked FROM AdminStats WHERE Name='" + player.Name + "'"), 0 );
	if ( lock ) return lock;
    else return 0;
}
	
function AddBans( player )
{
    local addbans = GetSQLColumnData( QuerySQL( db, "SELECT Bans From AdminStats WHERE Name='" + player.Name + "'"), 0 );
    local addban = addbans += 1;
    QuerySQL( db, format("UPDATE AdminStats SET Bans='" + addban + "' WHERE Name='" + player.Name + "'") );
}

function SetBans( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Bans='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetBans( player )
{
    local Bans = GetSQLColumnData( QuerySQL( db, "SELECT Bans FROM AdminStats WHERE Name='" + player.Name + "'"), 0 );
    return Bans;
}

function AddKicks( player )
{
    local addkicks = GetSQLColumnData( QuerySQL( db, "SELECT Kicks From AdminStats WHERE Name='" + player.Name + "'"), 0 );
    local addkick = addkicks += 1;
    QuerySQL( db, format("UPDATE AdminStats SET Bans='" + addkick + "' WHERE Name='" + player.Name + "'") );
}

function SetKicks( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Kicks='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetKicks( player )
{
    local Kicks = GetSQLColumnData( QuerySQL( db, "SELECT Kicks FROM AdminStats WHERE Name='" + player.Name + "'"), 0 );
    return Kicks;
}

function AddJails( player )
{
    local addjails = GetSQLColumnData( QuerySQL( db, "SELECT Jails From AdminStats WHERE Name='" + player.Name + "'"), 0 );
    local addjail = addjails += 1;
    QuerySQL( db, format("UPDATE AdminStats SET Jails='" + addjail + "' WHERE Name='" + player.Name + "'") );
}

function SetJails( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Jails='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetJails( player )
{
    local Jails = GetSQLColumnData( QuerySQL( db, "SELECT Jails FROM AdminStats WHERE Name='" + player.Name + "'"), 0 );
    return Jails;
}

function AddMutes( player )
{
    local addmutes = GetSQLColumnData( QuerySQL( db, "SELECT Mutes From AdminStats WHERE Name='" + player.Name + "'"), 0 );
    local addmute = addmutes += 1;
    QuerySQL( db, format("UPDATE AdminStats SET Mutes='" + addmute + "' WHERE Name='" + player.Name + "'") );
}

function SetMutes( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Mutes='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetMutes( player )
{
    local Mutes = GetSQLColumnData( QuerySQL( db, "SELECT Mutes FROM AdminStats WHERE Name='" + player.Name + "'"), 0 );
    return Mutes;
}

function AddWarns( player )
{
    local addwarns = GetSQLColumnData( QuerySQL( db, "SELECT Warns From AdminStats WHERE Name='" + player.Name + "'"), 0 );
    local addwarn = addwarns += 1;
    QuerySQL( db, format("UPDATE AdminStats SET Warns='" + addwarn + "' WHERE Name='" + player.Name + "'") );
}

function SetWarns( player, amount )
{
    QuerySQL( db, "UPDATE Accounts SET Warns='" + amount.tointeger() + "' WHERE Name='" + player.Name + "'");
}

function GetWarns( player )
{
    local Warns = GetSQLColumnData( QuerySQL( db, "SELECT Warns FROM AdminStats WHERE Name='" + player.Name + "'"), 0 );
    return Warns;
}

function Ban( player, admin, days, reason )
{
    QuerySQL( db, "INSERT INTO Bans ( Name, IP, Admin, Days, Reason, Date ) VALUES ( '" + player.Name + "', '" + player.IP + "', '" + admin.Name + "', '" + days + "', '" + reason + "', '" + GetFullTime() + "' )");
	AddBans( player );
	Message("-----> Ban Info <-----");
	ClientMessageToAll(" " + player.Name + " has Banned by Administrator " + admin + "",255,255,0);
	ClientMessageToAll("for ''" + days + "'' Days Reason: ''" + reason + "''",255,255,0);
    Message("----------------------------");
    MessagePlayer("",player);
    MessagePlayer("",player);
    MessagePlayer("",player);
    MessagePlayer("-------> Ban Info <------");
    ClientMessage("You are Banned by Administrator " + admin + " ",player,255,255,0);	
	ClientMessage("for ''" + days + "'' Days Reason: ''" + reason + "''",player,255,255,0);
	ClientMessage("Press F8 to take a Screen shot, make an UnBan Appeal at Vcmp.RPGKillerS.Com",player,255,255,0);

	Kick( player );
}

function IPBan( player, admin, days, reason )
{
    QuerySQL( db, "INSERT INTO Bans ( Name, IP, Admin, Days, Reason, Date, IPBan ) VALUES ( '" + player.Name + "', '" + player.IP + "', '" + admin.Name + "', '" + days + "', '" + reason + "', '" + GetFullTime() + "', '" + player.IP + "' )");
	AddBans( player );
	Message("-----> IPBan Info <-----");
	ClientMessageToAll(" " + player.Name + " has IP-Banned by Administrator " + admin + ""255,255,0);
	ClientMessageToAll("for ''" + days + "'' Days Reason: ''" + reason + "''",255,255,0);
    Message("----------------------------");	
	MessagePlayer("",player);
    MessagePlayer("",player);
    MessagePlayer("",player);
    MessagePlayer("-------> Ban Info <------");
    ClientMessage("You are IP-Banned by Administrator " + admin + " ",player,255,255,0);	
	ClientMessage("for ''" + days + "'' Days Reason: ''" + reason + "''",player,255,255,0);
	ClientMessage("Press F8 to take a Screen shot, make an UnBan Appeal at Vcmp.RPGKillerS.Com"player,255,255,0);

	Kick( player );
}

function GetBanName( player )
{
    local banname = GetSQLColumnData( QuerySQL( db, "SELECT Name FROM Bans WHERE Name='" + player.Name + "'"), 0 );
    return banname;
}

function GetIPBanName( player )
{
    local banname = GetSQLColumnData( QuerySQL( db, "SELECT Name FROM Bans WHERE IPBan='" + player.IP + "'"), 0 );
    return banname;
}

function GetBanIP( player )
{
    local banip = GetSQLColumnData( QuerySQL( db, "SELECT IP FROM Bans WHERE Name='" + player.Name + "'"), 0 );
    return banip;
}

function GetBanAdmin( player )
{
    local banadmin = GetSQLColumnData( QuerySQL( db, "SELECT Admin FROM Bans WHERE Name='" + player.Name + "'"), 0 );
    return banadmin;
}

function GetIPBanAdmin( player )
{
    local banadmin = GetSQLColumnData( QuerySQL( db, "SELECT Admin FROM Bans WHERE IPBan='" + player.IP + "'"), 0 );
    return banadmin;
}

function GetBanDays( player )
{
    local bandays = GetSQLColumnData( QuerySQL( db, "SELECT Days FROM Bans WHERE Name='" + player.Name + "'"), 0 );
    return bandays;
}

function GetIPBanDays( player )
{
    local banadmin = GetSQLColumnData( QuerySQL( db, "SELECT Days FROM Bans WHERE IPBan='" + player.IP + "'"), 0 );
    return banadmin;
}

function GetBanReason( player )
{
    local banreason = GetSQLColumnData( QuerySQL( db, "SELECT Reason FROM Bans WHERE Name='" + player.Name + "'"), 0 );
    return banreason;
}

function GetIPBanReason( player )
{
    local banreason = GetSQLColumnData( QuerySQL( db, "SELECT Reason FROM Bans WHERE IPBan='" + player.IP + "'"), 0 );
    return banreason;
}

function GetBanDate( player )
{
    local bandate = GetSQLColumnData( QuerySQL( db, "SELECT Date FROM Bans WHERE Name='" + player.Name + "'"), 0 );
    return bandate;
}

function GetIPBanDate( player )
{
    local banreason = GetSQLColumnData( QuerySQL( db, "SELECT Date FROM Bans WHERE IPBan='" + player.IP + "'"), 0 );
    return banreason;
}

function GetBanIPBan( player )
{
    local banipban = GetSQLColumnData( QuerySQL( db, "SELECT IPBan FROM Bans WHERE IPBan='" + player.IP + "'"), 0 );
    return banipban;
}

function GetBanSubnetBan( player )
{
    local bansubban = GetSQLColumnData( QuerySQL( db, "SELECT SubnetBan FROM Bans WHERE Name='" + player.Name + "'"), 0 );
    return bansubban;
}

function CheckUnBan( text )
{
   local q = QuerySQL( db, "SELECT * FROM Bans WHERE Name ='" + text + "'");
   local name = GetSQLColumnData( q, 0 );
   if ( name ) return 1;
   else return 0;
}

function UnBan(player, text )
{
    QuerySQL( db, "DELETE FROM Bans WHERE Name ='%" + text + "%'");
	MessagePlayer("-----> UnBanned Successfully <-----",player );
	MessagePlayer("You UnBanned User: " + text + " ",player );
}

function ConsoleUnBan(text )
{
    QuerySQL( db, "DELETE FROM Bans WHERE Name ='%" + text + "%'");
    print("-----> UnBanned Successfully <-----");
	print("You UnBanned User: " + text + " ");
}

function UnBanAll()
{
    QuerySQL( db, "DELETE FROM Bans");
}
	
function SetPlayerBodyPart( player, bodypart, amount )
{    
        QuerySQL( db, format("UPDATE BStats SET %s=%i WHERE Name='" + player.Name.tolower() + "'", BStats( bodypart ), amount ) );
}

function GetPlayerBodyPart( player, bodypart )
{
        local BP = GetSQLColumnData( QuerySQL( db, format("SELECT %s FROM BStats WHERE Name='" + player.Name.tolower() + "'", BStats( bodypart ) ) ), 0 );
	if ( BP ) return BP;
        else return 0;
}

function IncPlayerBodyPart( player, bodypart, amount )
{    
        QuerySQL( db, format("UPDATE BStats SET %s=%i WHERE Name='" + player.Name.tolower() + "'", BStats( bodypart ), ( GetPlayerBodyPart( player, bodypart ) + amount ) ) );
}

function DecPlayerBodyPart( player, bodypart, amount )
{    
        QuerySQL( db, format("UPDATE BStats SET %s=%i WHERE Name='" + player.Name.tolower() + "'", BStats( bodypart ), ( GetPlayerBodyPart( player, bodypart ) - amount ) ) );
}

function GetPlayerBStats( player )
{
        local bps = null;
        for ( local b = 0; b <= 6; b++ )
        {
 		if ( GetPlayerBodyPart( player, b ) > 0  )
 		{
 			if ( bps ) bps = bps + " " + BStats( b ) + ": [ " + GetPlayerBodyPart( player, b ) + " ]";
 			else bps = "" + BStats( b ) + ": [ " + GetPlayerBodyPart( player, b ) + " ]";
 		}
        }
        if ( bps ) return bps;
        else return "Empty (Need Stats)";
}

function SetPlayerWep( player, wepid, amount )
{    
        QuerySQL( db, format("UPDATE WStats SET %s=%i WHERE Name='" + player.Name.tolower() + "'", WStats( wepid ), amount ) );
}

function GetPlayerWep( player, wepid )
{
        local WP = GetSQLColumnData( QuerySQL( db, format("SELECT %s FROM WStats WHERE Name='" + player.Name.tolower() + "'", WStats( wepid ) ) ), 0 );
	if ( WP ) return WP;
        else return 0;
}

function IncPlayerWep( player, wepid, amount )
{    
        QuerySQL( db, format("UPDATE WStats SET %s=%i WHERE Name='" + player.Name.tolower() + "'", WStats( wepid ), ( GetPlayerWep( player, wepid ) + amount ) ) );
}

function DecPlayerWep( player, wepid, amount )
{    
        QuerySQL( db, format("UPDATE WStats SET %s=%i WHERE Name='" + player.Name.tolower() + "'", WStats( wepid ), ( GetPlayerWep( player, wepid ) - amount ) ) );
}

function GetPlayerWStats( player )
{
        local wps = null;
        for ( local w = 0; w <= 32; w++ )
        {
 		if ( GetPlayerWep( player, w ) > 0  )
 		{
 			if ( wps ) wps = wps + "  " + WStats( w ) + ": [ " + GetPlayerWep( player, w ) + " ] ";
 			else wps = " " + WStats( w ) + ": [ " + GetPlayerWep( player, w ) + " ] ";
 		}
        }
        if ( wps ) return wps;
        else return "Empty (Need Stats)";
}

function BStats( bodypart )
{
        local bp = "Not found";
	if ( bodypart.tointeger() == 0 ) bp = "Body";
	if ( bodypart.tointeger() == 1 ) bp = "Torso";
	if ( bodypart.tointeger() == 2 ) bp = "LeftArm";
	if ( bodypart.tointeger() == 3 ) bp = "RightArm";
	if ( bodypart.tointeger() == 4 ) bp = "LeftLeg";
	if ( bodypart.tointeger() == 5 ) bp = "RightLeg";
	if ( bodypart.tointeger() == 6 ) bp = "Head";
        return bp;
}

function WStats( wep )
{
    local wep = "Unkown";
		switch( reason )
		{
		case 0:
            wep = "Fist";
            break;
        case 1:
            wep = "BrassKnuckle";
            break;
        case 2:
            wep = "ScrewDriver";
            break;
        case 3:
            wep = "GolfClub";
            break;
        case 4:
            wep = "NightStick";
            break;
        case 5:
            wep = "Knife";
            break;
        case 6:
            wep = "BaseballBat";
            break;
		case 7:
            wep = "Hammer";
            break;
        case 8:
            wep = "Cleaver";
            break;
        case 9:
            wep = "Machete";
            break;
        case 10:
            wep = "Katana";
            break;
        case 11:
            wep = "Chainsaw";
            break;
        case 12:
            wep = "Grenade";
            break;
        case 13:
            wep = "RemoteGrenade";
            break;
		case 14:
            wep = "TearGas";
            break;
        case 15:
            wep = "Molotov";
            break;
        case 16:
            wep = "Missile";
            break;
        case 17:
            wep = "Colt45";
            break;
        case 18:
            wep = "Python";
            break;
        case 19:
            wep = "Shotgun";
            break;
        case 20:
            wep = "Spaz";
            break;
        case 21:
            wep = "Stubby";
            break;
        case 22:
            wep = "Tec9";
            break;
        case 23:
            wep = "Uzi";
            break;
        case 24:
            wep = "Ingrams";
            break;
        case 25:
            wep = "MP5";
            break;
        case 26:
            wep = "M4";
            break;
        case 27:
            wep = "Ruger";
            break;
        case 28:
            wep = "SniperRifle";
            break;
        case 29:
            wep = "LaserScope";
            break;
        case 30:
            wep = "RocketLauncher";
            break;
        case 31:
            wep = "FlameThrower";
            break;
        case 32:
            wep = "M60";
            break;
        }
}

function GetBPName( bodypart )
{
        local bpd;
        if ( bodypart == 0 ) bpd = "Body";
        if ( bodypart == 1 ) bpd = "Torso";
        if ( bodypart == 2 ) bpd = "Left Arm";
        if ( bodypart == 3 ) bpd = "Right Arm";
        if ( bodypart == 4 ) bpd = "Left Leg";
        if ( bodypart == 5 ) bpd = "Right Leg";
        if ( bodypart == 6 ) bpd = "Head";
        return bpd;
}


function GetTimeTable()
{
    //print("Executing command: " + cmd + " with params: " + text + " at " + GetTimeTable()[0] + "/" + GetTimeTable()[1] + "/" + GetTimeTable()[3] ); 
	timestamptable <- array(5,0);
	local time = GetFullTime().tostring();
	timestamptable[0] = time.slice(0,3);
	timestamptable[1] = time.slice(4,7);
	timestamptable[2] = time.slice(8,10);
	timestamptable[3] = time.slice(11,19);
	timestamptable[4] = time.slice(20,24);
	return timestamptable;
}
function Random(start, finish)
{
   local t;
   if (start < 0) t = ((rand() % (-start + finish)) + start)
   else
   {
      t = ((rand() % (finish - start)) + start);
   }
   return t;
}

function CmdSecurity( player, cmd, text )
{
    if ( !IsRegUser( player ) ) PrivMessage("[Error] - You're not Registered.", player );
    else if ( GetLogged( player ) == "false") PrivMessage("[Error] - You're not Logged-in.", player );
	else if ( !player.IsSpawned ) PrivMessage("[Error] - You're not Spawned.", player );
	else return true;
}
	
function ACmdSecurity( player, cmd, text )
{
	local ALevelNeeded = GetACmdLevel( cmd );
	cmd = cmd.tolower();
	
    if ( Stats[ player.ID ].Admin >= ALevelNeeded ) return true;
	else
	{
	    if ( Stats[ player.ID ].Admin <= 2 ) PrivMessage("[Error] - You're not an Administrator.", player );
	    else if ( !IsRegUser( player ) ) PrivMessage("[Error] - You're not Registered.", player );
        else if ( GetLogged( player ) == "false") PrivMessage("[Error] - You're not Logged-in.", player );
	    else if ( !player.IsSpawned ) PrivMessage("[Error] - You're not Spawned.", player );
		else PrivMessage("[Error] - You need Admin Level " + GetACmdLevel( cmd ) + " to use this Command. .", player );
	}
} 

function VCmdSecurity( player, cmd, text )
{
    local VLevelNeeded = GetVCmdLevel( cmd );
	cmd = cmd.tolower();
	
    if ( Stats[ player.ID ].VIP >= VLevelNeeded ) return true;
	else
	{
	    if ( Stats[ player.ID ].VIP <= 0 ) PrivMessage("[Error] - You're not VIP.", player );
	    else if ( !IsRegUser( player ) ) PrivMessage("[Error] - You're not Registered.", player );
        else if ( GetLogged( player ) == "false") PrivMessage("[Error] - You're not Logged-in.", player );
	    else if ( !player.IsSpawned ) PrivMessage("[Error] - You're not Spawned.", player );
		else PrivMessage("[Error] - You need VIP Level " + GetVCmdLevel( cmd ) + " to use this Command. .", player );
	}
}

function GetACmdLevel( cmd )
{
    cmd = cmd.tolower();
    local acmdlvl = GetSQLColumnData( QuerySQL( db, "SELECT ACmdLevel FROM CmdLevels WHERE ACmd='" + cmd + "'"), 0 );
	if ( acmdlvl ) return acmdlvl;
        else return 0;
}

function GetVCmdLevel( cmd )
{
    cmd = cmd.tolower();
    local vcmdlvl = GetSQLColumnData( QuerySQL( db, "SELECT VCmdLevel FROM CmdLevels WHERE VCmd='" + cmd + "'"), 0 );
	if ( vcmdlvl ) return vcmdlvl;
        else return 0;
}	
	
function MPCVO( player )
    {
	Owners <-
        [
            "javed"
	    ];
		
    foreach ( OName in Owners )
	    {	
	    if ( OName.tolower() == player.Name.tolower() )
		    {
			    ClientMessageToAll( player.Name + " Server Owner Is Connected To The Server!" 255,255,0);
				return;
		    }
		}
	CreateMarker( 24, Vector( -944.60668, -344.03997, 7.22693 ) );	 
	CreatePickup( 408, Vector( -941.5826, -344.0554, 7.2269 ) player );
	CreatePickup( 408, Vector( -882.6791, -340.7346, 11.1034 ) player );
    }

function CreatePickups()
    {
	    
	}
	
function Distance(x1, y1, x2, y2)
{
local dist = sqrt(((x2 - x1)*(x2 - x1)) + ((y2 - y1)*(y2 - y1)));
return dist;
}

function AutoUnmute( plr )
{
	local player = FindPlayer( plr );
	if ( !player ) return 0;
    else
        { 	
	        player.IsMuted = false;
	        ClientMessage("You have been UnMuted, Don't Try to Spam Again!" player 255, 255, 255 );
		}	
}

function GotoLoc( plr, text )
    {
    local 
	        Loc = GetSQLColumnData( QuerySQL( db, "SELECT Position From Locations WHERE Name='" + text.tolower() + "'"), 0 ),
            LocPos = split( Loc, " "),
	        player = FindPlayer( plr ),
			DriverVehicle = player.Vehicle;
			
	if ( !player ) return 0;
	else
	    {
		    if ( player.Vehicle ) DriverVehicle.Pos = Vector( LocPos[0].tofloat(), LocPos[1].tofloat(), LocPos[2].tofloat() );
	        else player.Pos = Vector( LocPos[0].tofloat(), LocPos[1].tofloat(), LocPos[2].tofloat() );
	        Stats[ player.ID ].Process = false;
            MessagePlayer("Successfully Teleported to " + text + "." player );
	        Announce(" " player );
		}	
    }

function SetCash( player, amount )
{
	player.Cash = amount.tointeger(); 
	Stats[ player.ID ].Cash = amount.tointeger();
}

function SetScore( player, amount ) 
{
    player.Score = amount.tointeger();
    status[ player.ID ].Score = amount.tointeger();
}

function Kick( pPlayer )
{
    Stats[ pPlayer.ID ].SaveStats( pPlayer );
	Stats[ pPlayer.ID ] = null;
	KickPlayer( pPlayer );
}

function Count1(i,plr)
{
	local player=FindPlayer(plr);
	if ( player ) Announce("~y~" +i.tointeger(), player, 1 );
}

function Spawner( player )
{
	onPlayerSpawn( player );
}

function Capture( player )
{
    player.IsFrozen = false;
    SetCinematicBorder( player, false );
}

function HyperMode( player )
    {
	//============ Method 1 ==================
		local pos = player.Pos;
        switch( player.Keys )
            {
            case 32768:			
			    {
		            pos.x += Speed[ player.ID];
                    player.Pos = pos; 	
				}
                break;				
			case 16384:			
			    {
					pos.x -= 15;
                    player.Pos = pos; 
				}
                break;				
			case 4096:			
			    {
					pos.y += 15;
                    player.Pos = pos; 
				}
				break;
			case 8192:			
			    {
					pos.y -= 15;
                    player.Pos = pos; 
				}
				break;
			case 2048:			
			    {
					pos.z += 15;
                    player.Pos = pos; 
				}
				break;
			case 1024:			
			    {
					pos.z -= 15;
                    player.Pos = pos; 
				}
				break;
			}
			//=============== Method 2 ===============
			if ( player.Keys & 32768 )			
			    {
				local pos = player.Pos;
		            pos.x += 15;
                    player.Pos = pos; 	
					return
				}
			if ( player.Keys & 16384 )			
			    {
				local pos = player.Pos;
					pos.x -= 15;
                    player.Pos = pos; 
					return
				}
			if ( player.Keys & 4096 )			
			    {
				local pos = player.Pos;
					pos.y += 15;
                    player.Pos = pos; 
					return
				}
			if ( player.Keys & 8192 )			
			    {
				local pos = player.Pos;
					pos.y -= 15;
                    player.Pos = pos; 
					return
				}
			if ( player.Keys & 2048 )			
			    {
				local pos = player.Pos;
					pos.z += 15;
                    player.Pos = pos; 
					return
				}
			if ( player.Keys & 1024 )			
			    {
				local pos = player.Pos;
					pos.z -= 15;
                    player.Pos = pos; 
					return
				}
	}
	
function FSpeed( player )
{
    local 
	        pos = player.Pos;
            pos.x += Speed[ player.ID ];
            player.Pos = pos; 
}
function BSpeed( player )
{
    local 
	        pos = player.Pos;
            pos.x -= Speed[ player.ID ];
            player.Pos = pos; 
}
function RSpeed( player )
{
    local 
	        pos = player.Pos;
            pos.y += Speed[ player.ID ];
            player.Pos = pos; 
}
function LSpeed( player )
{
    local 
	        pos = player.Pos;
            pos.y -= Speed[ player.ID ];
            player.Pos = pos; 
}
function USpeed( player )
{
    local 
	        pos = player.Pos;
            pos.z += Speed[ player.ID ];
            player.Pos = pos; 
}
function DSpeed( player )
{
    local 
	        pos = player.Pos;
            pos.z -= Speed[ player.ID ];
            player.Pos = pos; 
} 
//=========================================================[ CLAN SYSTEM ]===========================================================================

function FindClanTag(strPlayer)
{
    
     local
     D_DELIM = regexp(@"([\[(=^<]+\w+[\])=^>]+)").capture(strPlayer),
     S_DELIM = regexp(@"(\w.+[.*=]+)").capture(strPlayer);

     if ( D_DELIM != null )
    {
     return strPlayer.slice( D_DELIM[ 0 ].begin, D_DELIM[ 0 ].end );
    }
     else if ( S_DELIM != null )
    {
     return strPlayer.slice( S_DELIM[ 0 ].begin, S_DELIM[ 0 ].end );
    }
}

function CreateClan( player )
{
    local CTag = FindClanTag( player.Name );
         if ( CTag )
        {
         local ClanCheck = GetSQLColumnData( QuerySQL( db, "SELECT ClanTag FROM ServerClans WHERE ClanTag='" + CTag + "'"), 0 );
         if ( ClanCheck ) return MessagePlayer("Welcome, Your clan: " + ClanCheck, player );
         //else QuerySQL( db, "INSERT INTO ServerClans ( ClanTag, ClanName, ClanPoints, ClanKills, ClanOwner, ClanSkin, ClanSpawn, ClanColor ) VALUES ( '" + CTtag + "', '" + 0 + "', '" + 0 + "', '" + 0 + "', '" + player.Name + "', '" + 0 + "', '" + 0 + "', '" + 0 + "' )");
		 //else QuerySQL( db, "INSERT INTO ServerClans ( ClanTag, ClanName, ClanPoints, ClanKills, ClanOwner ) VALUES ( '" + CTtag + "', '" + 0 "', '" + 0 + "', '" + 0 + "', '" + player.Name + "' )");
		 else QuerySQL( db, "INSERT INTO ServerClans ( ClanTag, ClanName, ClanPoints, ClanKills, ClanOwner ) VALUES ( '" + CTag + "', '" + 0 + "', '" + 0 + "', '" + 0 + "', '" + player.Name + "' )");
		 print("Clan Created: " + CTag + " by " + player.Name + ". ");
        }
         else return 0;
}		 


function ClanChecker( player )
{
    local CTag = FindClanTag( player.Name );
    local clancheck = GetSQLColumnData( QuerySQL( db, "SELECT CTag FROM VSSClans WHERE CTag='" + CTag + "'"), 0 ),a;

	if ( clancheck == null )
    {
        a= "Free-Team";
	    return a; 
    }
    else if ( clancheck != null )
    {
        return clancheck;
    }
	return 0;
}

function GetClanOwner( CTag )
{
     local COwner = GetSQLColumnData( QuerySQL( db, "SELECT ClanOwner From ServerClans WHERE ClanTag='" + CTag + "'"), 0 );
	 if ( COwner ) return COwner;
	 else return 0;
}

function SetClanKills( CTag, CKills )
{
     QuerySQL( db, format("UPDATE ServerClans SET ClanKills='" + CKills + "' WHERE ClanTag='" + CTag + "'") );
}

function GetClanKills( CTag )
{
     local CKills = GetSQLColumnData( QuerySQL( db, "SELECT ClanKills From ServerClans WHERE ClanTag='" + CTag + "'"), 0 );
     if ( CKills ) return CKills;
     else return 0;
}
	 
function AddClanKills( CTag )
{
     local CKills = GetSQLColumnData( QuerySQL( db, "SELECT ClanKills From ServerClans WHERE ClanTag='" + CTag + "'"), 0 );
     local add1 = CKills += 1;
     QuerySQL( db, format("UPDATE ServerClans SET ClanKills='" + add1 + "' WHERE ClanTag='" + CTag + "'") );
}

function SetClanPoints( CTag, CKills )
{
     QuerySQL( db, format("UPDATE ServerClans SET ClanPoints='" + CPoints + "' WHERE ClanTag='" + CTag + "'") );
}

function GetClanPoints( CTag )
{
     local CPoints = GetSQLColumnData( QuerySQL( db, "SELECT ClanPoints From ServerClans WHERE ClanTag='" + CTag + "'"), 0 );
     if ( CPoints ) return CPoints;
     else return 0;
}

function AddClanPoints( CTag )
{
     local CPoints = GetSQLColumnData( QuerySQL( db, "SELECT ClanPoints From ServerClans WHERE ClanTag='" + CTag + "'"), 0 );
     local add3 = CPoints += 3;
     QuerySQL( db, format("UPDATE ServerClans SET ClanPoints='" + add3 + "' WHERE ClanTag='" + CTag + "'") );
}

//=======================================================[ GANG SYSTEM BY JAVED ]===========================================================

function CreateGang( text )
{
	QuerySQL( db, "INSERT INTO VSSdb ( Gang, Points, Kills, Deaths, Captures, Members ) VALUES ( '" + text + "', '" + 0 + "', '" + 0 + "', '" + 0 + "', '" + 0 + "', '" + 0 + "' )");
}

function ChangeGang( oldgname, newgname )
{
	QuerySQL( db, "UPDATE VSSdb Set Gang='" + newgname + "' WHERE Gang='" + oldgname + "'");
}

function RemoveGang( text )
{
	QuerySQL( db, "DELETE FROM VSSdb WHERE Gang ='%" + text + "%'");
	QuerySQL( db, "DELETE FROM VSSMembers WHERE Gang ='%" + text + "%'");
}

function CheckGang( text )
{
   local q = QuerySQL( db, "SELECT * FROM VSSdb WHERE Gang ='" + text + "'");
   local gang = GetSQLColumnData( q, 0 );
   if ( gang ) return 1;
   else return 0;
}

function MakeGangOwner( player, text )
{
	QuerySQL( db, format("UPDATE VSSdb SET Owner='" + player.Name + "' WHERE Gang='" + text + "'") );
}

function MakeGangNoOwner( text )
{
    QuerySQL( db, format("UPDATE VSSdb SET Owner=' ' WHERE Gang='" + text + "'") );
}

function RemoveGangOwner( text )
{
    QuerySQL( db, format("UPDATE VSSdb SET Owner=' ' WHERE Gang='" + text + "'") );
}

function CheckGangOwner( text )
{
    local owner = GetSQLColumnData( QuerySQL( db, "SELECT Owner From VSSdb WHERE Gang='" + text + "'"), 0 );
    if ( owner ) return owner;
    else return 0;
}

function CheckAlldbOwner( player )
{
   local q = QuerySQL( db, "SELECT * FROM VSSdb WHERE Owner ='" + player + "'");
   local allowner = GetSQLColumnData( q, 0 );
   if ( allowner ) return 1;
   else return 0;
}

function SetGangColor( color, gang )
{
    QuerySQL( db, format("UPDATE VSSdb SET Color='" + color + "' WHERE Gang='" + gang + "'") );	
}

function GetGangColor( player )
{
    local ThisGang = GetSQLColumnData( QuerySQL( db, "SELECT Gang From VSSMembers WHERE Name='" + player.Name + "'"), 0 );
    local Color = GetSQLColumnData( QuerySQL( db, "SELECT Color From VSSdb WHERE Gang='" + ThisGang + "'"), 0 );
    if ( Color ) return Color;
    else return 0;   
}

function CheckdbColor( text )
{
   local q = QuerySQL( db, "SELECT * FROM VSSdb WHERE Color ='" + text + "'");
   local allcolor = GetSQLColumnData( q, 0 );
   if ( allcolor ) return 1;
   else return 0;
}

function Setdbkin( skin, gang )
{
    QuerySQL( db, format("UPDATE VSSdb SET Skin='" + skin + "' WHERE Gang='" + gang + "'") );	
}

function Getdbkin( player )
{
    local ThisGang = GetSQLColumnData( QuerySQL( db, "SELECT Gang From VSSMembers WHERE Name='" + player.Name + "'"), 0 );
    local Skin = GetSQLColumnData( QuerySQL( db, "SELECT Skin From VSSdb WHERE Gang='" + ThisGang + "'"), 0 );
    if ( Skin ) return Skin;
    else return 0;   
}

function CheckdbSkin( text )
{
   local q = QuerySQL( db, "SELECT * FROM VSSdb WHERE Skin ='" + text + "'");
   local allskin = GetSQLColumnData( q, 0 );
   if ( allskin ) return 1;
   else return 0;
}

function Setdbpawn( x, y, z, text )
{
    QuerySQL( db, format("UPDATE VSSdb SET Spawn='" + x + " " + y + " " + z + "' WHERE Gang='" + text + "'") );                                               							    
}

function Getdbpawn( player )
{
    local ThisGang = GetSQLColumnData( QuerySQL( db, "SELECT Gang From VSSMembers WHERE Name='" + player.Name + "'"), 0 );
    local Spawn = GetSQLColumnData( QuerySQL( db, "SELECT Spawn From VSSdb WHERE Gang='" + ThisGang + "'"), 0 );
    if ( Spawn ) return Spawn;
    else return 0;   
}

function SetGangCPos( x, y, z, text )
{
    QuerySQL( db, format("UPDATE VSSdb SET CPos='" + x + " " + y + " " + z + "' WHERE Gang='" + text + "'") );                                               							    
}

function SetGangPoints( points, text )
{
     QuerySQL( db, format("UPDATE VSSdb SET Points='" + points + "' WHERE Gang='" + text + "'") );
}

function GetGangPoints( text )
{
     local Points = GetSQLColumnData( QuerySQL( db, "SELECT Points From VSSdb WHERE Gang='" + text + "'"), 0 );
     if ( Points ) return Points;
     else return 0;
}

function SetGangKills( kills, text )
{
     QuerySQL( db, format("UPDATE VSSdb SET Kills='" + kills + "' WHERE Gang='" + text + "'") );
}

function GetGangKills( text )
{
     local kills = GetSQLColumnData( QuerySQL( db, "SELECT Kills From VSSdb WHERE Gang='" + text + "'"), 0 );
     if ( kills ) return kills;
     else return 0;
}

function SetGangDeaths( deaths, text )
{
     QuerySQL( db, format("UPDATE VSSdb SET Deaths='" + deaths + "' WHERE Gang='" + text + "'") );
}

function GetGangDeaths( text )
{
     local deaths = GetSQLColumnData( QuerySQL( db, "SELECT Deaths From VSSdb WHERE Gang='" + text + "'"), 0 );
     if ( deaths ) return deaths;
     else return 0;
}

function SetGangCaptures( captures, text )
{
     QuerySQL( db, format("UPDATE VSSdb SET Captures='" + captures + "' WHERE Gang='" + text + "'") );
}

function GetGangCaptures( text )
{
     local captures = GetSQLColumnData( QuerySQL( db, "SELECT Captures From VSSdb WHERE Gang='" + text + "'"), 0 );
     if ( captures ) return captures;
     else return 0;
}

function SetGangMembers( members, text )
{
     QuerySQL( db, format("UPDATE VSSdb SET Members='" + members + "' WHERE Gang='" + text + "'") );
}

function IncGangMembers( player, thisgangmember )
{
     local thisgangmember = GetSQLColumnData( QuerySQL( db, "SELECT Gang From VSSMembers WHERE Name='" + player.Name + "'"), 0 );
     local members = GetSQLColumnData( QuerySQL( db, "SELECT Members From VSSdb WHERE Gang='" + thisgangmember + "'"), 0 );
     local add1 = members += 1;
     QuerySQL( db, format("UPDATE VSSdb SET Members='" + add1 + "' WHERE Gang='" + thisgangmember + "'") );
}

function DecGangMembers( thisgangmember )
{
     local thisgangmember = GetSQLColumnData( QuerySQL( db, "SELECT Gang From VSSMembers WHERE Name='" + player.Name + "'"), 0 );
     local members = GetSQLColumnData( QuerySQL( db, "SELECT Members From VSSdb WHERE Gang='" + thisgangmember + "'"), 0 );
     local sub1 = members -= 1;
     QuerySQL( db, format("UPDATE VSSdb SET Members='" + sub1 + "' WHERE Gang='" + thisgangmember + "'") );
}

function GetGangMembers( text )
{
     local members = GetSQLColumnData( QuerySQL( db, "SELECT Members From VSSdb WHERE Gang='" + text + "'"), 0 );
     if ( members ) return members;
     else return 0;
}

function CheckMember( player )
{
   local q = QuerySQL( db, "SELECT * FROM VSSMembers WHERE Name ='" + player + "'");
   local member = GetSQLColumnData( q, 0 );
   if ( member ) return 1;
   else return 0;
}

//=============================================================================================================================

function IsGangOwner( player )
{
    local isowner = GetSQLColumnData( QuerySQL( db, "SELECT Gang From VSSdb WHERE Owner='" + player.Name + "'"), 0 );
    if ( isowner ) return isowner;
    else return 0;
}

function IsGangCoOwner( player )
{
    local coowner = GetSQLColumnData( QuerySQL( db, "SELECT Name='" + player.Name + "' From VSSMembers WHERE Rank='Owner'"), 0 );
    if ( coowner ) return coowner;
    else return 0;
}

function IsGangLeader( player )
{
    local Leader = GetSQLColumnData( QuerySQL( db, "SELECT Name='" + player.Name + "' From VSSMembers WHERE Rank='Leader'"), 0 );
    if ( Leader ) return Leader;
    else return 0;
}

function IsGangCoLeader( player )
{
    local CoLeader = GetSQLColumnData( QuerySQL( db, "SELECT Name='" + player.Name + "' From VSSMembers WHERE Rank='CoLeader'"), 0 );
    if ( CoLeader ) return CoLeader;
    else return 0;
}

function IsGangMember( player )
{
    local Member = GetSQLColumnData( QuerySQL( db, "SELECT Name='" + player.Name + "' From VSSMembers WHERE Rank='Member'"), 0 );
    if ( Member ) return Member;
    else return 0;
}

function IsThisGangMember( plr, player )
{
    local thisgangmember = GetSQLColumnData( QuerySQL( db, "SELECT Gang From VSSMembers WHERE Name='" + player.Name + "'"), 0 );
    local ismember = GetSQLColumnData( QuerySQL( db, "SELECT Name='" + plr.Name + "' From VSSMembers WHERE Gang='" + thisgangmember + "'"), 0 );
    if ( ismember ) return ismember;
    else return 0;
} 

function KickGangMember( player ) 
{
	QuerySQL( db, "DELETE FROM VSSMembers WHERE Name ='%" + player.ID + "%'");
	player.Health = 0;
}