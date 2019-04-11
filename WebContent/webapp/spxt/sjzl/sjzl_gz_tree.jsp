<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	
	List<Map<String,Object>> fylist = bi09.queryForList("select GZID,GZMC from DIM_JYGZ ");
	
	JSONArray ja = new JSONArray();
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> mm = fylist.get(i);
		String dm = StringUtils.trim(mm.get("GZID"));
		String mc = StringUtils.trim(mm.get("GZMC"));
		JSONObject jo = new JSONObject();
		jo.put("id", dm);
		jo.put("pId","0");
		jo.put("name",mc);
		ja.add(jo);
	}
	out.print(ja);
%>