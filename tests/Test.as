import wot.BattleMessenger.BattleMessenger
import tests.TestAntispam;
/**
 * ...
 * @author Pavel Máca
 */
class tests.Test extends MovieClip
{
    public static function main(target:MovieClip):Void
    {
        target.__proto__ = Test.prototype;
        target.init();
    }

    private function init():Void
    {
		var antispam:TestAntispam = new TestAntispam();
		try {
            var msg = "<font color='#80D63A'>DonRocko1939 (KV-1S)&nbsp;:&nbsp;</font><font color='#80D63A'>Angriff!</font>";
            var msg2 = "<font color='#80D63A'>DonRocko1939 (KV-1S)&nbsp;: </font><font color='#80D63A'>Angriff!</font>";
            
          
            if (msg.indexOf('&nbsp;: ') >= 0) {
                trace('ok');
            }else {
                trace('bad');
            }
			//antispam.test();
		}catch (ex) {
			trace(ex);
		}
    }
}