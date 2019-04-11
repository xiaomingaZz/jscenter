package tdh;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import tdh.frame.web.context.WebAppContext;
import tdh.spring.SpringContextHolder;
import tdh.util.ConsoleWirter;

public class InitService implements ServletContextListener{

	public void contextDestroyed(ServletContextEvent event) {
		ConsoleWirter.info("服务器已关闭!");
	}

	public void contextInitialized(ServletContextEvent event) {
		ConsoleWirter.info("正在启动调度平台...");
		SpringContextHolder.initContext(event.getServletContext());
		WebAppContext.bindServletContext(event.getServletContext());
	}

}
