package tdh.cache;

import java.io.FileInputStream;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import tdh.core.jdbc.JdbcCore;
import tdh.util.ClassLoaderUtil;
import tdh.util.DBUtils;
import tdh.util.JSUtils;
import tdh.util.Print;
import tdh.util.xml.XMLNode;

public class CacheTab {
  // 表名
  private String tabName;

  // 数据库
  private String db;

  // 列名A, B, C
  private String col;
  
  // 排序
  private String order;
  

  // 完整SQL
  String sql = "";

  // 加载时间
  private long loadtime= 0l;
  
  // 是否需要重新加载
  private boolean needReload = false;
  
  private List<Map<String, Object>> list;

  // 二级缓存
  private ConcurrentHashMap<String, CacheMap> map_cache_2 = new ConcurrentHashMap<String, CacheMap>();

  public String getTabName() {
    return tabName;
  }

  public String getDb() {
    return db;
  }

  public void setCol(String col) {
    this.col = col;
  }
  
  public void setOrder(String order) {
    this.order = order;
  }

  public List<Map<String, Object>> getList() {
    return list;
  }

  /**
   * 参数初始化
   * @param node_c
   */
  public CacheTab(XMLNode node_c) {
    String tabName = JSUtils.trim(node_c.getAttributeValue("tabName"));
    String db = JSUtils.trim(node_c.getAttributeValue("db"));
    String col = JSUtils.trim(node_c.getAttributeValue("col"));
    String order = JSUtils.trim(node_c.getAttributeValue("order"));
    

    this.tabName = tabName;
    this.db = db;
    this.col = col;
    this.order = order;
    

    XMLNode[] node_m_arr = node_c.getAllChildNode();
    for (XMLNode node_m : node_m_arr) {

      String mapName = JSUtils.trim(node_m.getAttributeValue("mapName"));
      String key = JSUtils.trim(node_m.getAttributeValue("key"));
      String keySp = JSUtils.trim(node_m.getAttributeValue("keySp"));

      CacheMap cacheMap = new CacheMap();
      cacheMap.setMapName(mapName);
      cacheMap.setKey(key);
      cacheMap.setKeySp(keySp);

      map_cache_2.put(mapName, cacheMap);
    }

  }

  /**
   * 参数初始化
   * 
   * @author 仇国庆 
   * @date 2014-5-27
   */
  public void init() {
    String c = JSUtils.trim(this.col);
    if (c.length() == 0)
      c = " * ";

    this.sql = "select " + c + " from " + this.tabName + " " + this.order;
  }

  
  /**
   * 加载一级缓存
   * 
   * @author 仇国庆 
   * @date 2014-5-27
   */
  public void load() {
    Connection conn = null;
    List<Map<String, Object>> list_data = null;
    try {

      // 根据db获取conn
      conn = getConn(this.db);
      list_data = JdbcCore.queryForList(this.sql, conn);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DBUtils.closeConn(conn);
    }
    this.list = list_data;
    this.loadtime = new Date().getTime();
    
    Print.print("[加载一级缓存----->] " + this.db + "." + this.tabName);
  }
  
  
  /**
   * 重新加载缓存表数据，同时应用到二级缓存
   * 此处需要控制读取，写入的并发性
   * 
   * @author 仇国庆 
   * @date 2014-5-26
   */
  public void reload() {
    Print.print("[更新缓存start----->] " + this.db + "." + this.tabName);
    
    Connection conn = null;
    List<Map<String, Object>> list_data = null;
    try {

      // 根据db获取conn
      conn = getConn(this.db);
      list_data = JdbcCore.queryForList(this.sql, conn);

    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DBUtils.closeConn(conn);
    }
    
    // 更新主缓存数据
    this.list = list_data;
    this.loadtime = new Date().getTime();
    
    // 更新二级缓存数据
    gen2Cache();
    
    // 更新缓存结束...
    Print.print("[更新缓存end<-----] " + this.db + "." + this.tabName);
    
    // 重置需要加载标志
    setNeedReload(false);
  }

  /**
   * 加载二级缓存
   * 
   * @author 仇国庆 
   * @date 2014-5-27
   */
  public void gen2Cache() {
    for (Map<String, Object> map_data : this.list) {

      Set<ConcurrentHashMap.Entry<String, CacheMap>> entryseSet = map_cache_2.entrySet();
      for (ConcurrentHashMap.Entry<String, CacheMap> entry : entryseSet) {
        CacheMap cacheMap = entry.getValue();

        // 二级缓存Map
        ConcurrentHashMap<String, Object> map_2 = cacheMap.getMap();

        String keyS = cacheMap.getKey();
        String keySp = cacheMap.getKeySp();
        StringBuilder key_data = new StringBuilder();
        String[] keyArr = keyS.split(",");
        for (String keyCol : keyArr) {
          if (key_data.length() > 0)
            key_data.append(keySp);
          key_data.append(String.valueOf(map_data.get(keyCol)));
        }
        map_2.put(key_data.toString(), map_data);
      }
    }
    
    
    // 打印
    Set<ConcurrentHashMap.Entry<String, CacheMap>> entryseSet = map_cache_2.entrySet();
    for (ConcurrentHashMap.Entry<String, CacheMap> entry : entryseSet) {
      CacheMap cacheMap = entry.getValue();
      Print.print("[加载二级缓存----->] " + this.db + "." + this.tabName + "(" + cacheMap.getMapName() + ")");
    }
  }

  /**
   * 获取数据库连接
   * @param db 
   * @return
   * @author 仇国庆 
   * @date 2014-5-27
   */
  public static Connection getConn(String db) {
    Connection conn = null;
    InputStream in = null;
    try {

      String configFile = null;
      try {
        URL url = ClassLoaderUtil.getExtendResource("../config/jdbc.properties");
        configFile = url.getPath();
      } catch (MalformedURLException e1) {
        Print.print("[读取jdbc配置文件错误----->] "  + e1.getMessage());
        e1.printStackTrace();
      }
      in = new FileInputStream(configFile);
      Properties p = new Properties();
      p.load(in);
      String className = p.getProperty(db + ".driverClassName");
      String url = p.getProperty(db + ".url");
      String name = p.getProperty(db + ".username");
      String pass = p.getProperty(db + ".password");
      Class.forName(className);
      conn = DriverManager.getConnection(url, name, pass);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      JSUtils.closeStream(in);
    }
    return conn;
  }

  /**
   * 获取二级缓存列表
   * @return
   * @author 仇国庆 
   * @date 2014-5-27
   */
  public ConcurrentHashMap<String, CacheMap> getMap_cache_2() {
    return map_cache_2;
  }

  public boolean isNeedReload() {
    return needReload;
  }

  public void setNeedReload(boolean needReload) {
    this.needReload = needReload;
  }

}
