package components {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.external.ExternalInterface;
  import flash.events.MouseEvent;

  public class PartyItem extends Sprite {
    private var bg:Sprite;
    private var user:TextField;
    private var invite:Button;
    public var remove:Button;

    public function PartyItem(name:String) {
      super();

      this.user = renderer.text(name, 1, -1, 10);

      this.bg = renderer.rectangle(new Sprite(), 1, 1, 148, 13, renderer.GRAY_12);

      this.invite = new Button("invite", 96, 0, 40, 15, renderer.GREEN, 9);
      this.invite.addEventListener(MouseEvent.CLICK, onInvite);
      this.remove = new Button("X", 135, 0, 15, 15, renderer.RED, 9);

      this.addChild(this.bg);
      this.addChild(this.user);
      this.addChild(this.invite);
      this.addChild(this.remove);
    }

    public function set theme(t:Boolean) : void {
      this.bg.transform.colorTransform = renderer.hexToRGB(t ? renderer.GRAY_22 : renderer.GRAY_34);
    }

    private function onInvite(e:MouseEvent) : void {
      ExternalInterface.call("OnExecute", "/joinme " + this.user.text);
    }

    public function get title() : String {
      return this.user.text;
    }
  }
}
