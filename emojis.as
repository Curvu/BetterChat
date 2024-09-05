package {
  import flash.display.MovieClip;
  import flash.utils.getDefinitionByName;

  public class emojis {
    public static var current_list:Vector.<MovieClip> = new Vector.<MovieClip>();

    public static const _:Object = {
      "KEKW": "KEKW",
      "RAGEY": "RAGEY"
    }

    public static function getEmoji(name:String) : MovieClip {
      var clazz:Class = getDefinitionByName(name) as Class;
      return new clazz();
    }

    public static function scale(mc:MovieClip) : MovieClip {
      mc.scaleX = mc.scaleY = 18 / mc.height;
      return mc;
    }
  }
}