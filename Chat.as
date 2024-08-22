package {
  import flash.display.Sprite;
  import flash.display.MovieClip;
  import flash.external.ExternalInterface;
  import flash.events.MouseEvent;
  import flash.utils.Dictionary;
  import flash.utils.Timer;
  import flash.events.TimerEvent;

  import components.Menu;

  // TODO: auto filter out messages with "TROVE     FLUX . COM" in them (or similar)
  // TODO: party thing??
  // TODO: logos for the clubs?
  // TODO: emojis?

  public class Chat extends MovieClip {
    private var container:Sprite;
    public var indexScroll:int = 0;

    public var input:ChatInput;
    private var inputBg:Sprite;
    private var saved_channel:String = "";
    private var saved_channel_color:uint = 0;

    private var tabbar:Sprite;
    private var tabs:Dictionary = new Dictionary();
    public var current_tab:String = "ALL";

    private var menu:Menu;

    private var clipping_mask:Sprite;

    public var is_active:Boolean = false;

    private var bar:Sprite;
    private var draggable:Sprite;
    private var scrollzone:Sprite;

    public function Chat() {
      super();
      curvu.chat = this;
      ExternalInterface.addCallback("loadModConfiguration", cfg.onLoadModConfig);
      var timer:Timer = new Timer(100, 1);
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, configUI);
      timer.start();
      curvu.Y_EXPANDED = 725 - cfg.config.h_expanded;
      curvu.Y = cfg.config.h_expanded - cfg.config.h + curvu.Y_EXPANDED;
    }

    private function configUI(e:TimerEvent) {
      this.tabs["ALL"] = new Dictionary();
      this.tabs["ALL"]["messages"] = new Vector.<MessageContainer>();

      renderer.rectangle(this, 0, curvu.Y, cfg.config.w, cfg.config.h, renderer.GRAY_48, 0.5);

      this.inputBg = renderer.rectangle(new Sprite(), 0, curvu.Y_EXPANDED + cfg.config.h_expanded, cfg.config.w, 24, renderer.GRAY_28, 0.85);
      this.inputBg.visible = false;
      this.addChild(this.inputBg);
      this.input = new ChatInput();
      this.addChild(this.input);
      this.refreshSavedChannel();

      this.tabbar = renderer.rectangle(new Sprite(), 0, curvu.Y-25, cfg.config.w, 24, 0, 0);
      this.addChild(this.tabbar);

      this.container = renderer.rectangle(new Sprite(), 0, curvu.Y_EXPANDED, cfg.config.w+1, cfg.config.h_expanded, 0, 0);
      this.addChild(this.container);

      this.clipping_mask = renderer.rectangle(new Sprite(), 0, curvu.Y, cfg.config.w, cfg.config.h, 0xFF00FF);
      this.container.mask = this.clipping_mask;
      this.addChild(this.clipping_mask);

      this.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
      this.addEventListener(MouseEvent.CLICK, onDisableMenu);

      ExternalInterface.addCallback("onSetActive", this.onSetActive);
      ExternalInterface.addCallback("addMessage", this.addMessage);

      // this.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { onSetActive(!is_active); });
      // this.addMessage(0, "", "Sunseeker Guard", "gun ruler mother population brain girl unless east be arrange store became darkness upon anything explanation accident perfectly cold sun keep nice matter human", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Sunseeker Guard", "pupil shirt here tired promised anyone treated alive money plastic bar trouble broad decide pink appearance usually molecular particularly police for colony doll nice", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Sunseeker Guard", "give satisfied chart information card wonderful dog drop apart either route with nearest character per hello bear symbol signal outline caught graph wife tight", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Jus7Ace", "clay factory vote youth noun up remain train mile quarter simply grandmother melted return blow am settlers environment date let aboard last article kept", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Allen Moody", "topic sent supply specific stuck simplest declared poor distant play buy matter smaller yesterday shore lower point interest afternoon likely plan fun color nobody", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Christian Summers", "wheat dot taught private factor anyone donkey natural basic rising noted material headed development corner page make atom needed bad rule neighborhood peace east", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Sallie McKenzie", "sense graph living thumb wonderful shallow ten unknown till people distant review labor know surface aware pink sing behind season play because safe triangle", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Jus7Ace", "through apart thing percent state vapor mile slabs mad let struggle old whatever seems bridge truck suddenly gray expect hit judge increase fog difficulty", renderer.WHITE, renderer.RED, false, true, false);
      // this.addMessage(0, "", "Gothika_47", "through apart thing percent state vapor mile slabs mad let struggle old whatever seems bridge truck suddenly gray expect hit judge increase fog difficulty", renderer.WHISPER_COLOR, renderer.RED, false, true, false);
    }

    public function onSetActive(active:Boolean) : void {
      this.graphics.clear();
      if (active) renderer.rectangle(this, 0, curvu.Y_EXPANDED, cfg.config.w, cfg.config.h_expanded, renderer.GRAY_48, 0.5);
      else renderer.rectangle(this, 0, curvu.Y, cfg.config.w, cfg.config.h, renderer.GRAY_48, 0.5);

      this.input.onSetActive(active);
      this.inputBg.visible = active;
      this.is_active = active;
      if (current_tab != "ALL") this.input.setDefaultChannel("Whisper", renderer.WHISPER_COLOR);
      if (this.draggable) {
        this.draggable.visible = active;
        this.bar.visible = active;
      }

      // adjust the mask
      this.removeChild(this.clipping_mask);
      if (active) this.clipping_mask = renderer.rectangle(new Sprite(), 0, curvu.Y_EXPANDED, cfg.config.w+100, cfg.config.h_expanded + this.input.height, 0xFF00FF);
      else this.clipping_mask = renderer.rectangle(new Sprite(), 0, curvu.Y, cfg.config.w, cfg.config.h, 0xFF00FF);
      this.container.mask = this.clipping_mask;
      this.addChild(this.clipping_mask);

      this.renderMessages(indexScroll);
      this.buildTabs(this.current_tab != "ALL");

      if (!this.draggable) {
        this.bar = renderer.rectangle(new Sprite(), cfg.config.w+1, curvu.Y_EXPANDED, 6, cfg.config.h_expanded, renderer.GRAY_48, 0.85);
        this.draggable = renderer.rectangle(new Sprite(), cfg.config.w+2, curvu.Y+1, 4, cfg.config.h_expanded - 2, renderer.GRAY_12, 0.85);
        this.scrollzone = renderer.rectangle(new Sprite(), -cfg.config.w, -curvu.Y_EXPANDED, cfg.config.w*10, cfg.config.h_expanded*10, 0, 0);
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
      var height:int = Math.max(20, cfg.config.h_expanded / (this.tabs[current_tab]["messages"].length+1));
      var y:int = curvu.Y_EXPANDED + cfg.config.h_expanded - Math.min(cfg.config.h_expanded - 1, Math.max(height, (cfg.config.h_expanded / (this.tabs[current_tab]["messages"].length+1)) * (indexScroll+1)));

      this.draggable.graphics.clear();
      this.draggable.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
      this.draggable.removeEventListener(MouseEvent.MOUSE_UP, onRemoveDrag);
      this.removeChild(this.draggable);
      this.draggable = renderer.rectangle(new Sprite(), cfg.config.w+2, y, 4, height-1, renderer.GRAY_12, 0.85);
      this.draggable.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
      this.addChild(this.draggable);

      this.draggable.visible = this.is_active;
      this.bar.visible = this.is_active;
    }

    private function buildTabs(addAll:Boolean = false) : void {
      while (this.tabbar.numChildren > 0)
        this.tabbar.removeChildAt(0);

      var y:int = (is_active ? curvu.Y_EXPANDED : curvu.Y) - 25;

      this.removeChild(this.tabbar);
      this.tabbar = renderer.rectangle(new Sprite(), 0, y, cfg.config.w, 24, 0, 0);
      this.addChild(this.tabbar);

      var tab:ChatTab = null;
      var i:int = 0;
      if (addAll) {
        tab = new ChatTab("ALL", 0, y);
        tab.addEventListener(MouseEvent.CLICK, onChangeTab);
        this.tabbar.addChild(tab);
      }

      for (var author:String in this.tabs) {
        if (author == "ALL") continue;
        tab = new ChatTab(author, 0, y);
        tab.notification = this.tabs[author]["counter"];
        tab.addEventListener(MouseEvent.CLICK, onChangeTab);
        tab.addEventListener(MouseEvent.RIGHT_CLICK, onCloseTab);
        this.tabbar.addChild(tab);
      }

      for (i = 1; i < this.tabbar.numChildren; i++) {
        tab = this.tabbar.getChildAt(i) as ChatTab;
        var prev:ChatTab = this.tabbar.getChildAt(i-1) as ChatTab;
        tab.x = prev.x + prev.width + (prev.text == "ALL" ? 1 : -2);
      }
    }

    private function updateTabCounter(author:String, newVal:int) : void {
      if (!this.tabs[author]) return;
      this.tabs[author]["counter"] = newVal;

      var tab:ChatTab = null;
      var i:int = 0;
      for (i = 0; i < this.tabbar.numChildren; i++) {
        tab = this.tabbar.getChildAt(i) as ChatTab;
        if (tab.text != author) continue;
        tab.notification = newVal;
      }
    }

    public function addMessage(_:uint, channel:String, author:String, content:String, content_color:uint, author_color:uint, wasSent:Boolean, showAuthor:Boolean = true, broadcast:Boolean = false) : void {
      var msg:MessageContainer = new MessageContainer(channel, author, content, content_color, author_color, wasSent, showAuthor, broadcast);
      if (!msg.whoHandler()) return;
      if (curvu.cmd.zenMode) return;
      if (msg.isWhisper()) {
        if (!this.tabs[msg.author]) {
          this.tabs[msg.author] = new Dictionary();
          this.tabs[msg.author]["messages"] = new Vector.<MessageContainer>();
          this.tabs[msg.author]["counter"] = 0;
        }
        this.tabs[msg.author]["messages"].push(msg);
        if (this.tabs[msg.author]["messages"].length > cfg.config.max_messages) this.tabs[msg.author]["messages"].shift();
        if (msg.wasSent) this.current_tab = msg.author;
        buildTabs(this.current_tab != "ALL");
        if (this.current_tab != msg.author) this.updateTabCounter(msg.author, this.tabs[msg.author]["counter"] + 1);
        if (this.indexScroll == 0 && !this.menu) this.renderMessages(0);
        if (!msg.wasSent) ExternalInterface.call("POST_SOUND_EVENT", cfg.config.sound_whisperND_WHISPER);
        return;
      }

      // adding the message
      msg.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
      this.tabs["ALL"]["messages"].push(msg);

      if (this.tabs["ALL"]["messages"].length > cfg.config.max_messages)
        this.tabs["ALL"]["messages"].shift();

      this.updateScroll();
      if (this.indexScroll == 0 && !this.menu) this.renderMessages(0);
    }

    public function addExternalMessage(content:String) : void {
      var last_state:Boolean = curvu.cmd.zenMode;
      curvu.cmd.zenMode = false;
      this.addMessage(0, "", "", content, renderer.RED, 0, false, false, true);
      curvu.cmd.zenMode = last_state;
    }

    public function renderMessages(len:int) : void {
      this.onDisableMenu();

      while (this.container.numChildren > 0)
        this.container.removeChildAt(0);

      var message:MessageContainer = null;
      var i:int = this.tabs[current_tab]["messages"].length - len;
      var y:int = (this.is_active) ? curvu.Y_EXPANDED + cfg.config.h_expanded : curvu.Y + cfg.config.h;
      var counter:int = -1;
      while (--i >= 0 && ++counter < cfg.config.max_messages) {
        message = this.tabs[current_tab]["messages"][i];
        message.y = y - message.height;
        message.theme = !(i % 2 == 0);
        y = message.y;
        this.container.addChild(message);
      }
    }

    /* Event handlers */

    private function onScroll(e:MouseEvent) : void {
      if (!this.draggable) return;
      const len:int = this.tabs[current_tab]["messages"].length;
      const old:int = indexScroll;

      if (e.delta < 0) indexScroll = Math.max(0, indexScroll - 1);
      else indexScroll = Math.min(indexScroll + 1, len);

      if (old != indexScroll) renderMessages(indexScroll);
      this.updateScroll();
    }

    private function onDrag(e:MouseEvent) : void {
      var y:int = curvu.clamp(e.stageY - this.y - curvu.Y_EXPANDED / 2, curvu.Y_EXPANDED + 1, curvu.Y_EXPANDED + cfg.config.h_expanded - 1);
      var len:int = this.tabs[current_tab]["messages"].length;
      var index:int = Math.round(len - (y - curvu.Y_EXPANDED) / (cfg.config.h_expanded / len) - 0.4);
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

    private function onDisableMenu(e:MouseEvent=null) : void {
      if (!this.menu) return;
      this.removeChild(this.menu);
      this.menu.clear();
      this.menu = null;
    }

    private function onRightClick(e:MouseEvent) : void {
      var message:MessageContainer = e.currentTarget as MessageContainer;
      if (!message || message.author.length <= 0 || (message.channel.length <= 0 && message.author_color != renderer.WHISPER_COLOR)) return;
      this.onDisableMenu();

      this.menu = new Menu(message.x, message.y);
      this.menu.current_author = message.author;
      this.addChild(this.menu);
    }

    private function onChangeTab(e:MouseEvent) : void {
      var tab:ChatTab = e.currentTarget as ChatTab;
      if (!tab) return;
      if (tab.text == "ALL") {
        this.input.setDefaultChannel(this.saved_channel, this.saved_channel_color);
        buildTabs();
      } else {
        this.input.setDefaultChannel("Whisper", renderer.WHISPER_COLOR);
        buildTabs(true);
      }
      this.current_tab = tab.text;
      this.updateTabCounter(this.current_tab, 0);
      this.updateScroll();
      this.renderMessages(0);
    }

    private function onCloseTab(e:MouseEvent) : void {
      var tab:ChatTab = e.currentTarget as ChatTab;
      if (!tab || tab.text == "ALL") return;
      delete this.tabs[tab.text];
      buildTabs();
      if (this.current_tab == tab.text) {
        this.current_tab = "ALL";
        this.input.setDefaultChannel(this.saved_channel, this.saved_channel_color);
        this.renderMessages(0);
      }
    }

    /* External callbacks */

    public function refreshSavedChannel() : void {
      this.saved_channel = this.input.getDefaultChannel();
      this.saved_channel_color = this.input.getDefaultChannelColor();
    }

    public function clear() : void {
      for (var author:String in this.tabs) {
        this.tabs[author]["messages"] = new Vector.<MessageContainer>();
        this.tabs[author]["counter"] = 0;
      }
      this.current_tab = "ALL";
      this.updateScroll();
    }
  }
}
