import wot.BattleMessenger.Antispam.Antispam;
import wot.BattleMessenger.MessengerConfig;
import wot.BattleMessenger.Antispam.WGFilter;
import wot.BattleMessenger.Antispam.Filters;
/**
 * ...
 * @author 
 */
class tests.TestAntispam extends Antispam
{
	public function TestAntispam() {
		this.filters = new Filters();
		this.filters.addFiltersFromArray([
			".*bad1", ".*bad2.*", "bad3.*", "ext.*ra1", ".*ext.*ra2", ".*ext.*ra3.*", "blov.*job", "siem.*", "czesc", "idiot.*"
		]);
	}
		
	public function test() {

		var msg:String;
		
		// TODO: ignore nick, clan tanks names in messege like:
		// Útočím na bobobobobobobob[NUKES] (T-70)!

	/**Test this:

		 */

        msg = "Ahmedcz";
		expect(msg, this.filters.removeHTML(msg), "Ahmedcz");

		msg = "<color='#80D63A'>Útočím na <font color=''>zkouška</font> zde</font>";
		expect(msg, this.filters.removeHTML(msg), "Útočím na  zde");

		msg = "<font color='#80D63A'>siema</font>";
		expect(msg, this.filters.test(msg), true);
		
		/** TODO IMG tag <img /> <img > */
		msg = "<font color='#80D63A'>Reloafing <img src='img.jpg'>siema</font>";
		expect(msg, this.filters.test(msg), true);

		// ".*bad1"
		msg = "split words bad1 nothing here";
		expect(msg, this.filters.test(msg), true);
		
		//replacements & case sensitivity
		msg = "B@dL";
		expect(msg, this.filters.test(msg), true);
		
		msg = "bad1, word";
		expect(msg, this.filters.test(msg), true);
		
		msg = "verybad1";
		expect(msg, this.filters.test(msg), true);
		
		msg = "bad1not";
		expect(msg, this.filters.test(msg), false);
		
		msg = "xBad1not";
		expect(msg, this.filters.test(msg), false);
		
		// ".*bad2"
		msg = "verybad2";
		expect(msg, this.filters.test(msg), true);
		
		msg = "bad2not";
		expect(msg, this.filters.test(msg), true);
		
		msg = "xBad2not";
		expect(msg, this.filters.test(msg), true);
		
		// ".*bad3"
		msg = "verybad3";
		expect(msg, this.filters.test(msg), false);

		msg = "bad3not";
		expect(msg, this.filters.test(msg), true);
		
		msg = "xBad3not";
		expect(msg, this.filters.test(msg), false);
		
		/// "ext.*ra1"
		msg = "extra1";
		expect(msg, this.filters.test(msg), true);
		
		msg = "ext0ra100ra1";
		expect(msg, this.filters.test(msg), true);
		
		msg = "notext0ra100ra1";
		expect(msg, this.filters.test(msg), false);
		
		msg = "ext0ra100ra1fff";
		expect(msg, this.filters.test(msg), false);
		
		/// ".*ext.*ra2"
		msg = "extra2";
		expect(msg, this.filters.test(msg), true);
		
		msg = "superextra2";
		expect(msg, this.filters.test(msg), true);
		
		msg = "superextttttra2";
		expect(msg, this.filters.test(msg), true);
		
		msg = "superextra23";
		expect(msg, this.filters.test(msg), false);
		
		/// ".*ext.*ra3.*"
		msg = "extra3";
		expect(msg, this.filters.test(msg), true);
		
		msg = "superextra3";
		expect(msg, this.filters.test(msg), true);
		
		msg = "superextra355";
		expect(msg, this.filters.test(msg), true);
		
		//"blov.*job"
		msg = "blovvnjob";
		expect(msg, this.filters.test(msg), true);
		
		msg = "ablovjobs";
		expect(msg, this.filters.test(msg), false);
	
	}
	
	private function expect(input, res, expect) {
		trace("expect: " + input + " = " + (res == expect));
	}
}