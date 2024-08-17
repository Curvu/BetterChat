package {
  public class curvu {
    public static const W:int = 400;
    public static const H:int = 250;
    public static const Y:int = 125;
    public static const Y_EXPANDED:int = 25;
    public static const H_EXPANDED:int = 350;
    public static const TEXT_SIZE:int = 13;
    public static const MAX_MESSAGES:int = 50;
    public static const TIMESTAMP_FMT:String = "[${HOURS}:${MINUTES}:${SECONDS}]";

    public static const DEBUG:Boolean = false;

    public static var cmd:Command = new Command();
    public static var chat:Chat;

    public static function darken(color:uint, amount:Number) : uint {
      var r:uint = (color >> 16) & 0xFF;
      var g:uint = (color >> 8) & 0xFF;
      var b:uint = color & 0xFF;
      return ((r * amount) << 16) | ((g * amount) << 8) | (b * amount);
    }
  }
}