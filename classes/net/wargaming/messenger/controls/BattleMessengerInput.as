intrinsic class net.wargaming.messenger.controls.BattleMessengerInput extends net.wargaming.controls.TextInput
{
    var _receiverIdx: Number;
    var _receivers;
    var _storeLastReceiver: Boolean;
    var _hintText: String;
    var _toolTipText: String;
    var __height;
    var __width;
    var _disabled;
    var _focused;
    var constraints;
    var dispatchEvent;
    var hintBackground;
    var hintField;
    var hit;
    var initialized;
    var receiverField;
    var textField;

    function BattleMessengerInput();
    function get storeLastReceiver();
    function set storeLastReceiver(value);
    function addReceiver(id, label, modifiers, order, byDefault);
    function setReceiversLabels(data);
    function get receiverIdx();
    function set receiverIdx(value);
    function get receiverLabel();
    function get channelID();
    function get hintText();
    function set hintText(value);
    function get toolTipText();
    function set toolTipText(value);
    function nextReceiver();
    function changeReceiverByKeyMod();
    function setState();
    function updateHitArea();
    function handleHitAreaRelease();
    function updateReceiverField();
    function updateHintField();
    function showToolTipText();
    function hideToolTipText();
    function setMouseHandlers();
    function handleMouseRollOver(mouseIndex);
    function handleMouseRollOut(mouseIndex);
    function onMouseWheel(delta, target);
}

