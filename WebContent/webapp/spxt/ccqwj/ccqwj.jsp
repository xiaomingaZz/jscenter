<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	List<Map<String,Object>> citys = bi09.queryForList("select DM_CITY DM from DC_CITY where (DATALENGTH(DM_CITY) = 4 or DATALENGTH(DM_CITY) = 2) ");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<!-- 引入资源 -->
<jsp:include page="../../inc/resources.jsp"></jsp:include>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/scroll.js"></script>
<style type="text/css">
input,button,select,textarea{outline:none;}
ul,li,dl,ol{list-style:none;}

.list_lh{overflow:hidden;margin:0px auto;border:0px solid #FFFFFF;margin: 0px 15px 0px 15px;}
.list_lh ul{padding:0px;}
.list_lh li{padding:5px 10px;border-bottom: 1px dashed #b5b5b5}
.list_lh li.lieven{}
.list_lh li p{height:24px;line-height:24px;padding:0px;margin:0px;font-size:13px;}
.list_lh li p a{float:left;}
.list_lh li p em{width:80px;font:normal 12px/24px Arial;color:#FF3300;float:right;display:inline-block;}
.list_lh li p span{color:#999;float:right;}

</style>
</head>
<script type="text/javascript">
var contextPath = '<%=CONTEXT_PATH%>';
var citys = <%=JSONArray.fromObject(citys)%>
var map;
var bar;
var sjbar;
var pie;
var citymc = "";
var citydm = "";

var totalpage = 0;
var cuttpage = 1;

$(document).ready(function(){
	initEcharts(['echarts/chart/pie','echarts/chart/bar','echarts/chart/map'],contextPath+'/resources/echarts-2.2.7/build/dist',function(ec){
		var mapGeoData = require('echarts/util/mapData/params');
		for(var i=0;i<citys.length;i++){
			var dm = citys[i]["DM"]+"";
			mapGeoData.params[dm] = {
				getGeoJson: (function (cdm) {
					var path = contextPath+'/resources/json/' +cdm+ '.json?etc='+new Date().getTime();
					return function(callback) {$.getJSON(path, callback);};
				 })(dm)
			};
		}
		requireCallback(ec);
	});
});

function requireCallback(ec){
	
	var ecConfig = require('echarts/config');
	var zrEvent = require('zrender/tool/event');
	map = ec.init(document.getElementById('map'));
	map.on(ecConfig.EVENT.MAP_SELECTED, function(param){
		for( var key in param.selected){
			var ct="";
			if(param.selected[key]){
				ct = key;
				break;
			}
		}
		if(ct==""){
			return;
		}
		changeMap(ct,false);
	});
	
	bar = ec.init(document.getElementById('barChart'));
	bar.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['ctdm'],da['bmdm'],'');
	});
	sjbar = ec.init(document.getElementById('sjbarChart'));
	sjbar.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['ctdm'],da['bmdm'],'');
	});
	pie = ec.init(document.getElementById('pieChart'));
	pie.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['ctdm'],da['bmdm'],da['ajlx']);
	});
	changeMap(citymc,true);
}

function doFc(baseid,fydm,bmdm,ajlx){
	var param = "BASEID="+baseid+"&FYDM="+fydm;
	if(bmdm!=''){
		param +="&CBBM1="+bmdm; 
	}
	if(ajlx!=''){
		param +="&XTAJLX="+ajlx; 
	}
	window.open(contextPath+'/webapp/fc/fc.jsp?'+param);
}

function changeMap(ct,flag){
	citymc = ct;
	loadOption(contextPath+"/webapp/objectId.jsp",{'mc':citymc},true,function(op){
		loadData(flag,op['dm']);
	});
}

