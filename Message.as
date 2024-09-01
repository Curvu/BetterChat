package {
  import flash.text.TextField;

  public class Message {
    public var channel:String;
    public var author:String;
    public var content:String;
    public var content_color:uint;
    public var author_color:uint;
    public var wasSent:Boolean;
    public var showAuthor:Boolean;
    public var lootbox:Boolean;
    public var is_channel_swap:Boolean;
    private var _counter:int = 0;

    private var fmt:String;
    private var message:TextField;

    private var format:Object = {
      "default": "${AUTHOR} › ${CONTENT}",
      "toWhisper": "${ME} › ${CONTENT}",
      "fromWhisper": "${AUTHOR} › ${CONTENT}",
      "broadcast": "${CONTENT}",
      "lootbox": "${AUTHOR} › ${CONTENT}",
      "me": "${AUTHOR} ${CONTENT}",
      "timer": "${AUTHOR} started a timer of ${CONTENT} seconds.",
      "timer_going": "${AUTHOR} timer is still going for ${CONTENT} seconds.",
      "timer_end": "${AUTHOR} GO! GO! GO!",
      "dumb": "${AUTHOR} › I'm dumb :)",
      "channel": "${CHANNEL}"
    }

    public function Message(channel:String, author:String, content:String, content_color:uint, author_color:uint, wasSent:Boolean, showAuthor:Boolean = true, lootbox:Boolean = false) {
      this.channel = channel;
      this.author = author;
      this.content = content;
      this.content_color = content_color;
      this.author_color = author_color;
      this.wasSent = wasSent;
      this.showAuthor = showAuthor;
      this.lootbox = lootbox;
      this.is_channel_swap = !cfg.config.ignore_channel_swap && content.indexOf("#$#") == 0;
      this.message = renderer.text("", 5, 2, cfg.config.text_size, "left", 0, 0, true);
    }

    public function formatMessage(fmt:String) : TextField {
      var text:String = renderer.colored(format[fmt], renderer.rgbToHex(fmt == "me" ? curvu.users[author] || author_color : fmt == "timer" || fmt == "timer_going" || fmt == "timer_end" ? cfg.config.timer_color : content_color));

      if (_counter > 0) text += " ${COUNTER}";
      if (cfg.config.ignore_channel_swap) text = "[${CHANNEL}] " + text;

      // Replace the placeholders
      text = text.replace("${CHANNEL}", channel.replace(". ", " - "));
      text = text.replace("${ME}", renderer.colored("me", renderer.rgbToHex(author_color)));
      text = text.replace("${AUTHOR}", renderer.colored(author, renderer.rgbToHex(curvu.users[author] || author_color)));
      text = text.replace("${CONTENT}", content);
      text = text.replace("${COUNTER}", renderer.colored("("+_counter+")", renderer.rgbToHex(cfg.config.repeated_message_color)));

      message.htmlText = text;
      message.height = message.textHeight;

      return this.message;
    }

    public function get height() : int {
      return this.message.height;
    }

    public function toString() : TextField {
      fmt = "default";

      if(this.author != "") {
        if(this.channel.length <= 0)
          fmt = (this.wasSent) ? "toWhisper" : "fromWhisper";

        if(this.author.length > 0 && this.showAuthor && this.lootbox)
          fmt = "lootbox"
      }

      if(this.channel.length <= 0 && this.author.length <= 0) {
        fmt = "broadcast";
      }

      if(this.content.indexOf("me/") == 0) {
        fmt = "me";
        this.content = this.content.substr(4);
      } else if (this.content.indexOf("timer/") == 0 && this.channel.indexOf("World") > -1) {
        fmt = "timer";
        this.content = this.content.substr(6);
        var temp:Number = Number(this.content);
        if(isNaN(temp)) fmt = "default";
        else {
          if (temp > 0 && temp < 26) curvu.cmd.startTimer(temp, this);
          else fmt = "dumb";
        }
      }

      if (this.is_channel_swap) {
        fmt = "channel";
        this.channel = this.content.substr(3);
      }

      return this.formatMessage(fmt);
    }

    public function get counter() : int {
      return this._counter;
    }

    public function set counter(value:int) : void {
      this._counter = value;
      this.formatMessage(fmt);
    }
  }
}
