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
	
	String dm = JSUtils.fydm;
	String fjm = JSUtils.fjm;
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	List<Map<String,Object>> citys = bi09.queryForList("select DM_CITY DM from DC_CITY where DATALENGTH(DM_CITY) = 4 or DATALENGTH(DM_CITY) = 2 ");
	
	String jssj = "";
	String jssjValue = "";
	List<Map<String,Object>> li = bi09.queryForList("SELECT TOP 1 ID_DAY FROM FACT_YTZBA_WJ ");
	if(li != null && li.size() > 0){
		jssjValue = (String)li.get(0).get("ID_DAY");
		jssj = jssjValue.substring(0,4)+"年"+jssjValue.substring(4,6)+"月"+jssjValue.substring(6,8)+"日";
	}
	if("".equals(jssj)){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
		jssj = sdf.format(new Date());
		jssjValue = jssj.replace("年","").replace("月","").replace("日","");
	}
	String kssj = CalendarUtil.getFirstDayOfYear(jssj);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>院庭长案件</title>
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

var kssj = '<%=kssj%>';
var jssj = '<%=jssjValue%>';
var maxjssj = '<%=jssjValue%>';//定义一个统计了的结束天，时间只能统计到这一天，不能再往后
var dl='sls';
var citymc = '';//全局
var citydm = '';//全局
var fjm = '';

var zycitymc = '';

var yz = '1';
var fyz = '1';
var tz = '1';
var ftz = '1';
var zw = yz+fyz+tz+ftz;

var barUrl = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_bar_sls.jsp";
var pie1Url = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_pie1_sls.jsp";
var pie2Url = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_pie2_sls.jsp";

