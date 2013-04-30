import wot.BattleMessenger.Antispam.Antispam;
import wot.BattleMessenger.models.Player;
import wot.BattleMessenger.models.PlayersPanelProxy;
import wot.BattleMessenger.MessengerConfig;
import wot.BattleMessenger.Utils;
import wot.BattleMessenger.GlobalEventDispatcher;
import com.xvm.Logger;

class wot.BattleMessenger.BattleMessenger extends net.wargaming.messenger.BattleMessenger
{
	var self:Player;
	var antispam:Antispam;
		
	public function BattleMessenger() 
	{
		super();
		
		GlobalEventDispatcher.addEventListener("BM_config_loaded", this, onConfigLoaded);
		MessengerConfig.loadConfig();
	}
	
	private function onConfigLoaded() {
		
		Logger.add('BM config loaded');
		
		GlobalEventDispatcher.removeEventListener("BM_config_loaded", this, onConfigLoaded);
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
		
		var log:Object = {
			d_msg: message
		};
		
		
		/** ignore own msg (not in debug mode)*/
		if (MessengerConfig.enabled && (!himself || MessengerConfig.debugMode)) {
			if(!this.self) this.self = PlayersPanelProxy.getSelf();
			var player:Player;
			
			/** 
			 * split message in two parts 
			 * [0]: player name, clan, vehicle 
			 * [1]: content
			 */
			var msgParts:Array = message.split(":&nbsp;</font><font ", 2);
			if (msgParts.length == 2) {
				player = this.getPlayerFromMessage(msgParts[0]);
			}
		
			if(player && this.self){
				var isClan:Boolean = false;
				if (MessengerConfig.ignoreClan && this.self.clanAbbrev.length > 0) 
					isClan = (player.clanAbbrev == this.self.clanAbbrev);
					
				var isSquad:Boolean = false;
				if (MessengerConfig.ignoreSquad && self.squad != 0)
					isSquad = (player.squad == this.self.squad);
					
				log.d_isSquad = isSquad;
				log.d_isClan = isClan;
					
				/** ignore clan/squad */
				if (!isClan && !isSquad) {
					var isDead:Boolean = PlayersPanelProxy.isDead(player.uid);
					log.d_isDead = isDead;
					
					/** block dead/alive */
					if (player.team == self.team) {
						sendMsg = !(isDead ? MessengerConfig.blockAllyDead : MessengerConfig.blockAllyAlive);
					}else {
						sendMsg = !(isDead ? MessengerConfig.blockEnemyDead : MessengerConfig.blockEnemyAlive);
					}
					
					log.d_ally = (player.team == self.team);
					
					/** antispam #TODO: remove HTML from message*/
					if (sendMsg && MessengerConfig.antispamEnabled) {
						sendMsg = !this.antispam.isSpam(msgParts[1], player.uid);
						
						/** filters */
						if (sendMsg) {
							
							var start:Date = new Date();
							sendMsg = !this.antispam.isFilter(msgParts[1]);
							var end:Date = new Date();
							if(!sendMsg) {
								message += "\n" + this.antispam.lastMatch;
								log.d_filter = this.antispam.lastMatch;
								this.antispam.lastMatch = null;
							}
							log.d_took = (end.getTime() - start.getTime());
							
						}
					}
				}
			}
		}
		
		Logger.addObject(log, "[BattleMessanger]");
		
				
		if (sendMsg || MessengerConfig.debugMode) {	
			if (!sendMsg && MessengerConfig.debugMode) {
				message = "<font color='#CC0099'>deleted: </font>" + message;
			}
			super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
		}
    }
	
	/** <font color='#FFC697'>UserName[clan] (vehicle)&nbsp;:&nbsp;</font><font color='#80D63A'>message</font> */
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