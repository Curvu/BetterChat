package {
  public class curvu {
    public static const Y:int = 125;
    public static const Y_EXPANDED:int = 25;

    public static const DEBUG:Boolean = false;

    public static var cmd:Command = new Command();
    public static var chat:Chat;

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