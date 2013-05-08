intrinsic class net.wargaming.notification.FadingMessageList extends gfx.core.UIComponent
{
    var _itemRenderer: String;
    var _stackLength: Number;
    var _direction: String;
    var _lifeTime: Number;
    var _alphaSpeed: Number;
    var _renderers;
    var attachMovie;
    var getNextHighestDepth;
    var invalidate;

    function FadingMessageList();
    function get stackLength();
    function set stackLength(value);
    function get direction();
    function set direction(value);
    function get messageLifeTime();
    function set messageLifeTime(value);
    function get messageAlphaSpeed();
    function set messageAlphaSpeed(value);
    function pushMessage(messageData);
    function clear();
    function configUI();
    function draw();
    function getItemRenderer(messageData);
    function createItemRenderer(messageData, index);
    function onDrawRenderer(event);
}
