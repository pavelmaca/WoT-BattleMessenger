//import com.xvm.Logger;
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
	public static var BATTLE_SPECIAL:String = "Special";
	public static var BATTLE_RANDOM:String = "Random";
	public static var BATTLE_TRAINING:String = "Training";
	public static var BATTLE_COMPANY:String = "Company";
    public static var BATTLE_TEAM_7x7:String = "Team7x7";
	public static var BATTLE_UNKNOWN:String = "Unknown";
	
	private static var TEAM_1:String = "team1";
	private static var TEAM_2:String = "team2";
	private static var VEHICLE_DEAD_STATE:Number = 2;
	
	
	public static function getAllPlayers():Array {
		return getAllyPlayers().concat( getEnemyPlayers() );
	}
	
	public static function getSelf():Player {
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
	
	public static function isPlayerDead(uid:Number):Boolean {
		var player:Player = getPlayerByUid(uid);
        return (player.vehicleState == VEHICLE_DEAD_STATE);
	}
	
	/**
	 * @return	Battle type flag
	 */
	public static function getBattleType():String {
		switch(_root.statsData.arenaData.battleIcon.toString()) {
			case "1":
                // Clan wars & special battles (WG turnaments)
				return BATTLE_SPECIAL;
			case "ctf":
			case "domination":
			case "assault":
			case "assault1":
			case "assault2":
                // HOTFIX: cant recognize training battle anymore, only way is to check number of players in both teams
                // WARNING: FULL training battle is taken as random, not training !!
                if (_root.statsData.team1.length < 15 || _root.statsData.team2.length < 15) {
                    return BATTLE_TRAINING;
                }
            case "nations":
			case "historical":
                // randoms
				return BATTLE_RANDOM;
			case "3":
                // old training battles
				return BATTLE_TRAINING;
			case "4":
			case "team":
				/**
				 * Company CTF
				 * Company Assault (both side)
				 * Company Encounter
				 */
				return BATTLE_COMPANY;
            case "6":
			case "team7x7":
                /**
                 * Team battles 7x7
                 */
                return BATTLE_TEAM_7x7;
			default:
				//Logger.addObject(_root.statsData.arenaData.battleIcon.toString());
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
	
	private static function getPlayerByUid(uid:Number):Player
    {
        var playerInfo:Player = getPlayerFromByUid(getAllyPlayers(), uid);
        if (playerInfo)
            return playerInfo;

        return getPlayerFromByUid(getEnemyPlayers(), uid);
    }
	
	private static function getPlayerFromByUid(players:Array, uid:Number):Player
    {
        for (var i:Number = 0; i < players.length; i++)
            if (players[i].uid == uid)
                return players[i];

        return null;
    }
}