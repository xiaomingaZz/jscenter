package tdh.web;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import tdh.core.db.DataSourceManager;


public class WebInitContextListener implements ServletContextListener {
  public void contextInitialized(ServletContextEvent sce) {
    WebAppContext.bindServletContext(sce.getServletContext());

    //DataSourceManager.getInstnace().Starup();
  }

  public void contextDestroyed(ServletContextEvent sce) {
    //DataSourceManager.getInstnace().Shutdown();

    WebAppContext.removeServletContext();
  }

}
