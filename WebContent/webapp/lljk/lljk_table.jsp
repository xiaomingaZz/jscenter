<%@page import="tdh.frame.web.util.WebUtils,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	String []fys = new String []{
			"H0",
			"H1","H2","H3","H4",
			"H5","H6","H7","H8",
			"H9","HA","HB","HC",
			"HD","HE","HF","HG"
	};
	Map<String,String> fyMap = new HashMap<String,String>();
	fyMap.put("H0","省院");
	fyMap.put("H1","武汉");
	fyMap.put("H2","黄石");
	fyMap.put("H3","十堰");
	fyMap.put("H4","荆州");
	fyMap.put("H5","宜昌");
	fyMap.put("H6","襄阳");
	fyMap.put("H7","鄂州");
	fyMap.put("H8","荆门");
	fyMap.put("H9","黄冈");
	fyMap.put("HA","孝感");
	fyMap.put("HB","咸宁");
	fyMap.put("HC","恩施");
	fyMap.put("HD","汉江");
	fyMap.put("HE","随州");
	fyMap.put("HF","海事");
	fyMap.put("HG","铁路");
	
	StringBuilder sbEcourt = new StringBuilder();
	StringBuilder sbRd = new StringBuilder();
	StringBuilder sbTrdd = new StringBuilder();
	StringBuilder sbService = new StringBuilder();
	StringBuilder sbDc = new StringBuilder();
	StringBuilder sbSjsb = new StringBuilder();
	for(String fy : fys){
		sbEcourt.append("<tr style=\"height:25px;\">");
		sbEcourt.append("<td style=\"color:#ffffff;background:349DFF;\">"+fyMap.get(fy)+"</td>");
		//sbEcourt.append("</tr>");
		//sbEcourt.append("<tr style=\"height:25px;\">");
		sbEcourt.append("<td style=\"background:#ffffff;\"><span id='"+fy+"_ecourt'>0</span></td>");
		sbEcourt.append("</tr>");
	}
	
	sbTrdd.append("<td>");
	sbTrdd.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"125\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	for(String fy : fys){
		sbTrdd.append("<tr style=\"height:25px;\">");
		sbTrdd.append("<td style=\"color:#ffffff;background:349DFF;\">"+fyMap.get(fy)+"</td>");
		//sbTrdd.append("</tr>");
		//sbTrdd.append("<tr style=\"height:25px;\">");
		sbTrdd.append("<td style=\"background:#ffffff;\"><span id='"+fy+"_trdd'>0</span></td>");
		sbTrdd.append("</tr>");
	}
	sbTrdd.append("</table>");
	sbTrdd.append("</td>");
	   
	sbTrdd.append("<td style=\"background:#ffffff;\">");
	sbTrdd.append("<table  cellspacing=\"1\" cellpadding=\"0\" width=\"75\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbTrdd.append("<tr style=\"height:25px;background:green;\">");
	sbTrdd.append("<td style=\"color:#ffffff;\">").append("交换中心").append("</td>");
	sbTrdd.append("</tr>");
	sbTrdd.append("<tr style=\"height:25px;background:#ffffff;\">");
	sbTrdd.append("<td>").append("<span id='service'>0</span>").append("</td>");
	sbTrdd.append("</tr>");
	sbTrdd.append("</table>");
	sbTrdd.append("</td>");
	
	sbService.append("<div style=\"float:center;width:80px;margin-top:20px;\">");
	sbService.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbService.append("<tr style=\"height:50px;background:349DFF;\">");
	sbService.append("<td style=\"color:#ffffff;\">").append("服务队列").append("</td>");
	sbService.append("</tr>");
	sbService.append("</table>");
	sbService.append("</div>");   
	
	sbDc.append("<div style=\"float:center;margin-top:20px;\">");
	sbDc.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbDc.append("<td>");
	sbDc.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"65\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	for(String fy : fys){
		sbDc.append("<tr style=\"height:25px;\">");
		sbDc.append("<td style=\"color:#ffffff;background:349DFF;\">"+fyMap.get(fy)+"</td>");
		sbDc.append("</tr>");
		sbDc.append("<tr style=\"height:25px;\">");
		sbDc.append("<td style=\"background:#ffffff;\"><span id='"+fy+"_rk'>0</span></td>");
		sbDc.append("</tr>");
	}
	sbDc.append("</table>");
	sbDc.append("</td>");
	   
	sbDc.append("<td style=\"background:#ffffff;\">");
	sbDc.append("<table  cellspacing=\"1\" cellpadding=\"0\" width=\"75\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbDc.append("<tr style=\"height:25px;background:green;\">");
	sbDc.append("<td style=\"color:#ffffff;\">").append("司法中心").append("</td>");
	sbDc.append("</tr>");
	sbDc.append("<tr style=\"height:25px;background:#ffffff;\">");
	sbDc.append("<td>").append("<span id='sjzx'>0</span>").append("</td>");
	sbDc.append("</tr>");
	sbDc.append("</table>");
	sbDc.append("</td>");
	sbDc.append("</table>");
	sbDc.append("</div>");
	
	sbSjsb.append("<div style=\"float:center;width:80px;margin-top:20px;\">");
	sbSjsb.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbSjsb.append("<tr style=\"height:25px;background:349DFF;\">");
	sbSjsb.append("<td style=\"color:#ffffff;\">").append("数据上报").append("</td>");
	sbSjsb.append("</tr>");
	sbSjsb.append("<tr style=\"height:25px;background:#ffffff;\">");
	sbSjsb.append("<td>").append(0).append("</td>");
	sbSjsb.append("</tr>");
	sbSjsb.append("</table>");
	sbSjsb.append("</div>");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>湖北法院数据管理平台(流量监控)</title>
