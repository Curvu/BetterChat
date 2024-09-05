package {
  import components.Party;

  public class curvu {
    public static var Y:int = 25;
    public static var Y_EXPANDED:int = 25;
    public static var cmd:Command = new Command();
    public static var chat:Chat;
    public static var party:Party;

    public static const DEBUG:Boolean = true;

    public static const users:Object = {
      "Jus7Ace": 0xADFF00,
      "smellyalater": 0x00FF00,
      "Suo_": 0x10729C
    }

    public static function darken(color:uint, amount:Number) : uint {
      var r:uint = (color >> 16) & 0xFF;
      var g:uint = (color >> 8) & 0xFF;
      var b:uint = color & 0xFF;
      return ((r * amount) << 16) | ((g * amount) << 8) | (b * amount);
    }

    public static function clamp(p:Number, min:Number, max:Number) : Number {
      return Math.max(min, Math.min(max, p));
    }

    public static function trim(str:String) : String {
      const len:int = str.length;
      var result:String = "";
      for (var i:int = 0; i < len; ++i)
        if (str.charAt(i) != " ")
          result += str.charAt(i);
      return result.toLowerCase();
    }
  }
}