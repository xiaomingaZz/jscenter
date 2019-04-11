<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%
String CONTEXT_PATH =  WebUtils.getContextPath(request);
String menuTitle = (String)request.getAttribute("MENU_TITLE");
%>
<div class='logo_bg'>
	<table width="100%" height="80px" style="border: 0px;" cellpadding="0" cellspacing="0">
		<tr>
			<td class="logo_left"></td>
			<td></td>
			<td class="logo_right"></td>
		</tr>
	</table>
</div>
<div class="menu_title"><b><%= menuTitle%></b></div>
<div class="menu_click" id="menu_click_button">&nbsp;</div>
<div id="menu_panel" class="menu_panel">
<table border="0" width="200" cellpadding="0" cellspacing="0">
	<tr>
		<td height="6" background="../../resources/images/xlk_09.png"></td>
	</tr>
	<tr>
		<td class="menu_panel_bg menu_panel_td" onclick="tdClick(1);">
		<img alt="" src="<%=CONTEXT_PATH%>/resources/images/tubiao/jrdt.png">
		<a class="menu_panel_a" href="<%=CONTEXT_PATH%>/webapp/spxt/jrdt/jrdt.jsp">今日动态</a>
		</td>
	</tr>
	<tr>
		<td class="menu_panel_split"></td>
	</tr>
	<tr>
		<td class="menu_panel_bg menu_panel_td" onclick="tdClick(2);">
		<img alt="" src="<%=CONTEXT_PATH%>/resources/images/tubiao/hzdt.png">
		<a class="menu_panel_a" href="<%=CONTEXT_PATH%>/webapp/spxt/hzqk_day/hzdt_day.jsp">汇总动态</a></td>
	</tr>
	<tr>
		<td class="menu_panel_split"></td>
	</tr>
	<tr>
		<td class="menu_panel_bg menu_panel_td" onclick="tdClick(3);">
		<img alt="" src="<%=CONTEXT_PATH%>/resources/images/tubiao/cqwj.png">
		<a class="menu_panel_a" href="<%=CONTEXT_PATH%>/webapp/lljk/lljk_table_new.jsp">流向监控</a></td>
	</tr>
	<tr>
		<td class="menu_panel_split"></td>
	</tr>
	<tr>
		<td class="menu_panel_bg menu_panel_td" onclick="tdClick(4);">
		<img alt="" src="<%=CONTEXT_PATH%>/resources/images/tubiao/gpfh.png">
		<a class="menu_panel_a" href="<%=CONTEXT_PATH%>/webapp/spxt/sjzl/sjzl.jsp">数据质量</a></td>
	</tr>
	<tr>
		<td class="menu_panel_split"></td>
	</tr>
	<tr>
		<td class="menu_panel_bg menu_panel_td" onclick="tdClick(5);">
		<img alt="" src="<%=CONTEXT_PATH%>/resources/images/tubiao/tsqk.png">
		<a class="menu_panel_a" href="<%=CONTEXT_PATH%>/webapp/spxt/sjsjc/sjsjc.jsp">数据比对</a></td>
	</tr>
	<tr>
		<td class="menu_panel_split"></td>
	</tr>
	<tr>
		<td class="menu_panel_bg menu_panel_td" onclick="tdClick(16);">
		<img alt="" src="<%=CONTEXT_PATH%>/resources/images/tubiao/sy.png">
		<a class="menu_panel_a"  href="<%=CONTEXT_PATH%>/">返回首页</a></td>
	</tr>
	<tr>
		<td height="6" background="../../resources/images/xlk_12.png"></td>
	</tr>
</table>
</div>
<script type="text/javascript">
function toggleMenu(){
	$('#menu_panel').toggle();
}
$(document).ready(function(){
	
	$(document.body).click(function () {
		$("#menu_panel").hide();
	});
	
	$('#menu_click_button').click(function (ev){
		$("#menu_panel").toggle();
		return false;
	});


	$('.menu_panel_bg').hover(
		 function () {
			 $(this).removeClass("menu_panel_td");
			 $(this).addClass("menu_panel_td_hover");
		},
			function () {
			$(this).removeClass("menu_panel_td_hover");
			$(this).addClass("menu_panel_td");
		}		
	);
});

function tdClick(num){
	var url ="";
	if(num == 1){
		url ='<%=CONTEXT_PATH%>/webapp/spxt/jrdt/jrdt.jsp';
	}else if(num == 2){
		url ='<%=CONTEXT_PATH%>/webapp/spxt/hzqk_day/hzdt_day.jsp';
	}else if(num == 3){
		url ='<%=CONTEXT_PATH%>/webapp/lljk/lljk_table_new.jsp';
	}else if(num == 4){
		url ='<%=CONTEXT_PATH%>/webapp/spxt/sjzl/sjzl.jsp';
	}else if(num == 5){
		url ='<%=CONTEXT_PATH%>/webapp/spxt/sjsjc/sjsjc.jsp';
	}else{	
	   url = '<%=CONTEXT_PATH%>';
	}
	window.location.href=url;
}
</script>