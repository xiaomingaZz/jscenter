package tdh.cache;

import java.util.concurrent.ConcurrentHashMap;

public class CacheMap {
  // 
  private String mapName;

  // 
  private String key;

  private String keySp;

  private ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<String, Object>();

  public String getMapName() {
    return mapName;
  }

  public void setMapName(String mapName) {
    this.mapName = mapName;
  }

  public String getKey() {
    return key;
  }

  public void setKey(String key) {
    this.key = key;
  }

  public String getKeySp() {
    return keySp;
  }

  public void setKeySp(String keySp) {
    this.keySp = keySp;
  }

  public ConcurrentHashMap<String, Object> getMap() {
    return map;
  }

  public void setMap(ConcurrentHashMap<String, Object> map) {
    this.map = map;
  }

}
