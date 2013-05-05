import wot.BattleMessenger.Worker;
import wot.BattleMessenger.Config;
import com.xvm.Logger;

class wot.BattleMessenger.BattleMessenger extends net.wargaming.messenger.BattleMessenger
{	
	private var _bm_worker:Worker;
	
	public function BattleMessenger() 
	{
		super();
		_bm_worker = new Worker(this);

	}
	
	/** overwrire */
	function _onPopulateUI()
    {
		super._onPopulateUI.apply(this, arguments);
		_bm_worker.onGuiInit();
	}
	
	/** overwrite */
	function _onRecieveChannelMessage(cid:Number, message:String, himself:Boolean, targetIsCurrentPlayer:Boolean)
    {
		var displayMsg:Boolean = _bm_worker.getDisplayStatus(message);
		
		/** Edit message for debug mode */
		if (Config.debugMode) {
			if(!displayMsg){
				message = "<font color='" + Worker.DEBUG_COLOR + "'>Hidden: </font>" + message;
			}
			/** add reason, can be also "ignored for xx" */
			var reason:String = _bm_worker.popReason();
			if(reason != null){
				message += "\n<font color='" + Worker.DEBUG_COLOR + "'>" + reason + "</font>";
			}
		}
		
		/** Send message to render */
		if (displayMsg || Config.debugMode) {	
			super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
		}
    }
	
	/** 
	 * FIXIT: find better sulation how send extra messages without creating loop on "_onRecieveChannelMessage" 
	 * Send extra info messages, only in debug mude
	 */
	public function _bm_sendExtraMessage(text:String, ignoreDebugMode:Boolean) {
		if ((Config.debugMode || ignoreDebugMode) && text.length > 0) {
			Logger.add("[BattleMessenger] " + text);
			super._onRecieveChannelMessage(null, "<font color='" + Worker.DEBUG_COLOR + "'>" + text + "</font>", true, false);
		}
	}
}