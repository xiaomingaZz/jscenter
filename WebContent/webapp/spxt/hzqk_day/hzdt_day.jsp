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
	List<Map<String,Object>> citys = bi09.queryForList("select DM_CITY DM from DC_CITY where ((DATALENGTH(DM_CITY) = 4 or DATALENGTH(DM_CITY) = 2)) and DM_CITY like '"+JSUtils.fydm+"%' ");
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
	sizeChange();
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
	
	bar = ec.init(document.getElementById('barChart'),"macarons");
	//line = ec.init(document.getElementById('lineChart'));
	line = ec.init(document.getElementById('lineChart'),"macarons");
	pie1 = ec.init(document.getElementById('pieChart1'),"macarons");
	pie1.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['ctdm'],da['kssj'],da['jssj'],da['ajlx'],'','');
	});
	pie2 = ec.init(document.getElementById('pieChart2'),"macarons");
	pie2.on(ecConfig.EVENT.CLICK,function(param){
		var da = param.data;
		doFc(da['baseid'],da['ctdm'],da['kssj'],da['jssj'],'',da['spcx'],'');
	});
	bar.on(ecConfig.EVENT.CLICK, function(param) {
		var da = param.data;
		doFc(da['baseid'],da['dm'],da['kssj'],da['jssj'],'','',da['ajlx']);
	});
	
	changeMap();
}

function doFc(baseid,fydm,kssj,jssj,ajlx,spcx,xtajlx){
	var param = "BASEID="+baseid+"&FYDM="+fydm+"&KSSJ="+kssj+"&JSSJ="+jssj;
	if(ajlx!=''){
		param +="&ID_AJLX="+ajlx; 
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
	loadOption("hzdt_day_bar.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dl':dl,'dm':dm,'fjm':fjm,'mc':mc,'ajlx':ajlx},false,function(op){
		bar.clear();
		bar.setOption(op);
	});
}

function drawLine(nd,dl,dm,fjm,mc,ajlx){
	loadOption("hzdt_day_line.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dl':dl,'dm':dm,'fjm':fjm,'mc':mc,'ajlx':ajlx},false,function(op){
		line.clear();
		line.setOption(op);
	});
}

