<%@page import="tdh.frame.web.util.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="tdh.util.JSUtils,tdh.util.CalendarUtil"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
	String jssj = CalendarUtil.getMaxTjDay();
	if("".equals(jssj)){
		jssj = sdf.format(new Date());
	}else{
		jssj = jssj.substring(0,4)+"年"+jssj.substring(4,6)+"月"+jssj.substring(6,8)+"日";
	}
	String kssj = CalendarUtil.getFirstDayOfYear(jssj);
	String jssjValue = jssj.replace("年","").replace("月","").replace("日","");
	String dm = JSUtils.fydm;
	String fjm = JSUtils.fjm;
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	List<Map<String,Object>> citys = bi09.queryForList("select DM_CITY DM from DC_CITY where DATALENGTH(DM_CITY) = 4 or DATALENGTH(DM_CITY) = 2 ");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>汇总动态</title>
<style type="text/css">
.Out{ background-color: #95e6ff; } 
.Over{  background-color: #cd4147; } 
.Click{background-color: #00FF66; }
.UnClick{background-color: #95e6ff; }
</style>
<!-- 引入资源 -->
<jsp:include page="../../inc/resources.jsp"></jsp:include>
<script type="text/javascript"
	src="<%=CONTEXT_PATH%>/resources/anychart/js/AnyChart.js"></script>

</head>
<script type="text/javascript">
var citys = <%=JSONArray.fromObject(citys)%>
var contextPath = '<%=CONTEXT_PATH%>';
var map;
var bar;
var pie1;
var pie2;
var line;

var nd = '2015';
var kssj = '<%=kssj%>';
var jssj = '<%=jssjValue%>';
var dl='sas';
var citymc = '';//全局
var citydm = '';//全局
var fjm = '';

var zycitymc = '';

var ColorOut = '#95e6ff';
var ColorClick = '#00FF66';
var ColorOver = '#cd4147';
function changeBg(id,flag){
	var co = '';
	if(flag == 'Out'){
		co = ColorOut;
	}else if(flag == 'Click'){
		co = ColorClick;
	}else if(flag == 'Over'){
		co = ColorOver;
	}
	$('#'+id).css('background-color',co);
}

$(document).ready(function(){
	
	bindRq();
	
	$('#xs').bind('mouseover',function(){
		if($('#xs').attr('alt') == 'unclick'){
			changeBg('xs','Over');
		}
	});
	$('#xs').bind('mouseout',function(){
		if($('#xs').attr('alt') == 'unclick'){
			changeBg('xs','Out');
		}
	});
	$('#ms').bind('mouseover',function(){
		if($('#ms').attr('alt') == 'unclick'){
			changeBg('ms','Over');
		}
	});
	$('#ms').bind('mouseout',function(){
		if($('#ms').attr('alt') == 'unclick'){
			changeBg('ms','Out');
		}
	});
	$('#xz').bind('mouseover',function(){
		if($('#xz').attr('alt') == 'unclick'){
			changeBg('xz','Over');
		}
	});
	$('#xz').bind('mouseout',function(){
		if($('#xz').attr('alt') == 'unclick'){
			changeBg('xz','Out');
		}
	});
	
	$('#xs').bind('click',function(){
		var alt = $('#xs').attr('alt');
		if(alt == 'unclick'){
			changeBg('xs','Click');
			changeBg('ms','Out');
			changeBg('xz','Out');
			$('#xs').attr('alt','click');
			$('#ms').attr('alt','unclick');
			$('#xz').attr('alt','unclick');
			
			changeColor('xs');
			drawBar(nd,dl,citydm,fjm,citymc,'xsys');
			drawLine(nd,dl,citydm,fjm,citymc,'xsys');
		}else{
			changeBg('xs','Out');
			$('#xs').attr('alt','unclick');
			loadData(true);
		}
	});
	$('#ms').bind('click',function(){
		var alt = $('#ms').attr('alt');
		if(alt == 'unclick'){
			changeBg('ms','Click');
			changeBg('xs','Out');
			changeBg('xz','Out');
			$('#ms').attr('alt','click');
			$('#xs').attr('alt','unclick');
			$('#xz').attr('alt','unclick');
			
			changeColor('ms');
			drawBar(nd,dl,citydm,fjm,citymc,'msys');
			drawLine(nd,dl,citydm,fjm,citymc,'msys');
		}else{
			changeBg('ms','Out');
			$('#ms').attr('alt','unclick');
			loadData(true);
		}
	});
	$('#xz').bind('click',function(){
		var alt = $('#xz').attr('alt');
		if(alt == 'unclick'){
			changeBg('xz','Click');
			changeBg('ms','Out');
			changeBg('xs','Out');
			$('#xz').attr('alt','click');
			$('#ms').attr('alt','unclick');
			$('#xs').attr('alt','unclick');
			
			changeColor('xz');
			drawBar(nd,dl,citydm,fjm,citymc,'xzys');
			drawLine(nd,dl,citydm,fjm,citymc,'xzys');
		}else{
			changeBg('xz','Out');
			$('#xz').attr('alt','unclick');
			loadData(true);
		}
	});
		
	
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
	
	//require('echarts/util/mapData/params').params.DT = {
	//	getGeoJson: function(callback) {
    //		$.getJSON(contextPath+'/resources/json/jiang_su_geo.json?etc='+new Date().getTime(),callback);
   	//	}
	//};
	
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
		citymc = ct;
		changeMap();
	});
	map.on(ecConfig.EVENT.CLICK,function(param){
		var data = param.data;
		if(data.hasOwnProperty("x")&&data.hasOwnProperty("y")){
			doFc(data["id"]);
		}
	});
	
	//bar = ec.init(document.getElementById('barChart'),"macarons");
	AnyChart.renderingType = anychart.RenderingType.FLASH_ONLY;
	bar = new AnyChart(contextPath+'/resources/anychart/swf/AnyChart_6.0.11.swf', 
			contextPath + '/resources/anychart/swf/Preloader.swf');
	
	line = ec.init(document.getElementById('lineChart'),"macarons");
	/*pie1 = ec.init(document.getElementById('pie1Chart'),"macarons");
	pie1.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['ctdm'],da['kssj'],da['jssj'],da['ajlx'],'','');
	});
	pie2 = ec.init(document.getElementById('pie2Chart'),"macarons");
	pie2.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['ctdm'],da['kssj'],da['jssj'],'',da['spcx'],'');
	});*/
	pie1 = new AnyChart(contextPath+'/resources/anychart/swf/AnyChart_6.0.11.swf', 
			contextPath + '/resources/anychart/swf/Preloader.swf');
	pie2 = new AnyChart(contextPath+'/resources/anychart/swf/AnyChart_6.0.11.swf', 
			contextPath + '/resources/anychart/swf/Preloader.swf');
	
	
	changeMap();
}

function doFc(baseid,fydm,kssj,jssj,ajlx,spcx,xtajlx){
	var param = "BASEID="+baseid+"&FYDM="+fydm+"&KSSJ="+kssj+"&JSSJ="+jssj;
	if(ajlx!=''){
		param +="&ID_AJXZ="+ajlx; 
	}
	if(spcx!=''){
		param +="&ID_SPCX="+spcx; 
	}
	if(xtajlx!=''){
		param +="&XTAJLX="+xtajlx; 
	}
	window.open(contextPath+'/webapp/fc/fc.jsp?'+param);
}

function drawBar(nd,dl,dm,fjm,mc,ajlx){
	loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_bar.jsp",{
		'nd':nd,
		'kssj':kssj,
		'jssj':jssj,
		'dl':dl,
		'dm':dm,
		'fjm':fjm,
		'mc':mc,
		'ajlx':ajlx
	},true,function(op){
		//bar.clear();
		//bar.setOption(op);
		bar.width = '100%';
		bar.height = '100%';
		bar.wMode = 'transparent';
		bar.setData(op.bar);
		bar.write('barChart');
		
	});
}

function drawLine(nd,dl,dm,fjm,mc,ajlx){
	loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_line.jsp",{
		'nd':nd,
		'kssj':kssj,
		'jssj':jssj,
		'dl':dl,
		'dm':dm,
		'fjm':fjm,
		'mc':mc,
		'ajlx':ajlx
	},false,function(op){
		line.clear();
		line.setOption(op);
	});
}

