/*---------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                 Vice Super Stunt
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
 
const ScriptName    =    "Vice Super Stunt";
const Creator       =    "JaVeD";
const Mode          =    "DM-Stunt-Race-RP-Freeroam";
const Version       =    "v-0.1 ";
const Credits       =    "JaVeD";
const NameServer    =    "Vice Super Stunt > Vcmp.RPGKillerS.Com <";

const ICOL_WHITE    =    "\x000300";
const ICOL_BLACK    =    "\x000301";
const ICOL_BLUE     =    "\x000302";
const ICOL_GREEN    =    "\x000303";
const ICOL_RED      =    "\x000304";
const ICOL_BROWN    =    "\x000305";
const ICOL_PURPLE   =    "\x000306";
const ICOL_ORANGE   =    "\x000307";
const ICOL_YELLOW   =    "\x000308";
const ICOL_LGREEN   =    "\x000309";
const ICOL_CYAN     =    "\x000310";
const ICOL_LCYAN    =    "\x000311";
const ICOL_LBLUE    =    "\x000312";
const ICOL_PINK     =    "\x000313";
const ICOL_GREY     =    "\x000314";
const ICOL_LGREY    =    "\x000315";
const ICOL          =    "\x0003";
const ICOL_BOLD     =    "\x0002";
const ICOL_ULINE    =    "\x0031";
	
class PlayerStats
{
    User = null;
	Password = null;
    Admin = 0;
	VIP = 0;
    Kills = 0;
    Deaths = 0;
    Stunt = 0;
    Drift = 0;
	Hours = 0;
	Minutes = 0;
	Seconds = 0;
	Respect = 0;
    UnRespect = 0;
	Cash = 0;
    BankCash = 0;
    Coins = 0;
	Score = 0;
	BestSpree = 0;
	Joins = 0;
	PlayerIP = null;
	LastDate = null;
	RegDate = null;
	Bans = 0;
	Kicks = 0;
	Jails = 0;
	Mutes = 0;
	Warns = 0;
	Spree = 0;
	Muted = false;
	MuteTime = 0;
	MuteRem = 0;
	AutoMute = false;
	AutoMuteCount = 60;
	SCounter = 0;
	STimer = 0;
	PTextCount = 0;
	PText = null;
	SandL = null;
	Registered = false;     
	Logged = false;
	FirstSpawned = false;
	Warned = false;
	Warnings = 0;
	Jailed = false;
	JailTime = 0;
	Attemps = 0;
	Process = false;
    Leave = false;
	AntiHPHack = false;
	GodMode = false;
	GodCar = false;
    IgnorePM = false;
    IgnoreGoto = false;
    IgnoreSpec = false;
    IgnoreDuel = false;
	
constructor( szPlayerName )
	{
	local 
	        PlayerQuery   =    ::QuerySQL( db, "SELECT Name, Pass, Admin, VIP, Kills, Deaths, Stunt, Drift, Hours, Minutes, Seconds, Respect, UnRespect, Cash, BankCash, Coins, Score, BestSpree, Joins, IP, LastDate, RegDate FROM Accounts WHERE Name='" + szPlayerName + "'" ),
	        AdminQuery    =    ::QuerySQL( db, "SELECT Bans, Kicks, Jails, Mutes, Warns FROM AdminStats WHERE Name='" + szPlayerName + "'" ); 			
			
	if ( ::GetSQLColumnData( PlayerQuery, 0 ) != null )
        {
		    User = ::GetSQLColumnData( PlayerQuery, 0 );
			Password = ::GetSQLColumnData( PlayerQuery, 1 );
		    Admin = ::GetSQLColumnData( PlayerQuery, 2 );
    		VIP = ::GetSQLColumnData( PlayerQuery, 3 );
            Kills = ::GetSQLColumnData( PlayerQuery, 4 );
            Deaths = ::GetSQLColumnData( PlayerQuery, 5 );
            Stunt = ::GetSQLColumnData( PlayerQuery, 6 ); 
    	    Drift = ::GetSQLColumnData( PlayerQuery, 7 );
			Hours = ::GetSQLColumnData( PlayerQuery, 8 );
		    Minutes = ::GetSQLColumnData( PlayerQuery, 9 );
	    	Seconds = ::GetSQLColumnData( PlayerQuery, 10 );
    		Respect = ::GetSQLColumnData( PlayerQuery, 11 );
			UnRespect = ::GetSQLColumnData( PlayerQuery, 12 );
		    Cash = ::GetSQLColumnData( PlayerQuery, 13 );
		    BankCash = ::GetSQLColumnData( PlayerQuery, 14 );
	     	Coins = ::GetSQLColumnData( PlayerQuery, 15 );
		 	Score = ::GetSQLColumnData( PlayerQuery, 16 );
			BestSpree = ::GetSQLColumnData( PlayerQuery, 17 );
			Joins = ::GetSQLColumnData( PlayerQuery, 18 );
	 	    PlayerIP = ::GetSQLColumnData( PlayerQuery, 19 );
	    	LastDate = ::GetSQLColumnData( PlayerQuery, 20 );
		    RegDate = ::GetSQLColumnData( PlayerQuery, 21 );
        }
		::FreeSQLQuery( PlayerQuery );
		
	if ( Admin >=1 ) 
        {
		if ( ::GetSQLColumnData( AdminQuery, 0 ) != null )
            {
                Bans = ::GetSQLColumnData( AdminQuery, 0 );
				Kicks = ::GetSQLColumnData( AdminQuery, 1 );
                Jails = ::GetSQLColumnData( AdminQuery, 2 );
                Mutes = ::GetSQLColumnData( AdminQuery, 3 );
                Warns = ::GetSQLColumnData( AdminQuery, 4 ); 
            }
			::FreeSQLQuery( AdminQuery );
		}	
	}
	
function RegisterPlayer( pPlayer, szPass )
    {
	local 
	        RegisterQuery = format( "INSERT INTO Accounts ( Name, Pass, Admin, VIP, Kills, Deaths, Stunt, Drift, Hours, Minutes, Seconds, Respect, UnRespect, Cash, BankCash, Coins, Score, BestSpree, Joins, IP, LastDate, RegDate ) VALUES( '" + pPlayer.Name + "', '" + ::SHA256( szPass ) + "', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '" + pPlayer.IP + "', '" + ::GetFullTime() + "', '" + ::GetFullTime() + "' )" );
		    ::QuerySQL( db, RegisterQuery );
    }
	
function SaveStats( pPlayer )
    {			
	if ( Logged == true )
        {		
	    local 
			    SavePStats = format("UPDATE Accounts SET Name='%s', Pass='%s', Admin='%i', VIP='%i', Kills='%i', Deaths='%i', Stunt='%i', Drift='%i', Hours='%i', Minutes='%i', Seconds='%i', Respect='%i', UnRespect='%i', Cash='%i', BankCash='%i', Coins='%i', Score='%i', BestSpree='%i', Joins='%i', IP='%s', LastDate='%s' WHERE Name='%s'",
                User, Password, Admin, VIP, Kills, Deaths, Stunt, Drift, Hours, Minutes, Seconds, Respect, UnRespect, Cash, BankCash, Coins, Score, BestSpree, Joins+=1, pPlayer.IP, ::GetFullTime(), pPlayer.Name );
                ::QuerySQL( db, SavePStats );		
							
			::print( pPlayer.Name + "'s Stats Saved User [" + User + "] Admin [" + Admin + "] VIP [" + VIP + "] Kills [" + Kills + "], Deaths [" + Deaths + "], Stunt [" + Stunt + "], Drift [" + Drift + "], Hours[" + Hours + "], Minutes [" + Minutes + "], Second [" + Seconds + "], Respect [" + Respect + "], UnRespect [" + UnRespect + "], Cash [" + Cash + "], BankCash [" + BankCash + "], Coins [" + Coins + "], Score [" + Score + "], BestSpree [" + BestSpree + "], Joins [" + Joins + "], IP [" + pPlayer.IP + "], LastDate [" + GetFullTime() + "]" );
			
	    if ( Admin >= 1 )
            { 	
            local
        			SaveAStats = format("UPDATE AdminStats SET Bans='%i', Kicks='%i', Jails='%i', Mutes='%i', Warns='%i' WHERE Name='%s'",
                    Bans, Kicks, Jails, Mutes, Warns, pPlayer.Name ); 						
			        if ( AdminStats.find( pPlayer.Name ) != null ) ::QuerySQL( db, SaveAStats );	
			        else return ::QuerySQL( db, "INSERT INTO AdminStats ( Name, Bans, Kicks, Jails, Mutes, Warns ) VALUES ( '" + pPlayer.Name + "', " + Bans + ", " + Kicks + ", " + Jails + ", " + Mutes + ", " + Warns + " )");						
						
     	        ::print( pPlayer.Name + "'s Admin Stats Saved Bans [" + Bans + "] Kicks [" + Kicks + "] Jails [" + Jails + "], Mutes [" + Mutes + "], Warns [" + Warns + "] ");
            }
		}	
    }	
}		
	
ServerNames <-
    [
        "Beta Testing -> [r2] Vice Super Stunt [r2]",
	    "Beta Testing -> Vice Super Stunt > 24/7 <",
	    "Beta Testing -> Vice Super Stunt > GangWars <",
	    "Beta Testing -> Vice Super Stunt > Drifts <",
	    "Beta Testing -> Vice Super Stunt > Stunts <",
        "Beta Testing -> Vice Super Stunt > Clans <"
	];	
		
RandomColors <-
    [		
	    [255,255,255],         [0,128,128],
 	    [255, 0, 0],           [0,0,128],
 	    [0,255,0],             [107,142,35],
 	    [0,0,255],             [0,255,127],
 	    [255, 255, 0],         [0,191,255],
 	    [0,255,255],           [106,90,205],
 	    [255,0,255],           [238,130,238],
 	    [192,192,192],         [255,235,205],
 	    [128,128,128],         [244,164,96],    
 	    [128,0,0],             [176,196,222],
        [128,128,0],           [224,255,255],
 	    [0,128,0],             [128,0,128] 	
	]; 

RandomMessages <-
    [
        "Visit us at comming soon :D ",
        "Don't Forget to Add this server in Favorites List.",
        "Saw a Cheater/Rule Breaker ? do /C Report to Report him.",
        "All commands works with (/c) try /c commands, /c help & /c teles",
        "You can use /c tops to view top Players and Top Clans.",
        "Want to buy VIP ? So try /c buyvip to buy VIP.",
        "Want to Create your own Clan ? use /c createclan to do.",
        "/c changename & /c changepass to change your name and password.",
        "want to know about vip and clan commands ? /c vcmds & clancmds.",
        "want to view your Stats or admin Stats ? do /c Stats & /c aStats.",
		"NEW SYSTEM: Press LShif to Fix your Car & Space to Flip Your Car!",
		"This Server is Protected with JaVeD's Anti-Lag Killing Module!",
		"This is Beta Testing Server Hosted By JaVeD",
		"Press Fire Button in Vehicle to Up Your Vehicle!",
		"Our Complete VSS Version 2 Will come soon :) hope you guys will like!"
    ];
	
RandomSpawns <- 
    [
        Vector(217.5168, -417.7297, 10.6972),
        Vector(135.3318, -381.5050, 9.8172),
		Vector(126.7571, -350.6836, 17.9003),
		Vector(82.2338, -385.2808, 9.0851),
		Vector(96.6425, -372.7224, 8.7866),
		Vector(126.2449, -429.1601, 12.1850),
		Vector(157.2513, -412.4132, 8.8048),
		Vector(201.8346, -403.9304, 11.0602),
		Vector(177.8684, -371.6416, 8.1068),
	    Vector(149.8020, -358.9100, 8.6707)
    ];

WarSpawns <-
    [
	
	];

MinigunSpawns <-
    [
	
	];
	
OHSpawns <-
    [
	
	];
	
SDMSpawns <-
    [
        Vector(-679.0595, 1272.3608, 10.8171),
        Vector(-651.8962, 1267.5492, 10.8171),
        Vector(-656.5438, 1275.8749, 10.8171),
        Vector(-661.8282, 1290.5323, 10.8171),
        Vector(-674.6853, 1285.2823, 10.8171),
        Vector(-680.5518, 1267.5657, 10.8171),
        Vector(-661.4938, 1264.3759, 10.8171),
        Vector(-670.2382, 1292.8120, 10.8171)
    ]; 	

SniperSpawns <-
    [
	    Vector(-706.8302, -1626.2749, 31.1671), 
        Vector(-691.2640, -1613.0621, 32.6164), 
        Vector(-719.9144, -1606.0313, 23.8581), 
        Vector(-759.0250, -1613.5568, 23.7350), 
        Vector(-797.4974, -1578.6960, 23.8581), 
        Vector(-826.2145, -1576.7120, 28.4827), 
        Vector(-805.3470, -1575.5330, 28.4827) 
	];	
	
AdminStats    <-        [ ];
Rcons         <-        [ ];
Locked        <-        [ ];
BannedNames   <-        [ ];
Bans          <-        [ ];
IPBans        <-        [ ];
Locations     <-        [ ];
Reports       <-        [ ];
Stats         <-        array( GetMaxPlayers() );
Timer         <-        0;	
Event         <-        false;
EventTime     <-        0;
EventReward   <-        0;
	
function onScriptLoad()
{
 try
    {
	LoadModule("vcmp");
	//LoadModule("VCMP");
	//LoadModule("sq_vcmp");
	//LoadModule("vcmp-game");
	LoadModule("sq_hashing");
	LoadModule("lu_hashing2");
    LoadModule("sq_ini");
    LoadModule("sq_lite");
    //LoadModule("sq_json");
	LoadModule("sq_geoip");
	
    Print("-------------\x5 Vice Super Stunt \x5----------");
    Print(" ");
    Print("                >>   Script Name  <<");
	Print("                  " + ScriptName);
    Print("                >> Script Creator <<");
	Print("                       " + Creator);
	Print(" ");
	Print("-----------------------------------------------");
	Print("             Scripts And Databases!            ");
	Print("-----------------------------------------------");
    
    Print("[Loaded] - VSS-Server Functions.");
    dofile("VSS-Functions.JaVeD");
    
    Print("[Loaded] - VSS-Server Commands.");
    dofile("VSS-Commands.JaVeD");
    
    Print("[Loading] - VSS-Server IRC-Echo");
    dofile("VSS-Echo.JaVeD");
    ActivateEcho();	
   
    db <- ConnectSQL("DataBase.db");
       
    local DBQuery =

        QuerySQL( db, "CREATE TABLE IF NOT EXISTS Accounts ( Name VARCHAR(32), Pass VARCHAR(32), Admin INT, VIP INT, Kills INT, Deaths INT, Stunt INT, Drift INT, Hours INT, Minutes INT, Seconds INT, Respect INT, UnRespect INT, Cash INT, BankCash INT, Coins INT, Score INT, BestSpree INT, Joins INT, IP VARCHAR(32), LastDate VARCHAR(32), RegDate VARCHAR(32) )")
        QuerySQL( db, "CREATE TABLE IF NOT EXISTS AdminStats ( Name VARCHAR(32), Bans INT, Kicks INT, Jails INT, Mutes INT, Warns INT )")
		QuerySQL( db, "CREATE TABLE IF NOT EXISTS RCON ( Name VARCHAR(32) )")
		QuerySQL( db, "CREATE TABLE IF NOT EXISTS Locked ( Name VARCHAR(32) )")
		QuerySQL( db, "CREATE TABLE IF NOT EXISTS BannedNames ( Name VARCHAR(32) )")
		QuerySQL( db, "CREATE TABLE IF NOT EXISTS Bans ( Name VARCHAR(32), IP VARCHAR(32), Admin VARCHAR(32), Days VARCHAR(32), Reason VARCHAR(32), Date VARCHAR(32), IPBan VARCHAR(32), SubnetBan VARCHAR(32) )")
        QuerySQL( db, "CREATE TABLE IF NOT EXISTS Locations ( Name VARCHAR(32), Position VARCHAR(32) )")
        QuerySQL( db, "CREATE TABLE IF NOT EXISTS CmdLevels ( ACmd VARCHAR(32), ACmdLevel VARCHAR(32), VCmd VARCHAR(32), VCmdLevel VARCHAR(32) )")
		QuerySQL( db, "CREATE TABLE IF NOT EXISTS VSSGangs ( Gang TEXT, Points NUMERIC, Kills NUMERIC, Deaths NUMERIC, Captures NUMERIC, Members NUMERIC, Owner TEXT, CPos VARCHAR(25), Color NUMERIC, Skin NUMERIC, Spawn VARCHAR(25), Wep1 NUMERIC, Wep2 NUMERIC, Wep3 NUMERIC, Wep4 NUMERIC, Wep5 NUMERIC, Wep6 NUMERIC, Info1 TEXT, Info2 TEXT, Info3 TEXT, Info4 TEXT, Info5 TEXT, Info6 TEXT, Info7 TEXT )")            
        QuerySQL( db, "CREATE TABLE IF NOT EXISTS VSSMembers ( Name TEXT, Gang TEXT, Rank TEXT, GPoints NUMERIC, GKills NUMERIC, GCaptures NUMERIC, GSkin NUMERIC )")           
        QuerySQL( db, "CREATE TABLE IF NOT EXISTS VSSClans ( CTag TEXT, CName TEXT, CKills NUMERIC, CMembers NUMERIC, COwner TEXT, CSkin NUMERIC, CSpawn VARCHAR(25), CColor NUMERIC, CWeps NUMERIC, CInfo TEXT )")        	
		QuerySQL( db, "CREATE TABLE IF NOT EXISTS VSSCMembers ( CTag TEXT, CName TEXT, CKills, CRank TEXT )");            

    FreeSQLQuery( DBQuery );
	
	Print("[Connected] -> Database attached to the server.");
	Print("[Connected] -> Gang & Clan System by JaVeD Connected!"); 
	
	local 
	        AdminStatsQuery    =    QuerySQL( db, "SELECT Name FROM AdminStats"),
        	RconQuery          =    QuerySQL( db, "SELECT Name FROM RCON"),
			LockedQuery        =    QuerySQL( db, "SELECT Name FROM Locked"),
			BannedNamesQuery   =    QuerySQL( db, "SELECT Name FROM BannedNames"),
			BansQuery          =    QuerySQL( db, "SELECT Name FROM Bans"),
			IPBansQuery        =    QuerySQL( db, "SELECT IPBan FROM Bans"),
            LocationsQuery     =    QuerySQL( db, "SELECT Name FROM Locations"), 
	        CmdLevelsQuery     =    QuerySQL( db, "SELECT ACmd, ACmdLevel, VCmd, VCmdLevel FROM CmdLevels");
	 
	while
	        ( 
				GetSQLColumnData ( RconQuery, 0 )         ||    GetSQLColumnData ( BannedNamesQuery, 0 )  ||
				GetSQLColumnData ( LocationsQuery, 0 )    ||    GetSQLColumnData ( AdminStatsQuery, 0 )   ||  
				GetSQLColumnData ( LockedQuery, 0 )       ||	GetSQLColumnData ( BansQuery, 0 )         ||  
				GetSQLColumnData ( IPBansQuery, 0 )
		    )
	            {
				    AdminStats.push( GetSQLColumnData( AdminStatsQuery, 0 ) );
		            GetSQLNextRow( AdminStatsQuery );
					
		            Rcons.push( GetSQLColumnData( RconQuery, 0 ) );
		            GetSQLNextRow( RconQuery );
					
					Locked.push( GetSQLColumnData( LockedQuery, 0 ) );
		            GetSQLNextRow( LockedQuery );
			
			        BannedNames.push( GetSQLColumnData( BannedNamesQuery, 0 ) );
		            GetSQLNextRow( BannedNamesQuery );
					
					Bans.push( GetSQLColumnData( BansQuery, 0 ) );
		            GetSQLNextRow( BansQuery );
					
					IPBans.push( GetSQLColumnData( IPBansQuery, 0 ) );
		            GetSQLNextRow( IPBansQuery );

			        Locations.push( GetSQLColumnData( LocationsQuery, 0 ) );  
		            GetSQLNextRow( LocationsQuery );
	            }
			FreeSQLQuery( AdminStatsQuery );
	        FreeSQLQuery( RconQuery );
			FreeSQLQuery( LockedQuery );
		    FreeSQLQuery( BannedNamesQuery );
	        FreeSQLQuery( LocationsQuery );

	NewTimer("TheTimer", 1000, 0 ); 
	
    Print("Vehicles - [ " + GetVehicleCount() + " ] Pickups - [ " + GetPickupCount() + " ]");
    Print(" ");
    Print("-------------> \x3 Vice Super Stunt \x3 <----------");

	local
        	Player_Count = GetPlayers(),
			pPlayer;
			
	if ( !Player_Count ) return; 
	for ( local PlayerID = 0, PlayerCount = 0; PlayerID < GetMaxPlayers() && PlayerCount < Player_Count; PlayerID++ )
	    {
		if ( !( pPlayer = FindPlayer( PlayerID ) ) ) continue;
		
		    PlayerCount++;
		    onPlayerJoin( pPlayer );
			SetCinematicBorder( pPlayer, false );
			AnnounceAll(" ");
	    }
    }
    catch(e) Print("Error " + e );
}	
function onScriptUnload()
{
 try
    {
	if( db )
	    {
		    SaveAllStats();
	    	DisconnectSQL( db );
		    db = null;
	    }
        DisconnectBots();
        Print("------> Script UnLoaded <-------");
    }
    catch(e) Print("Error " + e );
}

function onServerStart()
{
 try
    {
        SetWeatherLock( true );
        Print("|--------------------------------------------------------------|");
        Print("|--------------------------------------------------------------|");
        Print("|                                                              |");
        Print("| \x1\x1\x1\x1                \x1\x1\x1\x1    \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1    \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1     |");
        Print("|  \x1\x1\x1\x1              \x1\x1\x1\x1    \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1     \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1       |");
        Print("|   \x1\x1\x1\x1            \x1\x1\x1\x1    \x1\x1\x1\x1            \x1\x1\x1\x1               |");
        Print("|    \x1\x1\x1\x1          \x1\x1\x1\x1    \x1\x1\x1\x1            \x1\x1\x1\x1                |");
        Print("|     \x1\x1\x1\x1        \x1\x1\x1\x1      \x1\x1\x1\x1            \x1\x1\x1\x1               |");
        Print("|      \x1\x1\x1\x1      \x1\x1\x1\x1         \x1\x1\x1\x1\x1\x1\x1\x1        \x1\x1\x1\x1\x1\x1\x1          |");
        Print("|       \x1\x1\x1\x1    \x1\x1\x1\x1            \x1\x1\x1\x1\x1\x1\x1\x1        \x1\x1\x1\x1\x1\x1\x1        |");
        Print("|        \x1\x1\x1\x1  \x1\x1\x1\x1                   \x1\x1\x1\x1           \x1\x1\x1\x1      |");
        Print("|         \x1\x1\x1\x1\x1\x1\x1\x1                     \x1\x1\x1\x1           \x1\x1\x1\x1     |");
        Print("|          \x1\x1\x1\x1\x1\x1                     \x1\x1\x1\x1           \x1\x1\x1\x1      |");
        Print("|           \x1\x1\x1\x1               \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1     \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1       |");
        Print("|            \x1\x1              \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1    \x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1        |");
        Print("|                                                              |");
        Print("|                 ----Vice Super Stunt----                     |");
        Print("|                            By                                |");
        Print("|                          @JaVeD                              |");
        Print("|--------------------------------------------------------------|");
        Print("|--------------------------------------------------------------|");
        Print("           Server Started on " + GetFullTime() );
    }
    catch(e) Print("Error " + e );
}

function onPlayerJoin( pPlayer )
{
 try
    {
	MPCVO( pPlayer );
    local
			Country = geoip_country_name_by_addr( pPlayer.IP );		
			Stats[ pPlayer.ID ] = PlayerStats( pPlayer.Name );
		    pPlayer.IsMuted = true;
		    SetCinematicBorder( pPlayer, true );

        Announce("\x10 \x10 \x10 \x10 \x10 ~y~ Welcome" pPlayer );
        ClientMessage("Welcome to Vice Super Stunt, " + pPlayer.Name + "!" pPlayer 255, 0, 0 );  
        EchoMessage( ICOL_BOLD+ICOL_GREY+ "[" + pPlayer.ID + "] " + pPlayer.Name + " has joined the server.");
		if ( Country != null) MessageAllExcept( pPlayer.Name + " Is Connecting From " + Country + ". " pPlayer );
		else MessageAllExcept( pPlayer.Name + " Is Connecting From Unkown." pPlayer );

		if ( ( IsNum( pPlayer.Name ) ) || ( pPlayer.Name.len() < 3 ) || ( pPlayer.Name.find("'")!=null ) || ( BannedNames.find( pPlayer.Name.tolower() ) != null ) )
			{    
		        if ( IsNum( pPlayer.Name ) ) MessagePlayer("VSS-Buster > Your Name Cannot be only numbers!" pPlayer );
			    else if ( pPlayer.Name.len() < 3 ) MessagePlayer("VSS-Buster > Your Name is Less then 3 Characters!" pPlayer );
				else if ( pPlayer.Name.find("'")!=null ) MessagePlayer("VSS-Buster > Your Name Can't Contain Character [ ' ]." pPlayer );
			    else if ( BannedNames.find( pPlayer.Name.tolower() ) != null ) MessagePlayer("VSS-Buster > Your Name is Blocked!" pPlayer );
		        MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Invalid-Nick) " pPlayer );
		        KickPlayer( pPlayer );
			    return;
			}	
			
	    if ( IPBans.find( pPlayer.IP ) != null )
	        {
			    local IPBan = QuerySQL( db, "SELECT Name, Days, Reason, Date, IPBan FROM Bans WHERE IPBan ='" + pPlayer.IP + "'");
			    SetCinematicBorder( pPlayer, false );
	            MessagePlayer(" " pPlayer);
		        MessagePlayer(" " pPlayer);
	    	    MessagePlayer(" " pPlayer);
			    MessagePlayer(" " pPlayer);
			    MessagePlayer(" " pPlayer);
    		    ClientMessage("You've been IP-Banned from the Server on " + GetSQLColumnData(IPBan,3) + " for " + GetSQLColumnData(IPBan,1) + " Days for Reason: " + GetSQLColumnData(IPBan,2) + " " pPlayer 255, 255, 0 );
		        ClientMessage("Make an UnBan Appeal at Vcmp.RPGKillers.Com with " pPlayer 255, 255, 0 );
		        ClientMessage("Name: " + GetSQLColumnData(IPBan,0 ) + " IP: " + GetSQLColumnData(IPBan,4) + " " pPlayer 255, 255, 0 );
	    	    MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Banned) " pPlayer); 
				FreeSQLQuery( IPBan );
    		    KickPlayer( pPlayer );
				return;
			}	
		else if ( Bans.find( pPlayer.Name ) != null )
            {		
			    local Ban = QuerySQL( db, "SELECT IP, Days, Reason, Date FROM Bans WHERE Name ='" + pPlayer.Name + "'");
			    SetCinematicBorder( pPlayer, false );
                MessagePlayer(" " pPlayer);
	  	        MessagePlayer(" " pPlayer);
	    		MessagePlayer(" " pPlayer);
       			MessagePlayer(" " pPlayer);
	      		MessagePlayer(" " pPlayer);
                ClientMessage("You've been Banned from the Server on " + GetSQLColumnData(Ban,3) + " for " + GetSQLColumnData(Ban,1) + " Days for Reason: " + GetSQLColumnData(Ban,2) + " " pPlayer 255, 255, 0 );
   		        ClientMessage("Make an UnBan Appeal at Vcmp.RPGKillers.Com with " pPlayer 255, 255, 0 );
	            ClientMessage("Name: " + pPlayer.Name + " IP: " + GetSQLColumnData(Ban,0 ) + " " pPlayer 255, 255, 0 );
	            MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (IP-Banned) " pPlayer);
				FreeSQLQuery( Ban );
	    	    KickPlayer( pPlayer );
				return;
			}
	    else if ( Rcons.find( pPlayer.Name ) != null );
		else if ( Locked.find( pPlayer.Name ) != null ) 
            {		
                MessagePlayer(" " pPlayer);
   	            MessagePlayer(" " pPlayer);
		     	MessagePlayer(" " pPlayer);
                MessagePlayer(" " pPlayer);
				MessagePlayer(" " pPlayer);
                MessagePlayer("-----> Account Locked! <-----" pPlayer);
                ClientMessage("There was a database problem recently and you got admin level." pPlayer 255, 255, 0 );
                ClientMessage("Contact ahmedzai100@yahoo.com to get back your account!" pPlayer 255, 255, 0 );
    			MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Acc-Locked!) " pPlayer );
                KickPlayer( pPlayer );
				return;
			}
				
		if ( Stats[ pPlayer.ID ].User == pPlayer.Name )
		    {
			Stats[ pPlayer.ID ].Registered = true;
            if ( Stats[ pPlayer.ID ].PlayerIP == pPlayer.IP )
			    {
					pPlayer.IsFrozen = false;		
                	Stats[ pPlayer.ID ].Logged = true;
                    pPlayer.Cash = Stats[ pPlayer.ID ].Cash;            
                    pPlayer.Score = Stats[ pPlayer.ID ].Score;
	                PrivMessage("Successfully Auto Logged-in!" pPlayer );
	                PrivMessage("Nick: " + pPlayer.Name + ", Admin:[ " + Stats[ pPlayer.ID ].Admin + " ], VIP:[ " + Stats[ pPlayer.ID ].VIP + " ]" pPlayer );
				}
			else PrivMessage("USE: /C Login <Password> to Login in your Account!" pPlayer );				    
		    }
		else PrivMessage("USE: /C Register <Password> To Register This Nick in our Database." pPlayer );
    }
    catch(e) Print("Error " + e );
}

function onPlayerRequestClass( pPlayer, szID, szTeam, szSkin )
{
 try
    {
        SetCinematicBorder( pPlayer, false );
        local Skin = "Unknown";	
		switch ( pPlayer.Skin )
		    {
		        case 29: case 94: case 68: 
                    Skin = "~b~Stunter";
                        break;	
                case 73: case 83: case 86:                                
                    Skin = "~y~Killer";
                        break; 
                case 62: case 7: case 15:                                
                    Skin = "~t~Drifter";
                        break; 
                case 9: case 67: case 49:                                
                    Skin = "~p~Girl";
                        break; 
                case 4: case 1: case 2:                            
                    Skin = "~w~Cop";
                        break;
                case 102:                         
                    Skin = "~o~VIP";
                        break;
                case 101:                                
                    Skin = "~x~Admin";
                        break;                 
                case 34:                                 
                    Skin = "~q~RCON";
                        break; 
            }    	    	
		Announce("\x10 \x10 \x10 \x10 \x10 " + Skin, pPlayer );
    }
    catch(e) Print("Error " + e );
}

function onPlayerSpawn( pPlayer )
{
 try
    {
	if ( Stats[ pPlayer.ID ].Registered == true )
	    {
        if ( Stats[ pPlayer.ID ].Logged == true )
            {
		    if ( CheckMember( pPlayer ) )
	            {   
		            local spawnPos = split( Getdbpawn( pPlayer ), " ");
			        pPlayer.Skin = Getdbkin( pPlayer );
		            pPlayer.Team = GetGangColor( pPlayer );
                    pPlayer.Pos = Vector( spawnPos[0].tofloat(), spawnPos[1].tofloat(), spawnPos[2].tofloat() );
		        }
                else   		
	                {
	                    pPlayer.Team = rand() % 16;  
		                pPlayer.Pos = RandomSpawns[ rand() % RandomSpawns.len() ];
	                }
				Announce("" pPlayer );	
			    Message(">> " + pPlayer + " has Spawned in " + GetDistrictName( pPlayer.Pos.x, pPlayer.Pos.y ) + " Clan: " + ClanChecker( pPlayer ) + ". ");            
		    	pPlayer.IsMuted = false;
				pPlayer.Cash = Stats[ pPlayer.ID ].Cash;
		     	Stats[ pPlayer.ID ].FirstSpawned = true;
				Stats[ pPlayer.ID ].AntiHPHack = true;
                ArmourRank( pPlayer );
            }
        else
            {
                MessagePlayer("Please Login To Play with This Account!" pPlayer );	
			    pPlayer.IsFrozen = true;
            }   
	    }	
		else
            {    
                pPlayer.Health = 0;
                PrivMessage(" " + pPlayer.Name + " You need to register first /c register <Password>" pPlayer );
            }
			 
    switch ( pPlayer.Skin )	
	    {
        case 102: 
            {
            if ( Stats[ pPlayer.ID ].VIP >= 1 ) 
                {                
                    ClientMessage("Successfully Spwned With VIP Skin." pPlayer, 0,211,124);
                }
                else
                    {
                        ClientMessage("You're not VIP, please choose a different skin." pPlayer 255, 255, 0 );
                        pPlayer.Health= 0;
                        Stats[ pPlayer.ID ].Deaths--;
                    }
            }	
	        break;
        case 101:
            {
            if ( Stats[ pPlayer.ID ].Admin >= 3 ) 
                {                
                    ClientMessage("Successfully Spwned With Admin Skin." pPlayer, 0,211,124);
                }
                else
                    {
                        ClientMessage("You're not Admin, please choose a different skin." pPlayer 255, 255, 0 );
                        pPlayer.Health= 0;
                        Stats[ pPlayer.ID ].Deaths--;
                    }
            }     
            break;					
        case 34:
            {
                if ( pPlayer.IsAdmin )
                    {                
                        ClientMessage("Successfully Spwned With RCON Skin." pPlayer, 0,211,124);
                    }
                else
                    {
                        ClientMessage("You're not RCON, please choose a different skin." pPlayer 255, 255, 0 );
                        pPlayer.Health= 0;
                        Stats[ pPlayer.ID ].Deaths--;
                    }
            }
			break;
	    }
			
    if ( Stats[ pPlayer.ID ].VIP >= 9 ) 
        {            
            SetDriveOnWater( true );
			pPlayer.StuntMode = true
            SetWeaponDamage( 20, 80 );
        }            
    if ( pPlayer.IsAdmin )
        {            
            pPlayer.ShootInAir = true; 
            pPlayer.StuntMode = true;
            pPlayer.DrivebyAbility = true;
            SetDriveOnWater( true );
            SetWeaponDamage( 33, 100 );
            SetWeaponDamage( 20, 100 );
            pPlayer.Health=100;
            pPlayer.Armour=100;
        }
		else return 0;
    }
    catch(e) Print("Error " + e );
}         
 
function onPlayerChat( pPlayer, szText )
{ 
 try 
    { 
	    if ( ( Stats[ pPlayer.ID ].FirstSpawned == false ) && ( !pPlayer.IsSpawned ) ) return ClientMessage("First Spawn then Chat!" pPlayer 255, 0, 0 );
	    else if ( ( Stats[ pPlayer.ID ].Logged == false ) && ( !pPlayer.IsSpawned ) ) return ClientMessage("First Spawn then Chat!" pPlayer 255, 0, 0 );
        else if ( ( Stats[ pPlayer.ID ].Registered == false ) && ( pPlayer.IsSpawned ) ) return ClientMessage("Please Use /C Register <Password> before Chatting!" pPlayer 255, 0, 0 );  		   	
        else if ( ( Stats[ pPlayer.ID ].Logged == false ) && ( pPlayer.IsSpawned ) ) return ClientMessage("Please Use /C Login <Password> before Chatting!" pPlayer 255, 0, 0 );  		
		else if ( Stats[ pPlayer.ID ].Muted == true ) return ClientMessage("[Error] - You are muted by Admin For " + Stats[ pPlayer.ID ].MuteTime + " Minutes, Please Wait " + Stats[ pPlayer.ID ].MuteRem + " Seconds for UnMute." pPlayer 255, 0, 0 );  		
		else if ( Stats[ pPlayer.ID ].AutoMute == true ) return ClientMessage("[Anti-Spam] - Please Wait " + Stats[ pPlayer.ID ].AutoMuteCount + " Seconds to Chat Again!" pPlayer 255, 0, 0 );  		
        else if ( Stats[ pPlayer.ID ].PText == null ) Stats[ pPlayer.ID ].PText = szText;
	    else if ( Stats[ pPlayer.ID ].PText == szText ) Stats[ pPlayer.ID ].PTextCount = Stats[ pPlayer.ID ].PTextCount+1;
	    else Stats[ pPlayer.ID ].PTextCount = 0;
	    Stats[ pPlayer.ID ].PText = szText;
	    if ( Stats[ pPlayer.ID ].STimer == 0 ) Stats[ pPlayer.ID ].STimer = GetTime().tointeger();
	    else if ( ( GetTime().tointeger()-Stats[ pPlayer.ID ].STimer ) <2 ) Stats[ pPlayer.ID ].SCounter = Stats[ pPlayer.ID ].SCounter+1;
	    else 
	        {
		        Stats[ pPlayer.ID ].SCounter = 0;
		        Stats[ pPlayer.ID ].STimer=GetTime().tointeger();
         	}
		if ( ( Stats[ pPlayer.ID ].SCounter >2 || Stats[ pPlayer.ID ].PTextCount > 3 ) && pPlayer.IsMuted == false &&  pPlayer.IsAdmin  );
 	    else if ( ( Stats[ pPlayer.ID ].SCounter >2 || Stats[ pPlayer.ID ].PTextCount > 3 ) && pPlayer.IsMuted == false && ( Stats[ pPlayer.ID ].VIP >= 5 ) )
        	{
		        pPlayer.IsMuted = true;
				Stats[ pPlayer.ID ].AutoMute = true
		        Stats[ pPlayer.ID ].SCounter = 0;
		        Stats[ pPlayer.ID ].PTextCount = 0;
		        ClientMessage("[Anti-Spam] - You Have Been Auto-Muted For 30 Seconds For Spamming!" pPlayer 255, 0, 0 );
	        }
	    else if ( ( Stats[ pPlayer.ID ].SCounter >=2 || Stats[ pPlayer.ID ].PTextCount >3 ) && pPlayer.IsMuted == false )
            {
			    pPlayer.IsMuted = true;
				Stats[ pPlayer.ID ].AutoMute = true;
		        Stats[ pPlayer.ID ].SCounter = 0;
		        Stats[ pPlayer.ID ].PTextCount = 0;
		        ClientMessage("[Anti-Spam] - You Have Been Auto-Muted For 1 Minute For Spamming!" pPlayer 255, 0, 0 );		      
			}	
	
        if ( szText )
	        {
		    if ( szText.slice( 0, 1 ) == "!" )
		        {
			    local i = NumTok( szText, " " );
			
			    if ( i == 1 ) onPlayerCommand2( pPlayer, GetTok( szText.slice( 1 ), " ", 1 ), null );
			    else onPlayerCommand2( pPlayer, GetTok( szText.slice( 1 ), " ", 1 ), GetTok( szText.slice( 1 ), " ", 2, i ) );
		        }
	        }

        local Color;
        switch ( rand() % 13 )
            { 
                case 0: 
                    Color = ICOL_BLUE;
                        break;	
                case 1:
                    Color = ICOL_GREEN;
                        break; 
                case 2:
                    Color = ICOL_RED;
                        break; 
                case 3:
                    Color = ICOL_BROWN;
                        break; 
                case 4:
                    Color = ICOL_PURPLE;
                        break;
                case 5:                         
                    Color = ICOL_ORANGE;
                        break;
                case 6:                                
                    Color = ICOL_YELLOW;
                        break;                 
                case 7:                                 
                    Color = ICOL_LGREEN;
                        break;
				case 8:                                 
                    Color = ICOL_CYAN;
                        break;
				case 9:                                 
                    Color = ICOL_LCYAN;
                        break;
				case 10:                                 
                    Color = ICOL_LBLUE;
                        break;
				case 11:                                 
                    Color = ICOL_PINK;
                        break;
                case 12:                                 
                    Color = ICOL_GREY;
                        break;						
				case 13:                                 
                    Color = ICOL_LGREY;
                        break;				
            }
        EchoMessage( ICOL_GREEN + "[" + pPlayer.ID + "] " + ICOL + Color + " " + pPlayer.Name + "> " + ICOL + szText );
    }
    catch(e) Print("Error " + e );
}    

function onPlayerKill( Killer, Killed, iReason, szBodyPart )
{
 try
    {
		Stats[ Killer.ID ].Kills++;
        Stats[ Killed.ID ].Deaths++;
        Stats[ Killer.ID ].Coins += 7;
        Stats[ Killed.ID ].Coins -= 2;
        Stats[ Killer.ID ].Spree++;
        Stats[ Killed.ID ].Spree = 0;
        Killer.Score += 50;
        Killed.Score -= 10;
        Killer.Cash += 750;
        Killed.Cash -=250;        
        Killer.WantedLevel += 1;
		Stats[ Killer.ID ].AntiHPHack = true;
		if ( Killer.Health < 100 ) Killer.Health +=25;
	    else if ( Killer.Armour >= 0 ) Killer.Armour +=25;
		
        local Part = "Unknown";
        switch( szBodyPart ) 
		{
            case 0:
                Part = "Body";
                    break;
            case 1:
                Part = "Torso";
                    break;
            case 2:
                Part = "Left Arm";
                    break;
            case 3:
                Part = "Right Arm";
                    break;
            case 4:
                Part = "Left Leg";
                    break;
            case 5:
                Part = "Right Leg";
                    break;
            case 6:
                Part = "Head";
                    break;
        }
		
		local Wep = "Unkown";
		switch( iReason )
		{
		    case 0:
                Wep = "Fist";
                    break;
            case 1:
                Wep = "BrassKnuckle";
                    break;
            case 2:
                Wep = "ScrewDriver";
                    break;
            case 3:
                Wep = "GolfClub";
                    break;
            case 4:
                Wep = "NightStick";
                    break;
            case 5:
                Wep = "Knife";
                    break;
            case 6:
                Wep = "BaseballBat";
                    break;
		    case 7:
                Wep = "Hammer";
                    break;
            case 8:
                Wep = "Cleaver";
                    break;
            case 9:
                Wep = "Machete";
                    break;
            case 10:
                Wep = "Katana";
                    break;
            case 11:
                Wep = "Chainsaw";
                    break;
            case 12:
                Wep = "Grenade";
                    break;
            case 13:
                Wep = "RemoteGrenade";
                    break;
		    case 14:
                Wep = "TearGas";
                    break;
            case 15:
                Wep = "Molotov";
                    break;
            case 16:
                Wep = "Missile";
                    break;
            case 17:
                Wep = "Colt45";
                    break;
            case 18:
                Wep = "Python";
                    break;
            case 19:
                Wep = "Shotgun";
                    break;
            case 20:
                Wep = "Spaz";
                    break;
            case 21:
                Wep = "Stubby";
                    break;
            case 22:
                Wep = "Tec9";
                    break;
            case 23:
                Wep = "Uzi";
                    break;
            case 24:
                Wep = "Ingrams";
                    break;
            case 25:
                Wep = "MP5";
                    break;
            case 26:
                Wep = "M4";
                    break;
            case 27:
                Wep = "Ruger";
                    break;
            case 28:
                Wep = "SniperRifle";
                    break;
            case 29:
                Wep = "LaserScope";
                    break;
            case 30:
                Wep = "RocketLauncher";
                    break;
            case 31:
                Wep = "FlameThrower";
                    break;
            case 32:
		        Wep = "M60";
                    break;
		    case 33:
                Wep = "Minigun";
                    break;			
        } 
            
        local R = rand() % 255;  			
	    switch ( Stats[ Killer.ID ].Spree )
            {	
			case 1:
			    {
				    ClientMessageToAll("FIRST BLOOD > " + Killer.Name + " Started Killing!",255, 0, 0 ); 
					Announce("~b~First ~o~Blood~w~!" Killer );
				}
				break;
			case 5:		
			    {
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Killing Spree Kills: 5 (Reward: 500$)"R, R, R);				
				    Killer.Cash += 500;
					Announce("~y~Killing ~o~Spree~b~!" Killer );
                }				
		        break;	
            case 10:	
			    {     			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Double Killing Spree Kills: 10 (Reward: 1000$)"R, R, R);
				    Killer.Cash += 1000; 
					Announce("~y~Killing ~o~Spree~b~!" Killer );
				}	
			    break;
			case 15:	
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Triple Killing Spree Kills: 15 (Reward: 1500$)"R, R, R);
				    Killer.Cash += 1500; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
				}
                break;				
			case 20:	
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Hunting Killing Spree Kills: 20 (Reward: 2000$)"R, R, R);
				    Killer.Cash += 2000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                }
				break;					
			case 25:	
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Big Boss Killing Spree Kills: 25 (Reward: 2500$)"R, R, R);
				    Killer.Cash += 2500; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );	
                } 
				break;					
            case 30:
		        {
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Blood Seeker Killing Spree Kills: 30 (Reward: 3000$)"R, R, R);
				    Killer.Cash += 3000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                }
				break;					
            case 35:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Wild Killing Spree Kills: 35 (Reward: 3500$)"R, R, R);
				    Killer.Cash += 3500; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );	
                }
				break;					
            case 40:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Hazardus Killing Spree Kills: 40 (Reward: 4000$)"R, R, R);
				    Killer.Cash += 4000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                } 
				break;					
            case 45:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Empire Killing Spree Kills: 45 (Reward: 4500$)"R, R, R);
				    Killer.Cash += 4500; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                }
				break;					
            case 50:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is OWNING!!! Please Someone Kill him!!!!! Kills: 50 (Reward: 5000$)"R, R, R);
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                }
				break;					
            case 55:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on Master Killing Spree!! Holly Shit!!!! Kills: 55 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                }
				break;					
            case 60:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on UNSTOPABLE KILLING SPREE!!!! Kills: 60 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                } 
				break;					
            case 65:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on FUCKING KILLING SPREE!!! Kills: 65 (Reward: 5000$)"R, R, R);
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                }
				break;					
            case 70:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " FUCKED ALL OF YOU!!! Kills: 70 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                } 
				break;					
            case 75:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on FUCKING PLAYERS!!!! Kills: 75 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                } 
				break;					
			case 80:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is Ending The Spree System!!! Kills: 80 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                } 
				break;					
			case 85:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on HUGE KILLING SPREE!!! Kills: 85 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                } 
				break;					
            case 90:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on ROCKER KILLING SPREE!!! Kills: 90 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                }
				break;					
            case 95:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " is on HUGE SPREE 5 KILL TO END SPREE!!! Kills: 95 (Reward: 5000$)"R, R, R);				
				    Killer.Cash += 5000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );
                } 
				break;					
            case 100:
			    {			
		            ClientMessageToAll("SPREE > " + Killer.Name + " Ended Spree!!! Please KILL HIM!!! Kills: 100 (Reward: 10000$)"R, R, R);				
				    Killer.Cash += 10000; 
		            Announce("~y~Killing ~o~Spree~b~!" Killer );	
                } 
				break;							
			}	
       
        Announce(" \x10 \x10 \x10 \x10 \x10 +~y~25~w~{ ~p~Spree: ~r~" + Stats[ Killer.ID ].Spree, Killer ); 
        EchoMessage( ICOL_RED + " ** " + Killer.Name + " killed " + Killed.Name + " (" + Wep + ") (" + Part + ")");
            
        if ( Stats[ Killer.ID ].Spree >= Stats[ Killer.ID ].BestSpree )
	        {
		        Stats[ Killer.ID ].BestSpree = Stats[ Killer.ID ].Spree;
		    }
			Stats[ Killer.ID ].BestSpree = 0;
		
        if ( Stats[ Killed.ID ].Spree >= 5 )
            {
                Killer.Cash += 500;
                ClientMessageToAll(" " + Killer.Name + " has ended " + Killed.Name + "'s Killing Spree! (Reward: $500 )", 0,211,124);
            }
		    Stats[ Killed.ID ].Spree = 0;
              
        /*if ( FindClanTag( Killer.Name ) ) 
            { 
                AddClanKills( CTag ); 
            }
        else return 0;*/
    }
    catch(e) Print("Error " + e );
}

