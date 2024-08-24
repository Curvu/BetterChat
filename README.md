# BetterChat
An upgrade of the chat system in Trove, with more features and alot more customization and code improvements.

## Features
- Config file for easy customization
- Chat tabs for whispers
- Aliases for commands
- More chat commands, you can see them with `/help`

## Installation
1. (trovessauros link)
2. Install the version you want, some have more features than others and install the config file (can be used without the config file)
3. Place the `BetterChat.tmod` on the mods folder and the `BetterChat.cfg` in `%appdata%/Trove/ModCfgs`

## Costumization
The mod has a config file that allows you to change some of the things:
```bash
[chat.swf]
w = 400 # between 200 and 500
h = 250 # between 100 and 700
h_expanded = 350 # between 100 and 700
sound_whisper = Play_ui_forge_use
sound_timer = Play_pvp_ui_match_start
max_messages = 150 # between 10 and 1000
text_size = 13 # between 8 and 16
show_hours = 1 # 0 = false, 1 = true
show_minutes = 1 # 0 = false, 1 = true
show_seconds = 1 # 0 = false, 1 = true
aliases = fx0:fxenable 0,fx1:fxenable 1 # alias:command,alias:command,...
blacklisted = troveflux.com # word1,word2,... ("TROVE     FLUX . COM" it will also detect it)
```

## Credits
- Geoflay, for helping me with the config file
- TheSymbols Chat Mod (Edited by Sqze & Axodius), for inspiring me for some features
- Irradiant, for feedback and testing and some feature ideas