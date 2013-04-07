import wot.utils.Config;
import wot.Minimap.dataTypes.Player;

/**
 * ...
 * @author 
 */
class wot.BattleMessenger.Filter
{
	
	
	public function Filter(message:String, himself:Number) 
	{
		/*
        var __reg6 = message.indexOf(">");
        var __reg7 = message.substr(__reg6 + 1, message.length - __reg6);
        __reg6 = __reg7.indexOf(" ");
        __reg7 = __reg7.substr(0, __reg6);
        __reg6 = __reg7.indexOf("[");
        if (__reg6 != -1) 
        {
            __reg7 = __reg7.substr(0, __reg6);
        }
        var sendMsg:Boolean = true;
        var isSquadOrClan:Boolean = false;
        var isMe:Boolean = false;
		
		// hide dead (kromě četa a klanu
        if (this.bm_config > 5) 
        {
            for (var n in _root.statsData.team2) 
            {
                if (_root.statsData.team2[n].userName == __reg7) 
                {
                    if (_root.statsData.team2[n].himself) 
                    {
                        isMe = true;
                        continue;
                    }
					// is dead ?
                    if (_root.statsData.team2[n].vehicleState == 2) 
                    {
						//není četa
                        if (this.c_squad == 0 || this.c_squad != _root.statsData.team2[n].squad) 
                        {
							// není klan
                            if (this.c_clan == "" || this.c_clan != _root.statsData.team2[n].clanAbbrev) 
                            {
                               sendMsg = false;
                            }
                        }
                    }
					
					// je z čety, nebo klanu
                    if ((this.c_squad != 0 && this.c_squad == _root.statsData.team2[n].squad) || (this.c_clan != "" && this.c_clan == _root.statsData.team2[n].clanAbbrev)) 
                    {
						isSquadOrClan = true;
                    }
                }
            }
            for (var n in _root.statsData.team1) 
            {
                if (_root.statsData.team1[n].userName == __reg7) 
                {
                    if (_root.statsData.team1[n].himself) 
                    {
                        isMe = true;
                        continue;
                    }
                    if (_root.statsData.team1[n].vehicleState == 2) 
                    {
                        if (this.c_squad == 0 || this.c_squad != _root.statsData.team1[n].squad) 
                        {
                            if (this.c_clan == "" || this.c_clan != _root.statsData.team1[n].clanAbbrev) 
                            {
                                sendMsg = false;
                            }
                        }
                    }
                    if ((this.c_squad != 0 && this.c_squad == _root.statsData.team1[n].squad) || (this.c_clan != "" && this.c_clan == _root.statsData.team1[n].clanAbbrev)) 
                    {
                        isSquadOrClan = true;
                    }
                }
            }
        }
		
		// hide all (kromě mně)
        if (this.bm_config > 999 && !isMe) 
        {
            sendMsg = false;
        }
		// hide all (kromě mně, četa a klanu)
        if (this.bm_config > 99 && (!isSquadOrClan && !isMe)) 
        {
            sendMsg = false;
        }
        if (sendMsg) 
        {
			super._onRecieveChannelMessage(cid, message, himself, targetIsCurrentPlayer);
        }*/
	}
	
	private function checkMessege(message:String, himself:Number):Boolean
	{
		if (Config.s_config.battleMessanger.enable) {
			if (Config.s_config.battleMessanger.disableChat ) {
				return false;
			}
			
			var player:Player;
			
			/** ignore Squad or Clan members*/
			if (!Config.s_config.battleMessanger.filters.squadAndClan) {
				return (isClan(player) || isSquad(player));
			}
			
			/** hide Dead players messagges */
			if (Config.s_config.battleMessanger.filters.dead && this.isDead(player)) {
				return false;
			}
			
			/** antispam */
			var isAntispamActive:Boolean = isAntispamActive(player);
			
		}
		return true;
	}
	
	
	function isSquad(player:Player):Boolean
	{
		return false;
	}
	
	function isClan(player:Player):Boolean
	{
		return false;
	}
	
	function isDead(player:Player):Boolean
	{
		return false;
	}
	
	
		
	private function isAntispamActive(player:Player):Boolean {
		return false;
	}
	
}