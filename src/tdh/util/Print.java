package tdh.util;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class Print {
  private static final Log LOG = LogFactory.getLog(Print.class);

  // Print with a newline:
  public static void print(Object obj) {
//    System.out.println("[ZCXT] " + CommUtils.dateFormat(new Date(), "yyyy-MM-dd HH:mm:ss") + " --> " + obj);
    LOG.info(" --> " + obj);

  }

  // Print a newline by itself:
  public static void print() {
    System.out.println();
  }

  // Print with no line break:
  public static void printnb(Object obj) {
//    System.out.print("[ZCXT] " + CommUtils.dateFormat(new Date(), "yyyy-MM-dd HH:mm:ss") + " --> " + obj);
    LOG.info(" --> " + obj);

  }

  // The new Java SE5 printf() (from C):
  // public static PrintStream printf(String format, Object... args) {
  // return System.out.printf(format, args);
  // }
}
