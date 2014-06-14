intrinsic dynamic class net.wargaming.messenger.controls.BattleMessengerInput extends net.wargaming.controls.TextInput
{
	public var _receiverIdx : Number;
	public var _receivers;
	public var _storeLastReceiver : Boolean;
	public var _hintText : String;
	public var _toolTipText : String;
	public var isDownHistoryEnbl : Boolean;
	public var isDownEnabled : Boolean;
	public var isUpEnabled : Boolean;
	public var isHistoryEnabled : Boolean;
	public static var selectionIndex : Number;
	public var isEditableChat : Boolean;
	public var intervalID : Number;
	public var countPlaing : Number;
	public var _removeReceivers : Boolean;
	public var __height;
	public var __width;
	public var _currentframe;
	public var _disabled;
	public var _focused;
	public var constraints;
	public var defaultTextFormat;
	public var dispatchEvent;
	public var hintBackground;
	public var hintField;
	public var historyDownBtn;
	public var historyLastMessageBtn;
	public var historyUpBtn;
	public var hit;
	public var initialized;
	public var receiverField;
	public var textField;

	public function get storeLastReceiver ();
	public function set storeLastReceiver (value) : Void;

	public function set removeReceivers (removeReceivers) : Void;

	public function get receiverIdx ();
	public function set receiverIdx (value) : Void;

	public function get receiverColor ();

	public function get receiverLabel ();

	public function get channelID ();

	public function get isEnableReceiver ();

	public function get hintText ();
	public function set hintText (value) : Void;

	public function get toolTipText ();
	public function set toolTipText (value) : Void;

	public function BattleMessengerInput ();

	public function historyEnabled (isHistoryEnabled);

	public function updateHistoryState ();

	public function enableHistoryControl (isUpEnabled, isDownEnabled, isDownHistoryEnbl);

	public function enableHistoryControls ();

	public function addReceiver (id, label, modifiers, order, byDefault, inputColor, isChatEnabled);

	public function setReceiversLabels (data);

	public function nextReceiver ();

	public function changeReceiverByKeyMod ();

	public function setState ();

	public function updateHitArea ();

	public function handleHitAreaRelease ();

	public function updateReceiverField ();

	public function updateEditableState (isEditable);

	public function updateHintField ();

	public function showAnimation (value);

	public function showText ();

	public function showToolTipText ();

	public function hideToolTipText ();

	public function setMouseHandlers ();

	public function onPressUpHistory (e);

	public function onPressDownHistory (e);

	public function onPressLastMessage (e);

	public function handleMouseRollOver (mouseIndex);

	public function handleMouseRollOut (mouseIndex);

	public function onMouseWheel (delta, target);
}
