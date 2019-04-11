<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="tdh.framework.util.StringUtils,java.text.SimpleDateFormat"%>

<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	JSONObject jo = new JSONObject();
	 	
	 	String now = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(new Date());
	 	
		JdbcTemplateExt xdbc= WebAppContext.getBeanEx(JSUtils.XDB_JDBCTEMPLATE_EXT);
	 	String sql = "SELECT max(SJ) SJ FROM TR_QUEUE ";
		List<Map<String, Object>> list = xdbc.queryForList(sql);
	 	if(list!=null && list.size() > 0){
	 		String sj = StringUtils.formatDate((Date)list.get(0).get("SJ"),"yyyy-MM-dd hh:mm:ss");
	 		if(sj.substring(0,10).equals(now.substring(0,10))){
	 			jo.put("time","当前更新时间："+sj);
	 		}else{
	 			jo.put("time","当前更新时间："+now);
	 		}
	 		
	 	}
		out.print(jo.toString());
 %>

                    
                    