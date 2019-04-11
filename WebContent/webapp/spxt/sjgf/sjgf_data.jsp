<%@page import="net.sf.json.JSONObject"%>
<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		mc = JSUtils.fymc;
		dm = JSUtils.fydm;
	}else if(dm.endsWith("00")){
 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
	}
	JSONObject jo = new JSONObject();
	jo.put("city",mc);
	out.print(jo);
%>

