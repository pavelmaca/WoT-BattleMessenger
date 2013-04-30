import wot.BattleMessenger.Utils;
//import wot.utils.Logger;

/**
 * ...
 * @author 
 */
class wot.BattleMessenger.Antispam.Filters
{
	/** TODO: debug only*/
	public var lastMatch:String;
	/**/
	private var filters:Array = [];
	
	/*[["@", "a"], ["0", "o"], ["1", "i"], 
  ["2", "r"], ["3", "e"], ["4", "a"], ["5", "s"], ["7", "t"], ["8", "b"], 
  ["9", "g"], ["|<", "k"], ["|\\/|", "m"], ["|\\|", "n"], ["ä", "a"], ["ã", "a"], 
  ["â", "a"], ["ä", "a"], ["á", "a"], ["à", "a"], ["å", "a"], ["é", "e"], 
  ["è", "e"], ["ë", "e"], ["ê", "e"], ["§", "s"], ["$", "s"], ["£", "l"], 
  ["€", "e"], ["ü", "u"], ["û", "u"], ["ú", "u"], ["ù", "u"], ["î", "i"], 
  ["ï", "i"], ["í", "i"], ["ì", "i"], ["ÿ", "y"], ["ý", "y"], ["ö", "o"], 
  ["ô", "o"], ["õ", "o"], ["ó", "o"], ["ò", "o"]];*/
	private var charReplacements:Array = [
		// WG
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
		//added
		["4", "a"], ["8", "b"], 
	//	["|<", "k"], ["|\\/|", "m"], ["|\\|", "n"], collision with nonStandardChars
		["ä", "a"], ["ã", "a"], ["â", "a"], ["ä", "a"], ["á", "a"], ["à", "a"], 
		["å", "a"], ["é", "e"], ["è", "e"], ["ë", "e"], ["ê", "e"], ["§", "s"], 
		["£", "l"], ["€", "e"], ["ü", "u"], ["û", "u"], ["ú", "u"], ["ù", "u"], 
		["î", "i"], ["ï", "i"], ["í", "i"], ["ì", "i"], ["ÿ", "y"], ["ý", "y"], 
		["ö", "o"], ["ô", "o"], ["õ", "o"], ["ó", "o"], ["ò", "o"]
	];
	
	private var nonStandardChars = ["*", "|", ".", ",", "&", "[", "]", 
		":", ";", "?", "<", ">", "~", "`", "(", ")", "^", "%", "#", "{", "}", 
		"=", "-"
	];
	
	public function Filters() 
	{
		
	}
	
	public function addFiltersFromArray(ar:Array) {
		for (var i in ar) {
			this.filters.push( this.normalize(ar[i], true) );
		}
	}
	
	public function test(message:String):Boolean {
		var words:Array  = this.splitWords( this.normalize(message, false) );
		for (var i in words) {
			if (words[i].length < 2) {
				//trace("skip: " + words[i]);
				continue;
			}
			for (var z in this.filters) {
				if (this.matchWord(words[i], this.filters[z]) > -1) {
					//trace("found: " + words[i]+" - "+this.filters[z]);
					this.lastMatch = "[BattleMessagner] match: " + words[i] + " - " + this.filters[z];
					return true;
				}
			}
		}
		return false;
	}
	
	private function matchWord(word:String, filter:String):Number {
		//trace(word + " - " + filter);
		var expandStart:Boolean = (filter.charAt(0) == "." && filter.charAt(1) == "*");
		var expandEnd:Boolean = (filter.charAt(filter.length - 2) == "." && filter.charAt(filter.length - 1) == "*");
		
		//detect .* inside "fil.*ter" (skip first and last 2 chars)
		var expandMiddle:Boolean = (filter.lastIndexOf(".*", (expandEnd ? filter.length - 3 : filter.length)) > 0);
		//trace("start: " + expandStart +" end: " + expandEnd);
		if (expandMiddle) {
			var index:Number = filter.indexOf(".*", (expandStart ? 2 : 0));
			//trace("is middle: " + index);
			var tmpFilter:String ;
			do {
				if (index == filter.length - 2 || index == -1) {
					trace("dont reach this");
					break;
				}
				tmpFilter = filter.slice(0, index+2);
				//trace("temp: " + tmpFilter);
				//return -1;

				var matchIndex:Number = this.matchWord(word, tmpFilter);

				if (matchIndex > -1) {
					word = word.slice(matchIndex + tmpFilter.length - 2 - (expandStart ? 2 : 0));
				//	trace(word);
				}else {
					return -1; //not match
				}
				filter = filter.slice(index);
				index = filter.indexOf(".*", 2);
			//	trace(filter);
			}while (index > 0 && index < (filter.length - 2));
			//trace(word +" - "+filter);
			return this.matchWord(word, filter);
		}
		
		if (expandStart || expandEnd) {
			filter = filter.slice( (expandStart ? 2 : 0) , (expandEnd ? -2 : filter.length));
		}
		
		var index:Number = word.indexOf(filter);
		var match:Boolean = false;
		if (expandStart && expandEnd) {
			// .*word.* == .*filter.*
			match = (index != -1);
		//	trace("match1: " + match);
		}else if (expandEnd) {
			// word.* == filter.*
			match = (index == 0);
		}else if (expandStart) {
			// .*word == .*filter
			index = word.lastIndexOf(filter); //fix "abab" with ".*ab" TODO: lepší řešení
			match = (index != -1 && index == (word.length - filter.length));
		}else if (!expandStart && !expandMiddle && !expandEnd){
			// word == filter || fil.*ter
			match = (word == filter);
		}
		return (match ? index : -1);
	}
	
	private function normalize(message:String, isFilter:Boolean):String {
		if (!isFilter) {
			message = this.removeHtml(message);
		}
		message = message.toLowerCase();
		for (var i in this.charReplacements) {
			message = Utils.strReplace(message, this.charReplacements[i][0], this.charReplacements[i][1]);
		}
		if(!isFilter){
			message = this.removeNonStandardCharacters(message);
		}
		//trace("normalize: " + message);
		return message;
	}
	
	private function splitWords(text:String):Array {
		return text.split(" ");
	}
	
	private function removeNonStandardCharacters(text:String):String {
		for (var i in this.nonStandardChars) {
			text = Utils.strReplace(text, this.nonStandardChars[i], "");
		}
		return text;
	}
	
	private function removeHtml(text:String):String {
		var firstTag:Number = text.indexOf(">");
		var lastTag:Number = text.lastIndexOf("<");
		return text.slice( firstTag + 1, (lastTag != -1 ? lastTag : text.length));
	}
}