function onPlayerDeath( pPlayer, iReason )
{
 try 
    { 
        Stats[ pPlayer.ID ].Deaths++;
		pPlayer.Health = 0;
		pPlayer.Armour = 0;
        pPlayer.Cash -= 100;
        pPlayer.Score -= 2;
		
		EchoMessage( ICOL_RED + "** " + pPlayer.Name + " died.");    
          
        if ( Stats[ pPlayer.ID ].Spree >= 5 )
        {
            Message( pPlayer.Name + " Has ended His own Killing Spree By Death");
            Stats[ pPlayer.ID ].Spree = 0;
        }
        Stats[ pPlayer.ID ].Spree = 0;    
    } 
    catch(e) Print("Error " + e );
}    

function onPlayerPart( pPlayer, iReason )
{ 
 try
    {
        local Text = "Unknown";
        switch ( iReason )
            {
                case PARTREASON_DISCONNECTED:
                    Text = "Quit";
                        break;
                case PARTREASON_TIMEOUT:
                    Text = "Timeout";
                        break;
				case PARTREASON_KICKED:		
				    Text = "Kicked";
					    break;
				case PARTREASON_BANNED:
                    Text = "Banned";
                        break;					
                default:
                    Text = "Crashed";
            } 
            EchoMessage(ICOL_BOLD+ICOL_GREY + "[" + pPlayer.ID + "] " + pPlayer.Name + " left the server. (" + Text + ")");
		
        if ( Stats[ pPlayer.ID ].Registered == true )
            {               
                Stats[ pPlayer.ID ].SaveStats( pPlayer );
            }
			Stats[ pPlayer.ID ] = null;
    }
    catch(e) Print("Error " + e );
}   

