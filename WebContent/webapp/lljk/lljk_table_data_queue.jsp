<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="tdh.framework.util.StringUtils"%>

<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	JSONObject jo = new JSONObject();
	 	
		JdbcTemplateExt xdbc= WebAppContext.getBeanEx(JSUtils.XDB_JDBCTEMPLATE_EXT);
	 	String sql = "SELECT SL FROM TR_QUEUE WHERE SJ = (SELECT MAX(SJ) FROM TR_QUEUE)";
		List<Map<String, Object>> list = xdbc.queryForList(sql);
	 	if(list!=null && list.size() > 0){
	 		jo.put("queue",list.get(0).get("SL"));
	 	}
	 	
		out.print(jo.toString());
 %>

                    
                    