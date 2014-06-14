intrinsic dynamic class net.wargaming.controls.TextInput extends gfx.controls.TextInput
{
	public var _extractEscapes : Boolean;
	public var addEventListener;
	public var textField;

	public function get extractEscapes ();
	public function set extractEscapes (value) : Void;

	public function TextInput ();

	public function updateTextField ();

	public function onKillFocus ();

	public function onSetFocus ();

	public function onUnload ();

	public function configUI ();

	public function onTextChange (args);
}
