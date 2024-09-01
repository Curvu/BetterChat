package components {
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.external.ExternalInterface;
  import flash.text.TextField;

  public class Button extends Sprite {
    private var _text:TextField;
    private var body:Sprite;
    private var color:uint;

    public var not_translated:String;

    private var listeners:Array = [];

    public function Button(txt:String = "", x:int = 0, y:int = 0, w:int = 0, h:int = 0, color:uint = 0, size:int = 11, a:Number = 1) {
      super();
      this.color = color;
      this.body = renderer.rectangle(new Sprite(), x+1, y+1, w-2, h-2, color, a);

      this._text = renderer.text(txt, 0, 0, size, "center", w, h-2);
      this._text.x = x + (w - this._text.width) / 2;
      this._text.y = y + (h - this._text.height) / 2;
      this.not_translated = txt;

      this.addChild(this.body);
      this.addChild(this._text);

      this.addMouseEventListeners();
    }

    private function addMouseEventListeners() : void {
      this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      this.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      this.addEventListener(MouseEvent.CLICK,this.onClick);
    }

    private function onMouseOver(e:MouseEvent) : void {
      this.body.transform.colorTransform = renderer.hexToRGB(curvu.darken(this.color, 0.75));
    }

    private function onMouseOut(e:MouseEvent) : void {
      this.body.transform.colorTransform = renderer.hexToRGB(this.color);
    }

    private function onMouseDown(e:MouseEvent) : void {
      ExternalInterface.call("POST_SOUND_EVENT", "Play_ui_button_select");
      this.body.transform.colorTransform = renderer.hexToRGB(curvu.darken(this.color, 0.6));
    }

    private function onMouseUp(e:MouseEvent) : void {
      // check if the mouse is still over the button
      var clr:uint = this.hitTestPoint(this.stage.mouseX, this.stage.mouseY) ? curvu.darken(this.color, 0.75) : this.color;
      this.body.transform.colorTransform = renderer.hexToRGB(clr);
    }

    private function onClick(e:MouseEvent) : void {
      for each (var listener:Function in this.listeners)
        listener.call();
    }

    public function get text() : String {
      return this._text.text || "";
    }
  }
}
