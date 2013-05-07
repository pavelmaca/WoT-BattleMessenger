import wot.BattleMessenger.Antispam.Antispam;
import wot.BattleMessenger.BattleMessenger;
import wot.BattleMessenger.models.Player;
import wot.BattleMessenger.models.StatsDataProxy;
import wot.BattleMessenger.Config;
import wot.BattleMessenger.utils.Utils;
import wot.BattleMessenger.utils.GlobalEventDispatcher;
import com.xvm.StatData;
//import com.xvm.Utils; used for accesing StatData
//import com.xvm.Defines; for testing xvm data state
//import com.xvm.Logger;

/**
 * Main mod class
 * @author Assassik
 */
class wot.BattleMessenger.Worker
{
	// Color of debug messages
	public static var DEBUG_COLOR:String = "#FF3362";
	
	private var battleType:String;
	
	private var battleMessenger:BattleMessenger;
	
	// Store own identity
	private var self:Player;
	
	private var antispam:Antispam;
	
	private var lastReason:String = null;
	
	public function Worker(bm:BattleMessenger) 
	{
		this.battleMessenger = bm;
		
		GlobalEventDispatcher.addEventListener(Config.EVENT_CONFIG_LOADED, this, onConfigLoaded);
		Config.loadConfig();
	}
	
	/** config loaded callback */
	private function onConfigLoaded() {
		GlobalEventDispatcher.removeEventListener(Config.EVENT_CONFIG_LOADED, this, onConfigLoaded);
		this.antispam = new Antispam();
	}
	
	public function onGuiInit() {
		/** in case of gui will be faster then config loader */
		if (!Config.isLoaded()) {
			GlobalEventDispatcher.addEventListener(Config.EVENT_CONFIG_LOADED, this, onGuiInit);
			return;
		}else {
			GlobalEventDispatcher.removeEventListener(Config.EVENT_CONFIG_LOADED, this, onGuiInit);
		}
		
		/** Warn on missing or corrupt config file */
		if (Config.error != null) {
			this.sendDebugMessage(Config.error, true);
		}else {
			this.sendDebugMessage("Config loaded");
		}
		
		if(Config.enabled){
			/**
			 * this.messageList = child of net.wargaming.notification.FadingMessageList
			 * this.messageList.stackLength not working, need _stackLength
			 */
			battleMessenger.messageList._stackLength = Config.chatLength;
			
			this.self = StatsDataProxy.getSelf();
			if (!this.self) {
				this.sendDebugMessage("Error: can't found own identity");
			}
			
			/** Ignore player and vehicle names */
			this.antispam.createIgnoreList();
			
			/** Get battle type */
			battleType = StatsDataProxy.getBattleType();
			
			/** Debug mode info */
			this.sendDebugMessage("Debug mode active, " + battleType + " battle");
		}
	}
	