function loadData(flag,dm){
	cuttpage = 1;
	citydm = dm;
	var type = $("input[name='type']:checked").val();
	var html = "";
	html += "<a id='qs' href=\"javaScript:void(0);\" onclick=\"loadData(false,'"+citydm.substring(0,2)+"')\">";
	html += "<span style=\"width:60px;height:25px;background:#f1443c;\">&nbsp;&nbsp;</span>全省";
	html += "</a>";
	var len = citydm.length;
	
	if(len == 2||(len==4&&citydm.substring(2,4)=="00")){
		html += "<a id='fy' href=\"javaScript:void(0);\" onclick=\"loadData(false,'"+citydm.substring(0,2)+"00')\">";
		html += "<span style=\"width:60px;height:25px;background:#3d9fee;\">&nbsp;&nbsp;</span>省院";
	}else{
		html += "<a id='fy' href=\"javaScript:void(0);\" onclick=\"loadData(false,'"+citydm.substring(0, 4)+"00')\">";
		html += "<span style=\"width:60px;height:25px;background:#3d9fee;\">&nbsp;&nbsp;</span>中院";
	}
	html += "</a>";
	$(".map_plus").html(html);
	if(len==2){
		$("#qs").css("color","#FF0000");
		$("#fy").css("color","");
	}else if(citydm.substring(len-2,len)=="00"){
		$("#qs").css("color","");
		$("#fy").css("color","#FF0000");
	}else{
		$("#qs").css("color","");
		$("#fy").css("color","");
	}
	
	loadOption(contextPath+"/webapp/spxt/ccqwj/ccqwj_map.jsp",{'mc':citymc,'dm':citydm,'type':type},false,function(op){
		map.clear();
		map.setOption(op);
	});
	
	loadOption(contextPath+"/webapp/spxt/ccqwj/ccqwj_bar.jsp",{"mc":citymc,'dm':citydm,'type':type},false,function(op){
		bar.clear();
		bar.setOption(op);
	});
	
	loadOption(contextPath+"/webapp/spxt/ccqwj/ccqwj_data.jsp",{"mc":citymc,'dm':citydm,'type':type,'start':cuttpage},true,function(jo){
		totalpage = jo.totalPages;
		$("#city").html(jo.city);
		$("div.list_lh").find("ul").empty().html(jo.li).css("margin-top", 0);
		if(flag){
			$("div.list_lh").scroll({speed:24,rowHeight:34},function(){
				if(cuttpage+1>=totalpage){
					cuttpage = 1;
				}
				loadOption(contextPath+"/webapp/spxt/ccqwj/ccqwj_data.jsp",{"mc":citymc,'dm':citydm,'type':type,'start':++cuttpage},true,function(jo){
					$("div.list_lh").find("ul").empty().html(jo.li).css("margin-top", 0);
				});
			});
		}
	});
	loadOption(contextPath+"/webapp/spxt/ccqwj/ccqwj_sjbar.jsp",{"mc":citymc,'dm':citydm,'type':type},false,function(op){
		sjbar.clear();
		sjbar.setOption(op);
	});
	changeSjType();
}

function switchType(){
	loadData(false,citydm);
}

function changeSjType(){
	var lxtype = $("input[name='type']:checked").val();
	var type = $("#sjtype option:selected").val();
	loadOption(contextPath+"/webapp/spxt/ccqwj/ccqwj_pie.jsp",{"mc":citymc,"type":type,'dm':citydm,"lxtype":lxtype},false,function(op){
		pie.clear();
		pie.setOption(op);
	});
}

