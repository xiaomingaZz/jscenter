<%@page import="tdh.util.JSUtils"%>
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
	List<Map<String,Object>> citys = bi09.queryForList("select DM_CITY DM from DC_CITY where ((DATALENGTH(DM_CITY) = 4 or DATALENGTH(DM_CITY) = 2)) and DM_CITY like '"+JSUtils.fydm+"%' ");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<!-- 引入资源 -->
<jsp:include page="../../inc/resources.jsp"></jsp:include>
</head>
<script type="text/javascript">
var contextPath = '<%=CONTEXT_PATH%>';
var citys = <%=JSONArray.fromObject(citys)%>
var map;
var bar;
//var pie;
var line;
var citymc = "";
var citydm = "";
var stime = "";

$(document).ready(function(){
	initEcharts(['echarts/chart/pie','echarts/chart/bar','echarts/chart/line','echarts/chart/map'],contextPath+'/resources/echarts-2.2.7/build/dist',function(ec){
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
	sizeChange();
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
		stime="";
		changeMap(ct,true);
	});
	bar = ec.init(document.getElementById('barChart'));
	
	bar.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['dm'],da['kssj'],'','',da['lx']);
	});
	
	line = ec.init(document.getElementById('lineChart'),"macarons");
	//pie = ec.init(document.getElementById('pieChart'));
	//pie.on(ecConfig.EVENT.CLICK,function(param){
	//	var da = param.data;
	//	doFc(da['baseid'],da['dm'],da['kssj'],'',da['ajlx'],da['lx']);
	//});
	changeMap(citymc,true);
}

function changeMap(ct,flag){
	citymc = ct;
	loadOption(contextPath+"/webapp/objectId.jsp",{'mc':citymc},true,function(op){
		loadData(flag,op['dm']);
	});
}

function loadData(flag,dm){
	if(flag){
		stime = "";
	}
	if(dm!=""){
		citydm = dm;
	}
	var len = dm.length;
	if(len < 6){
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
		
		loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_map.jsp",{'mc':citymc,'dm':citydm},false,function(op){
			map.clear();
			map.setOption(op);
		});
		loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_bar.jsp",{'mc':citymc,'dm':citydm},false,function(op){
			bar.clear();
			bar.setOption(op);
		});
	}
	
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
	
	
	loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_data.jsp",{'mc':citymc,'dm':citydm},true,function(json){
		$("#ajqk").html(json.table);
		$("#city").html(json.city);
	});
	reloadEChart(flag,line,["收案数","结案数"],contextPath+"/webapp/spxt/jrdt/jrdt_line.jsp",{'mc':citymc,'dm':citydm,'stime':stime},function(chart,rel,op,mc){
		if(!rel){return;}
		var leth = op["xAxis"][0]["data"].length;
		op["dataZoom"]={show:true,realtime:true,start:(Math.floor((leth/10))>7?7:Math.floor((leth/10)))*10,end:100,height:25};
		op["yAxis"]=[{type:'value',scale:true,splitNumber:6,axisLabel : {formatter: '{value}'}}];
		op["grid"]={x:50,y:40,x2:20,y2:60};
		op["title"]={show:true,x:'center',text: mc+'案件动态情况',textStyle:{fontSize:22,fontWeight:'bolder',color:'#000000',margin:'0 20 20 20'}};
		line.setOption(op);
	},flag);
	switchType();
}

function doFc(baseid,fydm,kssj,jssj,ajlx,lx){
	var param = "BASEID="+baseid+"&FYDM="+fydm+"&KSSJ="+kssj+"&JSSJ="+jssj;
	if(ajlx!=''){
		param +="&XTAJLX="+ajlx; 
	}
	if(lx!=''){
		param +="&LX="+lx;
	}
	window.open(contextPath+'/webapp/fc/fc.jsp?'+param);
}

//案件组成情况饼图切换收案数和结案数
function switchType(){
	//var type = $("input[name='type']:checked").val(); 
	//loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_pie.jsp",{'mc':citymc,'dm':citydm,'type':type},false,function(op){
	//	pie.clear();
	//	pie.setOption(op);
	//});
}

