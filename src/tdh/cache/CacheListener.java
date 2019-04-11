package tdh.cache;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class CacheListener implements ServletContextListener  {

  public void contextInitialized(ServletContextEvent event) {
    CacheMgr cacheMgr = CacheMgr.getInstance();
    cacheMgr.startCache();
  }

  public void contextDestroyed(ServletContextEvent event) {
  }

}
