# BetterChat
An upgrade of the chat system in Trove, with more features and alot more customization and code improvements.

## Features
- Config file for easy customization
- Chat tabs for whispers
- Aliases for commands
- More chat commands, you can see them with `/help`

## Installation
1. Go to the [releases](https://trovesaurus.com/mod=11094)
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
timestamp_fmt = HH:MM:SS # HH - hours, MM - minutes, SS - seconds
ignore_channel_swap = 0 # 1/0 (disables/enables the channel swap tab feature)
aliases = fx0:fxenable 0,fx1:fxenable 1 # alias:command,alias:command,...
blacklisted = troveflux.com # word1,word2,... ("TROVE     FLUX . COM" will also get detected)
party = # name1,name2,... (names that will be colored with the party color)
party_color = 0x222222 # color in hex
party_color_alpha = 0.45 # between 0 and 1
close_btn_color = 0xFE014C # color in hex
clear_btn_color = 0xFE014C # color in hex
invite_btn_color = 0x50DB66 # color in hex
party_item_1_color = 0x161616 # color in hex
party_item_2_color = 0x222222 # color in hex
chat_color = 0x303030 # color in hex
chat_color_alpha = 0.5 # between 0 and 1
chat_item_1_color = 0x0C0C0C # color in hex
chat_item_2_color = 0x1C1C1C # color in hex
timestamp_bg_color = 0x222222 # color in hex
tab_color = 0x1C1C1C # color in hex
tab_notification_color = 0xFE014C # color in hex
input_bg_color = 0x1C1C1C # color in hex
input_bg_color_alpha = 0.85 # between 0 and 1
scrollbar_color = 0x1C1C1C # color in hex
scrollbar_color_alpha = 0.85 # between 0 and 1
menu_bg_color = 0x222222 # color in hex
menu_bg_alpha = 0.85 # between 0 and 1
menu_btn_normal_color = 0x1C1C1C # color in hex
menu_btn_ignore_color = 0xFE014C # color in hex
menu_btn_alpha = 0.65 # between 0 and 1
timer_color = 0xFE014C # color in hex
repeated_message_color = 0xD3D3D3 # color in hex
cmd_header_color = 0x457B9D # color in hex
mod_message_default_color = 0xA8DADC # color in hex
```

## Credits
- Geoflay, for helping with the config file
- TheSymbols Chat Mod (Edited by Sqze & Axodius), for inspiring me for some features
- Irradiant, for feedback, testing and some feature ideas
- smellyalater, feature ideas and feedback