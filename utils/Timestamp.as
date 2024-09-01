package utils {
  public class Timestamp {
    public static function get() : String {
      var text:String = cfg.config.timestamp_fmt;
      var date:Date = new Date();
      var hours:String = ((date.hours < 10) ? "0" + date.hours : date.hours.toString());
      var minutes:String = ((date.minutes < 10) ? "0" + date.minutes : date.minutes.toString());
      var seconds:String = (date.seconds < 10) ? "0" + date.seconds : date.seconds.toString();
      text = text.replace("HH", hours);
      text = text.replace("MM", minutes);
      text = text.replace("SS", seconds);

      return text;
    }
  }
}