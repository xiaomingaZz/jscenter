package tdh.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import tdh.cache.CacheMgr;
import tdh.frame.web.context.WebAppContext;
import tdh.framework.dao.springjdbc.JdbcTemplateExt;

public class JSUtils {
  private static final Log LOG = LogFactory.getLog(JSUtils.class);
  
  /**
   * 部署法院
   * 
   * @return
   */
  public static String getLoginFydm() {
    return "320000";
  }
  
  /**
   * 是否支持地图钻取
   * @return
   */
  public static boolean mapIn() {
      return true;
  }
  
  /**
   * URL解码
   * 
   * @param str 字符串
   * @return 解码后的字符串
   * @throws UnsupportedEncodingException 异常
   */
  public static String decodeURI(String str) throws UnsupportedEncodingException {
    str = JSUtils.trim(str);
    return URLDecoder.decode(str, "utf-8");
  }
  
  /**
   * jsp中错误信息记载
   * 
   * @param e
   *          异常
   */
  public static void err(Exception e) {
    LOG.error(e.getMessage(), e);
  }

  /**
   * form表单提交时,解析参数
   * 
   * @param name
   *          键
   * @param request
   *          请求
   * @return 值
   * 
   */
  public static String getPar(String name, HttpServletRequest request) {
    return JSUtils.trim(request.getParameter(name));
  }

  /**
   * 将String|Short,Integer,BigDecimal,Double类型值为0和null的转为空字符,用于页面显示.
   * 
   * @param val
   *          待处理参数
   * @return String 处理后用于显示的字符串
   */
  public static String convertZero(Object val) {
    if (val == null)
      return "";

    if (val instanceof String) {
      String str = (String) val;
      if (val == null || "0".equals(str) || "null".equals(str))
        return "";
      else
        return str;
    } else if (val instanceof Integer) {
      Integer i = (Integer) val;
      if (i == null || i.intValue() == 0) {
        return "";
      } else {
        return "" + i;
      }
    } else if (val instanceof Short) {
      Short s = (Short) val;
      if (s == null || s.shortValue() == 0) {
        return "";
      } else {
        return "" + s;
      }
    } else if (val instanceof BigDecimal) {
      BigDecimal bd = (BigDecimal) val;
      Double dou = bd.doubleValue();
      dou = round(dou, 2);
      if (Math.abs(dou) < 0.0001) {
        return "";
      } else {
        DecimalFormat df = new DecimalFormat("#0.00");
        return df.format(bd);
      }
    } else if (val instanceof Double) {
      Double dou = (Double) val;
      dou = round(dou, 2);
      if (dou == null || Math.abs(dou.doubleValue()) < 0.0001) {
        return "";
      } else {
        DecimalFormat df = new DecimalFormat("#0.00");
        return df.format(dou);
      }
    } else {
      return "";
    }
  }

  /**
   * 保留几位小数
   * 
   * @param v
   *          double
   * @param scale
   *          几位小数
   * @return 处理后的double
   * 
   */
  public static double round(double v, int scale) {
    if (scale < 0) {
      throw new IllegalArgumentException("The scale must be a positive integer or zero");
    }
    BigDecimal b = new BigDecimal(Double.toString(v));
    BigDecimal one = new BigDecimal("1");
    return b.divide(one, scale, BigDecimal.ROUND_HALF_UP).doubleValue();
  }

  /**
   * 关闭数据流
   * 
   * @param obj
   *          数据流
   */
  public static void closeStream(Object obj) {
    try {
      if (obj != null) {
        if (obj instanceof InputStream) {
          ((InputStream) obj).close();
        } else if (obj instanceof OutputStream) {
          ((OutputStream) obj).close();
        } else if (obj instanceof Reader) {
          ((Reader) obj).close();
        }
        obj = null;
      }
    } catch (IOException e) {
    }
  }

  /**
   * 辖区
   * 
   * @param fydm
   * @return
   */
  public static List<Map<String, Object>> getCity(String fydm) {
    return getCityWithMe(fydm, false);
  }

  /**
   * 本院+辖区
   * 
   * @param fydm
   * @return
   */
  public static List<Map<String, Object>> getCityWithMe(String fydm) {
    return getCityWithMe(fydm, true);
  }