//重新加载图表
function reloadEChart(reload,chart,ldata,url,args,callback,loading){
	if(loading){
		chart.showLoading({effect:"whirling"});
	}
	loadOption(url,args,true,function(json){
		stime = json.stime;
		var op={};
		if(reload){
			if(loading){
				chart.hideLoading();
			}
			chart.clear();
			var series = [];
			for(var i=0;i<ldata.length;i++){
				series[i]= {"name":ldata[i],"type":"line","symbol":'emptyCircle',"data":json.series[i],"itemStyle":{"normal":{"label":{"show":true}}}};
			}
			op=getOption("",ldata, null,series,[],[]);
			op["color"]=["#FF7F50", "#da70d6"];
			op["xAxis"]=[{type:'category',boundaryGap:true,axisTick:{onGap:false},splitLine:{show:false},data:json.xdata}];
			op["yAxis"]=[{type:'value',scale:true,splitNumber:6,axisLabel : {formatter: '{value}'}}];
		}else{
			var params =[];
			var j=0;
			for(var i=0;i<ldata.length;i++){
				var series = json.series[i];
				for(var k=0;k<series.length;k++){
					if(i==0){
						params[j] = [i,series[k],false,true,json.xdata[k]];
					}else{
						params[j] = [i,series[k],false,true];
					}
					j++;
				}
			}
			if(params.length>0){
				chart.addData(params);
			}
		}
		callback(chart,reload,op,json.city);
	});
}

var times = setInterval("loadData(false,'')",2*60*1000);
window.onresize = sizeChange;
function sizeChange(){
	var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var w=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var left = $("#barChart").offset().left;
	$("#barChart").css({"width":w-left-25-5});
	$("#lineChart").css({"width":w-left-25-5});
}

</script>
<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "今日动态");
%>
<jsp:include page="../../inc/head.jsp"></jsp:include>
<div class="mainContent" >
	<!--左侧地图和文字区域  -->
	<div class="map_panel">
	 	 <table style="margin:5px 0px 5px 5px;" cellpadding="0" cellspacing="0" border="0">
	 	 	<tr>
	 	 		<td  class="tab_top_left"></td>
	 	 		<td  class="tab_top_center"></td>
	 	 		<td  class="tab_top_right"></td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td class="tab_left"></td>
	 	 		<td class="tab_center">
	 	 			<div class="map_plus"></div>
	 	 			<div id="map" style="width:565px;height: 380px;border:solid 0px;" ></div>
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
	 	
	 	<table style="margin:0px 0px 5px 5px;" cellpadding="0" cellspacing="0" border="0">
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
	 	 				<tr height="45px" >
	 	 					<td align="left" style="font-fimaly:微软雅黑;border-bottom: solid 2px #87CEEB;font-size: 26px;color: #000000;font-weight:bolder;">
	 	 						今日<span id='city'></span>动态
	 	 					</td>
	 	 				</tr>
	 	 				<tr>
	 	 					<td >
	 	 						<div style="text-align:center;height:300px;width:509px;border:solid 0px; padding: 0 20px;">
	 	 							<span  id='ajqk' style="text-align:center;" ></span>
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
	 <!--显示图表的区域 -->
	 <div class="chart_panel">
	 	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	 		<tr>
	 			<td >
	 				<table style="margin:5px 0px 5px 5px;" cellpadding="0" cellspacing="0" border="0">
				 		<tr>
				 	 		<td  class="tab_top_left"></td>
				 	 		<td  class="tab_top_center"></td>
				 	 		<td  class="tab_top_right"></td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td class="tab_left"></td>
				 	 		<td class="tab_center">
								 <div id="barChart" style="height: 380px;border:solid 0px;"></div>
				 	 		</td>
				 	 		<td class="tab_right"></td>
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
	 			<td >
	 				<table style="margin:0px 0px 5px 5px;" cellpadding="0" cellspacing="0" border="0">
				 		<tr>
				 	 		<td  class="tab_top_left"></td>
				 	 		<td  class="tab_top_center"></td>
				 	 		<td  class="tab_top_right"></td>
				 	 	</tr>
				 	 	<tr>
				 	 		<td class="tab_left"> </td>
				 	 		<td class="tab_center">
								<div id="lineChart" style="height:345px;border:solid 0px;"></div>
				 	 		</td>
				 	 		<td class="tab_right"> </td>
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