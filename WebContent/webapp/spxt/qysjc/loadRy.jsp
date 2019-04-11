<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%
/**
找到部门的第一个人
*/
	String bmdm = StringUtils.trim(request.getParameter("bmdm"));
	String fydm = StringUtils.trim(request.getParameter("fydm"));
	String nd = StringUtils.trim(request.getParameter("nd"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	String sql = "SELECT distinct YHDM,YHXM FROM ETL_USER A,ETL_CASE B WHERE A.DWDM = B.FYDM AND A.YHBM = B.CBBM1 AND A.YHDM = B.CBR AND A.DWDM = '"
		+fydm+"'  AND A.YHBM = '"+bmdm+"' AND BCYSFTJ = '0' AND XTAJLX <>'15' ";
	String []tjyf = CalendarUtil.getKssjJssjDay(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	if("sa".equals(dl)){
		sql += " AND AJZT>='300' AND LARQ >='"+kssj+"' AND LARQ <= '"+jssj+"' ORDER BY YHDM";
	}else if("ja".equals(dl)){
		sql += " AND AJZT>='800' AND JARQ >='"+kssj+"' AND JARQ <= '"+jssj+"' ORDER BY YHDM";
	}else if("wj".equals(dl)){
		sql += " AND AJZT>='300' AND AJZT <'800' AND (LARQ <='"+jssj+"' OR (AJZT >='800' AND JARQ > '"+jssj+"')) ORDER BY YHDM";
	}
	
	List<Map<String,Object>> list = bi09.queryForList(sql);
	
	JSONArray ja = new JSONArray();
	for(Map<String,Object> map : list){
		JSONObject jo = new JSONObject();
		String dm = StringUtils.trim(map.get("YHDM"));
		jo.put("id",dm);
		jo.put("name",StringUtils.trim(map.get("YHXM")));
		jo.put("pId","0");
		jo.put("checked",true);
		ja.add(jo);
	}
	
	out.println(ja.toString());
%>
