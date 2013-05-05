import wot.BattleMessenger.Antispam.Antispam;
import wot.BattleMessenger.BattleMessenger;
import wot.BattleMessenger.models.Player;
import wot.BattleMessenger.models.PlayersPanelProxy;
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
	public static var DEBUG_COLOR = "#FF3362";
	public static var MSG_DEBUG_FLAG = "bm_debug_message";
	public static var MSG_ERROR_FLAG = "bm_error_message";
	
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
		if(Config.enabled){
			/**
			 * this.messageList = child of net.wargaming.notification.FadingMessageList
			 * this.messageList.stackLength not working, need _stackLength
			 */
			battleMessenger.messageList._stackLength = Config.chatLength;
			
			/** Warn on missing or corrupt config file */
			if (Config.error != null) {
				this.sendDebugMessage(Config.error, true);
			}else {
				this.sendDebugMessage("Config loaded");
			}
			
			/** Debug mode info */
			this.sendDebugMessage("Debug mode active");
		}
	}
	
	public function getDisplayStatus(message:String, himself:Boolean):Boolean {
		/** ignore own msg (not in debug mode)*/
		if (!Config.enabled && (himself || !Config.debugMode)) {
			return true;
		}
		
		/** Load own identity on first message */
		if (!this.self && !(this.self = PlayersPanelProxy.getSelf())) {
			this.sendDebugMessage("Error: can't found own identity");
			return true; //error
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
		if ( ignoreForClan(sender) ) {
			this.lastReason = "Ignore: clan - " + sender.clanAbbrev;
			return true;
		}
		if ( ignoreForSquad(sender) ) {
			this.lastReason = "Ignore: squad - " + sender.squad;
			return true;
		}
		//if ( ignoreForCompanny(sender) ) return true;
		//if ( ignoreForSpecial(sender) ) return true;
		//if ( ignoreForTraining(sender) ) return true;
		
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
		
		return PlayersPanelProxy.getPlayerInfoByName(userName);
	}
	
	/**
	 * @param	player
	 * @return	true when player is from same clan, always false on own messages
	 */
	private function ignoreForClan(player:Player):Boolean {
		if (Config.ignoreClan && this.self.clanAbbrev.length > 0 && player.uid != this.self.uid) {
			return (player.clanAbbrev == this.self.clanAbbrev);
		}
		return false;
	}
	
	/**
	 * @param	player
	 * @return	true when player is from same squad, always false on own messages
	 */
	private function ignoreForSquad(player:Player):Boolean {
		if (Config.ignoreSquad && self.squad != 0 && player.uid != this.self.uid) {
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
					return true;
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
		var isDead:Boolean = PlayersPanelProxy.isDead(player.uid);
		
		var hide:Boolean;
		if (player.team == self.team) {
			hide = (isDead ? Config.blockAllyDead : Config.blockAllyAlive);
		}else {
			hide = (isDead ? Config.blockEnemyDead : Config.blockEnemyAlive);
		}
		
		if (hide) {
			lastReason = (player.team == self.team ? "Ally" : "Enemy") + " - " + (isDead ? "dead" : "alive");
		}
		return hide;
	}
	
}