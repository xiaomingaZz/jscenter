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
	String dm = JSUtils.fydm;
	String fjm = JSUtils.fjm;
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	if(mc!=null&&!mc.equals("")){
		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY ,NAME_CITY,FJM from DC_CITY where NAME_CITY = '"+mc+"'");
		if(fylist.size()!=0){
			dm = fylist.get(0).get("DM_CITY").toString();
			fjm = fylist.get(0).get("FJM").toString();
		}
	}
	out.print("{'dm':'"+dm+"','fjm':'"+fjm+"'}");
%>