function onPlayerMove( pPlayer, x1, y1, z1, x2, y2, z2 )
{
    //if ( sqrt( x2*x2 + y2*y2 + z2*z2 ) > 50 ) player.Pos = Vector( 0.0, 0.0, 0.0 );
	//MessagePlayer("You are moving" player );
}

function onPickupPickedUp( pPlayer, Pickup ) 
{
 try
    {
    if( Pickup.Model == 408 )
        {
            ClientMessageToAll( pPlayer.Name + " has picked up the cash and gained 1000$" RandomColors[ rand() % RandomColors.len() ][0], RandomColors[ rand() % RandomColors.len() ][1], RandomColors[ rand() % RandomColors.len() ][2] ); 
            pPlayer.Cash += 1000;
            Pickup.RespawnTime = 60;
        }
    else if( Pickup.Model == 405 && Event == true )
        {		  
            ClientMessageToAll( pPlayer.Name + "(ID:" + pPlayer.ID + ") has won the event Reward: $" + EventReward, RandomColors[ rand() % RandomColors.len() ][0], RandomColors[ rand() % RandomColors.len() ][1], RandomColors[ rand() % RandomColors.len() ][2] ); 
			AnnounceAll("Event Over!~n~ ~o~Winner:~h~" + pPlayer.Name + "~n~ ~o~ID:~w~" + pPlayer.ID + "~n~ ~o~Reward: ~p~$" + EventReward + "~n~ ~o~LastTime: ~b~" + EventTime );
            pPlayer.Cash += EventReward;
			Event = false;
			EventTime = 0;
			EventReward = 0;           
        }
    }
    catch(e) Print("Error " + e );
}

