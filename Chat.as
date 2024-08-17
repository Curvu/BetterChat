package {
  import flash.display.Sprite;
  import flash.display.MovieClip;
  import flash.external.ExternalInterface;
  import flash.text.TextField;
  import flash.events.MouseEvent;

  import components.Button;

  // TODO: chat tabs
  // TODO: Timestamps
  // TODO: config
  // TODO: colors for specific people
  // TODO (maybe): right click menu only on other's messages and not on my own
  // remove scroll?

  public class Chat extends MovieClip {
    private var messages:Vector.<MessageContainer> = new Vector.<MessageContainer>();
    private var container:Sprite;
    private var indexScroll:int = 0;

    private var input:ChatInput;
    private var inputBg:Sprite;

    private var clipping_mask:Sprite;

    private var is_active:Boolean = curvu.DEBUG;

    private var bar:Sprite;
    private var draggable:Sprite;
    private var scrollzone:Sprite;

    private var menu:Sprite;
    private var current_author:String = "";

    public function Chat() {
      super();
      curvu.chat = this;
      renderer.rectangle(this, 0, curvu.Y, curvu.W, curvu.H, renderer.GRAY_48, 0.5);

      this.inputBg = renderer.rectangle(new Sprite(), 0, curvu.Y + curvu.H, curvu.W, 24, renderer.GRAY_28, 0.85);
      this.inputBg.visible = false;
      this.addChild(this.inputBg);
      this.input = new ChatInput();
      this.addChild(this.input);

      this.container = renderer.rectangle(new Sprite(), 0, curvu.Y_EXPANDED, curvu.W+1, curvu.H_EXPANDED, 0, 0);
      this.addChild(this.container);

      this.clipping_mask = renderer.rectangle(new Sprite(), 0, curvu.Y, curvu.W, curvu.H, 0xFF00FF);
      this.container.mask = this.clipping_mask;
      this.addChild(this.clipping_mask);

      this.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
      this.addEventListener(MouseEvent.CLICK, onDisableMenu);

      ExternalInterface.addCallback("onSetActive", this.onSetActive);
      ExternalInterface.addCallback("addMessage", this.addMessage);

      if (curvu.DEBUG) {
        this.addMessage(0, "1. World", "Lester", "\n\n\n\n\nolo", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "", "", "Joined c1. Sobbing", 16776960, 12895232, false, true, false);
        this.addMessage(0, "", "Larry", "I am a from whisper", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "1. World", "Lester", "shut object involved mail anybody furniture skin nearby softly meet go which if planned stepped certainly sharp keep lips luck under girl pass had", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "2. World", "Mike", "far under lake including ever nuts few influence topic collect love grain settlers mission ants view lie needs heat lead straight greatly shirt attack", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "3 World", "Abbie", "wherever wind needs fill manner power strong least weight word pleasant according nuts form oil adult street refer drove wonderful corn husband when ground", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "4. World", "Lenora", "sort dozen copper average stone solar sugar took mood swept education tool tobacco classroom wise though partly truth blanket when death against discuss story", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "5. World", "Jeff", "setting collect bush street fox line former forget bell greater continent pleasure habit stuck bridge according popular organized married porch wave indeed folks anybody", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "6. World", "Jeanette", "his gulf vertical molecular machinery bent canal effort front potatoes orange central final engineer got left tall certain bean just class maybe additional hidden", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "7. World", "Ina", "plane means fully pattern noon map frog worse immediately also television frame hold remember nation lady result contrast height your compass course scientist mighty", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "8. World", "Minerva", "shore correctly trick jack surface town fur happily itself principle jump central particles husband free for vast sides adult fighting given failed effort waste", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "9. World", "Hannah", "value block audience pair hunt series necessary adjective pencil common president writing shop cookies machine oil fallen cutting cold forget neighbor fox tie arm", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "10. World", "Alex", "friend rhythm behind engine worker mother noun dirt winter cloud think draw team stop truck ready beginning leaving charge lady party arrow remove excitement", renderer.WHITE, renderer.RED, false, true, false);
        this.addMessage(0, "", "Sunseeker Guard", "npc whisper", renderer.WHITE, renderer.RED, false, true, false);
        onSetActive(true);
      }
    }

    public function onSetActive(active:Boolean) : void {
      this.graphics.clear();
      if (active) renderer.rectangle(this, 0, curvu.Y_EXPANDED, curvu.W, curvu.H_EXPANDED, renderer.GRAY_48, 0.5);
      else renderer.rectangle(this, 0, curvu.Y, curvu.W, curvu.H, renderer.GRAY_48, 0.5);

      this.input.onSetActive(active);
      this.inputBg.visible = active;
      this.is_active = active;

      // adjust the mask
      this.removeChild(this.clipping_mask);
      if (active) this.clipping_mask = renderer.rectangle(new Sprite(), 0, curvu.Y_EXPANDED, curvu.W+100, curvu.H_EXPANDED + this.input.height, 0xFF00FF);
      else this.clipping_mask = renderer.rectangle(new Sprite(), 0, curvu.Y, curvu.W, curvu.H, 0xFF00FF);
      this.container.mask = this.clipping_mask;
      this.addChild(this.clipping_mask);

      this.renderMessages(indexScroll);

      if (!this.draggable) {
        this.bar = renderer.rectangle(new Sprite(), curvu.W+1, curvu.Y_EXPANDED, 6, curvu.H_EXPANDED, renderer.GRAY_48, 0.85);
        this.draggable = renderer.rectangle(new Sprite(), curvu.W+2, curvu.Y+1, 4, curvu.H_EXPANDED - 2, renderer.GRAY_12, 0.85);
        this.scrollzone = renderer.rectangle(new Sprite(), -curvu.W, -curvu.Y_EXPANDED, curvu.W*10, curvu.H_EXPANDED*10, 0, 0);
        this.addChild(this.bar);
        this.addChild(this.draggable);

        this.draggable.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
        this.bar.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
        this.scrollzone.addEventListener(MouseEvent.MOUSE_UP, onRemoveDrag);
      }

      this.updateScroll();
    }

    private function updateScroll() : void {
      if (!this.draggable) return;
      var height:int = Math.max(20, curvu.H_EXPANDED / (this.messages.length+1));
      var y:int = curvu.Y_EXPANDED + curvu.H_EXPANDED - Math.min(curvu.H_EXPANDED - 1, Math.max(height, (curvu.H_EXPANDED / (this.messages.length+1)) * (indexScroll+1)));

      this.draggable.graphics.clear();
      this.draggable.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
      this.draggable.removeEventListener(MouseEvent.MOUSE_UP, onRemoveDrag);
      this.removeChild(this.draggable);
      this.draggable = renderer.rectangle(new Sprite(), curvu.W+2, y, 4, height-1, renderer.GRAY_12, 0.85);
      this.draggable.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
      this.addChild(this.draggable);

      this.draggable.visible = this.is_active;
      this.bar.visible = this.is_active;
    }

    private function onScroll(e:MouseEvent) : void {
      if (!this.draggable) return;
      const len:int = this.messages.length;
      const old:int = indexScroll;

      if (e.delta < 0) indexScroll = Math.max(0, indexScroll - 1);
      else indexScroll = Math.min(indexScroll + 1, len);

      if (old != indexScroll) renderMessages(indexScroll);
      this.updateScroll();
    }

    private function onDrag(e:MouseEvent) : void {
      var y:int = Math.min(curvu.H_EXPANDED - 1, Math.max(this.draggable.height, e.stageY - this.y - 25));
      var len:int = this.messages.length;
      var index:int = len - Math.round((y - curvu.Y_EXPANDED) / (curvu.H_EXPANDED / len)) - 1;
      if (index != indexScroll && index >= 0 && index < len) {
        indexScroll = index;
        this.renderMessages(indexScroll);
        this.updateScroll();
      }

      this.scrollzone.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
      this.addChild(this.scrollzone);
    }

    private function onRemoveDrag(e:MouseEvent) : void {
      this.scrollzone.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
      this.removeChild(this.scrollzone);
    }

    public function addMessage(_:uint, channel:String, author:String, content:String, content_color:uint, author_color:uint, wasSent:Boolean, showAuthor:Boolean = true, broadcast:Boolean = false) : void {
      var msg:MessageContainer = new MessageContainer(channel, author, content, content_color, author_color, wasSent, showAuthor, broadcast);
      if (!msg.shouldAdd()) return;

      // adding the message
      msg.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
      this.messages.push(msg);
      this.updateScroll();
      if (this.indexScroll == 0 && !this.menu) this.renderMessages(0);
    }

    public function addExternalMessage(content:String) : void {
      this.addMessage(0, "", "", content, renderer.RED, 0, false, false, true);
    }

    private function onRightClick(e:MouseEvent) : void {
      var message:MessageContainer = e.currentTarget as MessageContainer;
      if (!message || message.author.length <= 0) return;
      this.onDisableMenu();

      this.menu = renderer.rectangle(new Sprite(), 0, 0, 100, 100, renderer.GRAY_12);
      this.menu = renderer.rectangle(this.menu, 1, 1, 98, 98, renderer.GRAY_34);
      this.menu.x = message.x + 10;
      this.menu.y = message.y + 10;
      this.current_author = message.author;
      var items:Array = [["$ChatMenu_Whisper", renderer.GRAY_28], ["$ChatMenu_AddFriend", renderer.GRAY_28], ["$FriendRequest_JoinMe", renderer.GRAY_28], ["$ChatMenu_Ignore", renderer.RED]];

      for (var i:int = 0; i < items.length; i++) {
        var btn:Button = new Button(items[i][0], 2, 2 + i * 24, 96, 24, items[i][1]);
        btn.addEventListener(MouseEvent.CLICK, this.onMenuItemClick);
        this.menu.addChild(btn);
      }

      this.addChild(this.menu);
    }

    private function onMenuItemClick(e:MouseEvent) : void {
      var btn:Button = e.currentTarget as Button;
      if (!btn) return;

      switch(btn.not_translated) {
      case "$ChatMenu_Whisper":
        this.input.setInput("/w " + current_author + " ");
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

    private function onDisableMenu(e:MouseEvent=null) : void {
      if (!this.menu) return;
      this.removeChild(this.menu);
      this.menu = null;
      this.current_author = "";
    }

    private function renderMessages(len:int) : void {
      this.onDisableMenu();

      for each (var msg:MessageContainer in this.messages)
        if (this.contains(msg))
          this.container.removeChild(msg);

      if (this.messages.length > curvu.MAX_MESSAGES)
        this.messages.shift();

      var message:MessageContainer = null;
      var i:int = this.messages.length - len;
      var y:int = (this.is_active) ? curvu.Y_EXPANDED + curvu.H_EXPANDED : curvu.Y + curvu.H;
      var counter:int = -1;
      while (--i >= 0 && ++counter < curvu.MAX_MESSAGES) {
        message = this.messages[i];
        message.y = y - message.height;
        message.theme = !(i % 2 == 0);
        y = message.y;
        this.container.addChild(message);
      }
    }
  }
}
