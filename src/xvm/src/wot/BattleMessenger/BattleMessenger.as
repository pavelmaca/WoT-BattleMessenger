import wot.BattleMessenger.Antispam;
import wot.BattleMessenger.Player;
import wot.BattleMessenger.PlayersPanelProxy;
import wot.BattleMessenger.MessengerConfig;
import wot.utils.Logger;

/**
 * ...
 * @author 
 */
class wot.BattleMessenger.BattleMessenger extends net.wargaming.messenger.BattleMessenger
{
	var self:Player;
	var antispam:Antispam;
	
	public function BattleMessenger() 
	{
		super();
		
		if (MessengerConfig.enabled) {
			/** max chat lenght*/ //#TODO: not working
			//this.messageList.stackLength(MessengerConfig.chatLenght);

			this.antispam = new Antispam();
		}
	}
	
	/** overwrite*/
	function _onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer)
    {
		Logger.add("msg: " + message);
		if (!this.self) {
			this.self = PlayersPanelProxy.getSelf();
		}
		//Logger.addObject(this.self);
		
		var sendMsg:Boolean = true;
		
		
		//Logger.add("me: "+himself +"; debug: "+ MessengerConfig.debugMode + "; enabled: " +MessengerConfig.enabled);
		//Logger.add("result: "+ ((!himself || MessengerConfig.debugMode) && MessengerConfig.enabled));
		
		/** ignore own msg (not in debug mode)*/
		if ((!himself || MessengerConfig.debugMode) && MessengerConfig.enabled) {
			var player:Player = this.getPlayerFromMessage(message);
			//Logger.addObject(player);
			
			if(player){
				var isClan:Boolean = false;
				if (MessengerConfig.ignoreClan && this.self.clanAbbrev.length > 0) 
					isClan = (player.clanAbbrev == this.self.clanAbbrev);
					
				var isSquad:Boolean = false;
				if (MessengerConfig.ignoreSquad && self.squad != 0)
					isSquad = (player.squad == this.self.squad);
					
				/** ignore clan/squad */
				if (!isClan || !isSquad) {
					var isDead:Boolean = PlayersPanelProxy.isDead(player.uid);
					//Logger.add("dead: " + isDead);
					
					/** block dead/alive */
					if (player.team == self.team) {
						sendMsg = !(isDead ? MessengerConfig.blockAllyDead : MessengerConfig.blockAllyAlive);
					}else {
						sendMsg = !(isDead ? MessengerConfig.blockEnemyDead : MessengerConfig.blockEnemyAlive);
					}
					
					/** antispam */
					if (sendMsg && MessengerConfig.antispamEnabled) {
						sendMsg = !this.antispam.isSpam(message, player.uid);
						//Logger.add("spam: " + !sendMsg);
						
						/** filters */
						if (sendMsg) {
							sendMsg = !this.antispam.isFilter(message);
							//Logger.add("filter: " + !sendMsg);
						}
					}
				}
			}else Logger.add("[BattleMessenger] player not found");
		}
				
		if (sendMsg || MessengerConfig.debugMode) {
			if (!sendMsg && MessengerConfig.debugMode) {
				message = "<font color='#FF0000'>deleted: </font>" + message;
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
		var clanIndex:Number = userName.indexOf("[");
		if (clanIndex >= 0) {
			userName = userName.substr(0, clanIndex);
		}
		
		return PlayersPanelProxy.getPlayerInfoByName(userName);
	}
	
	

}