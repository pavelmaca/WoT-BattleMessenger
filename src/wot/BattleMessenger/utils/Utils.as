/**
 * Part of XVM project https://code.google.com/p/wot-xvm/
 * @author sirmax2
 */
class wot.BattleMessenger.utils.Utils
{
	
	// TODO: check performance, charAt is slow in ScaleForm
    public static function trim(str: String): String
    {
        var i, j;
        for (i = 0; str.charCodeAt(i) < 33; ++i);
        var len = str.length;
        for (j = len-1; str.charCodeAt(j) < 33; --j);
        return str.substring(i, j+1);
    }
	
	public static function GetPlayerName(fullplayername: String): String
    {
        var pos = fullplayername.indexOf("[");
        return (pos < 0) ? fullplayername : trim(fullplayername.slice(0, pos));
    }
	
	public static function toInt(value: Object, defaultValue: Number): Number
    {
        if (!defaultValue)
            defaultValue = 0;
        if (!value)
            return defaultValue;
        var n: Number = parseInt(value.toString());
        return isNaN(n) ? defaultValue : n;
    }
	
	/**
     * Recursive walt default config and merge with loaded values.
     */
    public static function MergeConfigs(config, def, prefix: String)
    {
        if (!prefix)
            prefix = "def";

        switch (typeof def)
        {
            case 'object':
                if (def instanceof Array)
                {
                    // warning: arrays are not checked now
                    return (config instanceof Array) ? config : def;
                }
                if (def == null)
                    return (typeof config == 'string' || typeof config == 'number') ? config : null;
                var result: Object = { };
                for (var name:String in def)
                {
                    result[name] = config.hasOwnProperty(name)
                       ? MergeConfigs(config[name], def[name], prefix + "." + name)
                       : def[name];
                }
                return result;

            case 'number':
                if (!isNaN(parseFloat(config)))
                    return parseFloat(config);
                if (typeof config == 'string')
                    return config;
                return def;

            case 'boolean':
                if (typeof config == 'boolean')
                    return config;
                if (typeof config == 'string')
                    return config.toLowerCase() == "true";
                return def;

            case 'string':
                return (config == null || typeof config == 'string') ? config : def;

            case 'undefined':
            case 'null':
                return (typeof config == 'string' || typeof config == 'number') ? config : def;

            default:
                return def;
        }
    }
	
	/**
	 * Helper that replaces all "find" with "replace" in the given input string
	 * http://danikgames.com/blog/?p=550
	 * @param	input
	 * @param	find
	 * @param	replace
	 * @return
	 */
	public static function strReplace(input:String, find:String, replace:String):String {
		while (input.indexOf("find") != -1)
			input = input.split(find).join(replace);
		return input.split(find).join(replace);
	}
}