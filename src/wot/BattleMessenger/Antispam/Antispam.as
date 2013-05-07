import wot.BattleMessenger.utils.Utils;
import wot.BattleMessenger.Config;
import wot.BattleMessenger.Antispam.Filters;
import wot.BattleMessenger.Antispam.WGFilterEU;
import wot.BattleMessenger.models.StatsDataProxy;
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
	
	public var lastSpam:Array = [];
			
	public function Antispam() 	{
		this.filters = new Filters();
		filters.addFiltersFromArray(Config.antispamCustomFilters);
		if (Config.antispamWGFiltersEnabled) {
			filters.addFiltersFromArray(WGFilterEU.badWords);
		}
	}
	
	public function isSpam(message:String, playerUid:Number):Boolean {
		var duplicateCount:Number = 0;
		var playerCount:Number = 0;
		var currentTime:Number = this.getCurrentTime();
		
		/** turn off duplicateCounter */
		if (Config.antispamDuplcateCount <= 0 || Config.antispamDuplicateInterval <= 0){
			duplicateCount = -1;
		}
		
		/** turn off playerCounter */
		if (Config.antispamPlayerCount <= 0 || Config.antispamPlayerInterval <= 0) {
			playerCount = -1;
		}
		
		/** init cache for player */
		if (!this.cache[playerUid]) {
			this.cache[playerUid] = new Object();
		}
		
		for ( var i:String in this.cache[playerUid] ){
			var msgTime:Number = Utils.toInt(i);

			/** is messenge in time interval && msg match */
			if (duplicateCount >= 0 && msgTime > currentTime - Config.antispamDuplicateInterval) {
				if(this.cache[playerUid][i] == message) {
					duplicateCount++;
				}
			}
			if (playerCount >= 0 && msgTime > currentTime - Config.antispamPlayerInterval) {
				playerCount++;
			}
		}
		
		/** add message to cache */
		this.cache[playerUid][currentTime] = message;
		
		var isDuplicate:Boolean = (duplicateCount >= Config.antispamDuplcateCount);
		if (isDuplicate) {
			this.lastSpam.push("Duplicate count: " + duplicateCount);
		}
		var isSpam = (playerCount >= Config.antispamPlayerCount);
		if (isSpam) {
			this.lastSpam.push("Spam count: " + playerCount);
		}
		
		return (isDuplicate || isSpam);
	}
	
	/**
	 * <font color='#80D63A'>message</font>
	 * @param	message
	 * @return	true when filter match
	 */
	public function isFilter(message:String):Boolean {
		if (this.filters.test(message)) {
			return true;
		}
		return false;
	}
	
	public function popLastFilter():String {
		return this.filters.popLastFilter();
	}
	
	public function popLastSpam():String {
		var ret = this.lastSpam.join("\n");
		this.lastSpam = [];
		return ret;
	}

	/**
	 * Return UNIX time
	 * @return timestamp in secunds
	 */
	private function getCurrentTime():Number {
		var date:Date = new Date();
		
		return Math.round(date.getTime()/1000);
	}
	
	public function createIgnoreList() {
		var players:Array = StatsDataProxy.getAllPlayers();

		for (var i in players) {
			/** Ignore usernames */
			this.filters.addIgnoredWord( players[i].userName + players[i].clanAbbrev);
			
			/** Ignore vehicle names */
			var splitedVehicle:Array = Filters.splitWords( players[i].vehicle );
			for (var z in splitedVehicle) {
				if(splitedVehicle[z].length > Filters.MIN_WORD_LENGTH){
					this.filters.addIgnoredWord( splitedVehicle[z] );
				}
			}
		}
	}
}