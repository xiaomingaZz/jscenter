package tdh.web;

import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.sql.DataSource;

import org.springframework.web.context.support.WebApplicationContextUtils;

public class WebAppContext {
  private static ServletContext webcxt;

  protected static void bindServletContext(ServletContext cxt) {
    webcxt = cxt;
  }

  public static ServletContext getServletContextEx() {
    return webcxt;
  }

  protected static void removeServletContext() {
    webcxt = null;
  }

  /**
   * 从Spring容器内获取一个Bean
   * 
   * @param beanName bean定义的名称
   * @return Object对象
   */
  public static <T> T getBeanEx(String beanName) {
    return getBeanEx(getServletContextEx(), beanName);
  }

  @SuppressWarnings("unchecked")
  public static <T> T getBeanEx(ServletContext sc, String beanName) {
    return (T) WebApplicationContextUtils.getRequiredWebApplicationContext(sc).getBean(beanName);
  }
  
  /**
   * 获取一个全新的数据库连接.
   * 
   * @param dataName
   * @return
   */
  public static Connection getNewConn(String dataName){
    try {
      return ((DataSource) getBeanEx(dataName)).getConnection();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return null;
  }

}