function loadData(flag){
	
	//刷新地图的时候
	changeBg('xs','Out');
	changeBg('ms','Out');
	changeBg('xz','Out');
	$('#xs').attr('alt','unclick');
	$('#ms').attr('alt','unclick');
	$('#xz').attr('alt','unclick');
	
	
	if(citydm.length < 6){
		var html = "";
		html += "<a href=\"javaScript:void(0);\" onclick=\"changeArea('"+citydm.substring(0,2)+"','"+fjm.substring(0,1)+"','全省')\">";
		html += "<span style=\"width:60px;height:25px;background:#f1443c;\">&nbsp;&nbsp;</span>全省";
		html += "</a>";
		
		if(citydm.length == 2 || citydm.length == 4 && citydm.substring(2,4) == '00'){
			html += "<a href=\"javaScript:void(0);\" onclick=\"changeArea('"+citydm.substring(0,2)+"00','"+fjm.substring(0,1)+"0','省院')\">";
			html += "<span style=\"width:60px;height:25px;background:#3d9fee;\">&nbsp;&nbsp;</span>省院";
		}else{
			zycitymc = citymc;
			html += "<a href=\"javaScript:void(0);\" onclick=\"changeArea('"+citydm+"00','"+fjm+"0','"+citymc.replace("市","")+"中院')\">";
			html += "<span style=\"width:60px;height:25px;background:#3d9fee;\">&nbsp;&nbsp;</span>中院";
		}
		html += "</a>";
		$(".map_plus").html(html);
		
		//地图
		loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_map.jsp",{
			'nd':nd,
			'kssj':kssj,
			'jssj':jssj,
			'dl':dl,
			'dm':citydm,
			'fjm':fjm,
			'mc':citymc
		},false,function(op){
			map.clear();
			map.setOption(op);
		});
		//bar
		drawBar(nd,dl,citydm,fjm,citymc,'');
		
	}else{
		//法院代码为6的
		if(flag){
			loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_map.jsp",{
				'nd':nd,
				'kssj':kssj,
				'jssj':jssj,
				'dl':dl,
				'dm':citydm.substring(0,4),
				'fjm':fjm.substring(0,2),
				'mc':zycitymc
			},false,function(op){
				map.clear();
				map.setOption(op);
			});
			
			drawBar(nd,dl,citydm.substring(0,4),fjm.substring(0,2),zycitymc,'');
			
		}
	}
	
	if(citymc == ''){
		$('#area').html('全省');
	}else{
		$('#area').html(citymc);
	}
	loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_data.jsp",{
		'nd':nd,
		'kssj':kssj,
		'jssj':jssj,
		'dl':dl,
		'dm':citydm,
		'fjm':fjm,
		'mc':citymc
	},true,function(mess){
		$("#ajqk").html(mess.ajqk);
		$('#info').html(mess.info);
	});
	
	drawLine(nd,dl,citydm,fjm,citymc,'');
	
	loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_pie1.jsp",{
		'nd':nd,
		'kssj':kssj,
		'jssj':jssj,
		'dl':dl,
		'dm':citydm,
		'fjm':fjm,
		'mc':citymc
	},true,function(op){
		//pie1.setOption(op);
		pie1.width = '100%';
		pie1.height = '100%';
		pie1.wMode = 'transparent';
		pie1.setData(op.pie);
		pie1.write('pie1Chart');
	});
	loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_pie2.jsp",{
		'nd':nd,
		'kssj':kssj,
		'jssj':jssj,
		'dl':dl,
		'dm':citydm,
		'fjm':fjm,
		'mc':citymc
	},true,function(op){
		//pie2.setOption(op);
		pie2.width = '100%';
		pie2.height = '100%';
		pie2.wMode = 'transparent';
		pie2.setData(op.pie);
		pie2.write('pie2Chart');
	});
}