function onPlayerRconLogin( pPlayer )
{
 try
    {
    if ( Stats[ pPlayer.ID ].Registered == true )
        {
        if ( Stats[ pPlayer.ID ].Logged == true )
            {
            if ( Rcons.find( pPlayer.Name ) != null )
                {
                    ClientMessage("You Logged-In as RCON, " + pPlayer.Name + "." pPlayer 255, 255, 0 );
                }
            else
                {
                    ClientMessage("Your Name is not in RCON List." pPlayer 255, 255, 0 );
                    Kick( pPlayer );
                }
			}
        else
            {
                ClientMessage("You need to login your account to Access RCON." pPlayer 255, 255, 0 );
                Kick( pPlayer );
            }
        }
    else
        {
            ClientMessage("You need to register your account to Access RCON." pPlayer 255, 255, 0 );
            Kick( pPlayer );
        }
    }
    catch(e) Print("Error " + e );
}

function onPlayerKeyStateChange( pPlayer, szKey, szDown )
{
 try
    {
	switch ( szKey )
	    {
	    case KEY_ONFOOT_AIM: 
            {
			local wep = pPlayer.Weapon;
            switch ( wep )
                {
                    case WEP_M4:
                    case WEP_RUGER:
                    case WEP_M60:
                    pPlayer.SetWeapon( wep, 0 );
                break;
                }
            }
		    break;
        case KEY_VEHICLE_HORN:
            {
                local veh = pPlayer.Vehicle;
                veh.Fix();
            }
            break;  
        case KEY_VEHICLE_HANDBRAKE:
            {
                local DriverVehicle = pPlayer.Vehicle;
                DriverVehicle.Angle = 0;
            }
		    break;			
		case KEY_VEHICLE_FIRE:
            {
			    local DriverVehicle = pPlayer.Vehicle;
				DriverVehicle.Pos = Vector( pPlayer.Pos.x, pPlayer.Pos.y, pPlayer.Pos.z+10 );
            }
            break;		
	    }		
    } 
    catch(e) Print("Error " + e );
}

