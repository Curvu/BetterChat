package {
  import flash.filters.DropShadowFilter;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.geom.ColorTransform;

  public class renderer {
    public static const FMT:TextFormat = new TextFormat("Open Sans", null, WHITE, null, false, false, null, null);
    public static const SHADOW:DropShadowFilter = new DropShadowFilter(1, 45, 0, 1, 0, 0, 1, 1);

    public static const WHITE:int = 0xFFFFFF;
    public static const WHISPER_COLOR:int = 14446832;
    public static const STATS_COLOR:int = 16777215;

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

    public static function text(str:String = "", x:int = 0, y:int = 0, size:Number = 8, align:String = "left", w:int = 100, h:int = 25, wordWrap:Boolean = false, isBold:Boolean = false, verticalAlign:Boolean = false) : TextField {
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

      if (verticalAlign) tf.y = y + (h - tf.textHeight) / 2;

      return tf;
    }
  }
}
