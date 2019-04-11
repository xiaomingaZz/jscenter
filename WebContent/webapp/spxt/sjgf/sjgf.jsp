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
<title>数据质量</title>
<!-- 引入资源 -->
<jsp:include page="../../inc/resources.jsp"></jsp:include>
</head>
<script type="text/javascript">
var contextPath = '<%=CONTEXT_PATH%>';
var citys = <%=JSONArray.fromObject(citys)%>
var map;
var bar;
var gauge;
var line;
var citymc = "";
var citydm = "";
var stime = "";

$(document).ready(function(){
	sizeChange();
	initEcharts(['echarts/chart/gauge','echarts/chart/bar','echarts/chart/line','echarts/chart/map'],contextPath+'/resources/echarts-2.2.7/build/dist',function(ec){
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
	gauge = ec.init(document.getElementById('gaugeChart'));
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
		$(".sjzl_qs").unbind().bind("click",function(){
			loadData(false,citydm.substring(0,2));
			$(".sjzl_sy").removeClass("hide");
			$(".sjzl_zy").addClass("hide");
			$(this).addClass("sjzl_select").siblings().removeClass("sjzl_select");
		});
		if(len == 2||(len==4&&citydm.substring(2,4)=="00")){
			$(".sjzl_sy").unbind().bind("click",function(){
				citymc += '高院';
				loadData(false,citydm.substring(0,2)+"00");
				$(this).addClass("sjzl_select").siblings().removeClass("sjzl_select");
			});
		}else{
			$(".sjzl_sy").addClass("hide");
			$(".sjzl_zy").unbind().bind("click",function(){
				loadData(false,citydm.substring(0,4)+"00");
				$(this).addClass("sjzl_select").siblings().removeClass("sjzl_select");
			}).removeClass("hide");
		}
		loadOption(contextPath+"/webapp/spxt/sjgf/sjgf_map.jsp",{'mc':citymc,'dm':citydm},false,function(op){
			map.clear();
			map.setOption(op);
		});
		loadOption(contextPath+"/webapp/spxt/sjgf/sjgf_bar.jsp",{'mc':citymc,'dm':citydm},false,function(op){
			bar.clear();
			bar.setOption(op);
		});
	}
	loadOption(contextPath+"/webapp/spxt/sjgf/sjgf_gauge.jsp",{'mc':citymc,'dm':citydm},false,function(op){
		$("#hgajs").html(op.GFS);
		$("#bhgajs").html(op.BGFS);
		gauge.clear();
		gauge.setOption(op);
	});
	loadOption(contextPath+"/webapp/spxt/sjgf/sjgf_data.jsp",{'mc':citymc,'dm':citydm},true,function(json){
		$("[id='city']").each(function(i){$(this).html(json['city']);});
	});
}

//var times = setInterval("loadData(false,'')",2*60*1000);
window.onresize = sizeChange;
function sizeChange(){
	var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var w=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var gaugeleft = $("#gaugeChart").offset().left;
	$("#gaugeChart").css({"width":w-gaugeleft-30});
	
	var barChart = $("#barChart").offset().left;
	$("#barChart").css({"width":w-barChart-30});
}
</script>
<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "数据质量");
%>
<jsp:include page="../../inc/head.jsp"></jsp:include>
<div class="mainContent">
	<div class="sjzl_map_panel" >
		<div class="sjzl_title"><i class="arrow"></i><span id='map_title'><span id='city'>湖北省</span></span></div>
		<div class="sjzl_qs sjzl_select"><i class="bg"></i><span>全省</span></div>
		<div class="sjzl_sy "><i class="bg"></i><span>省院</span></div>
		<div class="sjzl_zy hide"><i class="bg"></i><span>中院</span></div>
		<div class="map" id="map" style="width:470px;height:360px;" ></div>
	 </div>
	 <div class="sjzl_cont_panel">
	 	<div class="sjzl_title"><i class="arrow"></i><span id='bar_title'><span id='city'>湖北省</span>案件合格率</span></div>
	 	<div class="content">
	 		<ul>
	 			<li><span>合格案件数</span><span class="num" id="hgajs"></span><span class="unit">件</span></li>
	 			<li class="even"><span>不合格案件数</span><span class="num" id="bhgajs"></span><span class="unit">件</span></li>
	 		</ul>
	 	</div>
	 	<div class='gague' id="gaugeChart" style="width:370px;height: 280px;"></div>
	 </div>
	 <div class="sjzl_bar_panel">
	 	<div class="sjzl_title"><i class="arrow"></i><span id='bar_title'><span id='city'>湖北省</span>各地区数据质量分布</span></div>
	 	<div class='bar' id="barChart" style="height:380px;"></div>
	 </div>
	 <div class="sjzl_bottom"></div>
</div>
</body>
</html>