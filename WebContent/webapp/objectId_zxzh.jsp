<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String mc = StringUtils.trim(request.getParameter("cityName"));
	String dm = JSUtils.fydm;
	String fjm = JSUtils.fjm;
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	if(mc!=null&&!mc.equals("")){
	  mc = JSUtils.decodeURI(mc);
    
    String sql = "select DM_CITY ,NAME_CITY,FJM from DC_CITY where NAME_CITY = '"+mc+"'";
    
		List<Map<String,Object>> fylist = bi09.queryForList(sql);
		if(fylist.size()!=0){
			dm = fylist.get(0).get("DM_CITY").toString();
			fjm = fylist.get(0).get("FJM").toString();
  	}
	}
  dm = JSUtils.numToStrN(dm, 6);
	out.print("cityCode=" + dm);
%>

