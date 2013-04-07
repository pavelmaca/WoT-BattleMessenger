/**
 * ...
 * @author 
 */
intrinsic class net.wargaming.messenger.BattleMessenger
{
	var m_editable: Boolean = false;
    var m_channelsInit: Boolean = false;
    var m_tabIsDown: Boolean = false;
    var m_inactiveStateAlpha: Number = 0;
    var __height;
    var __width;
    var m_constraints;
    var messageInput;
    var messageList;
    var onEnterFrame;
    var onMouseDown;
    var skipFirstInput;
    var tabChildren;
	
	function BattleMessenger();
    function setStateAlpha(alpha);

    function getEditable();
   
    function setEditable(bool, forced);

    function changeReceiverByKeyMod();
    function handleInput(details, pathToFocus);

    function configUI();

    function draw();

    function sendMessage();

    function doSendMessage(channelID, valid);

    function _onFocusIn();

    function _onFocusOut();

    function _onReceiverChanged(event);

    function _onChannelsInit();
    function _onRefreshUI();

    function _onPopulateUI();

    function _onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);

    function _onClearMessages();
    function _onShowActionFailureMesssage(message);

    function _onJoinToChannel();
    function _onUpdateReceivers();

    function _onUserPreferencesUpdated(storeLastReceiver);

}