  /**
   * 本院+辖区(是/否)
   * 
   * @param fydm
   * @param hasMe
   * @return
   */
  public static List<Map<String, Object>> getCityWithMe(String fydm, boolean hasMe) {
    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

    fydm = JSUtils.trim(fydm);
    if (fydm.length() == 0)
      return list;

    String fydm_head = fydm;
    String fydm_mc = "";
    if (fydm.endsWith("0000")) {
      fydm_head = fydm.substring(0, 2);
      fydm_mc = "高院";
    } else if (fydm.endsWith("00")) {
      fydm_head = fydm.substring(0, 4);
      fydm_mc = "中院";
    }
    if (fydm_mc.length() == 0) {
      fydm_mc = convertFyDc(fydm);
    }

    String sql = "select (DM_CITY) DM,(NAME_CITY)QHJC,FJM from DC_CITY where 1=1";
    if (fydm.endsWith("0000")) {
      sql += " and DM_CITY like '"+fydm_head+"%' and datalength(DM_CITY)=4";
    } else if (fydm.endsWith("00")) {
      sql += " and DM_CITY like '"+fydm_head+"%' and datalength(DM_CITY)=6";
    }
    sql += " order by FJM";
    
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    try {
      conn = DBUtils.getBiConn();
      pst = conn.prepareStatement(sql);
      rs = pst.executeQuery();
      while (rs.next()) {
        Map<String, Object> map = new HashMap<String, Object>();
        String dm = JSUtils.trim(rs.getString("DM"));
        if(!hasMe){
        	if(dm.endsWith("00")){
        		continue;
        	}
        }
        map.put("FYDM", JSUtils.numToStrN(dm, 6));
        map.put("QHJC", JSUtils.trim(rs.getString("QHJC")));
        
        list.add(map);
      }
      
    } catch (Exception e) {
      JSUtils.err(e);
    } finally {
      DBUtils.closeRs(rs);
      DBUtils.closeSt(pst);
      DBUtils.closeConn(conn);
    }

/*    if (hasMe) {
      Map<String, Object> map_top = new HashMap<String, Object>();
      map_top.put("FYDM", fydm);
      map_top.put("QHJC", fydm_mc);
      list.add(0, map_top);
    }*/

    return list;
  }

  /**
   * 获取服务器的http地址路径.
   * 
   * @param request
   *          请求.
   * @return http://localhost:8080/
   */
  public static String getContextURl(HttpServletRequest request) {
    return request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
  }


  /**
   * double 类型 格式化输出
   * 
   * @param num
   *          double类型;
   * @param 输出格式
   *          例如: "#0.00";
   * @return String 格式化后的字符串;
   */
  public static String convertDouble(Double num, String pattern) {
    if (num == null) {
      return "";
    }
    if (num == 0.00) {
      return "";
    }
    DecimalFormat df = new DecimalFormat();
    df.applyPattern(pattern);
    return df.format(num);
  }

  /**
   * 格式化时间
   * 
   * @param dt
   *          时间
   * @param fmt
   *          格式
   * @return 格式化的时间串
   */
  public static String dateFormat(Date dt, String fmt) {
    if (dt == null)
      return "";
    SimpleDateFormat sdf = new SimpleDateFormat(fmt);
    return sdf.format(dt);
  }

  /**
   * 数字转换成字符串.
   * 
   * @param ob
   *          int或者long型数值
   * @param cnt
   *          转换成字符串的位数,不足位前面补0.
   * @return 字符串.
   */
  public static String numToStrP(Object ob, int cnt) {
    StringBuilder formatStr = new StringBuilder();
    for (int i = 0; i < cnt; i++) {
      formatStr.append("0");
    }
    String tt = formatStr.toString() + String.valueOf(ob);
    int len = tt.length();
    return tt.substring(len - cnt, len);
  }
  
  
  /**
   * 数字转换成字符串.
   * 
   * @param ob int或者long型数值
   * @param cnt 转换成字符串的位数,不足位后面补0.
   * @return 字符串.
   */
  public static String numToStrN(Object ob, int cnt) {
    StringBuilder formatStr = new StringBuilder();
    for (int i = 0; i < cnt; i++) {
      formatStr.append("0");
    }
    String tt = String.valueOf(ob) + formatStr.toString();
    return tt.substring(0, cnt);
  }

  public static String trim(String str) {
    if (str == null || "null".equals(str)) {
      str = "";
    }
    return str.trim();
  }

  /**
   * 格式化数字，默认格式"#0.00
   */
  public static String formatDouble(Double d) {
    return formatDouble(d, "#0.00");
  }

  /**
   * 格式刷数字
   */
  public static String formatDouble(Double d, String format) {
    if (d == null)
      return "0.00";
    DecimalFormat df1 = new DecimalFormat(format);
    return df1.format(d);
  }

