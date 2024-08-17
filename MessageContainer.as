package {
  import flash.external.ExternalInterface;
  import flash.text.TextField;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  import components.Button;

  public class MessageContainer extends Sprite {
    private var message:Message;
    private var bg:Sprite;

    public function MessageContainer(channel:String, author:String, content:String, content_color:uint, author_color:uint, wasSent:Boolean, showAuthor:Boolean = true, lootbox:Boolean = false) {
      this.message = new Message(channel, author, content, content_color, author_color, wasSent, showAuthor, lootbox);
      this.addChild(this.message.toString());

      this.bg = renderer.rectangle(new Sprite(), 0, 0, curvu.W, this.message.height+5, 0, 0.5);
      this.addChildAt(this.bg, 0);
    }

    public function shouldAdd() : Boolean {
      if (!(curvu.cmd.whoCommandSent && this.message.channel == "" && this.message.content.indexOf(": (") > -1))
        return true;

      curvu.cmd.whoCounter++;
      if (curvu.cmd.whoTimer != null) {
        curvu.cmd.whoTimer.stop();
        curvu.cmd.whoTimer.addEventListener(TimerEvent.TIMER, curvu.cmd.whoCounterOutput);
        curvu.cmd.whoTimer.start();
      }
      return !curvu.cmd.blockPrint;
    }

    public function set theme(t:Boolean) : void {
      this.bg.transform.colorTransform = renderer.hexToRGB(t ? renderer.GRAY_12 : renderer.GRAY_28);
    }

    public function get author() : String {
      return this.message.author;
    }

    public function get channel() : String {
      return this.message.channel;
    }
  }
}