function onPlayerEnterVehicle( pPlayer, Vehicle, IsPassenger )
{
 try
    {
	switch ( Vehicle.Model )
	    {
	    case 155: case 162:
            { 
            if ( pPlayer.IsAdmin ) ClientMessage(">> You've entered the RCON " + Vehicle + "." pPlayer 218, 112, 214 );
            else 
                { 
                    ClientMessage(">> Only RCON Administrators Can Drive this vehicle." pPlayer 255, 255, 0 );
                    pPlayer.Pos = Vector( pPlayer.Pos.x, pPlayer.Pos.y, pPlayer.Pos.z+1 );
                }
            }
			break;
        case 177:
            { 
            if ( Stats[ pPlayer.ID ].VIP >= 10 || pPlayer.IsAdmin ) ClientMessage(">> You've entered the VIP " + Vehicle + "." pPlayer 218, 112, 214 );
            else 
                { 
                    ClientMessage(">> You need VIP Level 10 to Drive this vehicle." pPlayer 255, 255, 0 );
                    pPlayer.Pos = Vector( pPlayer.Pos.x, pPlayer.Pos.y, pPlayer.Pos.z+1 );
                }
            }
			break;
		default:
            {		
                ClientMessage(">> You've entered the " + Vehicle + "." pPlayer 218, 112, 214 );	
            }				
		}
    }
    catch(e) Print("Error " + e );
}

