package {
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.external.ExternalInterface;
  import flash.text.TextField;
  import flash.ui.Keyboard;
  import flash.text.TextFormat;

  public class ChatInput extends MovieClip {
    public var defaultChannelTextField:TextField;
    public var inputText:TextField;

    public function ChatInput() {
      super();
      addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(e:Event) : void {
      this.y = curvu.Y + curvu.H - 2;

      this.visible = curvu.DEBUG;
      this.inputText.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
      ExternalInterface.addCallback("setDefaultChannel", this.setDefaultChannel);
      ExternalInterface.addCallback("setInput", this.setInput);
      ExternalInterface.addCallback("getInput", this.getInput);
      removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);

      if (curvu.DEBUG)
        this.setDefaultChannel("General", renderer.WHITE);
    }

    private function onKeyPressed(e:KeyboardEvent) : void {
      if(e.keyCode == Keyboard.ENTER) {
        if(curvu.cmd.checkCommand(this.inputText.text)) return;
        if(curvu.DEBUG) curvu.chat.addMessage(0, "World", "Jus7Ace", this.inputText.text, renderer.WHITE, renderer.WHITE, false, true, false);
        ExternalInterface.call("OnExecute", this.inputText.text);
      } else if(e.keyCode == Keyboard.SPACE) {
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

    private function setDefaultChannel(channel:String, color:uint) : void {
      this.defaultChannelTextField.text = channel + " >";

      var channelFormat:TextFormat = new TextFormat();
      channelFormat.size = curvu.TEXT_SIZE;
      var arrowFormat:TextFormat = new TextFormat();
      arrowFormat.size = curvu.TEXT_SIZE - 3;
      arrowFormat.bold = true;

      this.defaultChannelTextField.width = this.defaultChannelTextField.textWidth;
      this.inputText.x = this.defaultChannelTextField.x + this.defaultChannelTextField.width;
      this.inputText.width = curvu.W - this.inputText.x;
      this.defaultChannelTextField.textColor = color;

      this.defaultChannelTextField.setTextFormat(channelFormat);
      this.inputText.setTextFormat(channelFormat);
      this.defaultChannelTextField.setTextFormat(arrowFormat, channel.length, channel.length + 2);

      this.defaultChannelTextField.y = this.inputText.y = (this.height - this.defaultChannelTextField.textHeight) / 2;
    }
  }
}
