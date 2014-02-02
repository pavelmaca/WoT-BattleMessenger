intrinsic dynamic class net.wargaming.messenger.controls.BattleMessageRenderer extends net.wargaming.notification.FadingMessageRenderer
{
	public var textBottomPadding : Number;
	public var textRightPadding : Number;
	public var _shown;
	public var _xscale;
	public var _yscale;
	public var background;
	public var dispatchEvent;
	public var startVisibleLife;
	public var textField;
	public var tweenTo;

	public function BattleMessageRenderer ();

	public function startShow ();

	public function configUI ();

	public function draw ();

	public function populateData (initData);
}
