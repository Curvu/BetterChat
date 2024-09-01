package {
  import flash.external.ExternalInterface;
  import flash.display.Sprite;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import flash.text.TextField;
  import flash.utils.Dictionary;
  import flash.geom.ColorTransform;

  import utils.Timestamp;

  public class MessageContainer extends Sprite {
    private var message:Message;
    private var bg:Sprite;

    private var ts:TextField;
    private var ts_background:Sprite;
    private var _original_content:String;

    public function MessageContainer(channel:String, author:String, content:String, content_color:uint, author_color:uint, wasSent:Boolean, showAuthor:Boolean = true, lootbox:Boolean = false) {
      this.message = new Message(channel, author, content, content_color, author_color, wasSent, showAuthor, lootbox);
      this._original_content = content;
      var m:TextField = this.message.toString();

      var time:String = Timestamp.get();
      var width:int = time.length * cfg.config.text_size / 2 + 6;

      m.x = width + 2;
      m.width = cfg.config.w - (message.is_channel_swap ? 0 : width + 2);
      this.addChild(m);

      this.bg = renderer.rectangle(new Sprite(), 0, 0, cfg.config.w, this.message.height+5, 0, 0.5);
      this.addChildAt(this.bg, 0);

      if (!cfg.config.ignore_channel_swap && message.is_channel_swap) return;
      this.ts = renderer.text(time, 0, 2, cfg.config.text_size, "center", width, 0);
      this.ts_background = renderer.rectangle(new Sprite(), 0, 0, width, this.message.height+5, 0, 0.5);
      this.addChild(this.ts_background);
      this.addChild(this.ts);
    }

    public function whoHandler() : Boolean {
      if (!(curvu.cmd.whoCommandSent && this.message.channel == "" && this.message.content.indexOf(": (") > -1))
        return true;

      if (curvu.cmd.ignoreWho) {
        curvu.party.addToParty(this.message.content.split(": (")[0]);
      }

      curvu.cmd.whoCounter++;
      if (curvu.cmd.whoTimer != null) {
        curvu.cmd.whoTimer.stop();
        curvu.cmd.whoTimer.addEventListener(TimerEvent.TIMER, curvu.cmd.whoCounterOutput);
        curvu.cmd.whoTimer.start();
      }
      return !curvu.cmd.blockPrint;
    }

    public function statsHandler() : Boolean {
      if (!(curvu.cmd.statsCommandSent && this.message.content_color == renderer.STATS_COLOR))
        return true;

      curvu.cmd.statsCounter++;
      if (curvu.cmd.statsTimer != null) {
        curvu.cmd.statsTimer.stop();
        curvu.cmd.statsTimer.addEventListener(TimerEvent.TIMER, curvu.cmd.statsCounterOutput);
        curvu.cmd.statsTimer.start();
      }
      return (this.message.content.toLowerCase().indexOf(curvu.cmd.searchedStat) > -1);
    }

    public function isBlacklisted() : Boolean {
      var trimmed:String = curvu.trim(this.message.content);
      for each(var blacklisted:String in cfg.config.blacklisted) {
        if (blacklisted.length <= 0) continue;
        if (trimmed.indexOf(blacklisted) > -1)
          return true;
      }
      return false;
    }

    public function isParty() : Boolean {
      if (!curvu.party || !curvu.party.PARTY_ID) return false;
      var arr:Array = this.message.content.split(" ");
      if (arr.length != 2) return false;
      if (arr[1] != curvu.party.PARTY_ID) return false;
      if (arr[0] == "join/") {
        curvu.party.addToParty(this.message.author);
        curvu.chat.addExternalMessage("Added " + this.message.author + " to the party.");
        return true;
      } else if (arr[0] == "leave/") {
        curvu.party.removeFromParty(this.message.author);
        curvu.chat.addExternalMessage("Removed " + this.message.author + " from the party.");
        return true;
      }
      return false;
    }

    public function isWhisper() : Boolean {
      return this.message.content_color == renderer.WHISPER_COLOR && this.message.channel.length <= 0;
    }

    public function isRepeated() : void {
      var messages:Dictionary = curvu.chat.messages;
      var key = curvu.trim(this.message.channel+this.message.author+this.message.content);
      if (message.is_channel_swap) return;
      if (messages[key] > 1) {
        curvu.chat.removeMessage(this);
        message.counter = messages[key];
      }
    }

    public function set theme(t:Boolean) : void {
      this.bg.transform.colorTransform = renderer.hexToRGB(t ? cfg.config.chat_item_1_color : cfg.config.chat_item_2_color);
      if (!this.ts_background) return;
      this.ts_background.transform.colorTransform = renderer.hexToRGB(cfg.config.timestamp_bg_color);
    }

    public function get author() : String {
      return this.message.author;
    }

    public function get channel() : String {
      return this.message.channel;
    }

    public function get content() : String {
      return this.message.content;
    }

    public function get author_color() : uint {
      return this.message.author_color;
    }

    public function get wasSent() : Boolean {
      return this.message.wasSent;
    }
  }
}
