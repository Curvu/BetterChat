package {
  import flash.external.ExternalInterface;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  import components.Party;

  public class Command {
    public var blockPrint:Boolean = false;
    public var zenMode:Boolean = false;
    public var whoCommandSent:Boolean = false;
    public var whoCounter:uint = 0;
    public var whoTimer:Timer = new Timer(77, 1);
    public var statsCommandSent:Boolean = false;
    public var searchedStat:String = "#";
    public var statsCounter:uint = 0;
    public var statsTimer:Timer = new Timer(77, 1);
    public var ignoreWho:Boolean = false;

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
      case "stats":
        if (args.length > 0) {
          this.statsCommandSent = true;
          this.searchedStat = args.join(" ").toLowerCase();
        }
        ExternalInterface.call("OnExecute", "/stats");
        break;
      case "party":
        if (!curvu.party) {
          curvu.party = new Party();
          curvu.chat.addChild(curvu.party);
        }
        curvu.party.visible = true;
        if (args.length > 0) {
          var arr:Array = args[0].split(";");
          for (var i in arr) curvu.party.addToParty(arr[i]);
        }
        break;
      case "/party": // add to party everyone that is in the //who command
        if (!curvu.party) {
          curvu.party = new Party();
          curvu.chat.addChild(curvu.party);
        }
        curvu.party.visible = true;
        this.ignoreWho = true;
        this.blockPrint = true;
        this.whoCommandSent = true;
        ExternalInterface.call("OnExecute", "/who");
        break;
      case "clear":
        curvu.chat.clear();
        break;
      case "zen":
        this.zenMode = !this.zenMode;
        curvu.chat.addExternalMessage("Zen mode " + (this.zenMode ? "enabled." : "disabled."));
        break;
      case "help":
        printHelp();
        break;
      case "config":
        // Print the config
        if (args.length == 0) {
          printConfig();
          break;
        }

        // Set the config
        if (args.length != 2) {
          curvu.chat.addExternalMessage("Syntax: /config {key} {new_value}");
          break;
        }

        var key:String = args[0];
        var value:String = args[1];
        if (cfg.config[key] == undefined) {
          curvu.chat.addExternalMessage("Invalid key: " + key);
          break;
        }

        cfg.onLoadModConfig(key, value);
        curvu.chat.reload();
        cfg.saveConfig(key);
        break;
      default:
        ExternalInterface.call("OnExecute", "/" + cmd + " " + args.join(" "));
        return true;
      }
      ExternalInterface.call("OnExecute", " ");
      return true;
    }

    public function whoCounterOutput(e:TimerEvent) {
      this.whoCommandSent = false;
      this.blockPrint = false;
      if (!this.ignoreWho) curvu.chat.addExternalMessage("There are " + this.whoCounter + " players in the world.");
      this.ignoreWho = false;
    }

    public function statsCounterOutput(e:TimerEvent) {
      this.statsCommandSent = false;
      this.searchedStat = "#";
      if (this.statsCounter == 0) curvu.chat.addExternalMessage("No stats found for " + this.searchedStat + ".");
      this.statsCounter = 0;
    }

    public function startTimer(number:uint, message:Message) {
      var timer:Timer = new Timer(1000, number);
      timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent) {
        // edit the message content to show the countdown
        message.content = "" + (number - timer.currentCount);
        message.formatMessage(timer.currentCount != number ? "timer_going" : "timer_end");
        curvu.chat.renderMessages(curvu.chat.indexScroll);
        ExternalInterface.call("POST_SOUND_EVENT", timer.currentCount == number ? cfg.config.sound_timer_finished : cfg.config.sound_timer);
      });
      timer.start();
    }

    private function printHelp() {
      curvu.chat.addExternalMessage("New commands:");
      curvu.chat.addExternalMessage(" //who - Prints the number of players in the world");
      curvu.chat.addExternalMessage(" /stats {lookup} - Prints the stats for the given lookup");
      curvu.chat.addExternalMessage(" /party {name1;name2;...} - Adds the given names to the party list");
      curvu.chat.addExternalMessage(" //party - Add everyone that are in the world to the party list");
      curvu.chat.addExternalMessage(" /clear - Clears the chat");
      curvu.chat.addExternalMessage(" /zen - Toggles zen mode (disable/enable chat)");
      curvu.chat.addExternalMessage(" /config - Prints the current config");
      curvu.chat.addExternalMessage(" /config {key} {new_value} - Sets the config key to the new value");
      curvu.chat.addExternalMessage(" timer/{number} - Starts a countdown timer in the interval [1, 25]");
      curvu.chat.addExternalMessage(" me/ {message} - Sends a message with the same color of your name");
    }

    private function printConfig() {
      curvu.chat.addExternalMessage("Current config:");
      var temp:Vector.<String>;
      for (var key:String in cfg.config) {
        if (cfg.convert[key][0] == cfg.TYPE.MAP) {
          temp = new Vector.<String>();
          for (var k:String in cfg.config[key]) temp.push(k + ":" + cfg.config[key][k]);
          curvu.chat.addExternalMessage(key + " = " + temp.join(","));
          continue;
        } else if (cfg.convert[key][0] == cfg.TYPE.LIST) {
          curvu.chat.addExternalMessage(key + " = " + cfg.config[key].join(","));
          continue;
        }
        curvu.chat.addExternalMessage(key + " = " + cfg.config[key]);
      }
    }
  }
}