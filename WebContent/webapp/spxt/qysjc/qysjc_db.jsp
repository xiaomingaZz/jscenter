<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="tdh.util.JSUtils,tdh.util.CalendarUtil"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	String nd = StringUtils.trim(request.getParameter("nd"));
	String fydm = StringUtils.trim(request.getParameter("fydm"));
	String bmdm = StringUtils.trim(request.getParameter("bmdm"));
	String rydm = StringUtils.trim(request.getParameter("rydm"));
	String dl = StringUtils.trim(request.getParameter("dl"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>全院收结存情况</title>
	<!-- 引入资源 -->
	<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/jquery/jquery.js"></script>
	<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/echarts-2.2.7/build/dist/echarts.js"></script>
	<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/loadEcharts.js"></script>
	<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.css" type="text/css">
	<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.min.js"></script>
</head>
<script type="text/javascript">
var contextPath = '<%=CONTEXT_PATH%>';
var rybar;

var dl = '<%=dl%>';
var nd ='<%=nd%>';
var fydm='<%=fydm%>';
var bmdm='<%=bmdm%>';
var rydm='<%=rydm%>';

$(document).ready(function(){
	initEcharts(['echarts/chart/bar'],contextPath+'/resources/echarts-2.2.7/build/dist',requireCallback);
});

function requireCallback(ec){

	var ecConfig = require('echarts/config');
	var zrEvent = require('zrender/tool/event');
	
	rybar = ec.init(document.getElementById('barChart'));
	rybar.on(ecConfig.EVENT.CLICK, function(param) {
		var da = param.data;
	});
	$("#barChart").parent().mask("数据加载中，请稍后...");
	loadOption("./qysjc_db_bar.jsp",{'nd':nd,'dl':dl,'fydm':fydm,'bmdm':bmdm,'rydm':rydm},false,function(op){
		$("#barChart").parent().unmask();
		rybar.clear();
		rybar.hideLoading();
		rybar.setOption(op);
	});
}

function doFc(baseid,fydm,bmdm,kssj,jssj){
	var param = "BASEID="+baseid+"&FYDM="+fydm+"&KSSJ="+kssj+"&JSSJ="+jssj+"&CBBM1="+bmdm;
	window.open(contextPath+'/webapp/fc/fc.jsp?'+param);
}

</script>

<body>
	<div id="barChart" style="width: 960px;height: 450px;border:solid 0px;"></div>
</body>
</html>