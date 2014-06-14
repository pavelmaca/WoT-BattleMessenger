# BattleMessenger - Chat filter & antispam
- Limit number of messages displayed in chat
- **Hide messages by** dead/alive & ally/enemy **player status**
- Hide duplicate messages from players
- Prevent spam, by setting max. number of messages per x sec from one player
- **Custom words filter** for block messages containing "bad words"
- Set of Wargaming **word filters from lobby chat** (EU only)
- Ignore own messages, clan / squad mate, ally in company / clan wars / training / random battles (optional)
- Blocking messages based on min. WN8 rating (xvm statistics required)

When someone spaming chat, for example, with minimap ping.. this mod only hide messages, not remove ping sound or minimap action icon.

**I'm not responsible for any missing information from chat using this mod... it's up to you how to setup this mod, and if you check config in debug mode.**

---

## Download
> For latest version check:  
> [https://github.com/PavelMaca/WoT-BattleMessenger/releases/](https://github.com/PavelMaca/WoT-BattleMessenger/releases/)

---

## Forum Links
- [EU forum topic](http://forum.worldoftanks.eu/index.php?/topic/235204-)

---

## Config file
- config is stored in `BattleMessenger.conf` using [JSON](http://en.wikipedia.org/wiki/JavaScript_Object_Notation) with extra comments allowed *(same as XVM mod)*
- default config is also used when config file is corrupt or missing

---

## Custom filters
Simple filter like `"badword"` will match message: `In this message is badword and will not be displayed.`

>To avoid unwanted filtering with custom filters you need to know some details.
>
>- HTML code inside message is deleted, with content *(avoid filtering user, clan and vehicle names from RadialMenu actions)*
>- every message is splited to simple words, using space as delimeter
>- tested are only **words with 2 or more characters**
>- some characters become replaced, like `0` => `o`, `ä` => `a`, `c` => `k`, full list is here: [gist - charReplacements.as](https://gist.github.com/PavelMaca/3c9268e553ece98051f0#file-charreplacements-as)
>- special characters are removed, like `.`, `#`, `:`, full list is here: [gist - nonStandardChars.as](https://gist.github.com/PavelMaca/3c9268e553ece98051f0#file-nonstandardchars-as)

### Using .* statement
>For creating dynamic filters, you can use `.*` inside filter definition.
>It mean "any characters".
>
> - `.*bar` match `bar`, `foobar`
> - `sta.*` match `stay`, `stats`, `start`
> - `re.*d` match `red`, `reeeed`, `read`
> - `re.*d.*` match same as above + `reading`

---

## Tips for configuration
### Disable chat completely
>Simply don't display any message on chat *(can be used for recording videos)*

    chatLength: 0,

---

### Display chat messages little longer
>Open file `res_mods/0.8.x/gui/messenger.xml`.
>You can get original here: [[0.8.11] messenger.xml - original.rar](http://www.mediafire.com/download/v9pe1g89y1nl8mj),
>or use existing one if you have some mod using it (YasenKrasen etc.)
>
>Change `battle/messageLifeCycle/lifeTime` *value* field to set display time for ingame messages **in seconds**.

    <settings>
      <name>battle</name>
      <set>
        <name>    messageLifeCycle	</name>
        <items>
          <item>
            <name>	lifeTime	</name>
            <value>	10	</value>
>In combination with `chatLength` option in this mode, you are able to set as big value as you want, without having chat over whole screen.

---

### Debug mode
>Allows you test new configuration, while all messages will be displayed.
>Works also on own messages.

    debugMode: true
>![debugModePreview](http://imageshack.us/a/img837/9910/comp1t.png)

---

## Changelog
[List of changes](https://github.com/PavelMaca/WoT-BattleMessenger/releases/)