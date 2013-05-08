intrinsic  class net.wargaming.controls.TextInput extends gfx.controls.TextInput
{
    var _extractEscapes: Boolean;
    var addEventListener;
    var textField;

    function TextInput();
    function updateTextField();
    function onKillFocus();
    function onSetFocus();
    function onUnload();
    function configUI();
    function onTextChange(args);
    function get extractEscapes();
    function set extractEscapes(value);
}