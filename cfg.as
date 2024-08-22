package {
  public class cfg {
    public static const TYPE:Object = {
      // "BOOL":0,
      // "UINT":1,
      "INT": 2,
      // "FLOAT":3,
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
      "sound_timer": "Play_pvp_ui_match_start",
      "show_hours": 1,
      "show_minutes": 1,
      "show_seconds": 1,
      "aliases": {},
      "blacklisted": []
    };

    public static const convert:Object = {
      "w": [TYPE.INT, 200, 500],
      "h": [TYPE.INT, 100, 700],
      "h_expanded": [TYPE.INT, 100, 700],
      "text_size": [TYPE.INT, 8, 16],
      "max_messages": [TYPE.INT, 10, 1000],
      "sound_whisper": [TYPE.STRING],
      "sound_timer": [TYPE.STRING],
      "show_hours": [TYPE.INT, 0, 1],
      "show_minutes": [TYPE.INT, 0, 1],
      "show_seconds": [TYPE.INT, 0, 1],
      "aliases": [TYPE.MAP],
      "blacklisted": [TYPE.LIST]
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
        config[key] = val.split(",");
        break;
      default:
        break;
      }
    }
  }
}