  /**
   * 翻译法院短称
   * 
   * @param dm
   * @return
   */
  public static String convertFyDc(String dm) {
    dm = JSUtils.trim(dm);
    if (dm.length() == 0)
      return "";

    CacheMgr cacheMgr = CacheMgr.getInstance();
    Map<String, Object> map = cacheMgr.getCacheMap("TS_FYMC", "dpzs", "convert1").getMap();
    Map<String, Object> map_data = map.get(dm) == null ? null : (Map<String, Object>) map.get(dm);
    if (map_data == null) {
      // 无法翻译时通知重新加载缓存
      cacheMgr.getCacheTab("TS_FYMC", "dpzs").setNeedReload(true);
      return dm;
    } else {
      return JSUtils.trim((String) map_data.get("FYDC"));
    }
  }
  
  public static Map<String,String> map_city = new HashMap<String, String>();
  public static Map<String,String> map_gz = new HashMap<String, String>();
  /**
   * 翻译DC_CITY名称
   * @param dm
   * @return
   */
  public static String convertCityByDm(String dm){
	  if(map_city==null||map_city.size()==0){
		  JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		  List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY");
		  for(Map<String,Object> map : fylist){
			  String dm_city = map.get("DM_CITY").toString();
			  String name_city = map.get("NAME_CITY").toString();
			  map_city.put(dm_city, name_city);
		  }
	  }
	  return JSUtils.trim(map_city.get(dm));
  }
  
  
  /**
   * 翻译DIM_JYGZ名称
   * @param dm
   * @return
   */
  public static String convertDmByGz(String gz){
	  if(map_gz==null||map_gz.size()==0){
		  JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		  List<Map<String,Object>> fylist = bi09.queryForList("select GZID ,GZMC from DIM_JYGZ");
		  for(Map<String,Object> map : fylist){
			  String dm_city = map.get("GZMC").toString();
			  String name_city = map.get("GZID").toString();
			  map_gz.put(dm_city, name_city);
		  }
	  }
	  return JSUtils.trim(map_gz.get(gz));
  }
  
  
  public static Map<String,String> map_dm = new HashMap<String, String>();
  /**
   * 根据NAME_CITY翻译获取DM_CITY(6位代码)
   * @param qhjc
   * @return
   */
  public static String convertFydmByQhjc(String qhjc){
	  if(map_dm==null||map_dm.size()==0){
		  JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		  List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY");
		  for(Map<String,Object> map : fylist){
			  String dm_city = map.get("DM_CITY").toString();
			  String name_city = map.get("NAME_CITY").toString();
			  map_dm.put(name_city, dm_city);
		  }
	  }
	  return JSUtils.numToStrN(trim(map_dm.get(qhjc)),6);
  }

  public static String buildYearOpts(int years) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
    String nowYear = sdf.format(new java.util.Date());
    StringBuilder opts = new StringBuilder();
    for (int i = 0; i < years; i++) {
      opts.append("<option value=\"" + (Integer.parseInt(nowYear) - i) + "\">");
      opts.append(Integer.parseInt(nowYear) - i).append("</option>");
    }
    return opts.toString();
  }

  public static final String fydm = "42";

  public static final String fymc = "湖北省";
  
  public static final String fjm = "H";

  public static final String[] MAP_COLOR_ARRAY = { "#FF7F50", "#da70d6", "#32cd32", "#6495ed", "#ff69b4", "#ba55d3", "#cd5c5c", "#ffa500", "#40e0d0", "#1e90ff", "#ff6347", "#7b68ee", "#00fa9a", "#ffd700", "#6b8e23", "#ff00ff", "#3cb371", "#b8860b", "#30e0e0" };

  public static final String COLOR_STR = "'#FF7F50', '#da70d6', '#32cd32', '#6495ed','#ff69b4', '#ba55d3', '#cd5c5c', '#ffa500','#40e0d0','#1e90ff', '#ff6347', '#7b68ee', '#00fa9a', '#ffd700','#6b8e23', '#ff00ff', '#3cb371', '#b8860b', '#30e0e0'";

  /** 
	 * 中心库 bean 
	 */ 
	public static final String DBC_JDBCTEMPLATE_EXT="DbcjdbcTemplateExt";  
	/** 
	 * TR_DD bean 
	 */ 
	public static final String XDB_JDBCTEMPLATE_EXT="XdbjdbcTemplateExt"; 
	/**
	 * 中心库 分页bean
	 */
	public static final String DbcPaginateJdbc="DbcPaginateJdbc";  
	/** 
	 * TR_DD 分页bean 
	 */ 
	public static final String XdbPaginateJdbc="XdbPaginateJdbc";  
	public static final String DBC_DATASOURCE="DbcdataSource";//中心库 
	public static final String XDB_DATASOURCE="XdbdataSource";//TR_DD 
}
