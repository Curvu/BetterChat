package {
  import flash.external.ExternalInterface;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  public class Command {
    public var blockPrint:Boolean = false;
    public var zenMode:Boolean = false;
    public var whoCommandSent:Boolean = false;
    public var whoCounter:uint = 0;
    public var whoTimer:Timer = new Timer(77, 1);

    public function Command() {
      super();
    }

    public function checkCommand(input:String) {
      if(input.charAt(0) != "/") return false;
      var args:Array = input.split(" ");
      var cmd:String = args.shift().substr(1).toLowerCase();
      cmd = cfg.config.aliases[cmd] || cmd;

      switch(cmd) {
      case "/who":
        this.blockPrint = true;
      case "who":
        this.whoCounter = 0;
        this.whoCommandSent = true;
        ExternalInterface.call("OnExecute", "/who");
        break;
      case "clear":
        curvu.chat.clear();
        ExternalInterface.call("OnExecute", " ");
        break;
      case "zen":
        this.zenMode = !this.zenMode;
        curvu.chat.addExternalMessage("Zen mode " + (this.zenMode ? "enabled." : "disabled."));
        ExternalInterface.call("OnExecute", " ");
        break;
      case "help":
        printHelp();
        ExternalInterface.call("OnExecute", " ");
        break;
      default:
        ExternalInterface.call("OnExecute", "/" + cmd + " " + args.join(" "));
      }
      return true;
    }

    public function whoCounterOutput(e:TimerEvent) {
      this.whoCommandSent = false;
      this.blockPrint = false;
      curvu.chat.addExternalMessage("There are " + this.whoCounter + " players in the world.");
    }

    public function startTimer(number:uint, message:Message) {
      var timer:Timer = new Timer(1000, number);
      timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent) {
        // edit the message content to show the countdown
        message.content = "" + (number - timer.currentCount);
        message.formatMessage(timer.currentCount != number ? "timer_going" : "timer_end");
        curvu.chat.renderMessages(curvu.chat.indexScroll);
        ExternalInterface.call("POST_SOUND_EVENT", cfg.config.sound_timer);
      });
      timer.start();
    }

    private function printHelp() {
      curvu.chat.addExternalMessage("New commands:");
      curvu.chat.addExternalMessage(" //who - Prints the number of players in the world");
      curvu.chat.addExternalMessage(" /clear - Clears the chat");
      curvu.chat.addExternalMessage(" /zen - Toggles zen mode (disable/enable chat)");
      curvu.chat.addExternalMessage(" timer/{number} - Starts a countdown timer in the interval [1, 25]");
      curvu.chat.addExternalMessage(" me/ {message} - Sends a message with the same color of your name");
    }
  }
}