//地图点击--fydm长度小于6的时候需要重刷地图，地图改变；否则不用重刷
function changeMap(){
	loadOption(contextPath+"/webapp/objectId.jsp",{'mc':citymc},true,function(op){
		fjm = op['fjm'];
		citydm = op['dm'];
		if(citydm.length < 6){
			loadData(true);
		}else{
			loadData(false);
		}
		
	});
	
}

//需要重刷地图,bar
function changeNd(val){
	nd = val;
	loadData(true);
}

//需要重刷地图,bar
function changeDl(value){
	dl = value;
	if(dl == 'jas' || dl == 'wjs'){
		$('#condition_bottom').hide();
	}else{
		$('#condition_bottom').show();
	}
	loadData(true);
}

//需要重刷地图,bar
function changeArea(dm,_fjm,mc){
	citydm = dm;
	citymc = mc;
	fjm = _fjm;
	loadData(true);
}

//民事 刑事 行政--一审同比上升、下降
function changeColor(value){
	loadOption(contextPath+"/webapp/spxt/hzqk_day_anychart/hzdt_day_anychart_map_color.jsp",{
		'nd':nd,
		'kssj':kssj,
		'jssj':jssj,
		'dl':dl,
		'dm':citydm,
		'fjm':fjm,
		'lx':value,
		'mc':''
	},false,function(op){
		map.clear();
		map.setOption(op);
	});
}

function bindRq() {
	
	$("#jssj").bind("click",function() {
		WdatePicker({
			dateFmt : "yyyy年MM月dd日",
			maxDate : '<%=jssj%>',
			onpicked:function(){
				jssj = $('#jssj').val().replace("年","").replace("月","").replace("日","");
				loadData(true);
			}
		});
		
	});
	
}

function changeRq(){
	jssj = $('#jssj').val();
}

</script>

<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "汇总动态");
%>

