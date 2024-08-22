package {
  import flash.text.TextField;

  import utils.Timestamp;

  public class Message {
    public var channel:String;
    public var author:String;
    public var content:String;
    public var content_color:uint;
    public var author_color:uint;
    public var wasSent:Boolean;
    public var showAuthor:Boolean;
    public var lootbox:Boolean;

    private var message:TextField;

    private var format:Object = {
      "default": "[${CHANNEL}][${AUTHOR}]: ${CONTENT}",
      "toWhisper": "[${ME}]: ${CONTENT}",
      "fromWhisper": "[${AUTHOR}]: ${CONTENT}",
      "broadcast": " ${CONTENT}", // starts with a space to be pretty when added to the timestamp
      "lootbox": "[${CHANNEL}][${AUTHOR}]: ${CONTENT}",
      "me": "[${CHANNEL}] ${AUTHOR} ${CONTENT}",
      "timer": " ${AUTHOR} started a timer of ${CONTENT} seconds.", // same as broadcast
      "timer_going": " ${AUTHOR} timer is still going for ${CONTENT} seconds.", // saa
      "timer_end": " ${AUTHOR} GO! GO! GO!", // saa
      "dumb": "[${CHANNEL}][${AUTHOR}]: I'm dumb :)"
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
      this.message = renderer.text("", 5, 2, cfg.config.text_size, "left", cfg.config.w-5, 0, true);
    }

    public function formatMessage(fmt:String) : TextField {
      var text:String = renderer.colored(Timestamp.get() + format[fmt], renderer.rgbToHex(fmt == "me" ? curvu.users[author] || author_color : fmt == "timer" || fmt == "timer_going" || fmt == "timer_end" ? renderer.RED : content_color));

      // Replace the placeholders
      text = text.replace("${CHANNEL}", channel);
      text = text.replace("${ME}", renderer.colored("me", renderer.rgbToHex(author_color)));
      text = text.replace("${AUTHOR}", renderer.colored(author, renderer.rgbToHex(curvu.users[author] || author_color)));
      text = text.replace("${CONTENT}", content);

      message.htmlText = text;
      message.height = message.textHeight;

      return this.message;
    }

    public function get height() : int {
      return this.message.height;
    }

    public function toString() : TextField {
      var fmt:String = "default";

      if(this.author != "") {
        if(this.channel.length <= 0)
          fmt = (this.wasSent) ? "toWhisper" : "fromWhisper";

        if(this.author.length > 0 && this.showAuthor && this.lootbox)
          fmt = "lootbox"
      }

      if(this.channel.length <= 0 && this.author.length <= 0)
        fmt = "broadcast";

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

      return this.formatMessage(fmt);
    }
  }
}
