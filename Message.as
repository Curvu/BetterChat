package {
  import flash.text.TextField;
  import flash.display.MovieClip;

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
    private var tt:String;

    private var fmt:String;
    private var message:TextField;
    public var emojes:Vector.<MovieClip> = new Vector.<MovieClip>();

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
      this.message = renderer.text("", 5, 2, cfg.config.text_size, "left", 1, 1, true, false, true);
    }

    public function formatMessage(fmt:String) : TextField {
      tt = renderer.colored(format[fmt], renderer.rgbToHex(fmt == "me" ? curvu.users[author] || author_color : fmt == "timer" || fmt == "timer_going" || fmt == "timer_end" ? cfg.config.timer_color : content_color));

      if (_counter > 0) tt += " ${COUNTER}";
      if (cfg.config.ignore_channel_swap) tt = "[${CHANNEL}] " + tt;

      var ch:Array = channel.split(". ");
      if (ch.length > 1) {
        var l:Object = logos._[ch[1]];
        var calc:int = cfg.config.text_size + 3;
        if (l) {
          ch[1] = "<img src='" + l.src + "' width='"+curvu.ruleOfThree(l.h, l.w, calc)+"' height='"+calc+"' hspace='0' vspace='3' align='middle' /> "
        }
      }
      channel = ch.join(" - ");

      // Replace the placeholders
      tt = tt.replace("${CHANNEL}", channel);
      tt = tt.replace("${ME}", renderer.colored("me", renderer.rgbToHex(author_color)));
      tt = tt.replace("${AUTHOR}", renderer.colored(author, renderer.rgbToHex(curvu.users[author] || author_color)));
      tt = tt.replace("${CONTENT}", content);
      tt = tt.replace("${COUNTER}", renderer.colored("("+_counter+")", renderer.rgbToHex(cfg.config.repeated_message_color)));

      message.htmlText = tt;
      handleEmoji();
      return this.message;
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

    public function handleEmoji() : void {
      var arr:Array = [];
      var temp:Array = message.text.split(" ");
      if (temp[1] == '-') return;

      for (var i:int = 0; i < temp.length; i++) {
        if (emojis._[temp[i]]) arr.push(emojis.scale(emojis.getEmoji(emojis._[temp[i]])));
        else arr.push(temp[i]);
      }

      var phrase:String = "";
      var x:int = 0;
      var len:int = arr.length;
      for (i = 0; i < len; i++) {
        if (arr[i] is MovieClip) {
          if (phrase.length > 0) {
            var tf:TextField = renderer.text(phrase, x, 2, cfg.config.text_size, "left", cfg.config.w, 50, true);
            phrase = "";
            x += tf.textWidth;
          }
          arr[i].x = x;
          arr[i].y = 2;
          var lenn:int = Math.ceil(arr[i].width / curvu.spaceWidth) + 1;
          x += arr[i].width + (lenn / 1.5);
          emojes.push(arr[i]);

          // replace the emoji with a space
          var space:String = "";
          for (var j:int = 0; j < lenn; j++) space += "&nbsp;";
          tt = tt.replace(temp[i], space);
        } else phrase += arr[i] + " ";
      }

      message.htmlText = tt;
    }

    public function get height() : int {
      return this.message.height;
    }

    public function set height(value:int) : void {
      this.message.height = value;
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
