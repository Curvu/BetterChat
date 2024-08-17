package {
  import flash.filters.DropShadowFilter;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.geom.ColorTransform;

  public class renderer {
    public static const FMT:TextFormat = new TextFormat("Open Sans", null, WHITE, null, false, false, null, null);
    public static const SHADOW:DropShadowFilter = new DropShadowFilter(1, 45, 0, 1, 0, 0, 1, 1);

    public static const GREEN:uint = 0x50DB66;
    public static const RED:int = 0xFE014C;
    public static const BLACK:uint = 0x000000;
    public static const WHITE:uint = 0xFFFFFF;
    public static const GRAY_9:uint = 0x090909;
    public static const GRAY_12:int = 0x0C0C0C;
    public static const GRAY_16:int = 0x101010;
    public static const GRAY_22:int = 0x161616;
    public static const GRAY_25:int = 0x191919;
    public static const GRAY_28:int = 0x1C1C1C;
    public static const GRAY_30:int = 0x1E1E1E;
    public static const GRAY_34:int = 0x222222;
    public static const GRAY_38:int = 0x262626;
    public static const GRAY_41:int = 0x292929;
    public static const GRAY_48:int = 0x303030;

    public function renderer() {
      super();
    }

    public static function colored(txt:String, color:String) : String {
      return "<font color='" + color + "'>" + txt + "</font>";
    }

    public static function hexToRGB(hex:uint):ColorTransform {
      var red:uint = (hex >> 16) & 0xFF;
      var green:uint = (hex >> 8) & 0xFF;
      var blue:uint = hex & 0xFF;
      return new ColorTransform(0, 0, 0, 1, red, green, blue, 0);
    }

    public static function rgbToHex(rgb:uint):String {
      var r:uint = (rgb >> 16) & 0xFF;
      var g:uint = (rgb >> 8) & 0xFF;
      var b:uint = rgb & 0xFF;
      var rh:String = (r < 16 ? "0" : "") + r.toString(16);
      var gh:String = (g < 16 ? "0" : "") + g.toString(16);
      var bh:String = (b < 16 ? "0" : "") + b.toString(16);
      return "#" + rh + gh + bh;
    }

    public static function rectangle(s:*, x:int = 0, y:int = 0, w:int = 0, h:int = 0, rgb:int = 0, a:Number = 1) : * {
      if(!s) return;
      s.graphics.beginFill(rgb,a);
      s.graphics.drawRect(x,y,w,h);
      s.graphics.endFill();
      return s;
    }

    public static function text(str:String = "", x:int = 0, y:int = 0, size:Number = 8, align:String = "left", w:int = -1, h:int = -1, wordWrap:Boolean = false, isBold:Boolean = false):TextField {
      var tf:TextField = new TextField();
      tf.filters = [SHADOW];
      FMT.size = size;
      FMT.align = align;
      FMT.bold = isBold;
      tf.defaultTextFormat = FMT;
      tf.mouseEnabled = false;
      tf.x = x;
      tf.y = y;
      tf.htmlText = str;
      if (w != -1) tf.width = w;
      if (h != -1) tf.height = h;
      tf.wordWrap = wordWrap;
      tf.autoSize = align;
      return tf;
    }
  }
}