</script>
<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "超长期案件");
%>
<jsp:include page="../../inc/head.jsp"></jsp:include>
<div class="mainContent" >
     <!-- 左侧地图和文字区域 -->
	 <div class="map_panel">
	 	 <table style="margin:5px;" cellpadding="0" cellspacing="0" border="0">
	 	 	<tr>
	 	 		<td class="tab_top_left"></td>
	 	 		<td class="tab_top_center"></td>
	 	 		<td class="tab_top_right"></td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td class="tab_left"> </td>
	 	 		<td class="tab_center">
	 	 			<div style="position: absolute;left: 250px;top:143px;z-index:99999;">
	 	 				<input type="radio" name="type" id="radio1" class="css-checkbox" value="ss" onchange="switchType()" checked/>
	 	 				<label for="radio1" class="css-label">诉讼案件</label>
	 	 				<input type="radio" name="type" id="radio2" class="css-checkbox" value="zx" onchange="switchType()" />
	 	 				<label for="radio2" class="css-label">执行案件</label>
	 	 			</div>
	 	 			<div class="map_plus"></div>
	 	 			<div id="map"  style="width:565px;height: 600px;border:solid 0px;" > </div>
	 	 		</td>
	 	 		<td class="tab_right"> </td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td  class="tab_bottom_left"></td>
	 	 		<td  class="tab_bottom_center"></td>
	 	 		<td  class="tab_bottom_right"></td>
	 	 	</tr>
	 	 </table>
	 	
	 	<table style="margin:5px;" cellpadding="0" cellspacing="0" border="0">
	 			<tr>
	 	 		<td  class="tab_top_left"></td>
	 	 		<td  class="tab_top_center"></td>
	 	 		<td  class="tab_top_right"></td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td class="tab_left">
	 	 		</td>
	 	 		<td class="tab_center" style="padding: 0px 8px;">
	 	 			<table cellpadding="0" cellspacing="0" border="0" >
	 	 				<tr height="35px" >
	 	 					<td align="left" style="border-bottom: solid 2px #90D3F3;font-size: 26px;color: #000000;font-weight:bolder;">
	 	 						<span id='city'></span>案件
	 	 					</td>
	 	 				</tr>
	 	 				<tr>
	 	 					<td >
	 	 						<div style="height:260px;width:549px; text-align:left; border:solid 0px;">
				 					<div id='list' class="list_lh" style="height:100%;width:100%"><ul style="width:519px; "></ul></div>
				 				</div>
	 	 					</td>
	 	 				</tr>
	 	 			</table>
	 	 		</td>
	 	 		<td class="tab_right">
	 	 		</td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td  class="tab_bottom_left"></td>
	 	 		<td  class="tab_bottom_center"></td>
	 	 		<td  class="tab_bottom_right"></td>
	 	 	</tr>
	 	</table>
	 
	 </div>
	 <!-- 显示图表的区域 -->
	 <div class="chart_panel" style="position: absolute;left: 600px;top:125px;">
	 	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	 		<tr>
	 			<td colspan="2">
	 				<table style="margin:5px;" cellpadding="0" cellspacing="0" border="0">
				 			<tr>
				 	 		<td  class="tab_top_left"></td>
				 	 		<td  class="tab_top_center"></td>
				 	 		<td  class="tab_top_right"></td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td class="tab_left">
				 	 		</td>
				 	 		<td class="tab_center">
								 <div id="barChart" style="width: 1290px;height: 440px;border:solid 0px;"></div>
				 	 		</td>
				 	 		<td class="tab_right">
				 	 		</td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td  class="tab_bottom_left"></td>
				 	 		<td  class="tab_bottom_center"></td>
				 	 		<td  class="tab_bottom_right"></td>
				 	 	</tr>
				 	</table>	
	 			</td>
	 		</tr>
	 		<tr>
	 			<td width="50%">
	 				<table style="margin:5px;" cellpadding="0" cellspacing="0" border="0">
				 			<tr>
				 	 		<td  class="tab_top_left"></td>
				 	 		<td  class="tab_top_center"></td>
				 	 		<td  class="tab_top_right"></td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td class="tab_left">
				 	 		</td>
				 	 		<td class="tab_center">
								<div id="sjbarChart" style="width: 628px;height: 450px;border:solid 0px;"></div>
				 	 		</td>
				 	 		<td class="tab_right">
				 	 		</td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td  class="tab_bottom_left"></td>
				 	 		<td  class="tab_bottom_center"></td>
				 	 		<td  class="tab_bottom_right"></td>
				 	 	</tr>
				 	</table>	
	 				
	 			</td>
	 			<td width="50%">
	 			<table style="margin:5px;" cellpadding="0" cellspacing="0" border="0">
				 			<tr>
				 	 		<td  class="tab_top_left"></td>
				 	 		<td  class="tab_top_center"></td>
				 	 		<td  class="tab_top_right"></td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td class="tab_left">
				 	 		</td>
				 	 		<td class="tab_center">
				 	 			<div style="position: absolute;right: 25px;z-index:99999;right:20px;top:525px;">
				 	 				<select id="sjtype" style="width: 100px;height: 23px;text-align: right;font-size: 12px;" onchange="javaScript:changeSjType()">
				 	 					<option value="s_12">12个月以上</option>
				 	 					<option value="s_18">18个月以上</option>
				 	 					<option value="s_36">36个月以上</option>
				 	 				</select>
	 	 						</div>
								<div id="pieChart" style="width: 628px;height: 450px;border:solid 0px;"></div>
				 	 		</td>
				 	 		<td class="tab_right">
				 	 		</td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td  class="tab_bottom_left"></td>
				 	 		<td  class="tab_bottom_center"></td>
				 	 		<td  class="tab_bottom_right"></td>
				 	 	</tr>
				 	</table>	
	 			</td>
	 		</tr>
	 	</table>
	 </div>
</div>
</body>
</html>