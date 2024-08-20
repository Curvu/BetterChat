package utils {
  public class Timestamp {
    public static function get() : String {
      var date:Date = new Date();
      var hours:String = (date.hours < 10) ? "0" + date.hours : date.hours.toString();
      var minutes:String = (date.minutes < 10) ? "0" + date.minutes : date.minutes.toString();
      var seconds:String = (date.seconds < 10) ? "0" + date.seconds : date.seconds.toString();

      return cfg.config.TIMESTAMP_FMT.replace("${HOURS}", hours).replace("${MINUTES}", minutes).replace("${SECONDS}", seconds);
    }
  }
}