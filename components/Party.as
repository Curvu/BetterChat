package components {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.external.ExternalInterface;
  import flash.events.MouseEvent;

  public class Party extends Sprite {
    private var bg:Sprite;
    private var title:TextField;
    private var close:Button;
    private var current_index:int = 0;

    private var list:Vector.<PartyItem> = new Vector.<PartyItem>();

    public function Party() { // I AM NOT ADDING A SCROLLBAR TO THIS COMPONENT FUCK THAT
      super();
      this.x = cfg.config.w + 8;
      this.y = curvu.Y + cfg.config.h - 150;

      this.bg = renderer.rectangle(new Sprite(), 0, 0, 150, 155, renderer.GRAY_12);
      this.bg = renderer.rectangle(this.bg, 1, 1, 148, 153, renderer.GRAY_34);
      this.bg.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);

      this.title = renderer.text("PARTY", 1, 0, 10);

      this.close = new Button("CLOSE", this.bg.width-54, 0, 54, 15, renderer.RED, 9);
      this.close.addEventListener(MouseEvent.CLICK, onClose);

      this.addChild(this.bg);
      this.addChild(this.close);
      this.addChild(this.title);

      for (var i:int = 0; i < cfg.config.party.length; i++)
        addToParty(cfg.config.party[i], true);
    }

    private function searchName(name:String) : Boolean {
      for each (var item:PartyItem in list)
        if (item.title == name)
          return true;
      return false;
    }

    public function addToParty(name:String, loading:Boolean = false) : void {
      if (searchName(name)) return;

      this.visible = true;
      var pi:PartyItem = new PartyItem(name);
      pi.remove.addEventListener(MouseEvent.CLICK, onRemove);
      list.push(pi);
      if (!loading) {
        cfg.config.party.push(name);
        cfg.saveConfig("party");
      }
      buildList(current_index);
    }

    private function buildList(index:int=0) {
      while (this.bg.numChildren > 0) this.bg.removeChildAt(0);

      for (var i:int = index; i < list.length && i < index + 10; i++) {
        var item:PartyItem = list[i];
        item.y = 14 + (i - index) * 14;
        item.theme = i % 2 == 0;
        this.bg.addChild(item);
      }
    }

    public function refresh() : void {
      this.x = cfg.config.w + 8;
      this.y = curvu.Y + cfg.config.h - 150;
      buildList();
    }

    private function onClose(e:MouseEvent) : void {
      this.visible = false;
    }

    private function onScroll(e:MouseEvent) : void {
      var len:int = list.length;
      var indexScroll:int = current_index;

      if (e.delta > 0) indexScroll = Math.max(0, indexScroll - 1);
      else indexScroll = Math.min(indexScroll + 1, len - 10);

      if (indexScroll != current_index) {
        current_index = indexScroll;
        buildList(current_index);
      }
    }

    private function onRemove(e:MouseEvent) : void {
      var pi:PartyItem = e.currentTarget.parent as PartyItem;
      if (!pi) return;

      var index:int = list.indexOf(pi);
      if (index == -1) return;

      list.splice(index, 1);
      cfg.config.party.splice(cfg.config.party.indexOf(pi.title), 1);
      cfg.saveConfig("party");
      buildList(current_index);
    }
  }
}
