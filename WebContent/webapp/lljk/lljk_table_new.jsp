<%@page import="tdh.frame.web.util.WebUtils,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import='java.text.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	String rq2 = new SimpleDateFormat("yyyy年MM月dd日").format(new Date());
	String rq1 = rq2;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>湖北法院数据管理平台(流量监控)</title>
<!-- 引入资源 -->
<jsp:include page="../inc/resources.jsp"></jsp:include>


<style type="text/css">
html,body {font-family: "宋体", Arial, Helvetica, sans-serif;}
table {font-size: 12px; border-collapse: collapse;}
TR {word-break: break-all;}
TD {white-space: nowrap;}
html,body {
	margin: 0px 0px;
	width: 100%;
	height: 100%;
}

iframe {
	margin: 0px 0px;
	width: 100%;
	height: 100%;
}

.atheight {
	height: expression(document.body.clientHeight-58 +   "px");
	padding: 0px;
	margin: 0px;
}

.atheight2 {
	margin: 0px 0px;
	width: 100%;
	height: 100%;
}
</style>

</head>
<body style="margin:0px; overflow:hidden;width: 100%;height: 100%;" onload="ie_ck();">
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "流向监控");
%>
<jsp:include page="../inc/head.jsp"></jsp:include>
   <!-- 表格容器 -->
   <table id='table' width="100%" height='100%' style='Scroll:auto' align="center" border=0>
   <tr height='30'>
   <td colspan='6' align='left'>
   &nbsp;&nbsp;&nbsp;&nbsp;
   <span style='color:#ffffff;font-size:20px;' id='time'></span>
   
   </td>
   <td colspan='3' align='right'>
   <span style='color:white;font-size:20px;' >
   <input type="text" id="rq1" name="rq1" value="<%=rq1 %>" readonly class="selDate" />
	<img alt="" src="../../resources/images/zl/jiantou_09.png">
	<input type="text" id="rq2" name="rq2" value="<%=rq2 %>" readonly class="selDate" />
	<img alt="" id='btnSearch' onmouseover="this.style.cursor='pointer'" onmouseout="this.style.cursor=''" align='top' src="../../resources/images/zl/shuaxin_03.png">
   &nbsp;&nbsp;
   </span>
   </td>
   
   </tr>
   
   <tr height='5'>
   	<td colspan='9'>
   		<hr>
   	</td>
   </tr>
   
   <!-- 
   <tr height='25'>
   <td width='6%' align='center'> <div id="table1" style="border:solid 1px;margin-top:5px;color:#ffffff;">审判端<br>导出xml</div></td>
   <td width='4%' align='center' valign='bottom'><img src='../../resources/images/gif/gif194.gif'></td>
   <td width='6%' align='center'> <div id="table3" style="border:solid 1px;margin-top:5px;color:#ffffff;">传输交换平台<br>(服务队列)</div></td>
   <td width='6%' align='center' valign='bottom'><img src='../../resources/images/gif/gif194.gif'></td>
   <td width='18%' align='center'> <div id="table4" style="border:solid 1px;margin-top:5px;color:#ffffff;">数据交换库<br>TR_DD表</div></td>
   <td width='6%' align='center' valign='bottom'><img src='../../resources/images/gif/gif194.gif'></td>
   <td width='18%' align='center'> <div id="table5" style="border:solid 1px;margin-top:5px;color:#ffffff;">司法中心</div></td>
   <td width='9%' align='center' valign='bottom'><img src='../../resources/images/gif/gif194.gif'></td>
   <td width='10%' align='left'> <div id="table6" style="border:solid 1px;margin-top:5px;color:#ffffff;">数据利用</div></td>
   </tr>
    
   <tr height='5'>
   <td colspan='9'>
   <hr>
   </td>
   </tr>
   -->
   <tr height='*'>
      <td colspan='9' height='100%'>
        <iframe id="ifrm" name="ifrm" scrolling="auto"  src="lljk_table_child.jsp" width="100%" height="100%" style='margin-top:60px;' frameborder=0></iframe>
      </td>
    </tr>
    
   
   
    
   
   </table>
   
  </body>
<script type="text/javascript">

var kssj = '<%=rq1.replace("年","").replace("月","").replace("日","")%>';
var jssj = '<%=rq2.replace("年","").replace("月","").replace("日","")%>';

var times = setInterval("refreshData()",2*60*1000);//2min

function loadTrdd(){
	window.frames["ifrm"].loadTrdd(kssj,jssj);
}

function loadEcourt(){
	window.frames["ifrm"].loadEcourt(kssj,jssj);
}

function loadRk(){
	window.frames["ifrm"].loadRk(kssj,jssj);
}

function loadQueue(){
	window.frames["ifrm"].loadQueue();
}

function getTime(){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_time.jsp",
		   data: "t="+new Date(),
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   document.getElementById('time').innerHTML=json.time;
		   }
	});
}

$(document).ready(function(){
	bindRq();
	
	$('#btnSearch').bind('click',function(){
		
		kssj = $('#rq1').val().replace('年','').replace('月','').replace('日','');
		jssj = $('#rq2').val().replace('年','').replace('月','').replace('日','');
		if(kssj > jssj){
			alert("开始时间不能大于结束时间");
			return;
		}
		refreshData();
	});
});

function bindRq() {
	// 统计年月
	$("#rq1").bind("click", function() {
		WdatePicker({
			dateFmt : "yyyy年MM月dd日"
		});
	});
	$("#rq2").bind("click", function() {
		WdatePicker({
			dateFmt : "yyyy年MM月dd日"
		});
	});

}

function init(){
	getTime();
	loadEcourt();
	loadQueue();
	loadTrdd();
	loadRk();
}

function refreshData(){
	getTime();
	loadEcourt();
	loadQueue();
	loadTrdd();
	loadRk();
}

function ie_ck() {
	/*var Sys = {};
	var ua = navigator.userAgent.toLowerCase();
	if (window.ActiveXObject)
		Sys.ie = ua.match(/msie ([\d.]+)/)[1]
	else if (document.getBoxObjectFor)
		Sys.firefox = ua.match(/firefox\/([\d.]+)/)[1]
	else if (window.MessageEvent && !document.getBoxObjectFor)
		Sys.chrome = ua.match(/chrome\/([\d.]+)/)[1]
	else if (window.opera)
		Sys.opera = ua.match(/opera.([\d.]+)/)[1]
	else if (window.openDatabase)
		Sys.safari = ua.match(/version\/([\d.]+)/)[1];

	//以下进行测试  
	if (Sys.ie) {
		document.getElementById('ifrm').className = "atheight";
	}
	if (Sys.firefox) {
		document.getElementById('ifrm').className = "atheight2";
	}
	if (Sys.chrome) {
		document.getElementById('ifrm').className = "atheight2";
	}
	if (Sys.opera) {
		document.getElementById('ifrm').className = "atheight2";
	}
	if (Sys.safari) {
		document.getElementById('ifrm').className = "atheight2";
	}*/
	$("#table").css("height",(document.body.clientHeight - 80) + 'px');
	document.getElementById('ifrm').className = "atheight2";
}
</script>
</html>