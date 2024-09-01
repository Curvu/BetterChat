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

      this.user = renderer.text(name, 1, 0, 10);

      this.bg = renderer.rectangle(new Sprite(), 1, 1, 148, 15, 0, 0.45);

      this.invite = new Button("INVITE", 94, 1, 40, 15, cfg.config.invite_btn_color, 9, 0.45);
      this.invite.addEventListener(MouseEvent.CLICK, onInvite);
      this.remove = new Button("X", 134, 1, 15, 15, cfg.config.clear_btn_color, 9, 0.45);

      this.addChild(this.bg);
      this.addChild(this.user);
      this.addChild(this.invite);
      this.addChild(this.remove);
    }

    public function set theme(t:Boolean) : void {
      this.bg.transform.colorTransform = renderer.hexToRGB(t ? cfg.config.party_item_1_color : cfg.config.party_item_2_color);
    }

    private function onInvite(e:MouseEvent) : void {
      ExternalInterface.call("OnExecute", "/joinme " + this.user.text);
    }

    public function get title() : String {
      return this.user.text;
    }
  }
}
