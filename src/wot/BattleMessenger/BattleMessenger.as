import wot.BattleMessenger.Antispam.Antispam;
import wot.BattleMessenger.models.Player;
import wot.BattleMessenger.models.PlayersPanelProxy;
import wot.BattleMessenger.MessengerConfig;
import wot.BattleMessenger.utils.Utils;
import wot.BattleMessenger.utils.GlobalEventDispatcher;
import com.xvm.StatData;
//import com.xvm.Utils; used for accesing StatData
//import com.xvm.Defines; for testing xvm data state
import com.xvm.Logger;

class wot.BattleMessenger.BattleMessenger extends net.wargaming.messenger.BattleMessenger
{
	var self:Player;
	var antispam:Antispam;
		
	public function BattleMessenger() 
	{
		super();
		
		GlobalEventDispatcher.addEventListener("config_loaded", this, onConfigLoaded);
		MessengerConfig.loadConfig();
	}
	
	private function onConfigLoaded() {
		GlobalEventDispatcher.removeEventListener("config_loaded", this, onConfigLoaded);
		this.antispam = new Antispam();
	}
	
	/** overwrire */
	function _onPopulateUI()
    {
		super._onPopulateUI.apply(this, arguments);
		
		if(MessengerConfig.enabled){
			/**
			 * this.messageList = child of net.wargaming.notification.FadingMessageList
			 * this.messageList.stackLength not working, need _stackLength
			 */
			this.messageList._stackLength = MessengerConfig.chatLength;
		}
	}
	
	/** overwrite */
	function _onRecieveChannelMessage(cid, message:String, himself:Boolean, targetIsCurrentPlayer)
    {		
		var sendMsg:Boolean = true;
		
		var log:Object; 
		
		/** ignore own msg (not in debug mode)*/
		if (MessengerConfig.enabled && (!himself || MessengerConfig.debugMode)) {
			if(!this.self) this.self = PlayersPanelProxy.getSelf();
			var player:Player;
			
			log = {	d_message: message };
			
			/** 
			 * split message in two parts 
			 * [0]: player name, clan, vehicle 
			 * [1]: content
			 */
			var msgParts:Array = message.split("&nbsp;:&nbsp;</font>", 2);
			if (msgParts.length == 2) {
				player = this.getPlayerFromMessage(msgParts[0]);
			}
		
			if (player && this.self) {
				var isClan:Boolean = false;
				if (MessengerConfig.ignoreClan && this.self.clanAbbrev.length > 0) 
					isClan = (player.clanAbbrev == this.self.clanAbbrev);
				log.d_isClan = isClan;
					
				var isSquad:Boolean = false;
				if (MessengerConfig.ignoreSquad && self.squad != 0)
					isSquad = (player.squad == this.self.squad);
				log.d_isSquad = isSquad;
					
				/** ignore clan/squad */
				if (!isClan && !isSquad) {
					var xvmKey:String = com.xvm.Utils.GetNormalizedPlayerName(player.userName);
					/** check if data are presend */
					if (MessengerConfig.xvmEnabled && StatData.s_data[xvmKey]) {
						/** stats must be loaded */
						if (StatData.s_data[xvmKey].loadstate == com.xvm.Defines.LOADSTATE_DONE) {
							sendMsg = (MessengerConfig.xvmMinRating >= StatData.s_data[xvmKey].stat.wn);
							log.d_xvm = StatData.s_data[xvmKey].stat.wn;
						}
					}
					
					if(sendMsg){
						var isDead:Boolean = PlayersPanelProxy.isDead(player.uid);
						log.d_isDead = isDead;
						
						/** block dead/alive */
						if (player.team == self.team) {
							sendMsg = !(isDead ? MessengerConfig.blockAllyDead : MessengerConfig.blockAllyAlive);
						}else {
							sendMsg = !(isDead ? MessengerConfig.blockEnemyDead : MessengerConfig.blockEnemyAlive);
						}
						log.d_ally = (player.team == self.team);
					}
					
					/** antispam */
					if (sendMsg && MessengerConfig.antispamEnabled) {
						sendMsg = !this.antispam.isSpam(msgParts[1], player.uid);
						log.d_spam = !sendMsg;
						
						/** filters */
						if (sendMsg) {
							sendMsg = !this.antispam.isFilter(msgParts[1]);
							if (!sendMsg && MessengerConfig.debugMode) {
								var lastFilter = this.antispam.popLastFilter();
								message += "\n<font color='#CC0099'>filter: <b>" + lastFilter + "</b></font>\n";
								log.d_filter = lastFilter;
							}
						}
					}
				}
			}
		}
		
		if (MessengerConfig.debugMode) {
			log.d_result = !sendMsg;
			Logger.addObject(log, "[BattleMessanger]");
		}		
		
		if (sendMsg || MessengerConfig.debugMode) {	
			if (!sendMsg && MessengerConfig.debugMode) {
				message = "<font color='#CC0099'>deleted: </font>" + message;
			}
			super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
		}
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
}