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
		if (MessengerConfig.antispamDuplcateCount <= 0 && MessengerConfig.antispamDuplicateInterval <= 0) {
			return false;
		}
		
		/** timestamp in milisecunds */
		var currentTime:Number = this.getCurrentTime();
		
		//Logger.add("time: "+currentTime);

		if (!this.cache[playerUid]) {
			this.cache[playerUid] = new Object();
			//Logger.add("creating cache: " + playerUid);
		}
				
		var duplicateCount:Number = 0;
		var playerCount:Number = 0;
		for ( var i:String in this.cache[playerUid]) {
			var time:Number = Utils.toInt(i);
			//Logger.add("msg-time: " + time);

			/** is messenge in time interval && msg match */
			if (time > currentTime - MessengerConfig.antispamDuplicateInterval) {
				if(this.cache[playerUid][i] == message) {
					duplicateCount++;
				}
			}
			if (time > currentTime - MessengerConfig.antispamPlayerInterval) {
				playerCount++;
			}
			
		}
		
		/** add message to cache */
		this.cache[playerUid][currentTime] = message;
		
		//Logger.add("duplicateCount: " + duplicateCount );
		//Logger.add("playerCount: " + playerCount);
		
		var isSpam:Boolean = (duplicateCount >= MessengerConfig.antispamDuplcateCount);
		return (isSpam || (playerCount >= MessengerConfig.antispamPlayerCount));
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
	 * @return timestamp
	 */
	private function getCurrentTime():Number {
		var date:Date = new Date();
		
		return Math.round(date.getTime()/1000);
	}
}