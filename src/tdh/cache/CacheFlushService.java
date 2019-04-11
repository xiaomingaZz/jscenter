package tdh.cache;


public class CacheFlushService {

  public static boolean isRun = false;

  public void reloadCache() {
    if (isRun)
      return;

    isRun = true;
    
    CacheMgr cacheMgr = CacheMgr.getInstance();
    cacheMgr.reloadCache();

    isRun = false;
  }

}