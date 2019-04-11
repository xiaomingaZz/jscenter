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
	sbEcourt.append("<table cellspacing=\"1\" cellpadding=\"0\" border='0' width=\"100%\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbEcourt.append("<tr>");
	sbEcourt.append("<td colspan='2' height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;font-size:16px;\">审判端前置服务器</td>");
	sbEcourt.append("</tr>");
	sbEcourt.append("<tr style=\"font-size:12px;bgcolor='#87CEFA';\" >");
	sbEcourt.append("<td height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">单位</td>");
	sbEcourt.append("<td style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">导出数据量</td>");
	sbEcourt.append("</tr>");
	
	String colorHj = "#fffec8";
	int row = 1;
	for(String fy : fys){
		String color = "#ffffff";
		if(row%2 == 0){
			color = "#fffec8";
		}
		sbEcourt.append("<tr style=\"font-size:12px;line-height:18px;background:"+color+";\" >");
		sbEcourt.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">"+fyMap.get(fy)+"</td>");
		sbEcourt.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='"+fy+"_ecourt'>0</span></td>");
		sbEcourt.append("</tr>");
		
		row++;
	}
	sbEcourt.append("<tr style=\"font-size:12px;line-height:18px;background:"+colorHj+";\" >");
	sbEcourt.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">合计</td>");
	sbEcourt.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='ecourt'></span></td>");
	sbEcourt.append("</tr>");
	sbEcourt.append("</table>");
	
	sbTrdd.append("<table border='0' cellspacing=\"1\" cellpadding=\"0\" width=\"100%\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbTrdd.append("<td>");
	sbTrdd.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"100%\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbTrdd.append("<tr>");
	sbTrdd.append("<td colspan='3' height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;font-size:16px;\">数据交换库</td>");
	sbTrdd.append("</tr>");
	sbTrdd.append("<tr style=\"font-size:12px;line-height:18px;bgcolor='#87CEFA';\" >");
	sbTrdd.append("<td height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">单位</td>");
	sbTrdd.append("<td height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">接收案件数</td>");
	sbTrdd.append("<td style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">失败案件数</td>");
	sbTrdd.append("</tr>");
	row = 1;
	for(String fy : fys){
		String color = "#ffffff";
		if(row%2 == 0){
			color = "#fffec8";
		}
		sbTrdd.append("<tr style=\"font-size:12px;line-height:18px;background:"+color+";\">");
		sbTrdd.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">"+fyMap.get(fy)+"</td>");
		sbTrdd.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='"+fy+"_trdd'>0</span></td>");
		sbTrdd.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">"
			+"<span id='"+fy+"_trdd_sb' onclick=\"viewFc('"+fy+"','trans_fail')\" style='color:red;font-weight:bold;cursor:pointer;'>"
			+"0"
			+"</span>"
			+"</td>");
		sbTrdd.append("</tr>");
		row ++;
	}
	sbTrdd.append("<tr style=\"font-size:12px;line-height:24px;background:"+colorHj+";\" >");
	sbTrdd.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">合计</td>");
	sbTrdd.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='service'></span></td>");
	sbTrdd.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='service_sb'></span></td>");
	sbTrdd.append("</tr>");
	sbTrdd.append("</table>");
	sbTrdd.append("</td>");
	sbTrdd.append("</table>");
	
	String color="#ffffff";
	String color2="#fffec8";
	sbService.append("<table cellspacing=\"1\" width='100%' cellpadding=\"0\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbService.append("<tr style=\"font-size:12px;line-height:18px;bgcolor='#87CEFA';\">");
	sbService.append("<td colspan='2' height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;font-size:16px;\">传输交换平台</td>");
	sbService.append("</tr>");
	sbService.append("<tr style=\"font-size:12px;line-height:18px;bgcolor='#87CEFA';\">");
	sbService.append("<td style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">").append("单位").append("</td>");
	sbService.append("<td style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">").append("队列中案件数").append("</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">省院</td>");
	sbService.append("<td rowspan='18' style=\"background:#ffffff;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;font-size:22px;\">").append("<span id='queue'>0</span>").append("</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">武汉</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">黄石</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">十堰</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">荆州</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">宜昌</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">襄阳</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">鄂州</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">荆门</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">黄冈</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">孝感</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">咸宁</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">恩施</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">汉江</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">随州</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">海事</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">铁路</td>");
	sbService.append("</tr>");
	sbService.append("<tr  style=\"font-size:12px;line-height:18px;background:"+color2+";\">");
	sbService.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">-</td>");
	sbService.append("</tr>");
	sbService.append("</table>");
	
	sbDc.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"100%\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbDc.append("<td>");
	sbDc.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"100%\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbDc.append("<tr>");
	sbDc.append("<td colspan='4' height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;font-size:16px;\">省院中心库</td>");
	sbDc.append("</tr>");
	sbDc.append("<tr >");
	sbDc.append("<td height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">单位</td>");
	sbDc.append("<td style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">正在入库案件数</td>");
	sbDc.append("<td style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">成功案件数</td>");
	sbDc.append("<td style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">失败案件数</td>");
	sbDc.append("</tr>");
	row = 1;
	for(String fy : fys){
		color = "#ffffff";
		if(row%2 == 0){
			color = "#fffec8";
		}
		sbDc.append("<tr style=\"font-size:12px;line-height:18px;background:"+color+";\" >");
		sbDc.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">"+fyMap.get(fy)+"</td>");
		sbDc.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='"+fy+"_rk_wait'>0</span></td>");
		sbDc.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='"+fy+"_rk'>0</span></td>");
		sbDc.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">"
			+"<span id='"+fy+"_rk_sb' onclick=\"viewFc('"+fy+"','rk_fail')\" style='color:red;font-weight:bold;cursor:pointer;'>"
			+"0"
			+"</span>"
			+"</td>");
		sbDc.append("</tr>");
		
		row++;
	}
	sbDc.append("<tr style=\"font-size:12px;line-height:18px;background:"+colorHj+";\" >");
	sbDc.append("<td height='22' style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">合计</td>");
	sbDc.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='sjzx_wait'></span></td>");
	sbDc.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='sjzx'></span></td>");
	sbDc.append("<td style=\"border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\"><span id='sjzx_sb'></span></td>");
	sbDc.append("</tr>");
	sbDc.append("</table>");
	sbDc.append("</td>");
	   
	/*sbDc.append("<td style=\"background:#ffffff;\">");
	sbDc.append("<table  cellspacing=\"1\" cellpadding=\"0\" width=\"75\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbDc.append("<tr style=\"height:25px;background:green;\">");
	sbDc.append("<td style=\"color:#ffffff;\">").append("司法中心").append("</td>");
	sbDc.append("</tr>");
	sbDc.append("<tr style=\"height:25px;background:#ffffff;\">");
	sbDc.append("<td>").append("<span id='sjzx'>0</span>").append("</td>");
	sbDc.append("</tr>");
	sbDc.append("</table>");
	sbDc.append("</td>");*/
	sbDc.append("</table>");
	
	sbSjsb.append("<div style=\"float:center;\">");
	sbSjsb.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"100%\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
	sbSjsb.append("<tr>");
	sbSjsb.append("<td colspan='2' height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">数据利用</td>");
	sbSjsb.append("</tr>");
	sbSjsb.append("<tr>");
	sbSjsb.append("<td height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">项目</td>");
	sbSjsb.append("<td height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">数量</td>");
	sbSjsb.append("</tr>");
	sbSjsb.append("<tr style=\"height:22px;background:349DFF;\">");
	sbSjsb.append("<td height='22' style=\"color:#ffffff;background:349DFF;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">").append("数据上报").append("</td>");
	
	sbSjsb.append("<td style=\"background:#ffffff;border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;\">").append(0).append("</td>");
	sbSjsb.append("</tr>");
	sbSjsb.append("</table>");
	sbSjsb.append("</div>");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>湖北法院数据管理平台(流量监控)</title>

<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/jquery/jquery.js"></script>

<style type="text/css">
	body{
		no-repeat center top;
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

<script type="text/javascript">
function loadTrdd(kssj,jssj){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_trdd.jsp",
		   data: "t="+new Date()+"&kssj="+kssj+"&jssj="+jssj,
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   var to1=0;
			   var to2=0;
			   for(var fi in json){
				   if(fi.indexOf("_sb") > 0){
					   to2 = to2+json[fi];
				   }else{
					   to1 = to1+json[fi];
				   }
					document.getElementById(fi).innerHTML=json[fi];
			   }
			   document.getElementById('service').innerHTML=to1;
			   document.getElementById('service_sb').innerHTML=to2;
		   }
	});
}

function loadEcourt(kssj,jssj){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_ecourt.jsp",
		   data: "t="+new Date()+"&kssj="+kssj+"&jssj="+jssj,
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   var to=0;
			   for(var fi in json){
				   	to = to+json[fi];
					document.getElementById(fi).innerHTML=json[fi];
			   }
			   document.getElementById('ecourt').innerHTML=to;//审判端合计
		   }
	});
}

function loadQueue(kssj,jssj){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_queue.jsp",
		   data: "t="+new Date()+"&kssj="+kssj+"&jssj="+jssj,
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   for(var fi in json){
					document.getElementById(fi).innerHTML=json[fi];
			   }
		   }
	});
}

function loadRk(kssj,jssj){
	$.ajax({
		   type: "POST",
		   url: "lljk_table_data_rk.jsp",
		   data: "t="+new Date()+"&kssj="+kssj+"&jssj="+jssj,
		   cache: false,
		   dataType:'json',
		   success: function(json){
			   var to1=0;//成功总数
			   var to2=0;//失败总数
			   var to3=0;//等待入库
			   for(var fi in json){
				   if(fi.indexOf("_sb") > 0){
					   to2 = to2+json[fi];
				   }else if(fi.indexOf("_wait") > 0){
					   to3 = to3+json[fi];
				   }else{
					   to1 = to1+json[fi];
				   }
					
					document.getElementById(fi).innerHTML=json[fi];
			   }
			   document.getElementById('sjzx').innerHTML=to1;
			   document.getElementById('sjzx_sb').innerHTML=to2;
			   document.getElementById('sjzx_wait').innerHTML=to3;
		   }
	});
}

function loadFunc(){
	window.parent.init();
}

function viewFc(fy,flag){
	window.open('fc/lljk_fc.jsp?fy='+fy+'&flag='+flag);
}

</script>
</head>
<body style="margin: 0px;" onload='loadFunc();' >
   <!-- 表格容器 -->
   
   <table height='100%' width='100%' align="center" border=0>
   <tr height='100%'>
   
   <td width='3%'>&nbsp;</td>
   
   <td  align='center' height='100%'> 
   <%=sbEcourt.toString() %>
   </td>
   <td  align='center' valign='middle'><img src='../../resources/images/gif/gif194.gif'></td>
   <td  align='center'> 
   <%=sbService.toString() %>
   </td>
   <td  align='center' valign='middle'><img src='../../resources/images/gif/gif194.gif'></td>
   <td  align='center'> 
   <%=sbTrdd.toString() %>
   </td>
   <td  align='center' valign='middle'><img src='../../resources/images/gif/gif194.gif'></td>
   <td  align='center'> 
   <%=sbDc.toString() %>
   </td>
   
   <td width='3%'>&nbsp;</td>
   
   <!-- &rarr; 
   <td width='7%' align='center' valign='middle'><img src='../../resources/images/gif/gif194.gif'></td>
   <td width='10%' align='left'> 
   <%=sbSjsb.toString() %>
   </td>
   -->
   </tr>
   </table>
  </body>

</html>