<jsp:include page="../../inc/head.jsp"></jsp:include>
<div class="mainContent" >
     <!-- 左侧地图和文字区域 -->
	 <div class="map_panel">
	 	 <table style="margin:5px;" cellpadding="0" cellspacing="0" border="0">
	 	 	<tr>
	 	 		<td  class="tab_top_left"></td>
	 	 		<td  class="tab_top_center"></td>
	 	 		<td  class="tab_top_right"></td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td class="tab_left">
	 	 		
	 	 		</td>
	 	 		
	 	 		<!--  -->
	 	 		<td class="tab_center">
	 	 			<div style="position: absolute;left: 128px;top:143px;z-index:99999;">
	 	 				<input type="text" id="jssj" value="<%=jssj%>" readonly class='selDate'/>
		                <input type="radio" name="dl" id="sas" class="css-checkbox" value="1" onchange="changeDl('sas')" checked/>
		                <label for="sas" class="css-label">收案</label>
	 	 				<input type="radio" name="dl" id="jas" class="css-checkbox" value="2" onchange="changeDl('jas')" />
	 	 				<label for="jas" class="css-label">结案</label>
	 	 				<input type="radio" name="dl" id="wjs" class="css-checkbox" value="3" onchange="changeDl('wjs')" />
	 	 				<label for="wjs" class="css-label">未结</label>
 					</div>
		 	 		<div class="map_plus">
		 	 						<span onclick="changeArea('<%=dm %>','<%=fjm %>','全省')" style='cursor:pointer;'>
									<span style="width:60px;height:25px;background:#f1443c;">&nbsp;&nbsp;</span>全省
									</span>
									<span onclick="changeArea('<%=dm+"00" %>','<%=fjm+"0" %>','江苏高院')" style='cursor:pointer;'>
									<span style="width:60px;height:25px;background:#3d9fee;">&nbsp;&nbsp;</span>省院
									</span>
					</div>
					<div id='condition_bottom' class="condtion_bottom">
									<span alt = 'unclick' id = 'xs' style='cursor:pointer;' >
									刑事一审升降
									</span>
									|
		 	 						<span alt = 'unclick' id = 'ms' style='cursor:pointer;'>
									民事一审升降
									</span>
									|
									<span alt = 'unclick' id = 'xz' style='cursor:pointer;'>
									行政一审升降
									</span>
					</div>
		 	 		<div id="map" style="width:565px;height: 600px;border:solid 0px;" >
		 			</div>
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
	 	
	 	<table style="margin:5px;" cellpadding="0" cellspacing="0" border="0">
	 			<tr>
	 	 		<td  class="tab_top_left"></td>
	 	 		<td  class="tab_top_center"></td>
	 	 		<td  class="tab_top_right"></td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td class="tab_left">
	 	 		</td>
	 	 		<!--  
	 	 		<td class="tab_center">
	 	 			<div style="height:295px;width:565px; text-align:left; font-size:28px;line-height:60px;border:solid 0px;">
				 		<span id='ajqk' ></span>
				 	</div>
	 	 		</td>
	 	 		-->
	 	 		<td class="tab_center" style="padding: 0px 8px;">
	 	 			<table cellpadding="0" cellspacing="0" border="0" >
	 	 				<tr height="45px" >
	 	 					<td align="left" style="border-bottom: solid 2px #90D3F3;font-size: 26px;color: #000000;font-weight:bolder;">
	 	 						<span id='area'>全省</span>案件情况
	 	 					</td>
	 	 				</tr>
	 	 				<tr>
	 	 					<td>
	 	 						<div style="height:250px;width:509px;border:solid 0px; padding: 0 20px;">
	 	 							<span id='ajqk' ></span>
	 	 							<br>
	 	 							<span id='info' style=' text-align:left; float:left;color:blue;'></span>
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
	 			<!--  
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
	 			-->
	 			<!-- -->
	 			<td colspan="2">
	 				<table>
	 					<tr>
	 						<td>
		 						<table style="margin:2px;" cellpadding="0" cellspacing="0" border="0">
						 			<tr>
							 	 		<td  class="tab_top_left"></td>
							 	 		<td  class="tab_top_center"></td>
							 	 		<td  class="tab_top_right"></td>
							 	 	</tr>
							 	 	<tr>
							 	 		<td class="tab_left">
							 	 		</td>
							 	 		<td class="tab_center">
											 <div id="barChart" style="width: 840px;height: 440px;border:solid 0px;"></div>
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
	 						<td>
	 							<table style="margin:2px;" cellpadding="0" cellspacing="0" border="0">
						 			<tr>
							 	 		<td  class="tab_top_left"></td>
							 	 		<td  class="tab_top_center"></td>
							 	 		<td  class="tab_top_right"></td>
							 	 	</tr>
							 	 	<tr>
							 	 		<td class="tab_left">
							 	 		</td>
							 	 		<td class="tab_center">
											 <div id="lineChart" style="width: 420px;height: 440px;border:solid 0px;"></div>
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
								<div id="pie1Chart" style="width: 628px;height: 450px;border:solid 0px;"></div>
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
								<div id="pie2Chart" style="width: 628px;height: 450px;border:solid 0px;"></div>
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