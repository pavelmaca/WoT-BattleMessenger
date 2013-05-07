import wot.BattleMessenger.models.Player;

/**
 *  _root.statsData = {
 *  	"results": {},
 *     	"arenaData": {
 * 			"battleName": "#arenas:type/ctf/name",
 *        	"winText": "Úkol: Obsaďte nepřátelskou základnu nebo zničte všechna nepřátelská vozidla.",
 *        	"team2Text": "#menu:loading/team2",
 *        	"team1Text": "#menu:loading/team1",
 *        	"battleIcon": "ctf",
 *       	"mapText": "Erlenberg"
 *    	},
 *    	"current": 1,
 *     	"playerTeam": "team1",
 *     	"team2": [ {wot.BattleMessenger.models.Player},... ],
 * 		"team1": [ {wot.BattleMessenger.models.Player},... ]
 * 	};
 * 
 * @author Assassik
 */
class wot.BattleMessenger.models.StatsDataProxy
{
	public static var BATTLE_SPECIAL = "Special";
	public static var BATTLE_RANDOM = "Random";
	public static var BATTLE_TRAINING = "Training";
	public static var BATTLE_COMPANY = "Company";
	public static var BATTLE_UNKNOWN = "Unknown";
	
	private static var TEAM_1 = "team1";
	private static var TEAM_2 = "team2";
	
	
	public static function getAllPlayers():Array {
		return getAllyPlayers().concat( getEnemyPlayers() );
	}
	
	public static function getSelf() {
		var myTeam:Array = getAllyPlayers();
        for (var i in myTeam)
        {
            var player:Player = myTeam[i];
            if (player.himself == true)
                return player;
        }
        
        return null;
	}
	
	public static function getPlayerByName(username:String):Player {
		var playerInfo:Player = getPlayerFromByName(getAllyPlayers(), username);
        if (playerInfo)
            return playerInfo;
        
        return getPlayerFromByName(getEnemyPlayers(), username);
	}
	
	/**
	 * @return	Battle type flag
	 */
	public static function getBattleType():String {
		switch(_root.statsData.arenaData.battleIcon.toString()) {
			case "1": 
				/**
				 * Tournament CTF
				 * 	"battleName": "Open League Championship Series, Spring 2013: May 4th [Group 2]"
				 * 	"battleName": "Cruiserweight Cup: Cruiserweight Cup"
				 * 	"battleIcon": 1
				 * 
				 * Clan CTF
				 * 	"battleName": "Klanové války: Bir Moghrein - Jižní Tiris Zemmour, bitva o hranice"
				 * 	"battleIcon": 1
				 */
				return BATTLE_SPECIAL;
			case "ctf":
			case "domination":
			case "assault": 
				/**
				 * Random CTF
				 * 	"battleName": "#arenas:type/ctf/name"
				 * 	"battleIcon": "ctf"
				 * 
				 * Random Encounter
				 * 	"battleName": "#arenas:type/domination/name"
				 * 	"battleIcon": "domination"
				 * 
				 * Random Assault (both side)
				 * 	"battleName": "#arenas:type/assault/name"
				 * 	"battleIcon": "assault"
				 */
				return BATTLE_RANDOM;
			case "3": 
				/**
				 * Training CTF
				 * Training Encounter
				 * 	"battleName": "#menu:loading/battleTypes/2"
				 * 	"battleIcon": 3,
				 * 
				 * Training Assault
				 * 	TODO: get info
				 */
				return BATTLE_TRAINING;
			case "4":
				/** 
				 * Company CTF
				 * Company Assault (both side)
				 * Company Encounter
				 * 	"battleName": "#menu:loading/battleTypes/3"
				 * 	"battleIcon": 4
				 */
				return BATTLE_COMPANY;
			default:
				return BATTLE_UNKNOWN;
		}
	}
	
	/** private */
	private static function getAllyPlayers():Array {
		return _root.statsData[ getOwnTeamName() ];
	}
	
	private static function getEnemyPlayers():Array {
		return _root.statsData[ (getOwnTeamName() == TEAM_1 ? TEAM_2 : TEAM_1)];
	}
	
	private static function getOwnTeamName():String {
		return _root.statsData.playerTeam;
	}
	
	private static function getPlayerFromByName(players:Array, username:String):Player
    {
        for (var i:Number = 0; i < players.length; i++)
            if (players[i].userName == username)
                return players[i];
        
        return null;
    }
}