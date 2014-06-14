intrinsic dynamic class net.wargaming.notification.FadingMessageRenderer extends gfx.core.UIComponent
{
	public var _lifeTime : Number;
	public var _alphaSpeed : Number;
	public var _shown : Boolean;
	public var _alpha;
	public var _data;
	public var _height;
	public var _intervalID;
	public var _xscale;
	public var _yscale;
	public var dispatchEvent;
	public var initialized;
	public var removeMovieClip;
	public var tabChildren;
	public var tabEnabled;
	public var textField;
	public var tweenEnd;
	public var tweenTo;

	public function get data ();
	public function set data (value) : Void;

	public function FadingMessageRenderer ();

	public function setData (data);

	public function startShow ();

	public function configUI ();

	public function draw ();

	public function close ();

	public function populateData (initData);

	public function startVisibleLife ();

	public function stopVisibleLife ();
}
