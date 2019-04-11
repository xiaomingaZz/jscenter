<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tdh.util.GetFileFromUrl"%>	
<%
	/**
	 *	xml内容
	 **/
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	
	String xmlname = StringUtils.trim(request.getParameter("xmlname"));
	String ah = StringUtils.trim(request.getParameter("ah"));
	ah = java.net.URLDecoder.decode(ah, "UTF-8" );
	String sbyy = StringUtils.trim(request.getParameter("sbyy"));
	sbyy = java.net.URLDecoder.decode(sbyy, "UTF-8" );
	
	String path = "http://144.0.0.63:6888/Properties/download?des=";
	String nr = GetFileFromUrl.getDocumentAt(path+xmlname);
	nr = nr.replace(">","><br>");
	
	String []gzs = new String[]{
			"案号","经办法院","进展阶段","案件来源","适用程序","当事人","当事人类型","承办人",
			"承办审判庭","发回重审原因","法定审限天数","立案案由","主罪名","立案日期",
			"实际审理天数","收到诉状日期","报核日期","主刑种类","结案方式","结案日期",
			"生效日期","结案案由","执行案由","指控罪名","判处情况","定罪罪名",
			"审判监督子类别","案件标识","文书质量","裁判文书"
	};
	
	for(String gz : gzs){
		if(sbyy.contains(gz)){
			nr = nr.replace(gz,"<span style='color:red;'>"+gz+"</span>");
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>文件内容</title>
</head>
<body>
案号：<%=ah %>
<br>
失败原因：<span style='color:red;'><%=sbyy %></span>
<br>
<div style="width=100%x;height=100%;border:1px solid grey;overflow:auto;">
<%=nr %>
</div>
</body>
</html>