function onPlayerExitVehicle( pPlayer, Vehicle, IsPassenger )
{
 try
    {
	switch ( Vehicle.Model )
        {	 
        case 155: case 162:
            { 
                ClientMessage(">> You've left the VIP " + Vehicle + "." pPlayer 218, 112, 214 );
            }
		    break;
        case 177:
            { 
                ClientMessage(">> You've left the VIP " + Vehicle + "." pPlayer 218, 112, 214 );
            }
			break;
		default:
            {		
                ClientMessage(">> You've left the " + Vehicle + "." pPlayer 218, 112, 214 );
			}	
        }
	}	
    catch(e) Print("Error " + e );
}

function onVehicleHealthChange( Vehicle, OldHP, NewHP )
{
 try
    {
	local 
	        PlayerVehicle = Vehicle.Driver,
	        DriverVehicle = PlayerVehicle.Vehicle;
		
	if ( Stats[ PlayerVehicle.ID ].GodCar == true ) 
	    { 
		    Announce("\x10 \x10 \x10 \x10 \x10 \x10 ~y~God~b~Car" PlayerVehicle ); 
			DriverVehicle.Fix(); 
		} 
    }	
    catch(e) Print("Error " + e );
}

function onPlayerWeaponChange( pPlayer, OldWep, NewWep )
{
 try
    {
	switch ( NewWep )
	    {
        case 33:
            {
            if ( ( Stats[ pPlayer.ID ].VIP >=10 ) || pPlayer.IsAdmin );
            else
                {
                    PrivMessage("You have been kicked Reason: Minigun Hack!" pPlayer );
                    Announce("~o~Hack ~o~Alert! " pPlayer );
                    MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Minigun-Hack!) " pPlayer );
                    Kick( pPlayer );
                }
            }
            break;			
        case 30: case 31:
            {
            if ( pPlayer.IsAdmin );
            else
                {
                    PrivMessage("You have been kicked Reason: Rocket/Flame Weapon Hack!" pPlayer );
                    Announce("~b~Hack ~o~Alert! " pPlayer );
                    MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Rocket/Flame-Hack!) " pPlayer );
                    Kick( pPlayer );
                }
            }
			break;
        case 12: case 13: case 14: case 15:        
            {
            if ( pPlayer.IsAdmin );
            else
                {
                    PrivMessage("You have been kicked Reason: Weapon Hack!" pPlayer );
                    Announce("~y~Hack ~o~Alert! " pPlayer );
                    MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Weapon-Hack!) " pPlayer );
                    Kick( pPlayer );
                }
            }
            break;			
        }
	}	
    catch(e) Print("Error " + e );
}

