# BetterChat
An upgrade of the chat system in Trove, with more features and alot more customization and code improvements.

## Features
- Config file for easy customization
- Chat tabs for whispers
- More chat commands
  - //who - Prints the number of players in the world
  - /clear - Clears the chat
  - /zen - Toggles zen mode (disable/enable chat)
  - timer/{number} - Starts a countdown timer in the interval [1, 25]
  - me/ {message} - Sends a message with the same color of your name

## Installation
1. (trovessauros link)
2. Install the version you want, some have more features than others and install the config file (can be used without the config file)
3. Place the `BetterChat.tmod` on the mods folder and the `BetterChat.cfg` in `%appdata%/Trove/ModCfgs`

## Costumization
The mod has a config file that allows you to change some of the things:
```bash
[chat.swf]
w = 400 # between 200 and 500
h = 250 # between 100 and 410
h_expanded = 350 # between 100 and 410
sound_whisper = Play_ui_forge_use
max_messages = 150 # between 10 and 1000
text_size = 13 # between 8 and 16
show_hours = 1 # 0 = false, 1 = true
show_minutes = 1 # 0 = false, 1 = true
show_seconds = 1 # 0 = false, 1 = true
```

## Credits
- Geoflay, for helping me with the config file
- TheSymbols Chat Mod (Edited by Sqze & Axodius), for inspiring me for some features