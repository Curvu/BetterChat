package {
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.external.ExternalInterface;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.ui.Keyboard;

  public class ChatInput extends MovieClip {
    public var defaultChannelTextField:TextField;
    public var inputText:TextField;

    public function ChatInput() {
      super();
      addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(e:Event) : void {
      this.y = curvu.Y_EXPANDED + cfg.config.h_expanded - 2;
      this.visible = false;
      this.inputText.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
      ExternalInterface.addCallback("setDefaultChannel", this.setDefaultChannel);
      ExternalInterface.addCallback("setInput", this.setInput);
      ExternalInterface.addCallback("getInput", this.getInput);
      removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onKeyPressed(e:KeyboardEvent) : void {
      if(e.keyCode == Keyboard.ENTER) {
        if(curvu.cmd.checkCommand(this.inputText.text)) return;
        ExternalInterface.call("OnExecute", (curvu.chat.current_tab == "ALL" ? "" : "/w " + curvu.chat.current_tab + " ") + this.inputText.text);
      } else if(e.keyCode == Keyboard.SPACE && curvu.chat.current_tab == "ALL") {
        ExternalInterface.call("OnAutocomplete", this.inputText.text);
      } else if(e.keyCode == Keyboard.TAB) {
        // ExternalInterface.call("OnCycleWhisperTarget", this.inputText.text); -> very lagged
        if(stage.focus != this.inputText) {
          stage.focus = this.inputText;
          this.inputText.setSelection(this.inputText.text.length, this.inputText.text.length);
          e.stopPropagation();
        }
        // ExternalInterface.call("OnTabAutocomplete", this.inputText.text);
      } else if(e.keyCode == Keyboard.UP) {
        ExternalInterface.call("OnCycleInputHistory", -1);
      } else if(e.keyCode == Keyboard.DOWN) {
        ExternalInterface.call("OnCycleInputHistory", 1);
      }
    }

    public function onSetActive(state:Boolean) : void {
      stage.focus = state ? this.inputText : null;
      this.inputText.text = "";
      this.visible = state;
    }

    public function setInput(text:String) : void {
      if(text.length < 257) this.inputText.text = text;
      this.inputText.setSelection(this.inputText.text.length,this.inputText.text.length);
      stage.focus = this.inputText;
    }

    private function getInput() : String {
      return this.inputText.text;
    }

    public function getDefaultChannel() : String {
      return this.defaultChannelTextField.text;
    }

    public function getDefaultChannelColor() : uint {
      return this.defaultChannelTextField.textColor;
    }

    public function setDefaultChannel(channel:String, color:uint) : void {
      this.defaultChannelTextField.text = channel;

      var channelFormat:TextFormat = new TextFormat();
      channelFormat.size = cfg.config.text_size;
      // var arrowFormat:TextFormat = new TextFormat();
      // arrowFormat.size = cfg.config.text_size - 3;
      // arrowFormat.bold = true;

      this.defaultChannelTextField.width = this.defaultChannelTextField.textWidth + 5;
      this.inputText.x = this.defaultChannelTextField.x + this.defaultChannelTextField.width;
      this.inputText.width = cfg.config.w - this.inputText.x;
      this.defaultChannelTextField.textColor = color;

      // this.defaultChannelTextField.setTextFormat(channelFormat);
      // this.inputText.setTextFormat(channelFormat);
      // this.defaultChannelTextField.setTextFormat(arrowFormat, channel.length, channel.length + 2);
      // this.defaultChannelTextField.y = this.inputText.y = (this.height - this.defaultChannelTextField.textHeight) / 2;

      if (this.defaultChannelTextField.text != "Whisper")
        curvu.chat.refreshSavedChannel();
    }
  }
}
