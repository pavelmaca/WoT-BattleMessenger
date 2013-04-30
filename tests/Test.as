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
		try{
			antispam.test();
		}catch (ex) {
			trace(ex);
		}
    }
}