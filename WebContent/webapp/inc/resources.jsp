<%@page import="tdh.frame.web.util.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
%>

<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/jquery/jquery.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/echarts-2.2.7/build/dist/echarts.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/loadEcharts.js"></script>
<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/resources/css/hbcenter_flat.css">
<script src="<%=CONTEXT_PATH%>/resources/DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/ztree/jquery.ztree.core-3.5.min.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/ztree/jquery.ztree.excheck-3.5.min.js"></script>
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/ztree/css/demo.css" type="text/css">
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/treeCom.js"></script>

<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.css" type="text/css">
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.min.js"></script>