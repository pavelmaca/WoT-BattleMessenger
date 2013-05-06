/**
 * @author Assassik
 */
class wot.BattleMessenger.models.BattleType
{

	public static var SPECIAL = "Special";
	public static var RANDOM = "Random";
	public static var TRAINING = "Training";
	public static var COMPANY = "Company";
	
	public static var UNKNOWN = "Unknown";
	
	
	/**
	 * @param	battleIcon
	 * @return	Battle type flag
	 */
	public static function getType(battleIcon:String):String {
		switch(battleIcon) {
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
				return SPECIAL;
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
				return RANDOM;
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
				return TRAINING;
			case "4":
				/** 
				 * Company CTF
				 * Company Assault (both side)
				 * Company Encounter
				 * 	"battleName": "#menu:loading/battleTypes/3"
				 * 	"battleIcon": 4
				 */
				return COMPANY;
			default:
				return UNKNOWN;
		}
	}
	
}