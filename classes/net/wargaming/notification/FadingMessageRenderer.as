intrinsic class net.wargaming.notification.FadingMessageRenderer extends gfx.core.UIComponent
{
    var _lifeTime: Number;
    var _alphaSpeed: Number;
    var _shown: Boolean;
    var _alpha;
    var _data;
    var _height;
    var _intervalID;
    var _xscale;
    var _yscale;
    var dispatchEvent;
    var initialized;
    var removeMovieClip;
    var tabChildren;
    var tabEnabled;
    var textField;
    var tweenEnd;
    var tweenTo;

    function FadingMessageRenderer();

    function get data();
    function set data(value);
    function setData(data);

    function startShow();

    function configUI();

    function draw();

    function close();
    function populateData(initData);

    function startVisibleLife();

    function stopVisibleLife();

}