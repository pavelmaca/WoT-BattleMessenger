import wot.utils.Utils;
import wot.BattleMessenger.MessengerConfig;
//import wot.utils.Logger;

/**
 * ...
 * @author 
 */
class wot.BattleMessenger.Antispam
{
	/**
	 * {
	 * 	playerUid:
	 *		[time1: msg1],
	 * 		[time2: msg2]
	 * }
	 */
	private var cache:Object = new Object();
		
	public function Antispam() 	{
		
	}
	
	
	public function isSpam(message:String, playerUid:Number):Boolean {
		var duplicateCount:Number = 0;
		var playerCount:Number = 0;
		
		/** turn off duplicateCount */
		if (MessengerConfig.antispamDuplcateCount <= 0 || MessengerConfig.antispamDuplicateInterval <= 0) {
			 duplicateCount = -1;
		}
		
		/** turn off playerCount */
		if (MessengerConfig.antispamPlayerCount <= 0 || MessengerConfig.antispamPlayerInterval <= 0) {
			 playerCount = -1;
		}
		
		var currentTime:Number = this.getCurrentTime();
		
		if (!this.cache[playerUid]) {
			this.cache[playerUid] = new Object();
		}
				
		
		
		for ( var i:String in this.cache[playerUid]) {
			var time:Number = Utils.toInt(i);

			/** is messenge in time interval && msg match */
			if (duplicateCount >= 0 && time > currentTime - MessengerConfig.antispamDuplicateInterval) {
				if(this.cache[playerUid][i] == message) {
					duplicateCount++;
				}
			}
			if (playerCount >= 0 && time > currentTime - MessengerConfig.antispamPlayerInterval) {
				playerCount++;
			}
			
		}
		
		/** add message to cache */
		this.cache[playerUid][currentTime] = message;
		
		var isDuplicate:Boolean = (duplicateCount >= MessengerConfig.antispamDuplcateCount);
		return (isDuplicate || (playerCount >= MessengerConfig.antispamPlayerCount));
	}
	
	public function isFilter(message:String):Boolean {
		for (var i in MessengerConfig.antispamFilters) {
			if ( message.indexOf(MessengerConfig.antispamFilters[i]) >= 0) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 
	 * @return timestamp in secunds
	 */
	private function getCurrentTime():Number {
		var date:Date = new Date();
		
		return Math.round(date.getTime()/1000);
	}
}