<jsp:include page="../inc/resources.jsp"></jsp:include>
<style type="text/css">
	body{
		background: url("") no-repeat center top;
	}
	.logo_bg{
		background: url("");
	}
	A:link {
		COLOR: blue; TEXT-DECORATION: none
	}
	A:visited {
		COLOR: blue; TEXT-DECORATION: none
	}
	A:hover {
		COLOR: #FB855D; TEXT-DECORATION: none
	}
</style>
</head>
<body>
   <!-- 表格容器 -->
   <div id="lc_table">
   <table style="width:95%;" align="center" border=0>
   <tr>
   <td width='10%' align='center'> <div id="table1" style="border:solid 1px;margin-top:20px;color:#ffffff;">审判端</div></td>
   <td width='8%' align='center' valign='bottom'>&rarr;</td>
   <td width='10%' align='center'> <div id="table3" style="border:solid 1px;margin-top:20px;color:#ffffff;">数据传输交换平台</div></td>
   <td width='6%' align='center' valign='bottom'>&rarr;</td>
   <td width='14%' align='center'> <div id="table4" style="border:solid 1px;margin-top:20px;color:#ffffff;">数据交换库<br>TR_DD表</div></td>
   <td width='6%' align='center' valign='bottom'>&rarr;</td>
   <td width='14%' align='center'> <div id="table5" style="border:solid 1px;margin-top:20px;color:#ffffff;">司法中心</div></td>
   <td width='6%' align='center' valign='bottom'>&rarr;</td>
   <td width='10%' align='center'> <div id="table6" style="border:solid 1px;margin-top:20px;color:#ffffff;">数据利用</div></td>
   </tr>
   </table>
   <table style="width:95%;" align="center" border=0>
   <tr>
   <td width='10%' align='center'><div style="margin-top:20px;color:#ffffff;">导出xml</div></td>
   <td width='8%' align='center'> <div style="margin-top:20px;color:#ffffff;">xml传输</div></td>
   <td width='10%' align='center'></td>
   <td width='7%' align='center'> <div style="margin-top:20px;color:#ffffff;">写入</div></td>
   <td width='12%' align='center'></td>
   <td width='7%' align='center'> <div style="margin-top:20px;color:#ffffff;">解析入库</div></td>
   <td width='10%' align='center'></td>
   <td width='8%'> <div style="margin-top:20px;color:#ffffff;"></div></td>
   <td width='10%' align='center'></td>
   </tr>
   </table>
   </div>
   <hr>
   <div style="text-align:center;font-size:20px;margin-top:20px;">数据流向图</div>
   
   <table style="width:95%;" align="center" border=0>
   <tr>
   <td width='10%' align='center'> <div id="chart1" style="margin-top:20px;">
   <div style="float:center;width:90%;margin-top:20px;">
   <table cellspacing="1" cellpadding="0" width="100%" style="text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;">
   <%=sbEcourt.toString() %>
   </table>
   </div>
   </div></td>
   <td width='8%' align='center' valign='middle'>&rarr;</td>
   
   <td width='10%' align='center'> <div id="chart3" style="margin-top:20px;">
   <%=sbService.toString() %>
   </div></td>
   <td width='6%' align='center' valign='middle'>&rarr;</td>
   <td width='14%' align='center'> <div id="chart4" style="margin-top:20px;">
   <div style="float:center;width:90%;margin-top:20px;">
   <table cellspacing="1" cellpadding="0" width="100%" style="text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;">
   <%=sbTrdd.toString() %>
   </table>
   </div>
   </div></td>
   <td width='6%' align='center' valign='middle'>&rarr;</td>
   <td width='14%' align='center'> <div id="chart5" "style="float:center;width:90%;margin-top:20px;">
   <%=sbDc.toString() %>
   </div></td>
   <td width='6%' align='center' valign='middle'>&rarr;</td>
   <td width='10%' align='center'> <div id="chart6" style="margin-top:20px;">
   <%=sbSjsb.toString() %>
   </div></td>
   </tr>
   </table>
  </body>
<script type="text/javascript">
var times = setInterval("refreshData()",2*60*1000);//2min

function loadTrdd(){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_trdd.jsp",
		   data: "t="+new Date(),
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   var to=0;
			   for(var fi in json){
					to = to+json[fi];
					document.getElementById(fi).innerHTML=json[fi];
			   }
			   document.getElementById('service').innerHTML=to;
		   }
	});
}

function loadEcourt(){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_ecourt.jsp",
		   data: "t="+new Date(),
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   var to=0;
			   for(var fi in json){
					document.getElementById(fi).innerHTML=json[fi];
			   }
		   }
	});
}

function loadRk(){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_rk.jsp",
		   data: "t="+new Date(),
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   var to=0;
			   for(var fi in json){
					to = to+json[fi];
					document.getElementById(fi).innerHTML=json[fi];
			   }
			   document.getElementById('sjzx').innerHTML=to;
		   }
	});
}

$(document).ready(function(){
	
	loadEcourt();
	loadTrdd();
	loadRk();
	
});

function refreshData(){
	loadEcourt();
	loadTrdd();
	loadRk();
}
</script>
</html>