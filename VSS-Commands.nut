/*=========================================================================================================================================================
                            Vice Super Stunt Admin and pPlayer Commands (/c)
==========================================================================================================================================================*/

function onPlayerCommand( pPlayer, szCommand, szParams )
{
 try
	{
	local
			Players,
			Plr,
		    PlayersCount  =   GetPlayers(), 
			szParam1,  
            iParam1,			
			szParam2,     
			iParam2,
		    szParam3,   
            iParam3,			
			szParamA1,   
			iParamA1,
			szParamA2,
			iParamA2,
			szParamA3,
			iParamA3,
			szCmdError    =   szCommand,
	        szCommand     =   szCommand.tolower();
	
	if ( szParams )
	    {	    
			szParam1      =   GetTok( szParams, " ", 1 );
			iParam1       =   ( szParam1 ? split( szParam1, " ").len() : 0 );
			szParam2      =   GetTok( szParams, " ", 2 );
			iParam2       =   ( szParam2 ? split( szParam2, " ").len() : 0 );
		    szParam3      =   GetTok( szParams, " ", 3 );
			iParam3       =   ( szParam3 ? split( szParam3, " ").len() : 0 );
			szParamA1     =   GetTok( szParams, " ", 1, NumTok( szParams, " " ) );
			iParamA1      =   ( szParamA1 ? split( szParamA1, " ").len() : 0 );
			szParamA2     =   GetTok( szParams, " ", 2, NumTok( szParams, " " ) );
			iParamA2      =   ( szParamA2 ? split( szParamA2, " ").len() : 0 );
			szParamA3     =   GetTok( szParams, " ", 3, NumTok( szParams, " " ) );
			iParamA3      =   ( szParamA3 ? split( szParamA3, " ").len() : 0 );
	
		    if ( IsNum( szParam1 ) ) Plr = FindPlayer( szParam1.tointeger() );
			else Plr = FindPlayer( szParam1 );
		}
			
	for ( local PlayerID = 0, PlayerCount = 0; PlayerID < GetMaxPlayers() && PlayerCount < PlayersCount; PlayerID++ )
	    {
		if ( !( Players = FindPlayer( PlayerID ) ) ) continue;
		    PlayerCount++;
            if ( Players.IsAdmin ) PrivMessage( pPlayer.Name + " Used " + szCommand + " " + szParams, Players );	 			
        }
	
	if ( Stats[ pPlayer.ID ].Leave ) return Announce("\x10 \x10 \x10 \x10 \x10 ~h~!~y~leave" pPlayer );
	else if ( szCommand == "test")
	    {
		 try 
		    {
			if ( Stats[ pPlayer.ID ].Registered == true )
			    {
				if ( Stats[ pPlayer.ID ].Logged == true )
				    {
		         	PrivMessage("Test Started!.." pPlayer );
			            {
			                Stats[ pPlayer.ID ].Leave = true;
		                    MessagePlayer("Teleported To War" pPlayer ); 
	              			pPlayer.Skin = 0;
		               		pPlayer.Team = 0;  
		                    pPlayer.Pos = SDMSpawns[ rand() % SDMSpawns.len() ];
							Stats[ pPlayer.ID ].AntiHPHack = true;
		                    pPlayer.Health += 20;
							pPlayer.Armour += 200;
							pPlayer.Cash +=300;
			            	//pPlayer.SetWeapon
		                }
					PrivMessage("Test Successfully!.." pPlayer );	
                    }
                else PrivMessage("[Error] - You're not logged in" pPlayer );					
			    }
			else PrivMessage("[Error] - You're not Registered." pPlayer );
            }		        			
		catch(e) { Print("ERROR - DETECTED....."); Print( Typeof( e ) ); Print( e ); Print("ERROR - END..........."); }
		}	
	else if ( szCommand == "register")
		{
		if ( Stats[ pPlayer.ID ].Registered == false )
		    {
			if ( szParams ) 
			    { 
			    if ( iParamA1 < 2 )
 				    { 
			        if ( szParams.len() >= 4 ) 
					    { 
			            if ( szParams.len() < 18 ) 
						    { 
		                    if ( szParams != pPlayer.Name ) 
							    { 
    			                	Stats[ pPlayer.ID ].RegisterPlayer( pPlayer, szParams );
			                 		Stats[ pPlayer.ID ].Deaths = 0;
				                	Stats[ pPlayer.ID ].Cash = pPlayer.Cash;            
                                    Stats[ pPlayer.ID ].Score = pPlayer.Score;
                					Stats[ pPlayer.ID ].User = pPlayer.Name;
			                		Stats[ pPlayer.ID ].Password = SHA256( szParams );
		                			Stats[ pPlayer.ID ].Registered = true;
                            		Stats[ pPlayer.ID ].Logged = true;
	                                PrivMessage("Successfully Registered! /C Help for more Information." pPlayer );
	                                PrivMessage("Nick: " + pPlayer.Name + ", Password: " + szParams, pPlayer );
	                                ClientMessageToAll(">> " + pPlayer.Name + " is a register Nick-Name now!" 984, 252, 777 );
								}
								else PrivMessage("[Error] - Your Name Can't be your Password." pPlayer );
                            }
							else PrivMessage("[Error] - Password must be under 4 and 18 Characters." pPlayer );
                        }
						else PrivMessage("[Error] - Password must be under 4 and 18 Characters." pPlayer );
                    }	
       				else PrivMessage("[Error] - Password Can't Contain Space!" pPlayer );	
				}	
				else PrivMessage("[Syntax] - /c " + szCommand + " <password>" pPlayer );
			}
			else PrivMessage("[Error] - You're already register!" pPlayer );
		}	
	else if ( szCommand == "login")
		{
		if ( Stats[ pPlayer.ID ].Registered == true )
    		{ 
			if ( Stats[ pPlayer.ID ].Logged == false )
 			    { 
			    if ( szParams )
       				{ 
			        if ( SHA256( szParams ) == Stats[ pPlayer.ID ].Password )				
					    {
						    pPlayer.IsFrozen = false;		
                	        Stats[ pPlayer.ID ].Logged = true;
                            pPlayer.Cash = Stats[ pPlayer.ID ].Cash;            
                            pPlayer.Score = Stats[ pPlayer.ID ].Score;
	                        PrivMessage("Successfully Logged-in!" pPlayer );
	                        PrivMessage("Nick: " + pPlayer.Name + ", Admin:[ " + Stats[ pPlayer.ID ].Admin + " ], VIP:[ " + Stats[ pPlayer.ID ].VIP + " ]" pPlayer );						
					    }	
			        else
                        {
                        Stats[ pPlayer.ID ].Attemps++;
					    PrivMessage("[Error] - Wrong Password (" + Stats[ pPlayer.ID ].Attemps + "/3 Attemps) " pPlayer );
			        	if ( Stats[ pPlayer.ID ].Attemps == 3 )
					        {
						        MessagePlayer("3/3 Wrong Password Attemps." pPlayer );	
                                MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (3/3 Pass Attemps) " pPlayer );
		                        Kick( pPlayer );
			                }   
					    }
			        }
					else PrivMessage("[Syntax] - /c " + szCommand + " <password> " pPlayer );
                }
				else PrivMessage("[Error] - You're already logged in." pPlayer );
			}	
			else PrivMessage("[Error] - You're not Registered." pPlayer );
	   	}
    else if ( szCommand == "logout")
	    {
		if ( Stats[ pPlayer.ID ].Registered == true ) 
			{ 
			if ( Stats[ pPlayer.ID ].Logged == true )
				{ 
			    if ( pPlayer.IsAdmin ) 
					{
				        PrivMessage("Successfully Log out!" pPlayer ); 
					    Stats[ pPlayer.ID ].SaveStats( pPlayer );
					    Stats[ pPlayer.ID ].Logged = false;
				    }
				    else PrivMessage("[Error] - You're not RCON-Administrator." pPlayer );
			    }
                else PrivMessage("[Error] - You are already Log out." pPlayer );			
            }			
		    else PrivMessage("[Error] - You're not Registered." pPlayer );
		}		
	else if ( szCommand == "changepass")
	    {
		if ( Stats[ pPlayer.ID ].Registered == true )
     		{ 
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
			    { 
			    if ( szParams )
 				    { 
			        if ( iParamA1 > 1 ) 
					    { 
			            if ( szParams.len() > 4 ) 
						    { 
			                if ( szParams.len() < 18 )
          						{	
			                    if ( szParams != pPlayer.Name ) 
								    { 
		                            if ( Stats[ pPlayer.ID ].Password != SHA256( szParams ) )
     									{ 
			    	                        Stats[ pPlayer.ID ].Password = SHA256( szParams );
					                        MessagePlayer("You have Changed Your Password to [ " + szParams + " ] " pPlayer );
										}
										else PrivMessage("[Error] - This is your current Password." pPlayer );
									}
									else PrivMessage("[Error] - Your Name Can't be your Password." pPlayer );
								}	
								else PrivMessage("[Error] - Password must be under 4 and 18 Characters." pPlayer );
							}
							else PrivMessage("[Error] - Password must be under 4 and 18 Characters." pPlayer );
						}
						else PrivMessage("[Error] - Your Pass can't Contain Space!" pPlayer );
					}	
					else PrivMessage("[Syntax] - /c " + szCommand + " <new pass> " pPlayer );
				}
				else PrivMessage("[Error] - You're not logged in" pPlayer );
			}
			else PrivMessage("[Error] - You're not Registered" pPlayer );
		} 			
	else if ( szCommand == "changename")
	    {
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
		        {  
	            if ( Stats[ pPlayer.ID ].Admin <= 1 )
	                {	
		            if ( szParams ) 
		                { 
		                if ( iParamA1 < 1 ) 
                            { 
		                    if ( szParams != Stats[ pPlayer.ID ].User ) 
		                        { 
		                        if ( !CheckName( szParams ) ) 
		                            { 
		                            if ( !IsNum( szParams ) ) 
		                                {
	                                    if ( szParams.len() > 4 ) 
	                              	        { 
		                                    if ( szParams.len() < 18 )
		                                        {
		                                        if ( SHA256( szParams ) != Stats[ pPlayer.ID ].Password )
		                                            { 
    				                                    Stats[ pPlayer.ID ].User = szParams;
                                                        pPlayer.Name = szParams;
					                                    pPlayer.IsFrozen = true;
				                                    	MessagePlayer("You have Changed Your Name to [ " + szParams + " ] " pPlayer );
					                                    MessagePlayer("Please Rejoin with New Name " pPlayer );
                                                        Kick( pPlayer );
													}
													else PrivMessage("[Error] - Your Password Can't be your Name." pPlayer );
												}
												else PrivMessage("[Error] - Name must be under 4 and 18 Characters." pPlayer );
											}
											else PrivMessage("[Error] - Name must be under 4 and 18 Characters." pPlayer );
										}
										else PrivMessage("[Error] - You can't Change Name to Numbers." pPlayer );
									}
									else PrivMessage("[Error] - Name '" + szParams + "' already exists." pPlayer );
								}
								else PrivMessage("[Error] - This is your current Name." pPlayer );
							}
							else PrivMessage("[Error] - Your Name can't Contain Space!" pPlayer );
						}
						else PrivMessage("[Syntax] - /c " + szCommand + " <new name> " pPlayer );
					}	
					else PrivMessage("[Error] - Administrators Can't Change there Names.");
			    }	
				else PrivMessage("[Error] - You're not logged in" pPlayer );
		    }
			else PrivMessage("[Error] - You're not Registered" pPlayer );
		}		
	else if ( szCommand == "stats" || szCommand == "status")
	    {
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
			    {
		        if ( !szParams )
			        {
			            MessagePlayer("====> " + pPlayer.Name + "'s Stats - ID (" + pPlayer.ID + ") <====" pPlayer );
					    ClientMessage("Name: " + pPlayer.Name + " Admin: " + Stats[ pPlayer.ID ].Admin + " VIP: " + Stats[ pPlayer.ID ].VIP + " Online Time: " + Stats[ pPlayer.ID ].Hours + ":" + Stats[ pPlayer.ID ].Minutes + ":" + Stats[ pPlayer.ID ].Seconds, pPlayer 255, 255, 0 );
						ClientMessage("Score: " + Stats[ pPlayer.ID ].Score + " Cash: " + Stats[ pPlayer.ID ].Cash + " Coins: " + Stats[ pPlayer.ID ].Coins + " Respect: " + Stats[ pPlayer.ID ].Respect + "/-" + Stats[ pPlayer.ID ].UnRespect, pPlayer 255, 255, 0 );
					    ClientMessage("Kills: " + Stats[ pPlayer.ID ].Kills + " Deaths: " + Stats[ pPlayer.ID ].Deaths + " Killer Rank: " + KillerRank(pPlayer), pPlayer 255, 255, 0 );
						ClientMessage("Current Spree: " + Stats[ pPlayer.ID ].Spree + " Best Spree: " + Stats[ pPlayer.ID ].BestSpree + " - " + SpreeNote(pPlayer), pPlayer 255, 255, 0 );
						ClientMessage("Stunt: " + Stats[ pPlayer.ID ].Stunt + " Stunter Rank: " + StunterRank(pPlayer), pPlayer 255, 255, 0 );
						ClientMessage("Drift: " + Stats[ pPlayer.ID ].Drift + " Drifter Rank: " + DrifterRank(pPlayer), pPlayer 255, 255, 0 );
						ClientMessage("Player Rank: " + Rank(pPlayer), pPlayer 255, 255, 0 );
			        }
			    else 
			        {
				    if ( Plr ) 
					    { 
				        if ( Stats[ Plr.ID ].Registered == true ) 
						    { 
				            if ( Stats[ Plr.ID ].Logged == true )
       							{ 
				                    MessagePlayer("====> " + Plr.Name + "'s Stats - ID (" + Plr.ID + ") <====" pPlayer );
					                ClientMessage("Name: " + Plr.Name + " Admin: " + Stats[ Plr.ID ].Admin + " VIP: " + Stats[ Plr.ID ].VIP + " Online Time: " + Stats[ Plr.ID ].Hours + ":" + Stats[ Plr.ID ].Minutes + ":" + Stats[ Plr.ID ].Seconds, pPlayer 255, 255, 0 );
						            ClientMessage("Score: " + Stats[ Plr.ID ].Score + " Cash: " + Stats[ Plr.ID ].Cash + " Coins: " + Stats[ Plr.ID ].Coins + " Respect: " + Stats[ Plr.ID ].Respect + "/-" + Stats[ Plr.ID ].UnRespect, pPlayer 255, 255, 0 );
					                ClientMessage("Kills: " + Stats[ Plr.ID ].Kills + " Deaths: " + Stats[ Plr.ID ].Deaths + " Killer Rank: " + KillerRank(Plr), pPlayer 255, 255, 0 );
				          	    	ClientMessage("Current Spree: " + Stats[ Plr.ID ].Spree + " Best Spree: " + Stats[ Plr.ID ].BestSpree + " - " + SpreeNote(Plr), pPlayer 255, 255, 0 );
						            ClientMessage("Stunt: " + Stats[ Plr.ID ].Stunt + " Stunter Rank: " + StunterRank(Plr), pPlayer 255, 255, 0 );
			        			    ClientMessage("Drift: " + Stats[ Plr.ID ].Drift + " Drifter Rank: " + DrifterRank(Plr), pPlayer 255, 255, 0 );
					        	    ClientMessage("Player Rank: " + Rank(Plr), pPlayer 255, 255, 0 );
			                    }
         						else PrivMessage("[Error] - " + Plr.Name + " is not logged in." pPlayer );   		
			                }
							else PrivMessage("[Error] - " + Plr.Name + " is not Registered." pPlayer );	
		                }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
					}
        		}			
				else PrivMessage("[Error] - You are not logged in." pPlayer );	
		    }
			else PrivMessage("[Error] - You're Not Registered." pPlayer );
	    }
	else if ( szCommand == "astats" || szCommand == "astatus")
	    {
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
		    if ( AdminStats.find( pPlayer.Name ) != null )
			    {
		        if ( !szParams )
			        {
			            MessagePlayer("====> " + pPlayer.Name + "'s Admin Stats - ID (" + pPlayer.ID + ") <====" pPlayer );
					    ClientMessage("Name: " + pPlayer.Name + " Admin Level: " + Stats[ pPlayer.ID ].Admin, pPlayer 255, 255, 0 );
						ClientMessage("Bans: " + Stats[ pPlayer.ID ].Bans, pPlayer 255, 255, 0 );
					    ClientMessage("Kicks: " + Stats[ pPlayer.ID ].Kicks, pPlayer 255, 255 ,0 );
						ClientMessage("Jails: " + Stats[ pPlayer.ID ].Jails, pPlayer 255, 255, 0 );
						ClientMessage("Warns: " + Stats[ pPlayer.ID ].Warns, pPlayer 255, 255, 0 );
						ClientMessage("Mutes: " + Stats[ pPlayer.ID ].Mutes, pPlayer 255, 255, 0 );
			        }
			    else 
			        {
				    if ( Plr ) 
					    { 
				        if ( Stats[ Plr.ID ].Registered == true ) 
						    { 
				            if ( AdminStats.find( Plr.Name ) != null )
       							{ 
								    MessagePlayer("====> " + Plr.Name + "'s Admin Stats - ID (" + Plr.ID + ") <====" pPlayer );
					                ClientMessage("Name: " + Plr.Name + " Admin Level: " + Stats[ Plr.ID ].Admin, pPlayer 255, 255, 0 );
					        	    ClientMessage("Bans: " + Stats[ Plr.ID ].Bans, pPlayer 255, 255, 0 );
					                ClientMessage("Kicks: " + Stats[ Plr.ID ].Kicks, pPlayer 255, 255 ,0 );
						            ClientMessage("Jails: " + Stats[ Plr.ID ].Jails, pPlayer 255, 255, 0 );
						            ClientMessage("Warns: " + Stats[ Plr.ID ].Warns, pPlayer 255, 255, 0 );
						            ClientMessage("Mutes: " + Stats[ Plr.ID ].Mutes, pPlayer 255, 255, 0 );
			                    }
         						else PrivMessage("[Error] - " + Plr.Name + " is not an Administrator." pPlayer );   		
			                }
							else PrivMessage("[Error] - " + Plr.Name + " is not Registered." pPlayer );	
		                }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
					}
        		}			
				else PrivMessage("[Error] - You are not an Administrator." pPlayer );	
		    }
			else PrivMessage("[Error] - You're Not Registered." pPlayer );
	    }
    else if ( szCommand == "commands" || szCommand == "command" || szCommand == "cmd" || szCommand == "cmds")
	    {
        if ( Stats[ pPlayer.ID ].Registered == true )
		    {
                MessagePlayer("Registered User Cmds" pPlayer );
				if ( Stats[ pPlayer.ID ].Admin >= 1 ) MessagePlayer("Type /c acmds for Admin Commands! " pPlayer );
            }
	    else 
            {
			    MessagePlayer(" " pPlayer );
			    MessagePlayer(" " pPlayer );
			    MessagePlayer(" " pPlayer );
			    MessagePlayer("====> Commands <==== " pPlayer );
			    ClientMessage("Available Commands for Non-Registered Users." pPlayer 255, 255, 0 );
			    ClientMessage("(/c) register, credits, help, rules." pPlayer 255, 255, 0 );
			    MessagePlayer("Visit us : Www.VSS-Server.Com" pPlayer );
            }						        
	    }		
    else if ( szCommand == "acommands" || szCommand == "acommand" || szCommand == "acmd" || szCommand == "acmds")
	    {
		if ( Stats[ pPlayer.ID ].Admin >= 1 )
		    {
		        MessagePlayer(" " pPlayer );
			    MessagePlayer(" " pPlayer );
		    }
        else PrivMessage("[Error] - Your are not an Administrator." pPlayer );
        }
	else if ( szCommand == "credits")
	    {
		    MessagePlayer("=====> Credits <======" pPlayer );
			ClientMessage("Scripter       -   JaVeD " pPlayer 255, 255, 0 );
			ClientMessage("Website       -   JaVeD " pPlayer 255, 255, 0 );
		    ClientMessage("Clan System   -   JaVeD & Doom_Killer " pPlayer 255, 255, 0 );
			ClientMessage("Owners        -   JaVeD & HamzA " pPlayer 255, 255, 0 );
			ClientMessage("Best pPlayer     -   " + pPlayer.Name, pPlayer 255, 255, 0 );
			PrivMessage("Thankyou " + pPlayer.Name + " for Reading Credits! " pPlayer );
		}
    else if ( szCommand == "rules")
	    {
		    MessagePlayer("=====> Rules <======" pPlayer );
			ClientMessage("Health Hck -> Ban Permenent!" pPlayer 255, 255, 0 );
			ClientMessage("Hyper Hack etc.. -> Ban Permenent!" pPlayer 255, 255, 0 );
			ClientMessage("Spamming/Flooding -> Kick/BAN 3 days." pPlayer 255, 255, 0 );
            ClientMessage("Rocket/Minigun are not allowed aspect /c BuyBWep." pPlayer 255, 255, 0 );
			if ( Stats[ pPlayer.ID ].Admin >= 1 ) ClientMessage("USE: /c arules to view Admin Rules." pPlayer 255, 255, 0 );
			PrivMessage("Thankyou " + pPlayer.Name + " for Reading Rules! " pPlayer );
	    }
    else if ( szCommand == "arules")
	    {
		if ( Stats[ pPlayer.ID ].Level >= 3 )
		    {
		        MessagePlayer("=====> Admin Rules <======" pPlayer );
			    ClientMessage("Do not use any kind of Hack." pPlayer 255, 255, 0 );
			    ClientMessage("Do not Swear Help pPlayer that want Help." pPlayer 255, 255, 0 );
			    ClientMessage("Don't Ban pPlayers for personal Matters." pPlayer 255, 255, 0 );
			    ClientMessage("Do not ban pPlayer without Proofs!" pPlayer 255, 255, 0 );
			    ClientMessage("Visit Forum for more Information about Admin Rules!" pPlayer 255, 255, 0 );
			    PrivMessage("Thankyou " + pPlayer.Name + " for Reading Admin Rules! " pPlayer );
		    }
        else PrivMessage("[Error] - You are not Administrator." pPlayer );	 	
	    }		
    else if ( szCommand == "help")
	    {
		if ( Stats[ pPlayer.ID ].Registered == false )
		    {
		        MessagePlayer(" " pPlayer );
			    MessagePlayer(" " pPlayer );
		        MessagePlayer("=====> Help <======" pPlayer );
			    ClientMessage("Use: /c register to register an account in the server" pPlayer 255, 255, 0 );
			    ClientMessage("With Registering an account You can access all Commands. " pPlayer 255, 255, 0 );
			    ClientMessage("Please visit our Forum Vcmp.RPGKillerS.Com" pPlayer 255, 255, 0 );
			    PrivMessage("Thankyou " + pPlayer.Name + " for Reading Help! " pPlayer );
		    }
        else
		    {		
		        MessagePlayer(" " pPlayer );
			    MessagePlayer(" " pPlayer );
			    MessagePlayer("=====> Help <======" pPlayer );
			    ClientMessage("Please Use (/c) cmds, credits, rules, teles, top." pPlayer 255, 255, 0 );
			    ClientMessage("You can get more help by visiting our forum & website." pPlayer 255, 255, 0 );
			    ClientMessage("Please visit our Forum Vcmp.RPGKillerS.Com" pPlayer 255, 255, 0 );
			    PrivMessage("Thankyou " + pPlayer.Name + " for Reading Help! " pPlayer );
		    }	 
        }
	else if ( szCommand == "top")
	    {
	    if ( Stats[ pPlayer.ID ].Registered == false ) return PrivMessage("[Error] - You're not Registered." pPlayer );
		else if ( Stats[ pPlayer.ID ].Logged == false ) return PrivMessage("[Error] - You're not Logged in." pPlayer );
        local 
			    CKillsQuery   =   "SELECT CTag, CKills FROM VSSClans ORDER BY CKills DESC LIMIT 5",
				KillsQuery    =   "SELECT Name, Kills FROM Accounts ORDER BY Kills DESC LIMIT 5", 
				StuntsQuery   =   "SELECT Name, Stunt FROM Accounts ORDER BY Stunt DESC LIMIT 5", 
				DriftQuery    =   "SELECT Name, Drift FROM Accounts ORDER BY Drift DESC LIMIT 5", 
				HoursQuery    =   "SELECT Name, Hours FROM Accounts ORDER BY Hours DESC LIMIT 5", 
                CKQuery, KQuery, SQuery, DQuery, HQuery,
                Name1, Name2, Name3, Name4, Name5,
                Product1, Product2, Product3, Product4, Product5, 
				i = 1;
				
		if ( szParams == "clans")
		    {
			CKQuery = QuerySQL( db, CKillsQuery );
            while( GetSQLColumnData( CKQuery, 0 ) )
                {
                switch(i)
                    {
                    case 1:
                            Name1 = GetSQLColumnData( CKQuery, 0 );
                            Product1 = GetSQLColumnData( CKQuery, 1 ); 
                            break;

                    case 2:
                            Name2 = GetSQLColumnData( CKQuery, 0 );
                            Product2 = GetSQLColumnData( CKQuery, 1 ); 
                            break;

                    case 3:
                            Name3 = GetSQLColumnData( CKQuery, 0 );
                            Product3 = GetSQLColumnData( CKQuery, 1 ); 
                            break;

                    case 4:
                            Name4 = GetSQLColumnData( CKQuery, 0 );
                            Product4 = GetSQLColumnData( CKQuery, 1 ); 
                            break;

                    case 5:
                            Name5 = GetSQLColumnData( CKQuery, 0 );
                            Product5 = GetSQLColumnData( CKQuery, 1 ); 
                            break;
                    }
                GetSQLNextRow( CKQuery );
                i++;
		        }	
                FreeSQLQuery( CKQuery );
                MessagePlayer("=====> Top 5 Clans <===== " pPlayer );
		        ClientMessage("1 - " + Name1 + " Clan Kills: " + Product1, pPlayer 255, 255, 0 );
		        ClientMessage("2 - " + Name2 + " Clan Kills: " + Product2, pPlayer 255, 255, 0 );
		        ClientMessage("3 - " + Name3 + " Clan Kills: " + Product3, pPlayer 255, 255, 0 );
		        ClientMessage("4 - " + Name4 + " Clan Kills: " + Product4, pPlayer 255, 255, 0 );
		        ClientMessage("5 - " + Name5 + " Clan Kills: " + Product5, pPlayer 255, 255, 0 );
		        MessagePlayer("To View Full list Visit Vcmp.RPGKillerS.Com " pPlayer );
		    }
	    else if ( szParams == "kills")
	        {					
			KQuery = QuerySQL( db, CKillsQuery );
            while( GetSQLColumnData( KQuery, 0 ) )
                {
                switch(i)
                {
                    case 1:
                            Name1 = GetSQLColumnData( KQuery, 0 );
                            Product1 = GetSQLColumnData( KQuery, 1 ); 
                            break;

                    case 2:
                            Name2 = GetSQLColumnData( KQuery, 0 );
                            Product2 = GetSQLColumnData( KQuery, 1 ); 
                            break;

                    case 3:
                            Name3 = GetSQLColumnData( KQuery, 0 );
                            Product3 = GetSQLColumnData( KQuery, 1 ); 
                            break;

                    case 4:
                            Name4 = GetSQLColumnData( KQuery, 0 );
                            Product4 = GetSQLColumnData( KQuery, 1 ); 
                            break;

                    case 5:
                            Name5 = GetSQLColumnData( KQuery, 0 );
                            Product5 = GetSQLColumnData( KQuery, 1 ); 
                            break;
                }
                GetSQLNextRow( KQuery );
                i++;
                }
                FreeSQLQuery( KQuery );
                MessagePlayer("=====> Top 5 Killers <===== " pPlayer );
		        ClientMessage("1 - " + Name1 + " Kills: " + Product1, pPlayer 255, 255, 0 );
		        ClientMessage("2 - " + Name2 + " Kills: " + Product2, pPlayer 255, 255, 0 );
		        ClientMessage("3 - " + Name3 + " Kills: " + Product3, pPlayer 255, 255, 0 );
		        ClientMessage("4 - " + Name4 + " Kills: " + Product4, pPlayer 255, 255, 0 );
		        ClientMessage("5 - " + Name5 + " Kills: " + Product5, pPlayer 255, 255, 0 );
		        MessagePlayer("To View Full list Visit Vcmp.RPGKillerS.Com " pPlayer );
		    }
	    else if ( szParams == "stunt")
	        {
			SQuery = QuerySQL( db, CKillsQuery );
            while( GetSQLColumnData( SQuery, 0 ) )
                {
                switch(i)
                    {
                    case 1:
                            Name1 = GetSQLColumnData( SQuery, 0 );
                            Product1 = GetSQLColumnData( SQuery, 1 ); 
                            break;

                    case 2:
                            Name2 = GetSQLColumnData( SQuery, 0 );
                            Product2 = GetSQLColumnData( SQuery, 1 ); 
                            break;

                    case 3:
                            Name3 = GetSQLColumnData( SQuery, 0 );
                            Product3 = GetSQLColumnData( SQuery, 1 ); 
                            break;

                    case 4:
                            Name4 = GetSQLColumnData( SQuery, 0 );
                            Product4 = GetSQLColumnData( SQuery, 1 ); 
                            break;

                    case 5:
                            Name5 = GetSQLColumnData( SQuery, 0 );
                            Product5 = GetSQLColumnData( SQuery, 1 ); 
                            break;
                    }
                    GetSQLNextRow( SQuery );
                    i++;
                }
                FreeSQLQuery( SQuery );
                MessagePlayer("=====> Top 5 Stunters <===== " pPlayer );
		        ClientMessage("1 - " + Name1 + " Stunt Points: " + Product1, pPlayer 255, 255, 0 );
		        ClientMessage("2 - " + Name2 + " Stunt Points: " + Product2, pPlayer 255, 255, 0 );
	          	ClientMessage("3 - " + Name3 + " Stunt Points: " + Product3, pPlayer 255, 255, 0 );
	        	ClientMessage("4 - " + Name4 + " Stunt Points: " + Product4, pPlayer 255, 255, 0 );
		        ClientMessage("5 - " + Name5 + " Stunt Points: " + Product5, pPlayer 255, 255, 0 );
		        MessagePlayer("To View Full list Visit Vcmp.RPGKillerS.Com " pPlayer );
		    }
	    else if ( szParams == "drift")
	        {		
			DQuery = QuerySQL( db, CKillsQuery );
            while( GetSQLColumnData( DQuery, 0 ) )
                {
                switch(i)
                    {
                    case 1:
                            Name1 = GetSQLColumnData( DQuery, 0 );
                            Product1 = GetSQLColumnData( DQuery, 1 ); 
                            break;

                    case 2:
                            Name2 = GetSQLColumnData( DQuery, 0 );
                            Product2 = GetSQLColumnData( DQuery, 1 ); 
                            break;

                    case 3:
                            Name3 = GetSQLColumnData( DQuery, 0 );
                            Product3 = GetSQLColumnData( DQuery, 1 ); 
                            break;

                    case 4:
                            Name4 = GetSQLColumnData( DQuery, 0 );
                            Product4 = GetSQLColumnData( DQuery, 1 ); 
                            break;

                    case 5:
                            Name5 = GetSQLColumnData( DQuery, 0 );
                            Product5 = GetSQLColumnData( DQuery, 1 ); 
                            break;
                    }
                    GetSQLNextRow( DQuery );
                    i++;
                }
                FreeSQLQuery( DQuery );
                MessagePlayer("=====> Top 5 Drifters <===== " pPlayer );
		        ClientMessage("1 - " + Name1 + " Drift Points: " + Product1, pPlayer 255, 255, 0 );
		        ClientMessage("2 - " + Name2 + " Drift Points: " + Product2, pPlayer 255, 255, 0 );
		        ClientMessage("3 - " + Name3 + " Drift Points: " + Product3, pPlayer 255, 255, 0 );
		        ClientMessage("4 - " + Name4 + " Drift Points: " + Product4, pPlayer 255, 255, 0 );
		        ClientMessage("5 - " + Name5 + " Drift Points: " + Product5, pPlayer 255, 255, 0 );
		        MessagePlayer("To View Full list Visit Vcmp.RPGKillerS.Com " pPlayer );
		    }
	    else if ( szParams == "hours")
	        {		
			HQuery = QuerySQL( db, CKillsQuery );
            while( GetSQLColumnData( HQuery, 0 ) )
                {
                switch(i)
                    {
                    case 1:
                            Name1 = GetSQLColumnData( HQuery, 0 );
                            Product1 = GetSQLColumnData( HQuery, 1 ); 
                            break;

                    case 2:
                            Name2 = GetSQLColumnData( HQuery, 0 );
                            Product2 = GetSQLColumnData( HQuery, 1 ); 
                            break;

                    case 3:
                            Name3 = GetSQLColumnData( HQuery, 0 );
                            Product3 = GetSQLColumnData( HQuery, 1 ); 
                            break;

                    case 4:
                            Name4 = GetSQLColumnData( HQuery, 0 );
                            Product4 = GetSQLColumnData( HQuery, 1 ); 
                            break;

                    case 5:
                            Name5 = GetSQLColumnData( HQuery, 0 );
                            Product5 = GetSQLColumnData( HQuery, 1 ); 
                            break;
                    }
                    GetSQLNextRow( HQuery );
                    i++;
                }
                FreeSQLQuery( HQuery );
                MessagePlayer("=====> Top 5 Active pPlayers <===== " pPlayer );
		        ClientMessage("1 - " + Name1 + " Hours: " + Product1, pPlayer 255, 255, 0 );
		        ClientMessage("2 - " + Name2 + " Hours: " + Product2, pPlayer 255, 255, 0 );
		        ClientMessage("3 - " + Name3 + " Hours: " + Product3, pPlayer 255, 255, 0 );
		        ClientMessage("4 - " + Name4 + " Hours: " + Product4, pPlayer 255, 255, 0 );
		        ClientMessage("5 - " + Name5 + " Hours: " + Product5, pPlayer 255, 255, 0 );
		        MessagePlayer("To View Full list Visit Vcmp.RPGKillerS.Com " pPlayer );
	        }
		else 
			{
		        MessagePlayer("=====> Tops <===== " pPlayer );
			    ClientMessage("[ /c top clans ] - To View Top Clans in Server." pPlayer 255, 255, 0 );
			    ClientMessage("[ /c top kills ] - To View The List of Top Killers." pPlayer 255, 255, 0 );
			    ClientMessage("[ /c top stunt ] - To View The List of Top Stunters." pPlayer 255, 255, 0 );
			    ClientMessage("[ /c top drift ] - To View The List of Top Drifters." pPlayer 255, 255, 0 );
			    ClientMessage("[ /c top hours ] - To View The List of Top Active pPlayers." pPlayer 255, 255, 0 );
			    MessagePlayer("Visit Our Website To View Complete List of Top pPlayers." pPlayer );
		    }
	    }	
	else if ( szCommand == "teles")      
	    {
	    if ( Stats[ pPlayer.ID ].Registered == true )
		    {
		        MessagePlayer("=====> Teles <=====" pPlayer );
		        ClientMessage("(/C Loc) - For Locations Teles!" pPlayer 255, 255, 0 );
		        ClientMessage("(/C DM) - For Death Match Zones! " pPlayer 255, 255, 0 );
		        ClientMessage("(/C SSS) - For Stunt Zones! " pPlayer 255, 255, 0 );
		        ClientMessage("(/C Drift) - For Drift Zones! " pPlayer 255, 255, 0 );
		        ClientMessage("(/C MG) - For MiniGames! " pPlayer 255, 255, 0 );
		        ClientMessage("(/C Jobs) - For Jobs! " pPlayer 255, 255, 0 ); 
		    }
			else PrivMessage("[Error] - You're Not Registered." pPlayer );
	    }
	else if ( szCommand == "dm")      
	    {
	    if ( Stats[ pPlayer.ID ].Registered == true )
            {		
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
		        {
		            MessagePlayer("=====> Death Match Teles <=====" pPlayer );
			        ClientMessage("1 - War ( WEPS: Rocket, Grenade, AK47 ) " pPlayer 255, 255, 0 );
			        ClientMessage("2 - Minigun ( WEPS: Minigun ) " pPlayer 255, 255, 0 );
			        ClientMessage("3 - OH ( one Shoot ) " pPlayer 255, 255, 0 );
			        ClientMessage("4 - SDM ( Secret Death Match ) " pPlayer 255, 255, 0 );
			        ClientMessage("5 - Sniper ( WEPS: Sniper ) " pPlayer 255, 255, 0 );
			        MessagePlayer("All DM Teleports will work with (/c). " pPlayer );
				}
				else PrivMessage("[Error] - You're not Logged in." pPlayer );
		    }
			else PrivMessage("[Error] - You're not Registered." pPlayer );
        }
	else if ( szCommand == "drift")      
	    {
	    if ( Stats[ pPlayer.ID ].Registered == true )
            {		
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
		        {
		            MessagePlayer("=====> Drift Zones Teles <=====" pPlayer );
			        ClientMessage("/c drift1,...5 " pPlayer 255, 255, 0 );
			        ClientMessage("Example: /c drift1 - /c drift2 etc.. " pPlayer 255, 255, 0 );
		    	    ClientMessage("This Drift Teles will tele you to Drift Zone. " pPlayer 255, 255, 0 );
			        ClientMessage("Finish The Chekpoints and earn Drift Points!" pPlayer 255, 255, 0 );
			        ClientMessage("/c topdrift to view the list of Top Drifters." pPlayer 255, 255, 0 );
			        MessagePlayer("All Drift Zone Teleports will work with (/c). " pPlayer );
				}
				else PrivMessage("[Error] - You're not Logged in." pPlayer );
		    }
			else PrivMessage("[Error] - You're not Registered." pPlayer );
        }
	else if ( szCommand == "stunt")      
	    {
	    if ( Stats[ pPlayer.ID ].Registered == true )
            {		
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
		        {
		            MessagePlayer("=====> Stunt Zones Teles <=====" pPlayer );
		     	    ClientMessage("/c sss 1,...15 " pPlayer 255, 255, 0 );
		    	    ClientMessage("Example: /c sss 1 - /c sss 2 etc.. " pPlayer 255, 255, 0 );
			        ClientMessage("This Stunt Teles will tele you to Stunt Zone. " pPlayer 255, 255, 0 );
		    	    ClientMessage("Reach The Target and earn Stunt Points!" pPlayer 255, 255, 0 );
		     	    ClientMessage("/c topstunt to view the list of Top Stunters." pPlayer 255, 255, 0 );
			        MessagePlayer("All Stunt Zone Teleports will work with (/c). " pPlayer );
				}
				else PrivMessage("[Error] - You're not Logged in." pPlayer );
		    }
			else PrivMessage("[Error] - You're not Registered." pPlayer );
        }
	else if ( szCommand == "mg")      
	    {
	    if ( Stats[ pPlayer.ID ].Registered == true )
            {		
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
		        {
		            MessagePlayer("=====> Minigames <=====" pPlayer );
			        ClientMessage("1 - MC ( Monster Crash CAR: Monster )" pPlayer 255, 255, 0 );
			        ClientMessage("2 - Race ( Reward: $4000, 10 Coins, 30 Score ) " pPlayer 255, 255, 0 );
			        ClientMessage("3 - Nascar ( Reward: $2000, 5 Coins, 10 Score ) " pPlayer 255, 255, 0 );
			        ClientMessage("4 - Derby ( Reward: $2500, 20 Coins, 40 Score ) " pPlayer 255, 255, 0 );
			        ClientMessage("5 - Lastman ( Reward: $1000 15 Coins, 30 Score ) " pPlayer 255, 255, 0 ); 
			        MessagePlayer("All MiniGame Commands Will Work With (/c). " pPlayer );
				}
				else PrivMessage("[Error] - You're not Logged in." pPlayer );
		    }
			else PrivMessage("[Error] - You're not Registered." pPlayer );
        }
	else if ( szCommand == "jobs")      
	    {
	    if ( Stats[ pPlayer.ID ].Registered == true )
            {		
		    if ( Stats[ pPlayer.ID ].Logged == true ) 
		        {
		            MessagePlayer("=====> Jobs <=====" pPlayer );
			        ClientMessage("1 - Pizza ( Reward: $500, 10 Coins, 5 Score ) " pPlayer 255, 255, 0 );
			        ClientMessage("2 - Truck ( Reward: $700, 5 Coins, 10 Score ) " pPlayer 255, 255, 0 );
			        ClientMessage("3 - Charry ( Reward: $900, 10 Coins ) " pPlayer 255, 255, 0 );
			        ClientMessage("4 - Rober ( Reward: $200, 5 Coins ) " pPlayer 255, 255, 0 );
			        ClientMessage("5 - Police ( Reward: $1000, 20 Score ) " pPlayer 255, 255, 0 );
			        MessagePlayer("All Jobs Cmds works with (/c), Have Fun! " pPlayer );
				}
				else PrivMessage("[Error] - You're not Logged in." pPlayer );
		    }
			else PrivMessage("[Error] - You're not Registered." pPlayer );
        }	
	else if ( szCommand == "createloc") 
	    {
		if ( Stats[ pPlayer.ID ].Registered == true )
            {		
	        if ( Stats[ pPlayer.ID ].Logged == true ) 
			    {        
		        if ( pPlayer.IsAdmin ) 
				    {    
		            if ( pPlayer.IsSpawned )
                     	{	
                        if ( szParams )						
              		        { 						
							if ( Locations.find( szParams.tolower() ) == null )
                             	{						
                                    local 
									        x = pPlayer.Pos.x, 
											y = pPlayer.Pos.y, 
											z = pPlayer.Pos.z;					
											
									Locations.push( szParams.tolower() ); 					
		                            local LocQuery = QuerySQL( db, "INSERT INTO Locations ( Name, Position ) values ( '" + szParams.tolower() + "', '" + x + " " + y + " " + z + "' )");									
									FreeSQLQuery( LocQuery );
                                    PrivMessage("Location: [ " + szParams + " ] Created!" pPlayer );  
				                    return;
								}
								else return PrivMessage("[Error] - Location '" + szParams + "' already exists!." pPlayer );
                            }
							else return PrivMessage("[Syntax] - /c createloc <location name>" pPlayer );
                        }
						else return PrivMessage("[Error] - You haven't spawned." pPlayer );
                    }
                    else return PrivMessage("[Error] - You're not Rcon Administrator." pPlayer );					
                }   
				else return PrivMessage("[Error] - You're not Logged in." pPlayer );
			}
            else return PrivMessage("[Error] - You're not Registered." pPlayer );			
        }
    else if ( szCommand == "changeloc")
	    {
		if ( Stats[ pPlayer.ID ].Registered == true )
            {		
	        if ( Stats[ pPlayer.ID ].Logged == true ) 
			    {        
		        if ( pPlayer.IsAdmin ) 
				    {    
		            if ( pPlayer.IsSpawned )
                     	{
                        if ( szParams )						
              		        { 						
							if ( Locations.find( szParams.tolower() ) != null )
                             	{	                                
								local 
									    x = pPlayer.Pos.x, 
										y = pPlayer.Pos.y, 
										z = pPlayer.Pos.z;	
										
                                    Locations.remove( Locations.find( szParams.tolower() ) ); 								
			                        local DLocQuery = QuerySQL( db, "DELETE FROM Locations WHERE Name ='" + szParams.tolower() + "'");							
									FreeSQLQuery( DLocQuery );
			                        Locations.push( szParams.tolower() ); 
		                            local LocQuery = QuerySQL( db, "INSERT INTO Locations ( Name, Position ) values ( '" + szParams.tolower() + "', '" + x + " " + y + " " + z + "' )");									
									FreeSQLQuery( LocQuery );
                                    PrivMessage("Location [ " + szParams + " ] Position Changed!" pPlayer );                                       
         		                    return;
								}
								else return PrivMessage("[Error] - Location '" + szParams + "' Does not exists!." pPlayer );
                            }
							else return PrivMessage("[Syntax] - /c changeloc <location name>" pPlayer );
                        }
						else return PrivMessage("[Error] - You haven't spawned." pPlayer );
                    }
                    else return PrivMessage("[Error] - You're not Rcon Administrator." pPlayer );					
                }   
				else return PrivMessage("[Error] - You're not Logged in." pPlayer );
			}
            else return PrivMessage("[Error] - You're not Registered." pPlayer );			
        }
	else if ( szCommand == "removeloc")
	    { 
		if ( Stats[ pPlayer.ID ].Registered == true )
            {		
	        if ( Stats[ pPlayer.ID ].Logged == true ) 
			    {        
		        if ( pPlayer.IsAdmin ) 
				    {    
		            if ( pPlayer.IsSpawned )
                     	{	
                        if ( szParams )						
              		        { 						
							if ( Locations.find( szParams.tolower() ) != null )
                             	{	                                
                                    Locations.remove( Locations.find( szParams.tolower() ) ); 								
			                        local DLocQuery = QuerySQL( db, "DELETE FROM Locations WHERE Name ='" + szParams.tolower() + "'");
									FreeSQLQuery( DLocQuery );
                                    PrivMessage("Location [ " + szParams + " ] Removed Successfully!" pPlayer );                                      									
         		                    return;
								}
								else return PrivMessage("[Error] - Location '" + szParams + "' Does not exists!." pPlayer );
                            }
							else return PrivMessage("[Syntax] - /c removeloc <location name>" pPlayer );
                        }
						else return PrivMessage("[Error] - You haven't spawned." pPlayer );
                    }
                    else return PrivMessage("[Error] - You're not Rcon Administrator." pPlayer );					
                }   
				else return PrivMessage("[Error] - You're not Logged in." pPlayer );
			}
            else return PrivMessage("[Error] - You're not Registered." pPlayer );			
        }
	else if ( szCommand == "loc")
        {         
		if ( Stats[ pPlayer.ID ].Registered == true )
            {		
	        if ( Stats[ pPlayer.ID ].Logged == true ) 
			    {
				if ( pPlayer.IsSpawned )
                    {	
                    if ( szParams )						
              		    { 	
                        if ( Stats[ pPlayer.ID ].Process == false )
                            {						
						    if ( Locations.find( szParams.tolower() ) != null )
                                {				
								    Announce("~o~Teleporting~y~... \x10 \x10 \x10 \x10 \x10 ~b~ 5 ~w~sec " pPlayer );
									Stats[ pPlayer.ID ].Process = true;
								    NewTimer("GotoLoc", 5000, 1, pPlayer.ID, szParams );
							        return;
								}                      								
			                else 
		                        {
		                            MessagePlayer("=====> Locations <=====" pPlayer );
	                		        ClientMessage("(1) LH - LittleHavena (2) VC - Vice Beach (3) CC - Cuban Cafe " pPlayer 255, 255, 0 );
			                        ClientMessage("(4) SI - Starfish Island (5) NM - North Moll (6) AA - AirPort  " pPlayer 255, 255, 0 );
			                        ClientMessage("(7) MC - Malibu Club (8) PW - Print Work (9) VB - Vice Bank " pPlayer 255, 255, 0 );
			                        ClientMessage("(10 ) HH - Hospital (11) H1 - Hospital 1 (12) H2 - Hospital 2 " pPlayer 255, 255, 0 );
			                        ClientMessage("(13) BK - Bikers (14) PH - Phill Area (15) AM - Ammunation Shop " pPlayer 255, 255, 0 );
			                        MessagePlayer("All Loc Teleport will work with (/c)." pPlayer );
								    return;
							    }	
						    }
							else return PrivMessage("Wait 5 sec Teleport is curruntly in Process!" pPlayer ); 								
                        }
						else return PrivMessage("Error - Usage: /c loc <location name>" pPlayer );
                    }
					else return PrivMessage("[Error] - You haven't spawned." pPlayer );		
			    }   
				else return PrivMessage("[Error] - You're not Logged in." pPlayer );
			}
            else return PrivMessage("[Error] - You're not Registered." pPlayer );			
        }
    else if ( szCommand == "up")
        {         
		if ( Stats[ pPlayer.ID ].Registered == true )
            {		
	        if ( Stats[ pPlayer.ID ].Logged == true ) 
			    {
				if ( pPlayer.IsSpawned )
                    {	
                    if ( szParams )						
              		    { 	
					    if ( IsNum( szParams ) )
						    {
							if ( szParams.len() <= 3 )
							    {
                                if ( pPlayer.Pos.z <= 20 )
                                    {						
						            if ( pPlayer.Vehicle )
		                                {
										    local DriverVehicle = pPlayer.Vehicle;
		                                    DriverVehicle.Pos = Vector( pPlayer.Pos.x, pPlayer.Pos.y, pPlayer.Pos.z+=szParams.tointeger() );
				                            MessagePlayer("Teleported UP " + szParams.tointeger() + " Meters With Vehicle!" pPlayer );
		                                }
	                                else 
		                                {
		                                    pPlayer.Pos = Vector( pPlayer.Pos.x, pPlayer.Pos.y, pPlayer.Pos.z+=szParams.tointeger() );
			                                MessagePlayer("Teleported UP " + szParams.tointeger() + " Meters!" pPlayer );
			                            }
							        }	
								    else return PrivMessage("Wait Until You Get Down!" pPlayer ); 								
								}
								else return PrivMessage("[Error] - Value Must be Lower then 100 Meters!" pPlayer );
						    }
							else return PrivMessage("[Error] - Value Must be an Integer!" pPlayer );
                        }
						else return PrivMessage("[Syntax] - /c up <Value>" pPlayer );
                    }
					else return PrivMessage("[Error] - You haven't spawned." pPlayer );		
			    }   
				else return PrivMessage("[Error] - You're not Logged in." pPlayer );
			}
            else return PrivMessage("[Error] - You're not Registered." pPlayer );			
        }
	else if ( szCommand == "ignore")
        {    
		if ( Stats[ pPlayer.ID ].Registered == false ) return PrivMessage("[Error] - You're not Registered." pPlayer );					
	    else if ( Stats[ pPlayer.ID ].Logged == false ) return PrivMessage("[Error] - You're not Logged in." pPlayer );
	    else if ( szParams.tolower() == "pm")
            {
	        if ( Stats[ pPlayer.ID ].IgnorePM == false )
		        {
		            PrivMessage("You Ignored PM! Now no one can PM you." pPlayer );
		            Stats[ pPlayer.ID ].IgnorePM = true;
		        }
		    else 
		        {
		            PrivMessage("You UnIgnored PM! Now pPlayers can PM you." pPlayer );
		            Stats[ pPlayer.ID ].IgnorePM = false;
		        }	
	        }
        else if ( szParams.tolower() == "goto")    
            { 
	        if ( Stats[ pPlayer.ID ].IgnoreGoto == false )
	        	{
		            PrivMessage("You Ignored Goto! Now no one can Goto to you." pPlayer );
		            Stats[ pPlayer.ID ].IgnoreGoto = true;
		        }
		    else 
		        {
		            PrivMessage("You UnIgnored Goto! Now pPlayers can Goto to you." pPlayer );
		            Stats[ pPlayer.ID ].IgnoreGoto = false;
		        }	
	        }
	    else if ( szParams.tolower() == "spec")    
            {
	        if ( Stats[ pPlayer.ID ].IgnoreSpec == false )
	        	{
		            PrivMessage("You Ignored Spec! Now no one can Spec to you." pPlayer );
		            Stats[ pPlayer.ID ].IgnoreSpec = true;
		        }
		    else 
		        {
		            PrivMessage("You UnIgnored Spec! Now pPlayers can Spec to you." pPlayer );
		            Stats[ pPlayer.ID ].IgnoreSpec = false;
		        }	
	        }
        else if ( szParams.tolower() == "duel")    
            {
	        if ( Stats[ pPlayer.ID ].IgnoreDuel == false )
		        {
		            PrivMessage("You Ignored Duel! Now no one can Duel to you." pPlayer );
		            Stats[ pPlayer.ID ].IgnoreDuel = true;
		        }
		    else 
	     	    {
		            PrivMessage("You UnIgnored Duel! Now pPlayers can Duel to you." pPlayer );
		            Stats[ pPlayer.ID ].IgnoreDuel = false;
		        }	
	        }
			else PrivMessage("[Syntax] - /c ignore <pm/goto/spec/duel>" pPlayer );
        }
	else if ( szCommand == "s")
        {
        if ( pPlayer.IsSpawned ) 
            {		
			if ( Stats[ pPlayer.ID ].SandL == null )
			    {
		            Stats[ pPlayer.ID ].SandL = pPlayer.Pos;
                    MessagePlayer("Position Saved! Type "/c l" to Teleport." pPlayer ); 
				}
			else
                {
		            Stats[ pPlayer.ID ].SandL = pPlayer.Pos;
                    MessagePlayer("You have changed the Saved Position! Type "/c l" to Teleport." pPlayer ); 
                }				
		    }
		else PrivMessage("[Error] - You are not Spawned" pPlayer );
	    }	
	else if ( szCommand == "l")
        {
        if ( pPlayer.IsSpawned ) 
		    {
		    if ( Stats[ pPlayer.ID ].SandL == null ) 
                {
		            local SavedPos = Stats[ pPlayer.ID ].SandL;
			        pPlayer.Pos = SavedPos;
			        MessagePlayer("Teleported to saved Position!" pPlayer );
	            }
			else PrivMessage("[Error] - No Position Saved!" pPlayer );
			}
	    else PrivMessage("[Error] - You are not Spawned" pPlayer );
	    }
    else if ( szCommand == "admin" || szCommand == "admins")
	    {
		local 
		        a = 0,
				b = null;
		while ( a <= GetMaxPlayers() )
		    {
			local Admins = FindPlayer( a.tointeger() );
			if ( Admins )
			    {
				if ( Stats[ Admins.ID ].Admin >= 1 )
				    {
					if ( b ) b = b + ", " + Admins.Name + " (" + RCON( pPlayer ) + "Level: " + Stats[ Admins.ID ].Admin + ")"
					else b = Admins.Name + " (" + RCON( pPlayer ) + "Level: " + Stats[ Admins.ID ].Admin + ")"
				    }
			    }
			    a++;
		    }
		    if ( b )
      			{
				    Message("> Online Administrators <");
		            ClientMessageToAll( b, 255, 255, 255);
				}	
		    else Message("There are no Administrators in Game.");
	    }
	else if ( szCommand == "vip" || szCommand == "vips")
	    {
		local 
		        a = 0,
				b = null;
		while ( a <= GetMaxPlayers() )
		    {
			local VIPs = FindPlayer( a.tointeger() );
			if ( VIPs )
			    {
				if ( Stats[ VIPs.ID ].VIP >= 1 )
				    {
					if ( b ) b = b + ", " + VIPs.Name + " (Level: " + Stats[ VIPs.ID ].VIP + ")"
					else b = VIPs.Name + " (Level: " + Stats[ VIPs.ID ].VIP + ")"
				    }
			    }
			    a++;
		    }
		    if ( b )
      			{
				    Message("> Online VIPs <");
		            ClientMessageToAll( b, 255, 255, 255); 
				}	
		    else Message("There are no VIPs in Game.");
	    }
	else if ( szCommand == "spree" || szCommand == "topspree")
	    {
		local 
		        a = 0,
				b = null;
		while ( a <= GetMaxPlayers() )
		    {
			local Players = FindPlayer( a.tointeger() );
			if ( Players )
			    {
				if ( Stats[ Players.ID ].Spree >= 5 )
				    {
					if ( b ) b = b + ", " + Players.Name + " (Spree: " + Stats[ Players.ID ].Spree + ")"
					else b = Players.Name + " (Spree: " + Stats[ Players.ID ].Spree + ")"
				    }
			    }
			    a++;
		    }
		    if ( b )
      			{
				    Message("> Players on Killing <");
		            ClientMessageToAll( b, 255, 255, 255);
				}	
		    else Message("There are no Players on Killing Spree.");
	    }
	else if ( szCommand == "report")
	    {
		if ( Stats[ pPlayer.ID ].Registered == true )
            {		
	        if ( Stats[ pPlayer.ID ].Logged == true ) 
			    {
				if ( szParams )
                    {	
					if ( Plr )
					    {
						if ( Plr == pPlayer )
						    {
                            if ( iParamA1 >= 2 )						
              		            { 	
			                    if ( Stats[ Players.ID ].Admin >= 1 ) MessagePlayer( pPlayer.Name + " (" + pPlayer.ID + ") Reported " + Plr.Name + " (" + Plr.ID + ") Reason: " + szParamA2, Players );
							    MessagePlayer("Your Reported has Successfully Sent to all Online Admins!" pPlayer );
							    Reports.push( pPlayer.Name + " (" + pPlayer.ID + ") Reported " + Plr.Name + " (" + Plr.ID + ") Reason: " + szParamA2 );
		     	                }
						        else PrivMessage("[Syntax] - /c report [ ID ] [ Reason is Empty ]" pPlayer );
							}
                            else PrivMessage("[Error] - You cannot Report Yourself." pPlayer );										
					    }
					    else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                    }
					else PrivMessage("[Syntax] - /c report [ ID ] [ Reason ]" pPlayer );
			    }   
				else PrivMessage("[Error] - You're not Logged in." pPlayer );
			}
            else PrivMessage("[Error] - You're not Registered." pPlayer );			
        }
	else if ( szCommand == "reload")
        {
            ReloadScripts();
        }	
