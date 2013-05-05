import wot.BattleMessenger.utils.Utils;
import wot.BattleMessenger.Antispam.FilterData;
//import wot.utils.Logger;

/**
 * ...
 * @author 
 */
class wot.BattleMessenger.Antispam.Filters
{

	/** Contain last matched filter */
	public var lastFilter:String;

	/** List of all active filters */
	private var filters:Array = [];
	
	//public function Filters() {}
	
	/**
	 * Prepare filters on startup
	 * @param	ar List of filters
	 */
	public function addFiltersFromArray(ar:Array) {
		for (var i in ar) {
			this.filters.push( this.normalize(ar[i], true) );
		}
	}
	
	/**
	 * Sice message to words and test each filter on each word longer then 1 char
	 * @param	message
	 * @return	true if one of filters match
	 */
	public function test(message:String):Boolean {
		var words:Array  = this.splitWords( this.normalize(message, false) );
		for (var i in words) {
			if (words[i].length < 2) {
				continue;
			}
			for (var z in this.filters) {
				if (this.matchWord(words[i], this.filters[z]) > -1) {
					this.lastFilter = "<b>" + this.filters[z] + "</b> on word: " + words[i];
					//this.lastMatch = "word: '" + words[i] + "' filter: '" + this.filters[z] + "'";
					return true;
				}
			}
		}
		return false;
	}
	
	public function popLastFilter():String {
		var res = this.lastFilter;
		this.lastFilter = null;
		return res;
	}
	
	/**
	 * test single filter on given word
	 * @param	word
	 * @param	filter
	 * @return	-1 = no match; > -1 match (number indicate filter position on word)
	 */
	private function matchWord(word:String, filter:String):Number {
		//trace(word + " - " + filter);
		var expandStart:Boolean = (filter.charAt(0) == "." && filter.charAt(1) == "*");
		var expandEnd:Boolean = (filter.charAt(filter.length - 2) == "." && filter.charAt(filter.length - 1) == "*");
		
		//detect .* inside "fil.*ter" (skip first and last 2 chars)
		var expandMiddle:Boolean = (filter.lastIndexOf(".*", (expandEnd ? filter.length - 3 : filter.length)) > 0);
		if (expandMiddle) {
			var index:Number = filter.indexOf(".*", (expandStart ? 2 : 0));
			var tmpFilter:String ;
			do {
				if (index == filter.length - 2 || index == -1) {
					break;
				}
				tmpFilter = filter.slice(0, index+2);

				var matchIndex:Number = this.matchWord(word, tmpFilter);
				if (matchIndex > -1) {
					word = word.slice(matchIndex + tmpFilter.length - 2 - (expandStart ? 2 : 0));
				}else {
					return -1; //not match
				}
				filter = filter.slice(index);
				index = filter.indexOf(".*", 2);
			}while (index > 0 && index < (filter.length - 2));
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
			message = this.removeHTML(message);
		}
		message = message.toLowerCase();
		for (var i in FilterData.charReplacements) {
			message = Utils.strReplace(message, FilterData.charReplacements[i][FilterData.FIND], FilterData.charReplacements[i][FilterData.REPLACEMENT]);
		}
		if(!isFilter){
			message = this.removeNonStandardCharacters(message);
		}
		return message;
	}
	
	private function splitWords(text:String):Array {
		return text.split(" ");
	}
	
	private function removeNonStandardCharacters(text:String):String {
		for (var i in FilterData.nonStandardChars) {
			text = Utils.strReplace(text, FilterData.nonStandardChars[i], "");
		}
		return text;
	}
	
	/**
	 * @param	"<font color='#80D63A'>this is minimap <font color=''>username(vehicle)</font> action</font>"
	 * @return	"this is minimap action"
	 */
	public function removeHTML(message:String):String {
		// Remove first and last tag
		var firstTag:Number = message.indexOf(">");
		var lastTag:Number = message.lastIndexOf("<");
		var content:String = message.slice( firstTag + 1, (lastTag != -1 ? lastTag : message.length));
		
		// Remove all <font>text</font> WITH content
		var tagStart:Number;
		var tagEnd:Number;
		while ((tagStart = content.indexOf("<font ")) > -1 && (tagEnd = content.indexOf("</font>", tagStart)) > -1) {
			content = content.slice(0, tagStart) + content.slice(tagEnd + 7, content.length);
		}
		
		/**
		 * TODO: remove img tags?
		 */
		
		return content;
	}
}