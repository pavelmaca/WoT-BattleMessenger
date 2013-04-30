# BattleMessenger - Chat filter & antispam
- Limit number of messages displayed in chat
- Hide messages by dead/alive & ally/enemy player status
- Hide duplicate messages from players
- Prevent spam, by setting max. number of messages per x sec from one player
- Custom chat filters for block messages containing "bad words"
- Ignore own messages and clan, squad players (optional)

When someone spaming chat, for example, with minimap ping.. this mod only hide messages, not remove ping sound or minimap action icon.

**I'm not responsible for any missing information from chat using this mod... it's up to you how to setup this mod, and if you check config in debug mode.**

---

## Download
> [[0.8.5] BattleMessenger - filters & antispam 1.1.rar](http://www.mediafire.com/?shzrtyp48s93umk)

---

## Forum Links
- [EU forum topic](http://forum.worldoftanks.eu/index.php?/topic/235204-085-battlemessenger-chat-filter-antispam-v11-244/)
- [RU forum topic](http://forum.worldoftanks.ru/index.php?/topic/802335-%D1%84%D0%B8%D0%BB%D1%8C%D1%82%D1%80-%D1%87%D0%B0%D1%82%D0%B0-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%B0%D0%B8%D0%B2%D0%B0%D0%B5%D0%BC%D1%8B%D0%B9/) *- unofficial by Demon_Ok*

---

## Config file
- config is stored in `BattleMessenger.conf` using [JSON](http://en.wikipedia.org/wiki/JavaScript_Object_Notation) with extra comments allowed *(same as XVM mod)*
- default config is also used when config file is corrupt or missing

---

## Tips for configuration
### Disable chat completely
>Simply dont show eny message on chat *(can bee use for recording videos from replays)*

    chatLength: 0,

---

### Display chat messages little longer
>Open file `res_mods/0.8.5/gui/messenger.xml`.
>You can get original here - [[0.8.5] messenger.xml - original.rar](http://www.mediafire.com/?epncveoaa04a6lc),
>or use existing one if you have some mod using it (YasenKrasen etc.)
>
>Change `battle/lifeTime` value to set display time for ingame messages in seconds.

    <battle>
        <lifeTime> 10 </lifeTime>
>In combination with `chatLength` option in this mode, you are able to set as big value as you want, without having chat over whole screen.

---

### Debug mode
>allow you test new configuration, while all messages will be displayed
>affected messages will get "deleted:" prefix
>this also works on own messages

    debugMode: true
>![debugModePreview](http://imageshack.us/a/img577/3143/shot047d.jpg)

---

## Changelog
**[0.8.5]**
>no version (24.4.)
>
>- file structure for 0.8.5

**[0.8.4]**
>1.1 (21.4.)
>
>- filters are now case insensitive
>- config use UTF-8
>
>1.0 (16.4.)
>
>- public release