//--------------------------------------------------------		
//-------------------------- ACMDS -----------------------
//--------------------------------------------------------		
   else if ( szCommand == "a")
        { 
		if( Stats[ Players.ID ].Admin >= 1 ) ClientMessage("[Admin Chat] " + pPlayer.Name + ": " + szParams, Players 255, 255, 255 );
		}
	else if ( szCommand == "eject")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( Plr.Vehicle || Plr.IsPassenger )
							    {
								if ( !Plr.IsAdmin )
							        {
						                Plr.Pos=Vector( Plr.Pos.x, Plr.Pos.y, Plr.Pos.z+1 );
									    MessagePlayer("You have ejected " + Plr.Name + "(" + Plr.ID + ") from Vehicle." pPlayer );
						                MessagePlayer("You have been ejected by Admin " + pPlayer.Name + " from Vehicle." Plr );
					                }
								else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
								}
							else PrivMessage("[Error] - " + szParam1 + " is not in Vehicle." pPlayer );	
							}	
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
	else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
		else if ( szCommand == "disarm")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( !Plr.IsAdmin )
							    {
						            Plr.SetWeapon(0,0);
							        MessagePlayer("You have disarmed " + Plr.Name + "(" + Plr.ID + ")" pPlayer );
						            MessagePlayer("You have been disarmed by Admin " + pPlayer.Name, Plr );
					            }
							else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
	else if ( szCommand == "warn")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( szParamA2 )
							    {
								if ( !Plr.IsAdmin )
								    {
									if ( Stats[ Plr.ID ].Warned == false )
									    {
							            Stats[ Plr.ID ].Warnings++;
										Stats[ Plr.ID ].Warned = true;
								    	Stats[ pPlayer.ID ].Warns++;
										NewTimer("WarnTime", 10000, 1, pPlayer.ID );
							            MessagePlayer("You have warned " + Plr.Name + "(" + Plr.ID + ") Reason: " + szParamA2, pPlayer );
						                MessagePlayer("You have been warned by Admin " + pPlayer.Name + " Reason: " + szParamA2, Plr );
						                ClientMessageToAll("Admin " + pPlayer.Name + " has given a warning to " + Plr.Name + " Reason: " + szParamA2 + " (Warns " + Stats[ Plr.ID ].Warnings + "/3)" 255, 255, 0 );
							            if ( Stats[ Plr.ID ].Warnings == 3 )
                                            {
								                MessageAllExcept("VSS-Buster -> Kicked ''" + Plr.Name + "'' (Warns Limit Excited) " Plr );
								                Kick( Plr );
								            }
								        }
									else PrivMessage("[Error] - " + Plr.Name + " is already warned, wait 10 sec to warn again." pPlayer );	
									}	
								else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
                                }								
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Reason]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Reason]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }	
	else if ( szCommand == "kick")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( szParamA2 )
							    {
								if ( !Plr.IsAdmin )
								    {							       
						                ClientMessageToAll("Admin " + pPlayer.Name + " has kicked " + Plr.Name + " from Server Reason: " + szParamA2, 255, 255, 0 );
								    	MessagePlayer(" " Plr );
								    	MessagePlayer(" " Plr );
								    	MessagePlayer(" " Plr );
								    	MessagePlayer(" " Plr );
								    	MessagePlayer(" " Plr );
								    	ClientMessage("You have been Kicked by Administrator " + pPlayer.Name, Plr 255, 255, 0 );
								    	MessagePlayer("Reason: " + szParamA2, Plr );
										Stats[ pPlayer.ID ].Kicks++;
									    Kick( Plr );
                                    }
								else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
								}	
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Reason]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Reason]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
	else if ( szCommand == "slap")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
						    {
							if ( !Plr.IsAdmin )
					            {
						            Plr.Pos=Vector( Plr.Pos.x, Plr.Pos.y, Plr.Pos.z+30 );
							        MessagePlayer("You slapped " + Plr.Name + "(" + Plr.ID + ")." pPlayer );
                                    MessagePlayer("You have been slapped by Admin " + pPlayer.Name, Plr );		
							    }	
							else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }	
	else if ( szCommand == "mute")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( szParam2 )
							    {
								if ( IsNum( szParam2 ) )
								    {									                        		
									if ( szParam2.tointeger() <= 5 )
									    {
										if ( szParam2.tointeger() >= 1 )
									        {
										    if ( szParam3 )
										        {
								                if ( !Plr.IsAdmin )
								                    {	
													if ( Stats[ Plr.ID ].Muted == false )
													    {
                                                            Stats[ Plr.ID ].MuteTime = szParam2.tointeger();
					                                        Stats[ Plr.ID ].MuteRem = (szParam2.tointeger()*60);										
											    	    	Stats[ pPlayer.ID ].Mutes++;
												        	Plr.IsMuted = true;
											    	    	Stats[ Plr.ID ].Muted = true;
                                                            ClientMessageToAll("Admin " + pPlayer.Name + " has muted " + Plr.Name + " for " + szParam2 + " Minutes Reason: " + szParamA3, 255, 255, 0 );
								    	                    ClientMessage("You have been Muted by Admin " + pPlayer.Name + " for " + szParam2 + " Minutes", Plr 255, 255, 0 );	    	
														}
													else PrivMessage("[Error] - " + Plr.Name + " is already Muted for " + Stats[ Plr.ID ].MuteTime + " Minutes." pPlayer );	 	
                                                    }
								                else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
								                }										
                                            else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Minutes] [Reason]" pPlayer );							
											}
										else PrivMessage("[Error] - Minutes must be [1/2/3/4/5]." pPlayer );		
								        }
								    else PrivMessage("[Error] - Minutes must be [1/2/3/4/5]." pPlayer );	
								    }
								else PrivMessage("[Error] - Minutes must be numbers." pPlayer );	
								}
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Minutes] [Reason]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Minutes] [Reason]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
	else if ( szCommand == "unmute")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( Stats[ Plr.ID ].Muted == true || Stats[ Plr.ID ].AutoMute == true )
							    {
									Plr.IsMuted = false;
									Stats[ Plr.ID ].Muted = false;
									Stats[ Plr.ID ].MuteTime = 0;
					                Stats[ Plr.ID ].MuteRem = 0;
									Stats[ pPlayer.ID ].AutoMute = false;
						     	    Stats[ pPlayer.ID ].AutoMuteCount = 60;
                                    ClientMessageToAll("Admin " + pPlayer.Name + " has UnMuted " + Plr.Name, 255, 255, 0 );
								    ClientMessage("You have been UnMuted by Admin " + pPlayer.Name, Plr 255, 255, 0 );	    	
					            }
				            else PrivMessage("[Error] - " + Plr.Name + " is already UnMute or Not Spawned." pPlayer );	 	                        						
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "jail")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( szParam2 )
							    {
								if ( IsNum( szParam2 ) )
								    {									                        		
									if ( szParam2.tointeger() <= 5 )
									    {
										if ( szParam2.tointeger() >= 1 )
									        {
										    if ( szParam3 )
										        {
								                if ( !Plr.IsAdmin )
								                    {	
													if ( Stats[ Plr.ID ].Jailed == false )
													    {                                   
                                                        if ( Plr.IsSpawned )
                                                            {														
					                                            Stats[ Plr.ID ].JailTime = (szParam2.tointeger()*60);															    	  
											    	    	    Stats[ Plr.ID ].Jailed = true;
														    	Stats[ pPlayer.ID ].Jails++;							
                                                                ClientMessageToAll("Admin " + pPlayer.Name + " has Jailed " + Plr.Name + " for " + szParam2 + " Minutes Reason: " + szParamA3, 255, 255, 0 );
								    	                        MessagePlayer("You have been Jailed by Admin " + pPlayer.Name + " Reason: " + szParamA3, Plr);	    
                                                                Announce("\x10 \x10 ~g~ Busted by ~b~ Admins!" pPlayer );															
														    }
														else PrivMessage("[Error] - " + Plr.Name + " is not Spawned." pPlayer );	 		
														}	
													else PrivMessage("[Error] - " + Plr.Name + " is already in Jail." pPlayer );	 	
                                                    }
								                else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
								                }										
                                            else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Minutes] [Reason]" pPlayer );							
											}
										else PrivMessage("[Error] - Minutes must be [1/2/3/4/5]." pPlayer );		
								        }
								    else PrivMessage("[Error] - Minutes must be [1/2/3/4/5]." pPlayer );	
								    }
								else PrivMessage("[Error] - Minutes must be numbers." pPlayer );	
								}
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Minutes] [Reason]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Minutes] [Reason]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
	else if ( szCommand == "unjail")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( Stats[ Plr.ID ].Jailed == true )
							    {
								if ( Plr != pPlayer && pPlayer.IsAdmin )
								    {
								    	Stats[ Plr.ID ].JailTime = 0;
					                    Stats[ Plr.ID ].Jailed = false;
								    	onPlayerSpawn( pPlayer );
								        Announce("\x10 \x10 ~p~ UnJailed!" pPlayer );
                                        ClientMessageToAll("Admin " + pPlayer.Name + " has UnJailed " + Plr.Name, 255, 255, 0 );
								        ClientMessage("You have been UnJailed by Admin " + pPlayer.Name, Plr 255, 255, 0 );	    	
									}	
									else PrivMessage("[Error] - You Can't UnJail your self." pPlayer );	 	                        						
					            }
				            else PrivMessage("[Error] - " + Plr.Name + " is not in Jail." pPlayer );	 	                        						
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
	else if ( szCommand == "jailed")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    {
		            local 
		                    a = 0,
			            	b = null;
							
 		            while ( a <= GetMaxPlayers() )
		                {
			            local Players = FindPlayer( a.tointeger() );
			            if ( Players )
			                {
				            if ( Stats[ Players.ID ].Jailed == true )
				                {
					            if ( b ) b = b + ", " + Players.Name + " (ID: " + Players.ID + ")(Time: " + Stats[ Players.ID ].JailTime + ")"
				               	else b = Players.Name + " (ID: " + Players.ID + ")(Time: " + Stats[ Players.ID ].JailTime + ")"
				                }
			                }
			            a++;
		                }
		            if ( b )
      			        {
				            Message("> Jailed Players <");
		                    ClientMessage( b, pPlayer 255, 255, 255);
			        	}	
		            else Message("There are no Players in Jail.");			
					}
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "reports")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					if ( Reports.len() > 0 ) 
					    {
					    if ( szParam1 == "all" )
					        {
							MessagePlayer("----> Players All Reports <----" pPlayer );
						    local i = Reports.len()-20;
		                    if( i<0 ) i = 0;
		                    for( ;i<Reports.len();i++)
                            MessagePlayer(Reports[i], pPlayer);
                            }
					    else  
					        {
							MessagePlayer("----> Players Reports <----" pPlayer );
						    local i = Reports.len()-5;
		                    if( i<0 ) i = 0;
		                    for( ;i<Reports.len();i++) 
							MessagePlayer(Reports[i], pPlayer );		
                     	    }
                        }							
                    else PrivMessage("There are no Reports" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "clearchat")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 1 )
				    { 
					    Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
						Message(" ");
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "asay")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 4 )
				    { 
					if ( szParams )
					    {
						    ClientMessageToAll("[Admin] " + pPlayer.Name + "(ID:" + pPlayer.ID + "): " + szParams, 255, 255, 255 );
						}
					else PrivMessage("[Syntax] - /c " + szCommand + " [Text]" pPlayer );							 	
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }			
	else if ( szCommand == "announce")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 4 )
				    { 
					if ( szParams )
					    {
						    AnnounceAll("\x10 \x10 \x10 \x10 ~w~" + szParams );
						}
					else PrivMessage("[Syntax] - /c " + szCommand + " [Text]" pPlayer );							 	
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }			
	else if ( szCommand == "teleplayer")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 4 )
				    { 
					if ( szParams )
					    {
						if ( Plr )
						    {
							if ( szParam2 )
							    {
								local Plr2;
								if ( IsNum( szParam2 ) ) Plr2 = FindPlayer( szParam2.tointeger() ); 
								else Plr2 = FindPlayer( szParam2 );
								if ( Plr2 )
								    {
						                Plr.Pos = Plr2.Pos;
										MessagePlayer("You have been teleported to " + Plr2.Name + " by Admin " + pPlayer.Name, Plr );	
							            MessagePlayer( Plr.Name + " has been teleported to you by Admin " + pPlayer.Name, Plr2 );
                                        MessagePlayer("Taking " + Plr.Name + "(ID:" + Plr.ID + ") to " + Plr2.Name + "(ID:" + Plr2.ID + ")" Plr2 );
							        }
							    else PrivMessage("[Error] - " + szParam2 + " is not Connected!" pPlayer );	
							    }
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [ID/Nick]" pPlayer );							 	
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
						}
					else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [ID/Nick]" pPlayer );							 	
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "rweapon")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					local
        					RWep = rand() % 10,
							GRWep = RWep.tointeger();
							
					    Players.SetWeapon( GRWep,9999);
						AnnounceAll("\x10 \x10 \x10 \x10 ~o~This time to ~p~fight ~o~with ~b~" + GetWeaponName( GRWep ) );					 	
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "giveweapon")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( szParam2 )
							    {
								local Wep;							
								if ( IsNum( szParam2 ) ) Wep = szParam2.tointeger(); 
								else Wep = GetWeaponID( szParam2 );
								if ( Wep <= 33 )
								    {									                        		
									if ( szParam3 )
									    {
										if ( IsNum( szParam3 ) )
										    {
								            if ( !Plr.IsAdmin )
								                {	
											    if ( Stats[ Plr.ID ].Jailed == false )
											        {                                   
                                                    if ( Plr.IsSpawned )
                                                        {								
                                                            Plr.SetWeapon( Wep,szParam3.tointeger());
															MessagePlayer("Admin " + pPlayer.Name + " has given you " + GetWeaponName( Wep ) + " with " + szParam3 + " Ammo." Plr );	    														
								    	                    MessagePlayer("You have given " + GetWeaponName( Wep ) + " to " + Plr.Name + " with " + szParam3 + " Ammo." pPlayer );	    														
						                                }	
								                    else PrivMessage("[Error] - " + Plr.Name + " is not Spawned." pPlayer );	
													}
												else PrivMessage("[Error] - " + Plr.Name + " is in Jail." pPlayer );	 	 	
								                }										
                                            else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
											}
										else PrivMessage("[Syntax] - Weapon Ammo must be in Numbers." pPlayer );							
								        }
								    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [WepID/Name] [Ammo]" pPlayer );							
								    }
								else PrivMessage("[Error] - " + szParam2 + " is Invalid Weapon ID/Name." pPlayer );	
								}
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [WepID/Name] [Ammo]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [WepID/Name] [Ammo]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "spawn")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {			
                            if ( !Plr.IsAdmin )
                                {							
						            onPlayerSpawn( Plr );
                                    MessagePlayer("You have Spawned " + Plr.Name + "(" + Plr.ID + ")" pPlayer );
						            MessagePlayer("You have been Spawned by Admin " + pPlayer.Name, Plr );
								}
							else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );		
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }								
	else if ( szCommand == "carcolor")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					if ( szParams ) 
					    {
					    if ( IsNum( szParam1 ) )
					        {			
                            if ( szParam2 )
                                {					
                                if ( IsNum( szParam2 ) )
                                    {			
                                    if ( pPlayer.Vehicle )
                                        {								
                                        local 
											    Veh = pPlayer.Vehicle,
                                                CVeh = CreateVehicle( 232, pPlayer.Pos, pPlayer.Angle, szParam1.tointeger(), szParam2.tointeger() );                                       													
										        Veh.Remove();
	                                            pPlayer.Vehicle = CVeh;                                       
                                                MessagePlayer("Vehicle Color has been changed, Primary Color:[" + szParam1 + "], Secondary Color:[" + szParam2 + "]" pPlayer );						  
										}
									else PrivMessage("[Error] - You must be in Vehicle!" pPlayer );
							     	}
				         		else PrivMessage("[Error] - Color must be Numbers!" pPlayer );
                                }							
                            else PrivMessage("[Syntax] - /c " + szCommand + " [Color1] [Color2]" pPlayer );	
							}
						else PrivMessage("[Error] - Color must be Numbers!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [Color1] [Color2]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "gethere" || szCommand == "get" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {			
                            if ( !Plr.IsAdmin )
                                {							
						            Plr.Pos = pPlayer.Pos;
                                    MessagePlayer( Plr.Name + "(" + Plr.ID + ") teleported to your Location." pPlayer );
						            MessagePlayer("You have been Teleported to Admin " + pPlayer.Name + "'s Location.", Plr );
								}
							else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );		
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "ban")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( szParam2 )
							    {
								if ( IsNum( szParam2 ) )
								    {		
									if ( szParam3 )
										{
								        if ( !Plr.IsAdmin )
								            {						
                                                Stats[ pPlayer.ID ].Bans++;											
                                                QuerySQL( db, "INSERT INTO Bans ( Name, IP, Admin, Days, Reason, Date ) VALUES ( '" + Plr.Name + "', '" + Plr.IP + "', '" + pPlayer.Name + "', '" + szParam2 + "', '" + szParamA3 + "', '" + GetFullTime() + "' )");                                         
	                                            Message("-----> Ban Info <-----");
                                               	ClientMessageToAll(" " + Plr.Name + " has Banned by Administrator " + pPlayer.Name, 255, 255,0 );
	                                            ClientMessageToAll("for '' " + szParam2 + " '' Days Reason: ''" + szParamA3 + "''" 255, 255, 0 );
                                                Message("----------------------------");
                                                MessagePlayer("" pPlayer );
                                                MessagePlayer("" pPlayer );
                                                MessagePlayer("" pPlayer );
                                                MessagePlayer("-------> Ban Info <------" pPlayer );
                                                ClientMessage("You are Banned by Administrator " + pPlayer.Name + " " pPlayer 255, 255, 0 );	
                                                ClientMessage("for ''" + szParam2 + "'' Days Reason: ''" + szParamA3 + "''" pPlayer 255, 255, 0 );
	                                            ClientMessage("Press F8 to take a Screen shot, make an UnBan Appeal at Vcmp.RPGKillerS.Com" pPlayer 255, 255, 0 );
												MessagePlayer("------------------------------" pPlayer );
	                                            Kick( pPlayer );
                                            }
								        else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );									                												
								        }
								    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Days] [Reason]" pPlayer );							
								    }
								else PrivMessage("[Error] - Days must be numbers." pPlayer );	
								}
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Days] [Reason]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Days] [Reason]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }						
	else if ( szCommand == "event")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					if ( szParams ) 
					    {
					    if ( IsNum( szParam1 ) )
					        {			
                            if ( szParam1.tointeger() <= 5 )
                                {					                            
			          		    if ( szParam2 ) 
					                {			
									if ( IsNum( szParam2 ) )
									    {
                                        if ( szParam2.tointeger() >= 1000 )
                                            {							
											if ( pPlayer.Cash > szParam2.tointeger() )
											    {
                                                if ( Event == false )
                                                    {			
                                                    if ( pPlayer.IsSpawned )
                                                        {												
                                                            local 
															        Pos = pPlayer.Pos,
                                                                    pickup = CreatePickup( 405, Vector( Pos.x, Pos.y, Pos.z ) );
																	
															pickup.SetOnceOnly();		
                                                            Event = true;
							             		            EventTime = (szParam1.tointeger()*60);
							            		            EventReward = szParam2.tointeger();
								            	            pPlayer.Cash -= szParam2.tointeger();
													        AnnounceAll("\x10 \x10 \x10 \x10 \x10 ~y~ Event Started!");
													        ClientMessageToAll("Admin " + pPlayer.Name + "(ID:" + pPlayer.ID + ") has Created an Event in " + GetDistrictName( pPlayer.Pos.x, pPlayer.Pos.y ) + " Event Reward: $" + szParam2 + " Time: " + szParam1 + " Minutes" RandomColors[ rand() % RandomColors.len() ][0], RandomColors[ rand() % RandomColors.len() ][1], RandomColors[ rand() % RandomColors.len() ][2] ); 
													        onPlayerSpawn( pPlayer );
                                                            MessagePlayer("Successfully Created Event!" pPlayer );
													    }
                                                    else PrivMessage("[Error] - You're not Spawned!" pPlayer );												 													
												    }
                                                else PrivMessage("[Error] - Event is already in Process." pPlayer );	
                                                }
											else PrivMessage("[Error] - You don't have enough Cash." pPlayer );	
							               	}
							            else PrivMessage("[Error] - Event Cash amount must be at least 1000." pPlayer );
										}
									else PrivMessage("[Error] - Event Cash must be numbers." pPlayer );		
									}
								else PrivMessage("[Syntax] - /c " + szCommand + " [Time] [Cash]" pPlayer );							
								}	
                             else PrivMessage("[Error] - Event Time must be 1 to 5 Minutes." pPlayer );	
							}
						else PrivMessage("[Error] - Event Time must be numbers." pPlayer );	
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [Time] [Cash]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "stopevent")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 5 )
				    { 
					if ( Event == true )
					    {
		                    local pickup = FindPickup( 405 );
                            ClientMessageToAll("Admin " + pPlayer.Name + " has Stoped the Event." RandomColors[ rand() % RandomColors.len() ][0], RandomColors[ rand() % RandomColors.len() ][1], RandomColors[ rand() % RandomColors.len() ][2] ); 
	                   		AnnounceAll("\x10 \x10 \x10 \x10 \x10 ~r~ Event Over!");
	                		Event = false;
	                 		EventTime = 0;
			                EventReward = 0;
                            pickup.Remove();
			            }
			        else PrivMessage("[Error] - There are no Event to Stop." pPlayer );
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }					
	else if ( szCommand == "freeze" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 6 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {			
                            if ( !Plr.IsAdmin )
                                {							
								if ( Plr.IsFrozen == false )
								    {
						                Plr.IsFrozen = true;
                                        MessagePlayer( "You have Frozen " + Plr.Name + "(" + Plr.ID + ")" pPlayer );
						                MessagePlayer("Admin " + pPlayer.Name + " has Frozen you." Plr );
									}	
								else PrivMessage("[Error] - This Payer is already Frozen." pPlayer );			
								}
							else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );		
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "unfreeze" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 6 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {			
                            if ( !Plr.IsAdmin )
                                {							
								if ( Plr.IsFrozen == true )
								    {
						                Plr.IsFrozen = false;
                                        MessagePlayer( "You have Un-Frozen " + Plr.Name + "(" + Plr.ID + ")" pPlayer );
						                MessagePlayer("Admin " + pPlayer.Name + " has Un-Frozen you." Plr );
									}	
								else PrivMessage("[Error] - This Payer is already Un-Frozen." pPlayer );			
								}
							else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );		
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "write")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 6 )
				    { 
					if ( szParams )
					    {
						if ( IsNum( szParam1 ) )
						    {
							if ( szParam1.len() <= 3 )
							    {
								if ( szParam1.tointeger() <= 255 )
								    {
							        if ( szParam2 )
                                        {
								        if ( IsNum( szParam2 ) )
								            {
										    if ( szParam2.len() <= 3 )
										        {
												if ( szParam2.tointeger() <= 255 )
												    {
				 	                                if ( szParam3 )
					                                    {
						                                if ( IsNum( szParam3 ) )
						                                    {
													        if ( szParam3.len() <= 3 )
													            {
																if ( szParam3.tointeger() <= 255 )
																    {
																	local TextParam = GetTok( szParams, " ", 4, NumTok( szParams, " " ) );
							                                        if ( TextParam )
							                                            {						
						                                                    ClientMessageToAll(TextParam, szParam1.tointeger(), szParam2.tointeger(), szParam3.tointeger() );
						                                                }										
									                                }									 
							                                    else PrivMessage("[Error] - RBG Code value must be 255 or less then it." pPlayer );
					                                            }
					                                        else PrivMessage("[Error] - RBG Code must be 1 to 3 Digits, E.g. 255, 98, 0 etc.." pPlayer );
							                                }								
		                                                else PrivMessage("[Error] - Blue Colour Code must be number." pPlayer );
						                                }						
					                                else PrivMessage("[Syntax] - /c " + szCommand + " [Colour-R] [Colour-G] [Colour-B] [Text]" pPlayer );
									                }									 
							                    else PrivMessage("[Error] - RBG Code value must be 255 or less then it." pPlayer );
					                            }
					                        else PrivMessage("[Error] - RBG Code must be 1 to 3 Digits, E.g. 255, 98, 0 etc.." pPlayer );
						                  	}								
		                                else PrivMessage("[Error] - Green Colour Code must be number." pPlayer );
					                 	}						
                                    else PrivMessage("[Syntax] - /c " + szCommand + " [Colour-R] [Colour-G] [Colour-B] [Text]" pPlayer );							
									}									 
							    else PrivMessage("[Error] - RBG Code value must be 255 or less then it." pPlayer );
					            }
					        else PrivMessage("[Error] - RBG Code must be 1 to 3 Digits, E.g. 255, 98, 0 etc.." pPlayer );
							}								
		                else PrivMessage("[Error] - Red Colour Code must be number." pPlayer );
						}						
					else PrivMessage("[Syntax] - /c " + szCommand + " [Colour-R] [Colour-G] [Colour-B] [Text]" pPlayer );							 	
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "givecar")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 7 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {
							if ( szParam2 )
							    {
								local Veh;							
								if ( IsNum( szParam2 ) ) Veh = szParam2.tointeger(); 
								else Veh = GetVehicleModelFromName( szParam2 );
								if ( Veh <= 236 && Veh >= 130 )
								    {									                        		
									if ( szParam3 )
									    {
										if ( IsNum( szParam3 ) )
										    {
											if ( szParam3.len() <= 3 )
											    {
												if ( szParam3.tointeger() <= 255 )
												    {
								                    if ( !Plr.IsAdmin )
								                        {	
											            if ( Stats[ Plr.ID ].Jailed == false )
											               {                                   
                                                           if ( Plr.IsSpawned )
                                                                {					
                                                                if ( !Plr.Vehicle )
                                                                    {																
	                                                                    local CreateVeh = CreateVehicle( Veh.tointeger(), Plr.Pos, Plr.Angle, szParam3.tointeger(), szParam3.tointeger() );	                                                 
	                                                                    Plr.Vehicle = CreateVeh;
														             	MessagePlayer("Admin " + pPlayer.Name + " has given you Vehicle: " + GetVehicleNameFromModel( Veh ) + "." Plr );	    														
								    	                                MessagePlayer("You have given " + Plr.Name + " a Vehicle: " + GetVehicleNameFromModel( Veh ), pPlayer );	    														
																	}
																else PrivMessage("[Error] - " + Plr.Name + " is already in Vehicle." pPlayer );		
						                                        }	
								                            else PrivMessage("[Error] - " + Plr.Name + " is not Spawned." pPlayer );	
													        }
											         	else PrivMessage("[Error] - " + Plr.Name + " is in Jail." pPlayer );	 	 	
								                        }										
                                                    else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );	
											        }
											    else PrivMessage("[Error] - Colour Code must be 0 to 255." pPlayer );		
											    }
                                            else PrivMessage("[Error] - Colour Code must be under 3 Digits." pPlayer );																		
											}
										else PrivMessage("[Error] - Colour must be in Numbers." pPlayer );							
								        }
								    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Vehicle ID/Name] [Colour]" pPlayer );							
								    }
								else PrivMessage("[Error] - " + szParam2 + " is Invalid Vehicle ID/Name." pPlayer );	
								}
							else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Vehicle ID/Name] [Colour]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick] [Vehicle ID/Name] [Colour]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }					
	else if ( szCommand == "akill" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 8 )
				    { 
					if ( szParams ) 
					    {
					    if ( Plr )
					        {			
                            if ( !Plr.IsAdmin )
                                {							
								if ( Plr.IsSpawned )
								    {
						                Plr.Health = 0;
                                        MessagePlayer( "You have Killed " + Plr.Name + "(" + Plr.ID + ")" pPlayer );
						                MessagePlayer("Admin " + pPlayer.Name + " has Killed you." Plr );
									}	
								else PrivMessage("[Error] - " + Plr.Name + " is not Spawned!" pPlayer );			
								}
							else PrivMessage("[Error] - You can't use this Cmd on that Administrator." pPlayer );		
							}
						else PrivMessage("[Error] - " + szParam1 + " is not Connected!" pPlayer );
                        }							
                    else PrivMessage("[Syntax] - /c " + szCommand + " [ID/Nick]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }					
	else if ( szCommand == "god" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 8 )
					{		
					if ( pPlayer.IsSpawned )
					    {
						if ( Stats[ pPlayer.ID ].GodMode == false )
						    {
						        Stats[ pPlayer.ID ].GodMode = true;
                                MessagePlayer( "GodMode: ''ON''" pPlayer );
							}
                        else 
						    {
							    Stats[ pPlayer.ID ].GodMode = false;
								MessagePlayer( "GodMode: ''OFF''" pPlayer );
						    }
						}	
					else PrivMessage("[Error] - You're not Spawned!" pPlayer );			
					}
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "destroycar" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
					{		
					if ( pPlayer.Vehicle )
					    {
						    local Veh = pPlayer.Vehicle;
							Veh.KillEngine();
							Veh.Health = 0;
							MessagePlayer("Successfully! Car will be destroyed in 3 Seconds." pPlayer );						 
						}	
					else PrivMessage("[Error] - You're not in Vehicle!" pPlayer );			
					}
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "healall" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
					{		
                        Players.Health = 100;						
						MessagePlayer("Admin " + pPlayer.Name + " has restored all Players Health." Players );						 
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "armourall" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
					{		
                        Players.Armour = 100;						
						MessagePlayer("Admin " + pPlayer.Name + " has restored all Players Armour." Players );						 
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "disarmall" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
					{		
                        Players.SetWeapon(0,0);
						MessagePlayer("Admin " + pPlayer.Name + " has Disarmed all Players." Players );						 
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "setallskin" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
					{		
					if ( szParams )
					    {
						if ( IsNum( szParam1 ) )
						    {
							if ( GetSkinName( szParam1.tointeger() ) )
							    {
                                    Players.Skin = szParam1.tointeger();						
						            MessagePlayer("Admin " + pPlayer.Name + " has Set all Players Skin to " + szParam1 + " (" + GetSkinName( szParam1.tointeger() ) + ")" Players );						 
								}
							else PrivMessage("[Error] - " + szParam1 + " is not valid skin ID!" pPlayer );	
							}
						else PrivMessage("[Error] - Skin must be in Numbers." pPlayer );	
						}	
					else PrivMessage("[Syntax] - /c " + szCommand + " [Skin ID]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }		
	else if ( szCommand == "setallweather" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
					{		
					if ( szParams )
					    {
						if ( IsNum( szParam1 ) )
						    {
                                SetWeather( szParam1.tointeger() );					
						        MessagePlayer("Admin " + pPlayer.Name + " has Set all Players Weather to " + GetWeather(), Players );						 
						    }
						else PrivMessage("[Error] - Weather must be in Numbers." pPlayer );	
						}	
					else PrivMessage("[Syntax] - /c " + szCommand + " [Weather ID]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
	else if ( szCommand == "setalltime" )
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
					{		
					if ( szParams )
					    {
						if ( IsNum( szParam1 ) )
						    {
                                SetTimeRate( szParam1.tointeger() );
						        MessagePlayer("Admin " + pPlayer.Name + " has Set all Players Time to " + GetTimeRate(), Players );						 
						    }
						else PrivMessage("[Error] - Time Rate must be in Numbers." pPlayer );	
						}	
					else PrivMessage("[Syntax] - /c " + szCommand + " [Time Rate]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }
	else if ( szCommand == "giveallweapon")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 9 )
				    { 
					if ( szParams ) 
					    {						
						local Wep;							
						if ( IsNum( szParam1 ) ) Wep = szParam1.tointeger(); 
						else Wep = GetWeaponID( szParam1 );
						if ( Wep <= 33 )
						    {
							if ( szParam2 )
							    {
								if ( IsNum( szParam2 ) )
								    {								
                                        Players.SetWeapon( Wep,szParam2.tointeger());
										MessagePlayer("Admin " + pPlayer.Name + " has given Weapon " + GetWeaponName( Wep ) + " with " + szParam2 + " Ammo to all Players." Players );	    														
						            }									             
								else PrivMessage("[Syntax] - Weapon Ammo must be in Numbers." pPlayer );							
								}
							else PrivMessage("[Syntax] - /c " + szCommand + " [WepID/Name] [Ammo]" pPlayer );							
					        }
						else PrivMessage("[Error] - " + szParam1 + " is Invalid Weapon ID/Name." pPlayer );	
						}						
                    else PrivMessage("[Syntax] - /c " + szCommand + " [WepID/Name] [Ammo]" pPlayer );							
					}	
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "screen")
        {    
		if ( Stats[ pPlayer.ID ].Registered == true )
		    { 
	        if ( Stats[ pPlayer.ID ].Logged == true )
     			{ 
		        if ( Stats[ pPlayer.ID ].Admin >= 10 )
				    { 
					if ( szParams )
					    {
						if ( Plr )
						    {
							if ( szParam2 )
							    {
                                    AnnounceAll("\x10 \x10 \x10 ~w~" + szParamA2 );
								}	
							else PrivMessage("[Syntax] - /c " + szCommand + " [Nick/ID] [Text]" pPlayer );							 		
							}	
						else PrivMessage("[Error] - " + szParam1 + " is not Connected." pPlayer );			
						}
					else PrivMessage("[Syntax] - /c " + szCommand + " [Nick/ID] [Text]" pPlayer );							 	
                    }								
		        else PrivMessage("[Error] - Your Level is not higher enough to use this Cmd." pPlayer );
		        }
		    else PrivMessage("[Error] - You're not Logged in." pPlayer );
          	}	
		else PrivMessage("[Error] - You're not Registered." pPlayer );					
	    }				
	else if ( szCommand == "setlvl")
        {    
		if ( pPlayer.IsAdmin )
		    {
			if ( Plr )
			    {
                Stats[ Plr.ID ].Admin = szParam2.tointeger();
				}
			}					
	    }
//--------------------------------------------------------
//--------------------------------------------------------
        
    else MessagePlayer( szCmdError + " is Invalid Cmd! Type ''/C Cmds''." pPlayer );
	}
 catch(e) Print("onPlayerCommand Error: " + e );
}

function onPlayerCommand2( pPlayer, szCommand, szParams )
{
 try
	{
	local
			Players,
			Plr,
		    PlayersCount  =   0, 
	        szCommand     =   szCommand, 
	    	iParams       =   ( szParams ? split( szParams, " ").len() : 0 );
	
	if ( szParams )
	    {
		    if ( IsNum( szParams ) ) Plr = FindPlayer( szParams.tointeger() );
			else Plr = FindPlayer( szParams );
		}
	
	if ( szCommand == "leave")
        {
	    if ( !pPlayer.IsSpawned ) PrivMessage("[Error] - You are not Spawned" pPlayer );
		else if ( Stats[ pPlayer.ID ].Leave == false ) return MessagePlayer("You are already out of zone." pPlayer );
		else 
		    {
			    Announce("~h~Leaving..." pPlayer );
				Stats[ pPlayer.ID ].Leave = false;
		        NewTimer("Spawner",3000,1, pPlayer );
		    }
        }
	else if ( szCommand == "players")
        {
			MessagePlayer("Players online: " + GetPlayers() + "/" + GetMaxPlayers(), pPlayer );
        }
	    else MessagePlayer( szCommand + " is Invalid Cmd! Type "/c cmds"." pPlayer );
	}
	catch(e) Print("onPlayerCommand2 Error: " + e );
} 
