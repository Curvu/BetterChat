package utils {
  public class Timestamp {
    public static function get() : String {
      if (!cfg.config.show_hours && !cfg.config.show_minutes && !cfg.config.show_seconds) return "";
      var date:Date = new Date();
      var hours:String = ((date.hours < 10) ? "0" + date.hours : date.hours.toString()) + ":";
      var minutes:String = ((date.minutes < 10) ? "0" + date.minutes : date.minutes.toString()) + ((cfg.config.show_seconds) ? ":" : "");
      var seconds:String = (date.seconds < 10) ? "0" + date.seconds : date.seconds.toString();

      hours = (cfg.config.show_hours) ? hours : "";
      minutes = (cfg.config.show_minutes) ? minutes : "";
      seconds = (cfg.config.show_seconds) ? seconds : "";

      return "[" + hours + minutes + seconds + "]";
    }
  }
}