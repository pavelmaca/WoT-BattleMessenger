/**
 * 	_root.statsData.team1.[] = {
 * 		"uid": 502182284,
 *     	"vehicle": "IS-3",
 *      "position": 1,
 *     	"denunciations": 3,
 *     	"team": "team2",
 *      "squad": 0,
 *      "level": 0,
 *      "himself": false,
 *     	"vehId": 23024114,
 * 		"userName": "philhill",
 * 		"teamKiller": false,
 * 		"VIP": false,
 * 		"icon": "../maps/icons/vehicle/contour/ussr-IS-3.png",
 * 		"vipKilled": 0,
 * 		"muted": false,
 * 		"vehicleState": 1,
 * 		"speaking": false,
 * 		"roster": 0,
 * 		"isPostmortemView": false,
 * 		"clanAbbrev": "M-R",
 * 		"frags": 0,
 * 		"label": "philhill",
 * 		"vehAction": 0
 * 	}
 * @author Assassik
 */
  
class wot.BattleMessenger.models.Player
{
    public var uid:Number;
    public var vehicle:String;
    public var team:String;
    public var level:Number;
    public var himself:Boolean;
    public var userName:String;
    public var icon:String;
    public var vehicleState:Number;
	public var clanAbbrev:String;
	public var squad:Number;
}