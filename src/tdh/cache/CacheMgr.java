package tdh.cache;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import tdh.util.ClassLoaderUtil;
import tdh.util.Print;
import tdh.util.xml.XMLDocument;
import tdh.util.xml.XMLNode;

public class CacheMgr {

  private List<CacheTab> list_init = new ArrayList<CacheTab>();

  /**
   * 根据缓存配置文件加载缓存
   * 
   * @author 仇国庆
   * @date 2014-5-26
   */
  public void startCache() {

    XMLDocument xml = new XMLDocument();

    String configFile = null;
    try {
      URL url = ClassLoaderUtil.getExtendResource("../config/cache.xml");
      configFile = url.getPath();
    } catch (MalformedURLException e1) {
      Print.print("[读取cache配置文件错误----->] " + e1.getMessage());
      e1.printStackTrace();
    }

    Print.print("[加载缓存文件----->] " + configFile);

    // String configFile = "D:/TDHWORK/zcxt/src/tdh/cache/cache.xml";
    InputStream in = null;
    try {
      in = new FileInputStream(configFile);
      xml.loadFromInputStream(in);
      XMLNode node = xml.getRoot();
      XMLNode[] cachenodeS = node.getAllChildNode();
      for (XMLNode node_c : cachenodeS) {
        CacheTab cacheTab = new CacheTab(node_c);
        cacheTab.init();

        cacheTab.load();
        cacheTab.gen2Cache();

        list_init.add(cacheTab);

      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (in != null) {
        try {
          in.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }

//    getYhxm();
  }

  /**
   * 获取已缓存的table
   * 
   * @param tabName 表名
   * @param db jdbc配置文件中对应的数据库key
   * @return 缓存对象
   * @author 仇国庆
   * @date 2014-5-26
   */
  public CacheTab getCacheTab(String tabName, String db) {
    for (CacheTab cacheTab : list_init) {
      if (tabName.equals(cacheTab.getTabName()) && db.equals(cacheTab.getDb()))
        return cacheTab;
    }

    Print.print(db + "." + tabName + "：没有配置缓存");
    throw new RuntimeException(db + "." + tabName + "：没有配置缓存");
  }

  /**
   * 获取已缓存的table中的二级缓存Map
   * 
   * @param tabName 表名
   * @param db jdbc配置文件中对应的数据库key
   * @param mapName 二级缓存Map对应的名称
   * @return 二级缓存Map
   * @author 仇国庆
   * @date 2014-5-26
   */
  public CacheMap getCacheMap(String tabName, String db, String mapName) {
    CacheTab cacheTab = getCacheTab(tabName, db);
    if (cacheTab == null) {
      Print.print(db + "." + tabName + "：没有配置缓存");
      throw new RuntimeException(db + "." + tabName + "：没有配置缓存");
    }

    CacheMap cacheMap = cacheTab.getMap_cache_2().get(mapName);
    if (cacheMap == null) {
      Print.print(db + "." + tabName + "：没有配置缓存-" + mapName);
      throw new RuntimeException(db + "." + tabName + "：没有配置缓存-" + mapName);
    }
    
    return cacheMap;
  }

  /**
   * 重新加载缓存数据
   * 
   * @param tabName 表名
   * @param db jdbc配置文件中对应的数据库key
   * @author 仇国庆
   * @date 2014-5-26
   */
  public void reloadCacheTab(String db, String tabName) {
    for (CacheTab cacheTab : list_init) {
      if (tabName.equals(cacheTab.getTabName()) && db.equals(cacheTab.getDb())) {
        cacheTab.reload();
      }
    }

    Print.print(db + "." + tabName + "：没有配置缓存");
    throw new RuntimeException(db + "." + tabName + "：没有配置缓存");
  }
  
  public void reloadCache() {
    for (CacheTab cacheTab : list_init) {
      if (cacheTab.isNeedReload()) {
        cacheTab.reload();
      }
    }
  }
  
  private volatile static CacheMgr uniqueInstance = new CacheMgr();

  private CacheMgr() {
  }

  public static CacheMgr getInstance() {
    return uniqueInstance;
  }

  

  private void getYhxm() {
    String yhdm = "320100sar";
    Map<String, Object> map = getCacheMap("T_USER", "frame", "convert").getMap();
    Map<String, Object> map_date = map.get(yhdm) == null ? null : (Map<String, Object>) map.get(yhdm);

    if (map_date == null) {
      System.out.println("无法翻译");
      
      // 无法翻译时通知重新加载缓存
      getCacheTab("T_USER", "frame").setNeedReload(true);
      
    } else {
      System.out.println("翻译:" + map_date.get("YHXM"));
    }
  }

  public static void main(String[] args) {
    CacheMgr cacheMgr = CacheMgr.getInstance();
    cacheMgr.startCache();
  }

}