function onPlayerRequestAmmuWeapon( pPlayer, ShopID, SlotID )
{
 try
    {
	    local Slot;
        switch ( SlotID )
            {
            case 0:		
		        Slot = "~y~Want to buy Guns~w~? ";
		            break;
		    case 1:
		        Slot = "~b~Want to buy Guns~w~? ";
		            break;
            case 2:
		        Slot = "~p~Want to buy Guns~w~? ";
		            break;
            case 3:
		        Slot = "~g~Want to buy Guns~w~? ";
                    break;		
		    case 4:
		        Slot = "~o~Want to buy Guns~w~? ";
		            break;
		    case 5:
		        Slot = "~r~Want to buy Guns~w~? ";
				    break;
			default:
			    Slot = "~l~Want to buy Guns~w~? ";
			}	
		Announce( Slot , pPlayer );
    }
    catch(e) Print("Error " + e );
}
/*
function onPlayerHealthChange( pPlayer, OldHP, NewHP )
{
 try
    {
	if ( Stats[ pPlayer.ID ].GodMode == true )
	    { 
		    Announce("\x10 \x10 \x10 \x10 \x10 \x10 ~y~God~o~Mode" pPlayer ); 
			pPlayer.Health = 100;
		} 

	if ( OldHP < NewHP && Stats[ pPlayer.ID ].AntiHPHack == false ) 
	    {
            PrivMessage("You have been kicked Reason: Health Hack!" pPlayer );
            Announce("~o~Hack ~y~Alert! " pPlayer );
            MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Health-Hack!) " pPlayer );
            Kick( pPlayer );
	    }
	else 
	    {
            Stats[ pPlayer.ID ].AntiHPHack = false;
            if ( OldHP < NewHP ) Announce("\x10 \x10 \x10 \x10 \x10 \x10 ~y~+~p~" + ( OldHP - NewHP ) + "~r~{" pPlayer );	
		    else if ( OldHP > NewHP ) Announce("\x10 \x10 \x10 \x10 \x10 \x10 ~y~-~p~" + ( OldHP - NewHP ) + "~r~{" pPlayer );
        }	

	if ( ( pPlayer.Ping >= 900 ) && ( pPlayer.Health >= 10 ) )
        {
			pPlayer.Health - 9;
        }
	else if ( ( pPlayer.Ping >= 800  ) && ( pPlayer.Health >= 9 ) )
        {
			pPlayer.Health - 8;
        }
	else if ( ( pPlayer.Ping >= 700 ) && ( pPlayer.Health >= 8 ) )
        {
			pPlayer.Health - 7;
        }
	else if ( ( pPlayer.Ping >= 500 ) && ( pPlayer.Health >= 7 ) )
        {
			pPlayer.Health - 6;
        }
	else if ( ( pPlayer.Ping >= 300 ) && ( pPlayer.Health >= 6 ) )
        {
			pPlayer.Health - 5;
        }
	else if ( ( pPlayer.Ping >= 250 ) && ( pPlayer.Health >= 5 ) )
        {
			pPlayer.Health - 4;
        }	
	else if ( ( pPlayer.Ping >= 200 ) && ( pPlayer.Health >= 4 ) )
        {
			pPlayer.Health - 3;
        }	
    }
    catch(e) Print("Error " + e );
}

function onPlayerArmourChange( pPlayer, OldArm, NewArm )
{
 try
    {
    if ( OldArm < NewArm && Stats[ pPlayer.ID ].AntiHPHack == false ) 
	    {
            PrivMessage("You have been kicked Reason: Armour Hack!" pPlayer );
            Announce("~o~Hack ~y~Alert! " pPlayer );
            MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Armour-Hack!) " pPlayer );
            Kick( pPlayer );
		}
	else 
		{
			Stats[ pPlayer.ID ].AntiHPHack = false;
		    if ( OldArm < NewArm ) Announce("\x10 \x10 \x10 \x10 \x10 \x10 ~y~+~p~" + ( OldArm + NewArm ) + "~w~<" pPlayer );
		    else if ( OldArm > NewArm ) Announce("\x10 \x10 \x10 \x10 \x10 \x10 ~y~-~p~" + ( OldArm - NewArm ) + "~w~<" pPlayer );
	    }	
	
	if ( ( pPlayer.Ping >= 900 ) && ( pPlayer.Armour >= 10 ) )
        {
			pPlayer.Armour - 9;
        }
	else if ( ( pPlayer.Ping >= 800  ) && ( pPlayer.Armour >= 9 ) )
        {
			pPlayer.Armour - 8;
        }
	else if ( ( pPlayer.Ping >= 700 ) && ( pPlayer.Armour >= 8 ) )
        {
			pPlayer.Armour - 7;
        }
	else if ( ( pPlayer.Ping >= 500 ) && ( pPlayer.Armour >= 7 ) )
        {
			pPlayer.Armour - 6;
        }
	else if ( ( pPlayer.Ping >= 300 ) && ( pPlayer.Armour >= 6 ) )
        {
			pPlayer.Armour - 5;
        }
	else if ( ( pPlayer.Ping >= 250 ) && ( pPlayer.Armour >= 5 ) )
        {
			pPlayer.Armour - 4;
        }	
	else if ( ( pPlayer.Ping >= 200 ) && ( pPlayer.Armour >= 4 ) )
        {
			pPlayer.Armour - 3;
        }
    }
    catch(e) Print("Error " + e );
}
*/
function onPlayerCashChange( pPlayer, OldCash, NewCash )
{
    Stats[ pPlayer.ID ].Cash = pPlayer.Cash;
	PrivMessage("Your Cash: " + Stats[ pPlayer.ID ].Cash, pPlayer );
}

function onPlayerPM( pPlayer, pPlayerTo, szText )
{
 try
    {  
    if ( pPlayer.IsMuted ) PrivMessage("[Error] - You are Currently Muted! (Anti-PM)." pPlayer );
    else if ( Stats[ pPlayerTo.ID ].IgnorePM == true ) PrivMessage("[Error] - This player have Ignore PM!" pPlayer );
    else 
        {
		Announce("\x10 \x10 \x10 \x10 \x10 ~b~PM ~y~- ~o~[~w~" + pPlayer.ID + "~o~] " pPlayerTo );
		local 
		        a = 0, 
		    	b = GetMaxPlayers(), 
			    c = 0,
			    d = GetPlayers(), 
			    Rcons = FindPlayer( a );
			
        while ( ( a < b ) && ( c < d ) )
            {       
            if ( Rcons )
                {    
                if ( pPlayer.IsAdmin ) PrivMessage( pPlayer + " To " + pPlayerTo + ": " + szText, Rcons );
				c ++;
                }
            a ++;
            }
        }
    }   
    catch(e) Print("Error " + e );
}

function onPlayerFailedPM( pPlayer, pPlayerTo, szText )
{
 try
    {
        PrivMessage("[Erorr] - Player is not online!" pPlayer );
    }
    catch(e) Print("Error " + e );
}

function onPlayerAction( pPlayer, szText )
{
 try
    {
        if ( pPlayer.IsMuted == true ) PrivMessage("[Error] - You are Currently Muted! (Anti-Action)." pPlayer );
        else EchoMessage( ICOL_ORANGE + "** " + pPlayer.Name + " " + szText );
    }
    catch(e) Print("Error " + e );
}

function onPlayerCrashDump( pPlayer, Crash )
{
 try
    {
        MessagePlayer("!! Error: Game Crashed !!" pPlayer );
        MessageAllExcept("VSS-Buster -> Kicked ''" + pPlayer.Name + "'' (Crashed!) " pPlayer );
        Kick( pPlayer );
    }
    catch(e) Print("Error " + e );
}    

function onPlayerStartSpectating( pPlayer, pSpectated )
{
 try
    {
        if ( pSpectated.IsAdmin ) PrivMessage("[Error] - You Can't Spec RCON Admin." pPlayer );
        else if ( Stats[ pSpectated.ID ].IgnoreSpec ) PrivMessage("[Error] - This player have Ignore Spec!" pPlayer );
        else
        { 
            Announce("\x10 \x10 \x10 \x10 \x10 ID~l~: ~b~[" +pSpectated.ID + "] ~r~ {~l~: ~b~" + pSpectated.Health + " ~w~<~l~: ~b~" + pSpectated.Armour + "  " pPlayer );
            MessagePlayer("You are Spectating " + pSpectated + " now!" pPlayer );
        }
    }
    catch(e) Print("Error " + e );    
}

