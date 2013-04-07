import mx.data.kinds.Data;
import wot.Minimap.dataTypes.Player;
import wot.utils.Config;

/**
 * ...
 * @author 
 */
class wot.BattleMessenger.Antispam
{
	/**
	 * {
	 * 	uid: { time:
		 * 
	 * 		}
	 * }
	 */
	private static var data = { };
	
	var config:Object;
	
	public function Antispam() 
	{
		this.config = Config.s_config.battleMessanger;
	}
	
	public function checkMessage(message:String):Boolean {
		if (config.enable) {
			var player:Player = getPlayer(message);
			
			
			var lastMsg = data[player.uid];
			var date:Date = new Data();
			
			if (lastMsg.text == message) {
				if(lastMsg.time + config.interval >=  date.
			}
			if (config.interval > 0) {
				
			}
			player.uid
			
		}
		return true;
	}
	
	
	private getPLayer(message:String):Player {
		return null;
	}
	
	
}