function loadData(flag){
	
	//刷新地图的时候
	//changeBg('xs','Out');
	//changeBg('ms','Out');
	//changeBg('xz','Out');
	//$('#xs').attr('alt','unclick');
	//$('#ms').attr('alt','unclick');
	//$('#xz').attr('alt','unclick');
	
	var len = citydm.length;
	if(citydm.length < 6){
		$(".jrdt_qs").unbind().bind("click",function(){
			changeArea(citydm.substring(0,2),fjm.substring(0,1),'全省');
			$(".jrdt_sy").removeClass("hide");
			$(".jrdt_zy").addClass("hide");
			$(this).addClass("jrdt_select").siblings().removeClass("jrdt_select");
		});
		if(len == 2||(len==4&&citydm.substring(2,4)=="00")){
			$(".jrdt_sy").unbind().bind("click",function(){
				changeArea(citydm.substring(0,2)+"00",fjm.substring(0,1),'省院');
				$(this).addClass("jrdt_select").siblings().removeClass("jrdt_select");
			});
		}else{
			$(".jrdt_sy").addClass("hide");
			$(".jrdt_zy").unbind().bind("click",function(){
				changeArea(citydm.substring(0,4)+"00",fjm.substring(0,2),citymc.replace("市","")+"中院");
				$(this).addClass("jrdt_select").siblings().removeClass("jrdt_select");
			}).removeClass("hide");
		}
		
		//地图
		loadOption("hzdt_day_map.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dl':dl,'dm':citydm,'fjm':fjm,'mc':citymc},false,function(op){
			map.clear();
			map.setOption(op);
		});
		//bar
		drawBar(nd,dl,citydm,fjm,citymc,'');
	}else{
		//法院代码为6的
		if(flag){
			loadOption(contextPath+"/webapp/spxt/hzqk_day/hzdt_day_map.jsp",{
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
	loadOption("hzdt_day_data.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dl':dl,'dm':citydm,'fjm':fjm,'mc':citymc},true,function(mess){
		$("#fy").html(mess["fy"]);
		$("#rs").html(mess["rs"]);
		$("#sa").html(mess["sa"]);
		$("#sa_tb").html(mess["sa_tb"]);
		$("#ja").html(mess["ja"]);
		$("#ja_tb").html(mess["ja_tb"]);
		$("#wj").html(mess["wj"]);
		$("#wj_tb").html(mess["wj_tb"]);
		$('#info').html(mess.info);
		$("[id='city']").each(function(i){$(this).html(mess["city"]);});
	});
	
	drawLine(nd,dl,citydm,fjm,citymc,'');
	
	loadOption("hzdt_day_pie1.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dl':dl,'dm':citydm,'fjm':fjm,'mc':citymc},false,function(op){
		pie1.setOption(op);
	});
	loadOption("hzdt_day_pie2.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dl':dl,'dm':citydm,'fjm':fjm,'mc':citymc},false,function(op){
		pie2.setOption(op);
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
	loadOption("hzdt_day_map_color.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dl':dl,'dm':citydm,'fjm':fjm,'lx':value,'mc':''},false,function(op){
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

window.onresize = sizeChange;
function sizeChange(){
	var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var w=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var left = $("#lineChart").offset().left;
	$("#lineChart").css({"width":w-left-30});
	$("#lineChart").parent().css({"width":w-left-30});
	
	var ww = $(".hzdt_spcx_panel").offset().left- $(".hzdt_ajlx_panel").offset().left-10+$(".hzdt_spcx_panel").width();

	$("#pieChart1").css({"width":ww/2});
	$("#pieChart2").css({"width":ww/2});
	$("#pieChart1").parent().css({"width":ww/2});
	$("#pieChart2").parent().css({"width":ww/2});
	left = $("#barChart").offset().left;
	$("#barChart").css({"width":w-left-30});
	$("#barChart").parent().css({"width":w-left-30});
}

</script>

<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "汇总动态");
%>

<jsp:include page="../../inc/head.jsp"></jsp:include>
<div class="mainContent" >
     <div class="jrdt_map_panel" >
		<div class="jrdt_title"><i class="arrow"></i><span id='city'>湖北省</span></div>
		<div class="jrdt_qs jrdt_select"><i class="bg"></i><span>全省</span></div>
		<div class="jrdt_sy "><i class="bg"></i><span>省院</span></div>
		<div class="jrdt_zy hide"><i class="bg"></i><span>中院</span></div>
		<div class="map" id="map" style="width:470px;height: 360px;" ></div>
	 </div>
	  <div class="hzdt_line_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='city'>湖北省</span>收案趋势</div>
	 	<div id="lineChart" class='bar' style="height:384px;"></div>
	 </div>
	 <div class="hzdt_cont_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='city'>湖北省</span>案件情况</div>
	 	<div class="content">
	 		<ul>
	 			<li>法院<span class="num1" id="fy">0</span><span class="unit1">家</span>
	 				<span class="tb">法官</span><span class='num2' id='rs'>-</span><span class="unit2">人</span>
	 			</li>
	 			<li class="even">收案<span class="num1" id="sa">0</span><span class="unit1">件</span>
	 				<span class="tb">同比</span><span class='num2' id='sa_tb'>-</span><span class="unit2">%</span>
	 			</li>
	 			<li>结案<span class="num1" id="ja">0</span><span class="unit1">件</span>
	 				<span class="tb">同比</span><span class='num2' id='ja_tb'>-</span><span class="unit2">%</span>
	 			</li>
	 			<li class="even">未结<span class="num1" id="wj">0</span><span class="unit1">件</span>
	 				<span class="tb">同比</span><span class='num2' id='wj_tb'>-</span><span class="unit2">%</span>
	 			</li>
	 		</ul>
	 		<div style="margin: 0px 20px;font-size: 14px;width: 410px;color: #0000FF;">
	 			<p style="line-height:150%;margin: 0px;">说明:<span id='info'>以上数据统计期2015年12月21日至2016年01月15日，刑罚变更案件未统计在内（统计期内刑罚变更案件共审结0件）</span></p>
	 		</div>
	 	</div>
	 </div>
	 <div class="hzdt_ajlx_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='city'>湖北省</span><span id='type'>收案</span>案件类型组成</div>
	 	<div class='pie' id="pieChart1" style="width: 370px;height: 234px;"></div>
	 </div>
	 <div class="hzdt_spcx_panel">
	 	<div class="jrdt_title"><i class="arrow"></i><span id='city'>湖北省</span><span id='type'>收案</span>审判程序组成</div>
	 	<div class='pie' id="pieChart2" style="width: 370px;height: 234px;"></div>
	 </div>
	 <div class='hzdt_bar_panel'>
	 	<div class="jrdt_title"><i class="arrow"></i><span id='city'>湖北省</span>案件<span id='type'>收案</span>分布</div>
	 	<div class='bar' id="barChart" style="height: 284px;"></div>
	 </div>
	 <div class="hzdt_bottom"></div>
</div>
</body>
</html>