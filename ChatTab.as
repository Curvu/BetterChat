package {
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.external.ExternalInterface;
  import flash.text.TextField;

  public class ChatTab extends Sprite {
    private var listeners:Vector.<Function> = new Vector.<Function>();

    private var _text:TextField;
    private var _notification:TextField;
    private var body:Sprite;
    private var color:uint = renderer.GRAY_28;

    public function ChatTab(txt:String = "", x:int = 0, y:int = 0) {
      super();
      var w:int = renderer.text(txt, 0, 0, 11).width + 5;
      var h:int = 24;
      this.x = x;
      this.y = y;

      this.body = renderer.rectangle(new Sprite(), 0, 0, w, h, color, 0.65);

      this._text = renderer.text(txt, 0, 0, 11, "center", w, h);
      this._text.x = (w - this._text.width) / 2;
      this._text.y = (h - this._text.height) / 2;

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

    public function set notification(value:int) : void {
      if (this._notification) this.removeChild(this._notification);
      this._notification = renderer.text(value.toString(), this.body.x + this.body.width - 8, this.body.y - 4, 11, "left", 0, 0, false, true);
      this._notification.filters = [];
      this._notification.transform.colorTransform = renderer.hexToRGB(renderer.RED);
      this.addChild(this._notification);
      this._notification.visible = value > 0;
    }
  }
}
