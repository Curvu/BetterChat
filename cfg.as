package {
  import flash.external.ExternalInterface;

  public class cfg {
    public static const TYPE:Object = {
      // "BOOL":0,
      // "UINT":1,
      "INT": 2,
      "FLOAT":3,
      "STRING": 4,
      "LIST":5,
      "MAP": 6
    };

    public static var config:Object = {
      "w": 400,
      "h": 250,
      "h_expanded": 400,
      "text_size": 13,
      "max_messages": 150,
      "sound_whisper": "Play_ui_forge_use",
      "sound_timer": "Play_ui_forge_use",
      "sound_timer_finished": "Play_pvp_ui_match_start",
      "timestamp_fmt": "HH:MM:SS",
      "ignore_channel_swap": 0,
      "aliases": {},
      "blacklisted": [],
      "party": [],
      "party_color": "0x222222",
      "party_color_alpha": 0.45,
      "close_btn_color": "0xFE014C",
      "clear_btn_color": "0xFE014C",
      "invite_btn_color": "0x50DB66",
      "party_item_1_color": "0x161616",
      "party_item_2_color": "0x222222",
      "chat_color": "0x303030",
      "chat_color_alpha": 0.5,
      "chat_item_1_color": "0x0C0C0C",
      "chat_item_2_color": "0x1C1C1C",
      "timestamp_bg_color": "0x222222",
      "tab_color": "0x1C1C1C",
      "tab_notification_color": "0xFE014C",
      "input_bg_color": "0x1C1C1C",
      "input_bg_color_alpha": 0.85,
      "scrollbar_color": "0x1C1C1C",
      "scrollbar_color_alpha": 0.85,
      "menu_bg_color": "0x222222",
      "menu_bg_alpha": 0.85,
      "menu_btn_normal_color": "0x1C1C1C",
      "menu_btn_ignore_color": "0xFE014C",
      "menu_btn_alpha": 0.65,
      "timer_color": "0xFE014C",
      "repeated_message_color": "0xD3D3D3",
      "cmd_header_color": "0x457B9D",
      "mod_message_default_color": "0xA8DADC"
    };

    public static const convert:Object = {
      "w": [TYPE.INT, 200, 500],
      "h": [TYPE.INT, 100, 700],
      "h_expanded": [TYPE.INT, 100, 700],
      "text_size": [TYPE.INT, 8, 16],
      "max_messages": [TYPE.INT, 10, 1000],
      "sound_whisper": [TYPE.STRING],
      "sound_timer": [TYPE.STRING],
      "sound_timer_finished": [TYPE.STRING],
      "timestamp_fmt": [TYPE.STRING],
      "ignore_channel_swap": [TYPE.INT, 0, 1],
      "aliases": [TYPE.MAP],
      "blacklisted": [TYPE.LIST],
      "party": [TYPE.LIST],
      "party_color": [TYPE.STRING],
      "party_color_alpha": [TYPE.FLOAT, 0, 1],
      "close_btn_color": [TYPE.STRING],
      "clear_btn_color": [TYPE.STRING],
      "invite_btn_color": [TYPE.STRING],
      "party_item_1_color": [TYPE.STRING],
      "party_item_2_color": [TYPE.STRING],
      "chat_color": [TYPE.STRING],
      "chat_color_alpha": [TYPE.FLOAT, 0, 1],
      "chat_item_1_color": [TYPE.STRING],
      "chat_item_2_color": [TYPE.STRING],
      "timestamp_bg_color": [TYPE.STRING],
      "tab_color": [TYPE.STRING],
      "tab_notification_color": [TYPE.STRING],
      "input_bg_color": [TYPE.STRING],
      "input_bg_color_alpha": [TYPE.FLOAT, 0, 1],
      "scrollbar_color": [TYPE.STRING],
      "scrollbar_color_alpha": [TYPE.FLOAT, 0, 1],
      "menu_bg_color": [TYPE.STRING],
      "menu_bg_alpha": [TYPE.FLOAT, 0, 1],
      "menu_btn_normal_color": [TYPE.STRING],
      "menu_btn_ignore_color": [TYPE.STRING],
      "menu_btn_alpha": [TYPE.FLOAT, 0, 1],
      "timer_color": [TYPE.STRING],
      "repeated_message_color": [TYPE.STRING],
      "cmd_header_color": [TYPE.STRING],
      "mod_message_default_color": [TYPE.STRING]
    };

    public function cfg() {
      super();
    }

    public static function onLoadModConfig(key:String, val:String) : void {
      if(config[key] == null) return;
      switch(convert[key][0]) {
      case TYPE.INT:
        config[key] = int(curvu.clamp(Number(val), convert[key][1], convert[key][2]));
        break;
      case TYPE.FLOAT:
        config[key] = curvu.clamp(Number(val), convert[key][1], convert[key][2]);
        break;
      case TYPE.STRING:
        config[key] = val;
        break;
      case TYPE.MAP:
        var arr:Array = val.split(",");
        for(var i:int = 0; i < arr.length; i++) {
          var pair:Array = arr[i].split(":");
          config[key][pair[0]] = pair[1];
        }
        break;
      case TYPE.LIST:
        arr = val.split(",");
        for each(var item:String in arr)
          if(item.length > 0)
            config[key].push(item);
        break;
      default:
        break;
      }
    }

    public static function saveConfig(key) : void {
      var out:String = "";
      var val:* = config[key];
      if(config[key] == null) return;
      switch(convert[key][0]) {
      case TYPE.INT:
        out = Number(val).toString();
        break;
      case TYPE.STRING:
        out = val;
        break;
      case TYPE.MAP:
        for(var k:String in val) out += k + ":" + val[k] + ",";
        out = out.slice(0, -1);
        break;
      case TYPE.LIST:
        out = val.join(",");
        break;
      default:
        break;
      }
      ExternalInterface.call("UIComponent.OnSaveConfig", "chat.swf", key, out);
    }

    public static function saveExternalConfig(file:String, key:String, val:String) : void {
      ExternalInterface.call("UIComponent.OnSaveConfig", file, key, val);
    }
  }
}
