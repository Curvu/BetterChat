package components {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.external.ExternalInterface;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  public class Party extends Sprite {
    public var PARTY_ID:String;

    private var bg:Sprite;
    private var title:TextField;
    private var close:Button;
    private var inviteAll:Button;
    private var current_index:int = 0;
    private var list:Vector.<PartyItem> = new Vector.<PartyItem>();

    private var removeTimer:Timer = new Timer(1000, 1);

    public function Party() { // I AM NOT ADDING A SCROLLBAR TO THIS COMPONENT FUCK THAT
      super();
      this.x = cfg.config.w + 8;
      this.y = curvu.Y + cfg.config.h - 178;

      this.bg = renderer.rectangle(new Sprite(), 0, 0, 150, 177, renderer.GRAY_12, 0.45);
      this.bg = renderer.rectangle(this.bg, 1, 1, 148, 175, renderer.GRAY_34, 0.45);
      this.bg.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);

      this.title = renderer.text("PARTY LIST", 1, -1, 12);

      this.inviteAll = new Button("INVITE ALL", this.bg.width-75, 0, 59, 17, renderer.GREEN, 9);
      this.inviteAll.addEventListener(MouseEvent.CLICK, onInviteAll);
      this.inviteAll.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      this.inviteAll.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);

      this.close = new Button("X", this.bg.width-16, 0, 16, 17, renderer.RED, 9);
      this.close.addEventListener(MouseEvent.CLICK, onClose);

      this.addChild(this.bg);
      this.addChild(this.inviteAll);
      this.addChild(this.close);
      this.addChild(this.title);

      for (var i:int = 0; i < cfg.config.party.length; i++)
        addToParty(cfg.config.party[i], true);

      removeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSaveConfig);
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

    public function removeFromParty(name:String) : void {
      var index:int = -1;
      for (var i:int = 0; i < list.length; i++) {
        if (list[i].title == name) {
          index = i;
          break;
        }
      }

      if (index == -1) return;
      list.splice(index, 1);

      // empty config array and re-add all items
      cfg.config.party = [];
      for each (var item:PartyItem in list)
        cfg.config.party.push(item.title);

      removeTimer.reset();
      removeTimer.start();
      removeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSaveConfig); // Add this line to re-add the event listener

      buildList(current_index);
    }

    private function buildList(index:int=0) {
      while (this.bg.numChildren > 0) this.bg.removeChildAt(0);

      for (var i:int = index; i < list.length && i < index + 10; i++) {
        var item:PartyItem = list[i];
        item.y = 16 + (i - index) * 16;
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
      removeFromParty(pi.title);
    }

    private function onInviteAll(e:MouseEvent) : void {
      cfg.saveExternalConfig("friendslist.swf", "betterfriendlist:auto_whisper", "true");
      var timer:Timer = new Timer(600, list.length);
      timer.addEventListener(TimerEvent.TIMER, onTick);
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
        cfg.saveExternalConfig("friendslist.swf", "betterfriendlist:auto_whisper", "false");
      });
      timer.start();
    }

    private function onTick(e:TimerEvent) : void {
      cfg.saveExternalConfig("navigationmenu.swf", "friendlist", "friendList");
      var index:int = e.target.currentCount - 1;
      var item:PartyItem = list[index];

      var inv:Timer = new Timer(100, 1);
      inv.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
        ExternalInterface.call("OnExecute", "/joinme " + item.title);
      });
      inv.start();

      var timer:Timer = new Timer(200, 1);
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
        cfg.saveExternalConfig("navigationmenu.swf", "friendlist", "null");
      });
      timer.start();
    }

    private function onSaveConfig(e:TimerEvent) : void {
      cfg.saveConfig("party");
    }

    private function onMouseOver(e:MouseEvent) : void {
      ExternalInterface.call("UIComponent.OnShowTooltip", e.stageX, e.stageY, "More information", "This will only work if you have BetterFriendlist and NavAPI mods installed.");
    }

    private function onMouseOut(e:MouseEvent) : void {
      ExternalInterface.call("UIComponent.OnHideTooltip");
    }
  }
}
