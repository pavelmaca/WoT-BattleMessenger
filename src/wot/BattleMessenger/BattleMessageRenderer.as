import wot.BattleMessenger.Config;

/**
 * @author Assassik
 */
class wot.BattleMessenger.BattleMessageRenderer extends net.wargaming.messenger.controls.BattleMessageRenderer
{
	/** overwrite */
	function populateData(initData)
    {
		super.populateData.apply(this, arguments);
		
		this.background._alpha = Config.backgroundAlpha;
    }	
}