	public function getDisplayStatus(message:String, himself:Boolean):Boolean {
		/** ignore own msg (not in debug mode)*/
		if (!this.self || (himself && !Config.debugMode)) {
			return true;
		}
		
		/** sender */
		var sender:Player;
			
		/** 
		 * split message in two parts 
		 * [0]: player name, clan, vehicle 
		 * [1]: content
		 */
		var msgParts:Array = message.split("&nbsp;:&nbsp;</font>", 2);
		if (msgParts.length == 2) {
			sender = this.getPlayerFromMessage(msgParts[0]);
		}
		
		if (!sender) {
			this.sendDebugMessage("Error: can't parse sender identity");
			return true; //error
		}
		
		/** Ignore */
		if ( ignoreForClan(sender) && !himself ) {
			this.lastReason = "Ignore: own clan";
			return true;
		}
		if ( ignoreForSquad(sender) && !himself) {
			this.lastReason = "Ignore: own squad";
			return true;
		}
		
		/** Ignore by battle type, skip self */
		if (isSameTeam(sender) && !himself) {
			switch(battleType) {
				case StatsDataProxy.BATTLE_RANDOM:
					if (Config.ignoreRandomBattle) {
						this.lastReason = "Ignore: ally in Random battle";
						return true;
					} break;
				case StatsDataProxy.BATTLE_COMPANY: 
					if (Config.ignoreCompanyBattle) {
						this.lastReason = "Ignore: ally in Company battle";
						return true;
					} break;
				case StatsDataProxy.BATTLE_SPECIAL: 
					if (Config.ignoreSpecialBattle) {
						this.lastReason = "Ignore: ally in Special battle";
						return true;
					} break;
				case StatsDataProxy.BATTLE_TRAINING: 
					if (Config.ignoreTrainingBattle) {
						this.lastReason = "Ignore: ally in Training battle";
						return true;
					} break;
			}
		}

		/** XVM */
		if (Config.xvmEnabled && !isXvmRatingHigher(sender) ) return false;
		
		/** Dead/Alive */
		if ( isTeamStatusBlock(sender) ) return false;
		
		/** Antispam */
		if (Config.antispamEnabled) {
			/** Spam */
			if (this.antispam.isSpam(msgParts[1], sender.uid)) {
				lastReason = this.antispam.popLastSpam();
				return false;
			}
			
			/** Filters */
			if (this.antispam.isFilter(msgParts[1])) {
				lastReason = this.antispam.popLastFilter();
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * @return	null on empty reason
	 */
	public function popReason():String {
		var ret = this.lastReason;;
		this.lastReason = null;
		return ret;
	}
	
	private function sendDebugMessage(text:String, ignoreDebugMode:Boolean) {
		battleMessenger._bm_sendExtraMessage(text, ignoreDebugMode);
	}
		
	/** <font color='#FFC697'>UserName[clan] (vehicle) */
	private function getPlayerFromMessage(message:String):Player {
		
		var endOfFirtsTag:Number = message.indexOf(">");
        var messageWitOutFirstTag:String = message.substr(endOfFirtsTag + 1, message.length - endOfFirtsTag);
        var endOfUsername:Number = messageWitOutFirstTag.indexOf(" ");
       		
		var userName:String = messageWitOutFirstTag.substr(0, endOfUsername);
		
		/** remove clan tag */
		userName = Utils.GetPlayerName(userName);
		
		return StatsDataProxy.getPlayerByName(userName);
	}
	
	/**
	 * @param	player
	 * @return	true when player is from same clan, always false on own messages
	 */
	private function ignoreForClan(player:Player):Boolean {
		if (Config.ignoreClan && this.self.clanAbbrev.length > 0) {
			return (player.clanAbbrev == this.self.clanAbbrev);
		}
		return false;
	}
	
	/**
	 * @param	player
	 * @return	true when player is from same squad, always false on own messages
	 */
	private function ignoreForSquad(player:Player):Boolean {
		if (Config.ignoreSquad && self.squad != 0) {
			return (player.squad == this.self.squad);
		}
		return false;
	}
	
	/**
	 * XVM 4.0 or higher, with xvm-stats requered 
	 * @param	player
	 * @return
	 */
	private function isXvmRatingHigher(player:Player):Boolean {
		if (com.xvm.StatData == undefined) {
			this.sendDebugMessage("XVM is not present");
			return true;
		}
		
		var xvmKey:String = com.xvm.Utils.GetNormalizedPlayerName(player.userName);
		/** check if data are presend */
		if (Config.xvmEnabled && StatData.s_data[xvmKey]) {
			/** stats must be loaded */
			if (StatData.s_data[xvmKey].loadstate == com.xvm.Defines.LOADSTATE_DONE) {
				if (StatData.s_data[xvmKey].stat.wn < Config.xvmMinRating) {
					this.lastReason = "XVM rating: " + StatData.s_data[xvmKey].stat.wn;
					return false;
				}
			}else {
				this.sendDebugMessage("XVM data not loaded");
			}
		}else if (Config.xvmEnabled) {
			this.sendDebugMessage("XVM data not found: " + xvmKey);
		}
		return true;
	}
	
	/**
	 * Check player team and alive status against config
	 * @param	player
	 * @return	true for hide msg, false for display
	 */
	private function isTeamStatusBlock(player:Player):Boolean {
		var isDead:Boolean = StatsDataProxy.isPlayerDead(player.uid);
		
		var hide:Boolean;
		if (isSameTeam(player)) {
			hide = (isDead ? Config.blockAllyDead : Config.blockAllyAlive);
		}else {
			hide = (isDead ? Config.blockEnemyDead : Config.blockEnemyAlive);
		}
		
		if (hide) {
			lastReason = (isSameTeam(player) ? "Ally" : "Enemy") + " - " + (isDead ? "dead" : "alive");
		}
		return hide;
	}
	
	private function isSameTeam(player:Player):Boolean {
		return (self.team == player.team);
	}
	
}