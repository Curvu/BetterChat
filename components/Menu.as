package components {
  import flash.display.Sprite;
  import flash.external.ExternalInterface;
  import flash.events.MouseEvent;

  public class Menu extends Sprite {
    private var bg:Sprite;
    private var btns:Vector.<Button> = new Vector.<Button>();

    public var current_author:String = "";

    public function Menu(x, y) {
      super();
      this.bg = renderer.rectangle(new Sprite(), 0, 0, 100, 100, renderer.GRAY_12);
      this.bg = renderer.rectangle(this.bg, 1, 1, 98, 98, renderer.GRAY_34);
      this.bg.x = x + 10;
      this.bg.y = y + 10;

      var items:Array = [["$ChatMenu_Whisper", renderer.GRAY_28], ["$ChatMenu_AddFriend", renderer.GRAY_28], ["$FriendRequest_JoinMe", renderer.GRAY_28], ["$ChatMenu_Ignore", renderer.RED]];

      for (var i:int = 0; i < items.length; i++) {
        var btn:Button = new Button(items[i][0], 2, 2 + i * 24, 96, 24, items[i][1]);
        btn.addEventListener(MouseEvent.CLICK, this.onMenuItemClick);
        this.bg.addChild(btn);
        this.btns.push(btn);
      }

      this.addChild(this.bg);
    }

    private function onMenuItemClick(e:MouseEvent) : void {
      var btn:Button = e.currentTarget as Button;
      if (!btn) return;

      switch(btn.not_translated) {
      case "$ChatMenu_Whisper":
        curvu.chat.input.setInput("/w " + current_author + " ");
        break;
      case "$ChatMenu_AddFriend":
        ExternalInterface.call("OnExecute", "/friend " + current_author);
        break;
      case "$FriendRequest_JoinMe":
        ExternalInterface.call("OnExecute", "/joinme " + current_author);
        break;
      case "$ChatMenu_Ignore":
        ExternalInterface.call("OnExecute", "/ignore " + current_author);
        break;
      default:
        break;
      }
    }

    public function clear() : void {
      for each(var btn:Button in this.btns) {
        btn.removeEventListener(MouseEvent.CLICK, this.onMenuItemClick);
        this.bg.removeChild(btn);
      }
      this.bg.graphics.clear();
      this.removeChild(this.bg);
    }
  }
}
