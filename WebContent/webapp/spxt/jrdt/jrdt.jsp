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
var pie;
var line;
var citymc = "";
var citydm = "";
var stime = "";

$(document).ready(function(){
	sizeChange();
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
	
	pie = ec.init(document.getElementById('pieChart'));
	pie.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['dm'],da['kssj'],'',da['ajlx'],da['lx']);
	});
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
		$(".jrdt_qs").unbind().bind("click",function(){
			loadData(false,citydm.substring(0,2));
			$(".jrdt_sy").removeClass("hide");
			$(".jrdt_zy").addClass("hide");
			$(this).addClass("jrdt_select").siblings().removeClass("jrdt_select");
		});
		if(len == 2||(len==4&&citydm.substring(2,4)=="00")){
			$(".jrdt_sy").unbind().bind("click",function(){
				loadData(false,citydm.substring(0,2)+"00");
				$(this).addClass("jrdt_select").siblings().removeClass("jrdt_select");
			});
		}else{
			$(".jrdt_sy").addClass("hide");
			$(".jrdt_zy").unbind().bind("click",function(){
				loadData(false,citydm.substring(0,4)+"00");
				$(this).addClass("jrdt_select").siblings().removeClass("jrdt_select");
			}).removeClass("hide");
		}
		loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_map_rq.jsp",{'mc':citymc,'dm':citydm},false,function(op){
			map.clear();
			map.setOption(op);
		});
		loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_bar.jsp",{'mc':citymc,'dm':citydm},false,function(op){
			bar.clear();
			bar.setOption(op);
		});
	}
	
	loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_data.jsp",{'mc':citymc,'dm':citydm},true,function(json){
		$("#jr_sa").html(json['jr_sa']);
		$("#jr_ja").html(json['jr_ja']);
		$("#nl_sa").html(json['nl_sa']);
		$("#nl_ja").html(json['nl_ja']);
		$("#jr_wj").html(json['jr_wj']);
		$("[id='city']").each(function(i){$(this).html(json['city']);});
	});
	reloadEChart(flag,line,["收案数","结案数"],contextPath+"/webapp/spxt/jrdt/jrdt_line.jsp",{'mc':citymc,'dm':citydm,'stime':stime},function(chart,rel,op,mc){
		if(!rel){return;}
		var leth = op["xAxis"][0]["data"].length;
		op["dataZoom"]={show:true,realtime:true,start:(Math.floor((leth/10))>7?7:Math.floor((leth/10)))*10,end:100,height:25};
		op["legend"]["y"] = 20;
		cc=[{type:'value',scale:true,splitNumber:6,axisLabel : {formatter: '{value}'}}];
		op["grid"]={x:50,y:80,x2:20,y2:60};
		op["title"]={show:false,x:'center',text: mc+'案件动态情况',textStyle:{fontSize:22,fontWeight:'bolder',color:'#000000',margin:'0 20 20 20'}};
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
	loadOption(contextPath+"/webapp/spxt/jrdt/jrdt_pie.jsp",{'mc':citymc,'dm':citydm,'type':"sa"},false,function(op){
		pie.clear();
		pie.setOption(op);
	});
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
	$("#barChart").css({"width":w-left-30});
	$(".jrdt_bar_panel").css({"width":w-left-30});
	
	var line_left = $("#lineChart").offset().left;
	var pie_left = $("#pieChart").offset().left;
	$("#lineChart").css({"width":pie_left-line_left-10});
	$(".jrdt_line_panel").css({"width":pie_left-line_left-10});
}

</script>
<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "今日动态");
%>
<jsp:include page="../../inc/head.jsp"></jsp:include>
<div class="mainContent">
	<div class="jrdt_map_panel" >
		<div class="jrdt_title"><i class="arrow"></i><span id='city'>湖北省</span></div>
		<div class="jrdt_qs jrdt_select"><i class="bg"></i><span>全省</span></div>
		<div class="jrdt_sy "><i class="bg"></i><span>省院</span></div>
		<div class="jrdt_zy hide"><i class="bg"></i><span>中院</span></div>
		<div class="map" id="map" style="width:470px;height: 360px;" ></div>
	 </div>
	 <div class="jrdt_bar_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='bar_title'><span id='city'></span>收案结案结构图</span></div>
	 	<div class='bar' id="barChart" style="height: 404px;"></div>
	 </div>
	 <div class="jrdt_cont_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='bar_title'>今日动态</span></div>
	 	<div class="content">
	 		<ul>
	 			<li><span>今日<span id='city'></span>新收案件</span><span class="num" id='jr_sa'>0</span><span class="unit">件</span></li>
	 			<li class="even"><span>今日<span id='city'></span>审结案件</span><span class="num" id='jr_ja'>0</span><span class="unit">件</span></li>
	 			<li><span>今年<span id='city'></span>累计收案</span><span class="num" id='nl_sa'>0</span><span class="unit">件</span></li>
	 			<li class="even"><span>今年<span id='city'></span>累计结案</span><span class="num" id='nl_ja'>0</span><span class="unit">件</span></li>
	 			<li><span>当前<span id='city'></span>未结案件</span><span class="num" id='jr_wj'>0</span><span class="unit">件</span></li>
	 		</ul>
	 	</div>
	 </div>
	 <div class="jrdt_line_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='bar_title'><span id='city'></span>今日案件动态情况</span></div>
	 	<div class='line' id="lineChart" style="width:300px;height:334px;"></div>
	 </div>
	 <div class="jrdt_pie_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='bar_title'><span id='city'></span>收案类型分布</span></div>
	 	<div class='pie' id="pieChart" style="width: 370px;height: 280px;"></div>
	 </div>
	 <div class="jrdt_bottom"></div>
</div>
</body>
</html>