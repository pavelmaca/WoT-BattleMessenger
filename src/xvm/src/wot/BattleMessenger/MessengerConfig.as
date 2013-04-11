import wot.utils.Config;
/**
 * ...
 * @author 
 */
class wot.BattleMessenger.MessengerConfig
{
	//#TODO: use DefaultConfgig file
	private static var defaultConfig:Object = {
		enabled: true,
		chatLength: 10,
		ignoreClan: false,
		ignoreSquad: false,
		blockAlly: {
			dead: false,
			alive: false
		},
		blockEnemy: {
			dead: true,
			alive: false
		},
		antispam: {
			enabled: true,
			duplicateCount: 2,
			duplicateInterval: 5,
			playerCount: 3,
			playerInterval: 5,
			filters: []
		},
		debugMode: true
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
		//#TODO: use DefaultConfgig file
        return Config.s_config.battleMessenger || defaultConfig;
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
	
}