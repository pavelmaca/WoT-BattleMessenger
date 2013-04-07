import mx.controls.streamingmedia.config.PlayerControls;
import wot.BattleMessenger.Antispam;
import wot.Minimap.dataTypes.Player;
import wot.Minimap.model.externalProxy.PlayersPanelProxy;
import wot.utils.Logger;
import wot.utils.Config;

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
		this.self = PlayersPanelProxy.getSelf();
		this.antispam = new Antispam();
	}
	
	
	
	/** overwrite*/
	function _onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer)
    {
		Logger.add("msg: " + message + "; himslef:" +himself.toString() + "; targetIsMe:" + targetIsCurrentPlayer.toString());
		super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
		return;
		
		if (himself || antispam.checkMessage(message)) {
			super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
		}
    }
	

}