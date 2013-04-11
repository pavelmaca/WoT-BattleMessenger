import gfx.core.UIComponent;
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
			//Logger.addObject(this.messageList, "BattleMessageList");
			this.messageList.stackLength = MessengerConfig.chatLenght;

			this.antispam = new Antispam();
		}
	}
	
	/** overvrire */
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
	
	/** overwrite*/
	function _onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer)
    {
		//Logger.add("msg: " + message);
		if (!this.self) {
			this.self = PlayersPanelProxy.getSelf();
		}
		
		var sendMsg:Boolean = true;
		
		/** ignore own msg (not in debug mode)*/
		if ((!himself || MessengerConfig.debugMode) && MessengerConfig.enabled) {
			var player:Player;
			
			var msgParts:Array = message.split(":&nbsp;</font><font ", 2);
			if (msgParts.length == 2) {
				player = this.getPlayerFromMessage(msgParts[0]);
			}
			
			Logger.addObject(msgParts);
			
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
					
					/** block dead/alive */
					if (player.team == self.team) {
						sendMsg = !(isDead ? MessengerConfig.blockAllyDead : MessengerConfig.blockAllyAlive);
					}else {
						sendMsg = !(isDead ? MessengerConfig.blockEnemyDead : MessengerConfig.blockEnemyAlive);
					}
					
					/** antispam #TODO: remove HTML from message*/
					if (sendMsg && MessengerConfig.antispamEnabled) {
						sendMsg = !this.antispam.isSpam(msgParts[1], player.uid);
						//Logger.add("spam: " + !sendMsg);
						
						/** filters */
						if (sendMsg) {
							sendMsg = !this.antispam.isFilter(msgParts[1]);
							//Logger.add("filter: " + !sendMsg);
						}
					}
				}
			}else Logger.add("[BattleMessenger] player not found");
		}
				
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
		var clanIndex:Number = userName.indexOf("[");
		if (clanIndex >= 0) {
			userName = userName.substr(0, clanIndex);
		}
		
		return PlayersPanelProxy.getPlayerInfoByName(userName);
	}
	
	

}