package {
  import flash.external.ExternalInterface;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  // TODO: Popular chats

  public class Command {
    public var blockPrint:Boolean = false;
    public var zenMode:Boolean = false;
    public var whoCommandSent:Boolean = false;
    public var whoCounter:uint = 0;
    public var whoTimer:Timer = new Timer(77, 1);

    private var aliases:Object = {
      "fx0": "fxenable 0",
      "fx1": "fxenable 1"
    };

    public function Command() {
      super();
    }

    public function checkCommand(input:String) {
      if(input.charAt(0) != "/") return false;
      var args:Array = input.split(" ");
      var cmd:String = args.shift().substr(1).toLowerCase();
      cmd = this.aliases[cmd] || cmd;

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
      case "config":
        printConfig();
        ExternalInterface.call("OnExecute", " ");
        break;
      default:
        if((cmd == "w" || cmd == "whisper") && args.length > 1)
          curvu.chat.current_tab = args[0];
        ExternalInterface.call("OnExecute", "/" + cmd + " " + args.join(" "));
      }
      return true;
    }

    public function whoCounterOutput(e:TimerEvent) {
      this.whoCommandSent = false;
      this.blockPrint = false;
      curvu.chat.addExternalMessage("There are " + this.whoCounter + " players in the world.");
    }

    public function startTimer(number:uint) {
      var timer:Timer = new Timer(1000, number);
      timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent) {
        if(timer.currentCount != number) curvu.chat.addExternalMessage("" + (number - timer.currentCount));
        else curvu.chat.addExternalMessage("GO! GO! GO!");
      });
      timer.start();
    }

    private function printConfig() {
      curvu.chat.addExternalMessage("Config:");
      curvu.chat.addExternalMessage("W: " + cfg.config.W);
      curvu.chat.addExternalMessage("H: " + cfg.config.H);
      curvu.chat.addExternalMessage("H_EXPANDED: " + cfg.config.H_EXPANDED);
      curvu.chat.addExternalMessage("TEXT_SIZE: " + cfg.config.TEXT_SIZE);
      curvu.chat.addExternalMessage("MAX_MESSAGES: " + cfg.config.MAX_MESSAGES);
      curvu.chat.addExternalMessage("SOUND_WHISPER: " + cfg.config.SOUND_WHISPER);
      curvu.chat.addExternalMessage("TIMESTAMP_FMT: " + cfg.config.TIMESTAMP_FMT);
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