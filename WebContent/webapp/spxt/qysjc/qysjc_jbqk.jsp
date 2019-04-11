<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.CalendarUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%
	String yhdm = StringUtils.trim(request.getParameter("yhdm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	String sql = "select YHXM,(select BMMC FROM ETL_DEPART WHERE BMDM = ETL_USER.YHBM) BMMC,"
				+" (SELECT MC FROM TS_BZDM WHERE CODE = ETL_USER.YHZW) YHZW,"
				+" (SELECT MC FROM TS_BZDM WHERE CODE = ETL_USER.FLZW) FLZW,"
				+" YHXB, "
				+" (SELECT MC FROM TS_BZDM WHERE CODE = ETL_USER.YHXB) XBMC"
				+" from ETL_USER "
				+" where YHDM = '"+yhdm+"' ";
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String yhxm = "";
	String bmmc = "";
	String yhzw = "";
	String flzw = "";
	String xbmc = "";
	if(list != null && list.size() > 0){
		yhxm = (String)list.get(0).get("YHXM");
		bmmc = (String)list.get(0).get("BMMC");
		yhzw = (String)list.get(0).get("YHZW");
		flzw = (String)list.get(0).get("FLZW");
		xbmc = (String)list.get(0).get("XBMC");
	}
	
	JSONObject jo = new JSONObject();
	jo.put("yhxm",yhxm);
	jo.put("yhbm",bmmc);
	jo.put("yhzw",yhzw);
	jo.put("flzw",flzw);
	jo.put("xbmc",xbmc);
	out.print(jo.toString());
	
%>

