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
> [[0.8.11] BattleMessenger - chat filter & antispam 2.6.rar](http://www.mediafire.com/download/5x587yy0f9njwub)
>
> MD5 checksum: `0a744579e4106cd8c42698316341ee9c`

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
        <name>	messageLifeCycle	</name>
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
**[0.8.11]**
>2.6 (11.02.2014)
>- adaptation for client version 0.8.11
>- rating filter now use WN8
>- ready for XVM 5.0.2 and higher

**[0.8.10]**
>2.5 (23.12.2013)
>- adaptation for client version 0.8.10

**[0.8.9]**
>2.4 (31.10.2013)
>- adaptation for client version 0.8.9
>- update for XVM 5.0.1-test2 and higher

**[0.8.8]**
>2.3 (11.9.2013)
>- update for XVM 5.0.0 and higher

**[0.8.6]**
>2.2 (15.7.2013)
>- fix: game freeze on loading screen
>
>2.1 (19.6.2013)
>- option for background transparency

**[0.8.5]**
>2.0 (7.5.2013)
>
>- ignore section reworked, add battle types
>- new implementation of filters
>    - testing each word separatly
>    - included set of WG filters from lobby chat (EU)
>    - special chars replacing and removing
>    - default custom filters in config
>- add XVM section
>    - depend on XVM > 4.0 & xvm-stats
>    - messages blocking based on minimum {{WN}} rating
>- debug mode
>    - using XVM 4.0 & xvm-stats for loging
>    - hide/ignore reason under messages
>
>no version (24.4.)
>
>- file structure for 0.8.5

**[0.8.4]**
>1.1 (21.4.2013)
>
>- filters are now case insensitive
>- config use UTF-8
>
>1.0 (16.4.2013)
>
>- public release