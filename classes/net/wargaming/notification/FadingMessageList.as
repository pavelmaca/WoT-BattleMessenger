intrinsic dynamic class net.wargaming.notification.FadingMessageList extends gfx.core.UIComponent
{
	public var _itemRenderer : String;
	public var _stackLength : Number;
	public var _direction : String;
	public var _lifeTime : Number;
	public var _alphaSpeed : Number;
	public var _renderers;
	public var attachMovie;
	public var getNextHighestDepth;
	public var invalidate;

	public function get stackLength ();
	public function set stackLength (value) : Void;

	public function get direction ();
	public function set direction (value) : Void;

	public function get messageLifeTime ();
	public function set messageLifeTime (value) : Void;

	public function get messageAlphaSpeed ();
	public function set messageAlphaSpeed (value) : Void;

	public function FadingMessageList ();

	public function pushMessage (messageData);

	public function clear ();

	public function configUI ();

	public function draw ();

	public function getItemRenderer (messageData);

	public function createItemRenderer (messageData, index);

	public function onDrawRenderer (event);
}
