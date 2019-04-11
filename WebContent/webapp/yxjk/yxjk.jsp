<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.util.JSUtils"%>
<%@ page language="java" import="java.util.*"  contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);

	JdbcTemplateExt dbc= WebAppContext.getBeanEx(JSUtils.BI09_JDBCTEMPLATE_EXT);	
	List<Map<String,Object>> fy_List = dbc.queryForList("SELECT substring(FJM,1,2) DM,NAME_CITY MC FROM DC_CITY where FJM like '"+JSUtils.fjm.substring(0,1)+"[0-9A-Z]' and datalength(FJM) = 2 ");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>湖北法院数据管理平台(平台运行监控)</title>
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
   <div id="lc_table"></div>
   <table style="width:95%;" align="center" border=0>
   <tr>
   <td width='19%' align='center'> <div id="table1" style="border:solid 1px;margin-top:20px;color:#ffffff;">审判端服务器</div></td>
   <td width='8%' align='center' valign='bottom'></td>
   <td width='19%' align='center'> <div id="table2" style="border:solid 1px;margin-top:20px;color:#ffffff;">瑞达前置tomcat服务</div></td>
   <td width='8%' align='center' valign='bottom'></td>
   <td width='10%' align='center'> <div id="table3" style="border:solid 1px;margin-top:20px;color:#ffffff;">交换中心<br>(瑞达服务队列)</div></td>
   <td width='6%' align='center' valign='bottom'></td>
   <td width='14%' align='center'> <div id="table4" style="border:solid 1px;margin-top:20px;color:#ffffff;">解析入库服务</div></td>
   <td width='6%' align='center' valign='bottom'></td>
   <td width='10%' align='center'> <div id="table5" style="border:solid 1px;margin-top:20px;color:#ffffff;">数据上报打包服务</div></td>
   </tr>
   </table>
   <hr>
   
   <table style="width:95%;" align="center" border=0>
   <tr>
   <td width='19%' align='center'> <div id="chart1" style="margin-top:20px;">
   <div style="float:center;width:90%;margin-top:20px;">
   <table cellspacing="1" cellpadding="0" width="100%" style="text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;">
   <tr style="height:25px;">
   <td width='50%' style="color:#ffffff;background:349DFF;">省院</td>
   <td style="background:#ffffff;"><span id='H0_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">武汉</td>
   <td style="background:#ffffff;"><span id='H1_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">黄石</td>
   <td style="background:#ffffff;"><span id='H2_ecourt'>✘</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">十堰</td>
   <td style="background:#ffffff;"><span id='H3_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">荆州</td>
   <td style="background:#ffffff;"><span id='H4_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">宜昌</td>
   <td style="background:#ffffff;"><span id='H5_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">襄阳</td>
   <td style="background:#ffffff;"><span id='H6_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">鄂州</td>
   <td style="background:#ffffff;"><span id='H7_ecourt'>✘</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">荆门</td>
   <td style="background:#ffffff;"><span id='H8_ecourt'>✘</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">黄冈</td>
   <td style="background:#ffffff;"><span id='H9_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">孝感</td>
   <td style="background:#ffffff;"><span id='HA_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">咸宁</td>
   <td style="background:#ffffff;"><span id='HB_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">恩施</td>
   <td style="background:#ffffff;"><span id='HC_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">汉江</td>
   <td style="background:#ffffff;"><span id='HD_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">随州</td>
   <td style="background:#ffffff;"><span id='HE_ecourt'>✔</span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">铁路</td>
   <td style="background:#ffffff;"><span id='HG_ecourt'>✔</span></td>
   </tr>
   
   </table>
   </div>
   </div></td>
   <td width='8%' align='center' valign='middle'></td>
   <td width='19%' align='center'> <div id="chart2" style="margin-top:20px;">
   <div style="float:center;width:90%;margin-top:20px;">
   <table cellspacing="1" cellpadding="0" width="100%" style="text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;">
   <tr style="height:25px;">
   <td width='50%' style="color:#ffffff;background:349DFF;">省院</td>
   <td style="background:#ffffff;"><span id='H0_ecourt'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">武汉</td>
   <td style="background:#ffffff;"><span id='H1_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">黄石</td>
   <td style="background:#ffffff;"><span id='H2_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">十堰</td>
   <td style="background:#ffffff;"><span id='H3_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">荆州</td>
   <td style="background:#ffffff;"><span id='H4_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">宜昌</td>
   <td style="background:#ffffff;"><span id='H5_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">襄阳</td>
   <td style="background:#ffffff;"><span id='H6_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">鄂州</td>
   <td style="background:#ffffff;"><span id='H7_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">荆门</td>
   <td style="background:#ffffff;"><span id='H8_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">黄冈</td>
   <td style="background:#ffffff;"><span id='H9_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">孝感</td>
   <td style="background:#ffffff;"><span id='HA_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">咸宁</td>
   <td style="background:#ffffff;"><span id='HB_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">恩施</td>
   <td style="background:#ffffff;"><span id='HC_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">汉江</td>
   <td style="background:#ffffff;"><span id='HD_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">随州</td>
   <td style="background:#ffffff;"><span id='HE_rd'></span></td>
   </tr>
   <tr style="height:25px;">
   <td style="color:#ffffff;background:349DFF;">铁路</td>
   <td style="background:#ffffff;"><span id='HG_rd'></span></td>
   </tr>
   
   </table>
   </div>
   </div></td>
   <td width='8%' align='center' valign='middle'></td>
   <td width='10%' align='center'> <div id="chart3" style="margin-top:20px;"></div></td>
   <td width='6%' align='center' valign='middle'></td>
   <td width='14%' align='center'> <div id="chart4" style="margin-top:20px;"></div></td>
   <td width='6%' align='center' valign='middle'></td>
   <td width='10%' align='center'> <div id="chart5" style="margin-top:20px;"></div></td>
   </tr>
   </table>
   <br>
   注：
   <br>
   ✔：表示服务器ping通正常运行或tomcat服务正常运行
   <br>
   ✘：表示服务器ping不通无法访问或tomcat服务无法访问
  </body>
<script type="text/javascript">
$(document).ready(function(){
	//1、加载table的数据
	$.ajax({
		   type: "POST",
		   url: "yxjk_data.jsp",
		   data: "t="+new Date(),
		   cache: false,
		   dataType:'json',
		   success: function(json){
		     //$("#chart1").html(json.chart1);
		     //$("#chart2").html(json.chart2);
		     //$("#chart3").html(json.chart3);
		     //$("#chart4").html(json.chart4);
		     //$("#chart5").html(json.chart5);
		     //$("#chart6").html(json.chart6);
		   }
	});
});
</script>
</html>