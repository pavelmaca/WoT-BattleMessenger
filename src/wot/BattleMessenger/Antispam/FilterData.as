/**
 * @author Assassik
 */
class wot.BattleMessenger.Antispam.FilterData
{
	public static var FIND:Number = 0;
	public static var REPLACEMENT:Number = 1;
	
	
	/**
	 * List of replaced chars
	 * ["char", "replacement"] 
	 */
	public static var charReplacements:Array = [
		/** Replacments from /res/text/messenger_oldictionary.xml (EU client) */
		["@", "a"],
		["3", "e"],
		["ph", "f"],
		["6", "g"],
		["c", "k"],
	//	["\\(", "k"], collision with nonStandardChars
		["1", "l"],
		["!", "l"],
		["i", "l"],
		["0", "o"],
		["9", "q"],
		["$", "s"],
		["5", "s"],
		["z", "s"],
		["2", "s"],
		["7", "t"],
		["+", "t"],
		["u", "v"],
		["w", "v"],
		/** Extension */
		["4", "a"], ["8", "b"],
		["ä", "a"], ["ã", "a"], ["â", "a"], ["ä", "a"], ["á", "a"], ["à", "a"], 
		["å", "a"], ["é", "e"], ["è", "e"], ["ë", "e"], ["ê", "e"], ["§", "s"], 
		["£", "l"], ["€", "e"], ["ü", "u"], ["û", "u"], ["ú", "u"], ["ù", "u"], 
		["î", "i"], ["ï", "i"], ["í", "i"], ["ì", "i"], ["ÿ", "y"], ["ý", "y"], 
		["ö", "o"], ["ô", "o"], ["õ", "o"], ["ó", "o"], ["ò", "o"]
	];
	
	/**
	 * List of deleted chars
	 */
	public static var nonStandardChars = ["*", "|", ".", ",", "&", "[", "]", 
		":", ";", "?", "<", ">", "~", "`", "(", ")", "^", "%", "#", "{", "}", 
		"=", "-"
	];
}