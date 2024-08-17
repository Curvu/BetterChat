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
      "toWhisper": "[To: ${AUTHOR}]: ${CONTENT}",
      "fromWhisper": "[From: ${AUTHOR}]: ${CONTENT}",
      "broadcast": " ${CONTENT}", // starts with a space to be pretty when added to the timestamp
      "lootbox": "[${CHANNEL}][${AUTHOR}]: ${CONTENT}",
      "me": "[${CHANNEL}] ${AUTHOR} ${CONTENT}",
      "timer": " ${AUTHOR} started a timer of ${CONTENT} seconds.", // same as broadcast
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
      this.message = renderer.text("", 5, 2, curvu.TEXT_SIZE, "left", curvu.W-5, 0, true);
    }

    private function formatMessage(fmt:String) : TextField {
      var text:String = renderer.colored(Timestamp.get() + this.format[fmt], renderer.rgbToHex(fmt == "me" ? this.author_color : fmt == "timer" ? renderer.RED : this.content_color));

      // Replace the placeholders
      text = text.replace("${CHANNEL}", this.channel);
      text = text.replace("${AUTHOR}", renderer.colored(this.author, renderer.rgbToHex(this.author_color)));
      text = text.replace("${CONTENT}", this.content);

      this.message.htmlText = text;
      this.message.height = this.message.textHeight;

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
          if (temp > 0 && temp < 26) curvu.cmd.startTimer(temp);
          else fmt = "dumb";
        }
      }

      return this.formatMessage(fmt);
    }
  }
}
