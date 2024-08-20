package {
  public class cfg {
    public static const TYPE:Object = {
      // "BOOL":0,
      // "UINT":1,
      "INT":2,
      // "FLOAT":3,
      "STRING":4
      // "LIST":5,
      // "MAP":6
    };

    public static var config:Object = {
      "W": 400,
      "H": 250,
      "H_EXPANDED": 350,
      "TEXT_SIZE": 13,
      "MAX_MESSAGES": 150,
      "SOUND_WHISPER": "Play_ui_forge_use",
      "TIMESTAMP_FMT": "[${HOURS}:${MINUTES}:${SECONDS}]"
    };

    public static const convert:Object = {
      "W": [TYPE.INT, 200, 500],
      "H": [TYPE.INT, 100, 410],
      "H_EXPANDED": [TYPE.INT, 100, 410],
      "TEXT_SIZE": [TYPE.INT, 8, 16],
      "MAX_MESSAGES": [TYPE.INT, 10, 1000],
      "SOUND_WHISPER": [TYPE.STRING],
      "TIMESTAMP_FMT": [TYPE.STRING]
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
      default:
        break;
      }
    }
  }
}
