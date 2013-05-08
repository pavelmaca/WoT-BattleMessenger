intrinsic class net.wargaming.messenger.controls.BattleMessageRenderer extends net.wargaming.notification.FadingMessageRenderer
{
    var textBottomPadding: Number;
    var textRightPadding: Number;
    var _shown;
    var _xscale;
    var _yscale;
    var background;
    var dispatchEvent;
    var startVisibleLife;
    var textField;
    var tweenTo;

    function BattleMessageRenderer();

    function startShow();

    function configUI();

    function draw();

    function populateData(initData);

}