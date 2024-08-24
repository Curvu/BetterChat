package {
  import components.Party;

  public class curvu {
    public static var Y:int = 25;
    public static var Y_EXPANDED:int = 25;
    public static var cmd:Command = new Command();
    public static var chat:Chat;
    public static var party:Party;

    public static var users:Object = {
      "Jus7Ace": 0xADFF00,
      "smellyalater": 0x00FF00,
      "mamameow": 0xA2E4B8,
      "Axodius": 0xFF0087,
      "Naxie": 0xD470A2,
      "Agum0n": 0xffc0cb,
      "_Carbon": 0xCF9FFF,
      "KaiJiieow": 0xEE775E,
      "Suo_": 0x10729c
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
  }
}