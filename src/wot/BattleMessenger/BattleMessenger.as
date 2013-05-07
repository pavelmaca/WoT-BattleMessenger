import wot.BattleMessenger.Handler;
import wot.BattleMessenger.Config;
import com.xvm.Logger;

/**
 * BattleMessenger.swf extension
 * @author Assassik
 */
class wot.BattleMessenger.BattleMessenger extends net.wargaming.messenger.BattleMessenger
{	
	private var _bm_handler:Handler;
	
	public function BattleMessenger() 
	{
		super();
		_bm_handler = new Handler(this);

	}
	
	/** overwrire */
	function _onPopulateUI()
    {
		super._onPopulateUI.apply(this, arguments);
		
		_bm_handler.onGuiInit();
	}
	
	/** overwrite */
	function _onRecieveChannelMessage(cid:Number, message:String, himself:Boolean, targetIsCurrentPlayer:Boolean)
    {
		//var timer:Number = getTimer();
		var displayMsg:Boolean = (Config.enabled ? _bm_handler.getDisplayStatus(message, himself) : true);
		//Logger.add("timer: " +(getTimer() - timer));
		
		/** Edit message for debug mode */
		if (Config.enabled && Config.debugMode) {
			var log:Object = { 
				msg: message,
				display: displayMsg
			};
			
			if(!displayMsg){
				message = "<font color='" + Handler.DEBUG_COLOR + "'>Hidden: </font>" + message;
			}
			/** add reason, can be also "ignored for xx" */
			var reason:String = _bm_handler.popReason();
			if (reason != null) {
				message += "\n<font color='" + Handler.DEBUG_COLOR + "'>" + reason + "</font>";
				
				log.reason = reason;
				Logger.addObject(log, "[BattleMessenger]");
			}
		}
		
		/** Send message to render */
		if (displayMsg || (Config.enabled && Config.debugMode)) {	
			super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
		}
    }
	
	/** 
	 * FIXIT: find better sulation how send extra messages without creating loop on "_onRecieveChannelMessage" 
	 * Send extra info messages, only in debug mude
	 */
	public function _bm_sendExtraMessage(text:String, ignoreDebugMode:Boolean):Void {
		if (Config.enabled && (Config.debugMode || ignoreDebugMode) && text.length > 0) {
			Logger.add("[BattleMessenger] " + text);
			super._onRecieveChannelMessage(null, "<font color='" + Handler.DEBUG_COLOR + "'>" + text + "</font>", true, false);
		}
	}
}