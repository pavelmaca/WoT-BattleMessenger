import wot.BattleMessenger.utils.Utils;
import wot.BattleMessenger.MessengerConfig;
import wot.BattleMessenger.Antispam.Filters;
import wot.BattleMessenger.Antispam.WGFilter;
//import com.xvm.Logger;

class wot.BattleMessenger.Antispam.Antispam
{
	/**
	 * {
	 * 	playerUid:
	 *		{time1: msg1},
	 * 		{time2: msg2}
	 * }
	 */
	private var cache:Object = {};
	
	private var filters:Filters;
	
	public var lastMatch:String;
			
	public function Antispam() 	{
		this.filters = new Filters();
		filters.addFiltersFromArray(MessengerConfig.antispamCustomFilters);
		if (MessengerConfig.antispamWGFiltersEnabled) {
			filters.addFiltersFromArray(WGFilter.badWords);
		}
	}
	
	public function isSpam(message:String, playerUid:Number):Boolean {
		var duplicateCount:Number = 0;
		var playerCount:Number = 0;
		var currentTime:Number = this.getCurrentTime();
		
		/** turn off duplicateCounter */
		if (MessengerConfig.antispamDuplcateCount <= 0 || MessengerConfig.antispamDuplicateInterval <= 0){
			duplicateCount = -1;
		}
		
		/** turn off playerCounter */
		if (MessengerConfig.antispamPlayerCount <= 0 || MessengerConfig.antispamPlayerInterval <= 0) {
			playerCount = -1;
		}
		
		/** init cache for player */
		if (!this.cache[playerUid]) {
			this.cache[playerUid] = new Object();
		}
		
		for ( var i:String in this.cache[playerUid] ){
			var msgTime:Number = Utils.toInt(i);

			/** is messenge in time interval && msg match */
			if (duplicateCount >= 0 && msgTime > currentTime - MessengerConfig.antispamDuplicateInterval) {
				if(this.cache[playerUid][i] == message) {
					duplicateCount++;
				}
			}
			if (playerCount >= 0 && msgTime > currentTime - MessengerConfig.antispamPlayerInterval) {
				playerCount++;
			}
		}
		
		/** add message to cache */
		this.cache[playerUid][currentTime] = message;
		
		var isDuplicate:Boolean = (duplicateCount >= MessengerConfig.antispamDuplcateCount);
		if (isDuplicate) {
			//Logger.add("duplicity (" + duplicateCount + "): " + message);
		}
		if (playerCount >= MessengerConfig.antispamPlayerCount) {
			//Logger.add("spam: ("+playerCount + "): " + message);
		}
		return (isDuplicate || (playerCount >= MessengerConfig.antispamPlayerCount));
	}
	
	/**
	 * <font color='#80D63A'>message</font>
	 * @param	message
	 * @return	true when filter match
	 */
	public function isFilter(message:String):Boolean {
		if (this.filters.test(message)) {
			this.lastMatch = this.filters.lastMatch;
			return true;
		}
		return false;
	}

	/**
	 * Return UNIX time
	 * @return timestamp in secunds
	 */
	private function getCurrentTime():Number {
		var date:Date = new Date();
		
		return Math.round(date.getTime()/1000);
	}
}