$(document).ready(function(){
	
	bindRq();
	
	$("[name = checkbox]:checkbox").bind("click", function () {
		yz = $('#yz').is(':checked')==true?'1':'0';
		fyz = $('#fyz').is(':checked')==true?'1':'0';
		tz = $('#tz').is(':checked')==true?'1':'0';
		ftz = $('#ftz').is(':checked')==true?'1':'0';
		zw = yz+fyz+tz+ftz;
		//changeMap();
		loadData(true);
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
	pie1 = ec.init(document.getElementById('pie1Chart'));
	pie1.on(ecConfig.EVENT.CLICK, function(param) {
		var da = param.data;
		doFc(da['baseid'],da['dm'],da['kssj'],da['jssj'],da['zw']);
	});
	pie2 = ec.init(document.getElementById('pie2Chart'));
	pie2.on(ecConfig.EVENT.CLICK, function(param) {
		var da = param.data;
		doFc(da['baseid'],da['dm'],da['kssj'],da['jssj'],da['zw']);
	});
	bar.on(ecConfig.EVENT.CLICK, function(param) {
		var da = param.data;
		doFc(da['baseid'],da['dm'],da['kssj'],da['jssj'],da['zw']);
	});
	
	changeMap();
}

function doFc(baseid,fydm,kssj,jssj,zw){
	var param = "BASEID="+baseid+"&FYDM="+fydm+"&KSSJ="+kssj+"&JSSJ="+jssj;
	if(zw!=''){
		param +="&ZW="+zw; 
	}
	window.open(contextPath+'/webapp/fc/fc.jsp?'+param);
}

function loadData(flag){
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
		
		loadOption(contextPath+"/webapp/spxt/ytzba_day/ytzba_day_map.jsp",{
			'kssj':kssj,
			'jssj':jssj,
			'maxjssj':maxjssj,
			'dl':dl,
			'dm':citydm,
			'fjm':fjm,
			'zw':zw,
			'mc':citymc
		},false,function(op){
			map.setOption(op);
		});
		loadOption(barUrl,{
			'kssj':kssj,
			'jssj':jssj,
			'maxjssj':maxjssj,
			'dl':dl,
			'dm':citydm,
			'fjm':fjm,
			'zw':zw,
			'mc':citymc
		},false,function(op){
			bar.setOption(op);
		});
	}else{
		if(flag){
			loadOption(contextPath+"/webapp/spxt/ytzba_day/ytzba_day_map.jsp",{
				'kssj':kssj,
				'jssj':jssj,
				'maxjssj':maxjssj,
				'dl':dl,
				'dm':citydm.substring(0,4),
				'fjm':fjm.substring(0,2),
				'zw':zw,
				'mc':zycitymc
			},false,function(op){
				map.setOption(op);
			});
			loadOption(barUrl,{
				'kssj':kssj,
				'jssj':jssj,
				'maxjssj':maxjssj,
				'dl':dl,
				'dm':citydm.substring(0,4),
				'fjm':fjm.substring(0,2),
				'zw':zw,
				'mc':zycitymc
			},false,function(op){
				bar.setOption(op);
			});
		}
	}
	
	if(citymc == ''){
		$('#area').html('全省');
	}else{
		$('#area').html(citymc);
	}
	
	var ytzname = '';
	if(!(zw == '1111' || zw == '0000')){
		if(zw.substring(0,1) == '1'){
			ytzname += '院长';
		}
		if(zw.substring(1,2) == '1'){
			if(ytzname.length > 0){
				ytzname += "、";
			}
			ytzname += '副院长';
		}
		if(zw.substring(2,3) == '1'){
			if(ytzname.length > 0){
				ytzname += "、";
			}
			ytzname += '庭长';
		}
		if(zw.substring(3,4) == '1'){
			if(ytzname.length > 0){
				ytzname += "、";
			}
			ytzname += '副庭长';
		}
	}
	$('#js').html(ytzname);
	loadOption(contextPath+"/webapp/spxt/ytzba_day/ytzba_day_data.jsp",{
		'kssj':kssj,
		'jssj':jssj,
		'maxjssj':maxjssj,
		'dl':dl,
		'dm':citydm,
		'fjm':fjm,
		'zw':zw,
		'mc':citymc
	},true,function(mess){
		$("#ajqk").html(mess.ajqk);
		$("#info").html(mess.info);
	});
	loadOption(pie1Url,{
		'kssj':kssj,
		'jssj':jssj,
		'maxjssj':maxjssj,
		'dl':dl,
		'dm':citydm,
		'fjm':fjm,
		'zw':zw,
		'mc':citymc
	},false,function(op){
		pie1.setOption(op);
	});
	loadOption(pie2Url,{
		'kssj':kssj,
		'jssj':jssj,
		'maxjssj':maxjssj,
		'dl':dl,
		'dm':citydm,
		'fjm':fjm,
		'zw':zw,
		'mc':citymc
	},false,function(op){
		pie2.setOption(op);
	});
}

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

function changeNd(val){
	nd = val;
	loadData(true);
}

function changeDl(value){
	dl = value;
	if(dl == 'sls'){
		barUrl = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_bar_sls.jsp";
		pie1Url = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_pie1_sls.jsp";
		pie2Url = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_pie2_sls.jsp";
	}else{
		barUrl = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_bar.jsp";
		pie1Url = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_pie1.jsp";
		pie2Url = contextPath+"/webapp/spxt/ytzba_day/ytzba_day_pie2.jsp";
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

</script>
<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "院庭长办案");
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
	 	 		<td class="tab_center">
	 	 			<div style="position: absolute;left: 128px;top:143px;z-index:99999;">
		 	 						<input type="text" id="jssj" value="<%=jssj%>" readonly class='selDate'/>
		                        	<input type="radio" name="dl" id="sls" class="css-checkbox" value="3" onchange="changeDl('sls')" checked />
	 	 							<label for="sls" class="css-label">受理</label>
		                        	<input type="radio" name="dl" id="sas" class="css-checkbox" value="1" onchange="changeDl('sas')" />
		                			<label for="sas" class="css-label">收案</label>
	 	 							<input type="radio" name="dl" id="jas" class="css-checkbox" value="2" onchange="changeDl('jas')" />
	 	 							<label for="jas" class="css-label">结案</label>
	 				</div>
	 				<div class="map_plus">
						<span onclick="changeArea('<%=dm %>','<%=fjm %>','全省')" style='cursor:pointer;'>
						<span style="width:60px;height:25px;background:#f1443c;">&nbsp;&nbsp;</span>全省
						</span>
						<span onclick="changeArea('<%=dm+"00" %>','<%=fjm+"0" %>','江苏高院')" style='cursor:pointer;'>
						<span style="width:60px;height:25px;background:#3d9fee;">&nbsp;&nbsp;</span>省院
						</span>
					</div>
					<div class="condtion_bottom">
						<input type='checkbox' id='yz' name='checkbox' checked='checked'>院长
						|
						<input type='checkbox' id='fyz' name='checkbox' checked='checked'>副院长
						|
						<input type='checkbox' id='tz' name='checkbox' checked='checked'>庭长
						|
						<input type='checkbox' id='ftz' name='checkbox' checked='checked'>副庭长
					</div>
	 				<div id="map"  style="width:565px;height: 600px;border:solid 0px;" > </div>
		 	 		
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
	 	 		<td class="tab_center" style="padding: 0px 8px;">
	 	 			<table cellpadding="0" cellspacing="0" border="0" >
	 	 				<tr height="45px" >
	 	 					<td align="left" style="border-bottom: solid 2px #90D3F3;font-size: 26px;color: #000000;font-weight:bolder;">
	 	 						<span id='area'>全省</span><span id='js'></span>办案情况
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
								 <div id="barChart" style="width: 1288px;height: 440px;border:solid 0px;"></div>
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