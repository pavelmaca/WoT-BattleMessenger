intrinsic dynamic class net.wargaming.messenger.BattleMessenger extends gfx.core.UIComponent
{
	public var isHistoryEnabled : Boolean;
	public var historyZeroPoint : Boolean;
	public var countMessagesOfHistory : Number;
	public var alphaLastMessage : Number;
	public var messageLifeTime : Number;
	public var messageAlphaSpeed : Number;
	public var isListing : Boolean;
	public var lastCaretIndex : Number;
	public var recoveredLatestMessagesAlpha : Number;
	public var latestMessageLength : Number;
	public var lifeTimeRecoveredMessages : Number;
	public var isChatEnable : Boolean;
	public var m_editable : Boolean;
	public var m_channelsInit : Boolean;
	public var m_tabIsDown : Boolean;
	public var m_inactiveStateAlpha : Number;
	public var __height;
	public var __width;
	public var m_constraints;
	public var messageInput;
	public var messageList;
	public var onEnterFrame;
	public var onMouseDown;
	public var skipFirstInput;
	public var tabChildren;

	public function BattleMessenger ();

	public function setStateAlpha (alpha);

	public function getEditable ();

	public function setEditable (bool, forced, generateEvent);

	public function showAfterHistoryMessages (length);

	public function changeReceiverByKeyMod ();

	public function handleInput (details, pathToFocus);

	public function configUI ();

	public function draw ();

	public function sendMessage ();

	public function doSendMessage (channelID, valid);

	public function _onFocusIn ();

	public function _onFocusOut ();

	public function _onReceiverChanged (event);

	public function _onChannelsInit ();

	public function _onRefreshUI ();

	public function _enableHistoryControls (value);

	public function _onRecieveChannelMessage (cid, message, himself, targetIsCurrentPlayer);

	public function _showLatestMessages (message, himself);

	public function _showHistoryMessages (message, himself, numberOfMessages, historyCount);

	public function _isHistoryEnabled (value);

	public function changeHistoryBehavior (isHistory);

	public function upHistoryHandler (e);

	public function downHistoryHandler (e);

	public function lastMessagesHandler (e);

	public function _onPopulateUI ();

	public function _onClearMessages ();

	public function _onShowActionFailureMesssage (message);

	public function _onJoinToChannel ();

	public function _onUpdateReceivers ();

	public function _onUserPreferencesUpdated (storeLastReceiver, removeReceivers, toolTipText);
}
