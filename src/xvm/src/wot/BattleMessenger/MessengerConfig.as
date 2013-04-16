import wot.BattleMessenger.Utils;

class wot.BattleMessenger.MessengerConfig
{
	private static var CONFIG_FILE:String = "BattleMessenger.conf";
	
	private static var _config:Object;
	
	private static var _defaultConfig:Object = {
		enabled: true,
		chatLength: 10,
		ignoreClan: true,
		ignoreSquad: true,
		blockAlly: {
			dead: false,
			alive: false
		},
		blockEnemy: {
			dead: false,
			alive: false
		},
		antispam: {
		enabled: false,
			duplicateCount: 2,
			duplicateInterval: 7,
			playerCount: 3,
			playerInterval: 7,
			filters: []
		},
		debugMode: false
	};
	
	public static function get enabled():Boolean    {
        return battleMessenger.enabled;
	}
	
	public static function get chatLength():Number   {
        return battleMessenger.chatLength;
	}
	
	public static function get ignoreClan():Boolean   {
        return battleMessenger.ignoreClan;
	}
	
	public static function get ignoreSquad():Boolean   {
        return battleMessenger.ignoreSquad;
	}
	
	public static function get blockAllyDead():Boolean   {
        return battleMessenger.blockAlly.dead;
	}
	
	public static function get blockAllyAlive():Boolean   {
        return battleMessenger.blockAlly.alive;
	}
	
	public static function get blockEnemyDead():Boolean   {
        return battleMessenger.blockEnemy.dead;
	}
	
	public static function get blockEnemyAlive():Boolean   {
        return battleMessenger.blockEnemy.alive;
	}
	
	public static function get antispamEnabled():Boolean   {
        return battleMessenger.antispam.enabled;
	}
	
	public static function get antispamDuplcateCount():Number   {
        return battleMessenger.antispam.duplicateCount;
	}
	
	public static function get antispamDuplicateInterval():Number   {
        return battleMessenger.antispam.duplicateInterval;
	}
	
	public static function get antispamPlayerCount():Number   {
        return battleMessenger.antispam.playerCount;
	}
	
	public static function get antispamPlayerInterval():Number   {
        return battleMessenger.antispam.playerInterval;
	}
	
	public static function get antispamFilters():Array   {
        return battleMessenger.antispam.filters;
	}
	
	
	public static function get debugMode():Boolean   {
        return battleMessenger.debugMode;
	}
	
	
	/** private */
	private static function get battleMessenger():Object
    {
        return _config;
    }
	
	private static function get blockAlly():Object
    {
        return battleMessenger.blockAlly;
    }
	
	private static function get blockEnemy():Object
    {
        return battleMessenger.blockEnemy;
    }
	
	private static function get antispam():Object
    {
        return battleMessenger.antispam;
    }
	
	/** Load config from file */
	public static function loadConfig()	{
		if (_config) return;
		
		var lv:LoadVars = new LoadVars();
		lv.onData = onLoadConfig;
        lv.load(CONFIG_FILE);
	}
	
	private static function onLoadConfig(str:String) {
		if (str) {
			var config = com.xvm.JSON.parse(str);
			
			if (config) {
				_config = Utils.MergeConfigs(config, _defaultConfig);
			}
		}
		/** set default config */
		if (!_config) _config = _defaultConfig;
	}
	
}