function onConsoleInput( cmd, text ) 
{
 try
    {
    local ctext = cmd.tolower(); 
    if ( cmd == "cmds" || cmd == "commands")
        {            
            Print("JaVeD's Console System By JaVeD");
            Print("----------> Commands <----------");
            Print("Kill, Kickp, Banp, Unban, Unbanall");
            Print("ServerName, Map, Slots, GameMode");
            Print("DeathMessages, Driveonwater, Fall");
            Print("Driveby, Carfly, Get/Rconpassword");
            Print("Players, Count, Message, Announce");
            Print("-------- Reload, Compile --------");
        }
    else if ( cmd == "compile")
        {
        if ( text )
            {
            local file = loadfile( text );
            if ( file )
                {
                    Print("Script " + text + " compiled successfully");  
                    writeclosuretofile(" " +text + ".JaVeD", file );
                }
            else Print("Unable to load script " + text );
            }
        else Print("Error - Invalid arguments (compile <script>)");
        }
    else if ( cmd == "kill")
        {
        if ( !text ) Print("[Syntax] - kill <id/nick>");
        else if ( text )
            {
            local plr = GetPlayer( GetTok( text, " ", 1 ) );
            if ( !plr ) Print(" " + text + " is invalid Nick/ID!");
            else 
                {
                    local plr = GetPlayer( GetTok( text, " ", 1 ) );
                    MessagePlayer("You are Killed by an Administrator from Console",plr);
                    MessageAllExcept(" " + plr.Name + " is Killed by an Administrator from Console",plr); 
                    plr.Health = 0;
                    Print(" You Killed " + plr.Name );
                }
            }
        }
    else if ( cmd == "kickp")
        {
        if ( !text ) Print("[Syntax] - kickp <id/nick>");
        else if ( text )
            {
            local plr = GetPlayer( GetTok( text, " ", 1 ) );
            if ( !plr ) Print(" " + text + " is invalid Nick/ID!");
            else 
                {
                    local plr = GetPlayer( GetTok( text, " ", 1 ) );
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer("You are Kicked by an Administrator from Console",plr);
                    MessageAllExcept(" " + plr.Name + " is Kicked by an Administrator from Console",plr); 
                    Print(" You Kicked " + plr.Name );
                    Kick( plr );
                }
            }
        }
    else if ( cmd == "banp")
        {
        if ( !text ) Print("[Syntax] - banp <id/nick> <days> <reason>");
        else if ( text )
            {
            local plr = GetPlayer( GetTok( text, " ", 1 ) );
            if ( !plr ) Print(" " + text + " is invalid Nick/ID!");
            else 
                {
                    local plr = GetPlayer( GetTok( text, " ", 1 ) );
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer(" ",plr);
                    MessagePlayer("You are Banned by an Administrator from Console",plr);
                    MessageAllExcept(" " + plr.Name + " is Banned by an Administrator from Console",plr); 
                    local days = GetTok( text, " ", 0 ), admin = GetTok( text, " ", 1 ), reason = GetTok( text, " ", 2 );
                    QuerySQL( db, "INSERT INTO Bans ( Name, IP, Admin, Days, Reason, Date ) VALUES ( '" + plr.Name + "', '" + plr.IP + "', '" + admin + "', '" + days + "', '" + reason + "', '" + GetFullTime() + "' )");
                    Print(" You Banned " + plr.Name );
                    Kick( plr );    
                }
            }
        }
    else if ( cmd == "unban")
        {
            if ( !text ) Print("[Syntax] - " + cmd + " <Full Nick>");
            else if ( CheckUnBan( text ) == 0 ) Print("[Error] - " + text + " is not Banned.");
            else ConsoleUnBan( text );    
        } 
    else if ( cmd == "unbanall")
        {
            UnBanAll();
            Print("-----> UnBanned All Bnned Players <-----");
        }    
    else if ( cmd == "players")
        {
        local maxPlayers = GetMaxPlayers();
        local i = 0, ii = 0, iii = 0;
        local buffer = null;
        while ( ( i < maxPlayers ) && ( ii < GetPlayers() ) )
            {
            local plr = FindPlayer( i );
            if ( plr )
                {
                if ( !buffer ) 
                    {
                        buffer = plr.Name;
                        iii++;
                    }
                else if ( ++iii < 3 ) buffer = buffer + "     |     " + plr.Name;
                else
                    {
                        Print( buffer );
                        buffer = plr.Name;
                        iii = 0;
                    }
                ii++;
                }
            i++;
            }
            if ( buffer ) Print( buffer ); 
            Print("Total players: " + GetPlayers() );
        }
    else if ( cmd == "reload")
        {
        SaveAllStats();
		ReloadScripts();
        }
    else if ( cmd == "pmannounce")
        {
        if ( !text ) Print("[Syntax] - PMAnnounce <id/nick> <text>");
        else if ( text )
            {
            local plr = GetPlayer( GetTok( text, " ", 1 ) );
            if ( !plr ) Print(" " + text + " is invalid Nick/ID!");
            else 
                {
                    Announce("~p~PM ~w~- " + text + " ", plr);
                    Print("PRIVATE ANNOUNCE: " +text+" ");
                    Print("Successfully Private Announce Send to Server on " + GetFullTime() + ". ");
                }
            }
        }    
    else if ( cmd == "pmmessage")
        {
        if ( !text ) Print("[Syntax] - PMMessage <id/nick> <text>");
        else if ( text )
            {
            local plr = GetPlayer( GetTok( text, " ", 1 ) );
            if ( !plr ) Print(" " + text + " is invalid Nick/ID!");
            else 
                {
                    MessagePlayer("JaVeD's Console (PM): " + text + " ", plr);
                    Print("PRIVATE MESSAGE: " +text+" ");
                    Print("Successfully Private Message Send to Server on " + GetFullTime() + ". ");
                }
            }
        } 
    else if ( cmd == "message")
        {
            Message("JaVeD's Console: " +text);
            Print("JaVeD's Console:" +text);
            Print("Successfully Message Send to Server on " + GetFullTime() + ". ");
        }
    else if ( cmd == "announce")
        {
            AnnounceAll(" " +text);
            Print("ANNOUNCE: " +text);
            Print("Successfully Announce Send to Server on " + GetFullTime() + ". ");
        } 
    else if ( cmd == "." || cmd == "irc") 
        {
            Print("IRC -> " +text);
            EchoMessage( ICOL_ORANGE + "JaVeD's Console: " + ICOL_BLACK + " " + text );
        } 
    else if ( cmd == "!" || cmd == "/") 
        {
            Message("JaVeD's Console: " +text);
            Print("----------------------------------");
            Print("Server -> " +text);
            Print("IRC -> " +text);
            Print("----------------------------------");
            EchoMessage( ICOL_ORANGE + "JaVeD's Console: " + ICOL_BLACK + " " + text );
        } 
    else if ( cmd == "count")
        {
            Print("[Pickups] - " + GetPickupCount().tostring());
            Print("[Vehicles] - " + GetVehicleCount().tostring());
        }
    else if ( cmd == "servername")
        {        
        if ( !text ) Print("[Syntax] - /c " + cmd + " <value> ");
        else
            {
                SetServerName( text );
                Print(" Server Name Changed to " + text + ".");
            }    
        }
    else if ( cmd == "gamemode")
        {
        if ( !text ) Print("[Syntax] - /c " + cmd + " <value> ");
        else
            {        
                SetGamemodeName( text );
                Print("Game Mode Changed to " + text + ".");
            }    
        }
    else if ( cmd == "map")
        {
        if ( !text ) Print("[Syntax] - /c " + cmd + " <value> ");
        else
            {        
                SetMapName( text );
                Print("Server Map Name Changed to " + text + ".");
            }    
        } 
    else if ( cmd == "getrconpassword")
        {
            Print("Rcon Password: " + GetPassword(), player );
        }
    else if ( cmd == "rconpassword")
        {
        if ( !text ) Print("[Syntax] - /c " + cmd + " <value> ");
        else
            {
                SetPassword( text );
                Print("Rcon Password Changed to " + text + ".");
            }
        }
    else if ( cmd == "slots")
        {
        if ( !text ) Print("[Syntax] - /c " + cmd + " <value> ");
        else
		    {
                SetMaxPlayers( text.tointeger() );
                Print("Slots Changed to: " + text.tointeger() + ". ");
			}	
        }
    else if ( cmd == "carfly")
        {
        if ( text == "on")
            {
            if ( GetFlyingCars() == true ) Print("Flying cars are already enabled.");
            else
                {
                    SetFlyingCars( true );
                    Print("Flying cars are enabled!");
                }
            }
        else if ( text == "off")
            {
            if ( GetFlyingCars() == false ) Print("Flying cars are already disabled.");
            else
                {
                    SetFlyingCars( false );
                    Print("Flying cars are disabled! ");
                }
			}
            else Print(" " + cmd + " <on/off> ");            
        } 
    else if ( cmd == "deathmessages")
        {
        if ( text == "on")
            {
            if ( GetDeathMessages() == true ) Print("DeathMessages is already enabled.");
            else
                {
                    SetDeathMessages( true );
                    Print("DeathMessages has been enabled.");
                }
            }
        else if ( text == "off")
            {
            if ( GetDeathMessages() == false ) Print("DeathMessages is already disabled.");
            else
                {
                    SetDeathMessages( false );
                    Print("DeathMessages has been disabled.");
                }
            }
            else Print(" " + cmd + " <on/off> ");
        } 
    else if ( cmd == "driveby")
        {
        if ( text == "on")
            {
            if ( GetDrivebyEnabled() == true ) Print("Driveby is already enabled.");
            else
                {
                    SetDrivebyEnabled( true );
                    Print("DriveBy Enabled!");
                }
            }
        else if ( text == "off")
            {
            if ( GetDrivebyEnabled() == false ) Print("Driveby is already disabled.");
            else 
                {
                    SetDrivebyEnabled( false );
                    Print("DriveBy Disabled!");
                }    
            }
            else Print(" " + cmd + " <on/off> ");
        }  
    else if ( cmd == "fall")
        {
        if ( text == "on")
            {
            if ( GetFallEnabled() == true ) Print("fall is already enabled.");
            else
                {
                    SetFallEnabled( true );
                    Print("fall has been enabled.");
                }
            }
        else if ( text == "off")
            {
            if ( GetFallEnabled() == false ) Print("fall is already disabled.");
            else
                {
                    SetFallEnabled( false );
                    Print("fall has been disabled.");
                }
            }
            else Print(" " + cmd + " <on/off> ");
        } 
    else if ( cmd == "driveonwater")
        {
        if ( text == "on")
            {
            if ( GetDriveOnWater() == true ) Print("Driving on water is already permitted here.");
            else
                {
                    SetDriveOnWater( true );
                    Print("Driving on water has been enabled.");
                }
            }
        else if ( text == "off")
            {
            if ( GetDriveOnWater() == false ) Print("Driving on water is already disabled here.");
            else
                {                
                    SetDriveOnWater( false );
                    Print("riving on water has been disabled.");
                }
            }
            else Print(" " + cmd + " <on/off> ");
        }
    else if ( cmd == "time")
        {
            Print( GetFullTime() );
        }
    else if ( cmd == "test")
        {
		local
        	Player_Count = GetPlayers(),
			pPlayer;
			
        	if ( !Player_Count ) return;  
        	for ( local PlayerID = 0, PlayerCount = 0; PlayerID < GetMaxPlayers() && PlayerCount < Player_Count; PlayerID++ )
			if ( pPlayer == 0 ) return Print("No Players ");
			else Print( GetMaxPlayers() );
        } 
    else Print(" " + ctext + " Command does not exist! ");           
    }
    catch(e) Print("Error " + e );
}