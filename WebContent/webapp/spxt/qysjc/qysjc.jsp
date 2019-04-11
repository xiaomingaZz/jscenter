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
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
	String nd = sdf.format(new Date());
	String dm = JSUtils.fydm+"0000";
	String fjm = JSUtils.fjm+"00";
	String mc = "省院";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>全院收结存情况</title>
<style type="text/css">
.Out{ background-color: #95e6ff; } 
.Over{  background-color: #cd4147; } 
.Click{background-color: #00FF66; }
.UnClick{background-color: #95e6ff; }
</style>
<!-- 引入资源 -->
<jsp:include page="../../inc/resources.jsp"></jsp:include>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/scroll.js"></script>

<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH %>/resources/extjs3/resources/css/ext-all.css" />
<script type="text/javascript" src="<%=CONTEXT_PATH %>/resources/extjs3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH %>/resources/extjs3/ext-all.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH %>/resources/extjs3/ext-lang-zh_CN.js"></script>

<style type="text/css">
input,button,select,textarea{outline:none;}
ul,li,dl,ol{list-style:none;}

.list_lh{overflow:hidden;margin:0px auto;border:0px solid #FFFFFF;margin: 0px 5px 0px 5px;}
.list_lh ul{padding:0px;}
.list_lh li{padding:5px 10px;border-bottom: 1px dashed #b5b5b5}
.list_lh li.lieven{}
.list_lh li p{height:24px;line-height:24px;padding:0px;margin:0px;font-size:13px;}
.list_lh li p a{float:left;}
.list_lh li p em{width:80px;font:normal 12px/24px Arial;color:#FF3300;float:right;display:inline-block;}
.list_lh li p span{color:#999;float:right;}

.title{font-family:Microsoft YaHei;font-size:26px;font-weight:bolder;color: #000000;}

</style>
</head>
<script type="text/javascript">
var contextPath = '<%=CONTEXT_PATH%>';

var rybar;
var ndbar;

var dl = 'sa';
var nd='<%=nd%>';
var dm='<%=dm%>';
var fjm='<%=fjm%>';
var mc='<%=mc%>';
var bmdm = '';
var bmmc = '';
var clicknd = '';

$(document).ready(function(){
	initEcharts(['echarts/chart/bar'],contextPath+'/resources/echarts-2.2.7/build/dist',requireCallback);
});

function requireCallback(ec){
	
	var ecConfig = require('echarts/config');
	var zrEvent = require('zrender/tool/event');
	
	rybar = ec.init(document.getElementById('barChart'));
	rybar.on(ecConfig.EVENT.CLICK, function(param) {
		var da = param.data;
		$("#sjcgrid").parent().mask("数据加载中，请稍后...");
		$("#bar2Chart").parent().mask("数据加载中，请稍后...");
		$("#jbqk").parent().mask("数据加载中，请稍后...");
		drawNdBar(da["dm"],da["name"],false);
	});
	
	ndbar = ec.init(document.getElementById('bar2Chart'));
	ndbar.on(ecConfig.EVENT.CLICK, function(param) {
		var d = param.data;//改变年度
		$("#sjcgrid").parent().mask("数据加载中，请稍后...");
		loadAjList(false,d['yhdm'],d['kssj'],d['jssj']);
	});
	loadData(true);
}

function loadData(flag){
	$("#sjcqk").parent().mask("数据加载中，请稍后...");
	$("#sjcgrid").parent().mask("数据加载中，请稍后...");
	$("#barChart").parent().mask("数据加载中，请稍后...");
	$("#bar2Chart").parent().mask("数据加载中，请稍后...");
	$("#jbqk").parent().mask("数据加载中，请稍后...");
	loadOption("./qysjc_sjcqk.jsp",{'nd':nd,'dm':dm},true,function(op){
		$("#sjcqk").parent().unmask();
		$("#sjcqk").html(op.sjcqk);
		$(".table_row").bind("mouseover",function(){ 
			$(this).css("background-color","#87CEFA"); 
		});
		$(".table_row").bind("mouseout",function(){ 
			$(this).css("background-color","#B0E6FF"); 
		});
		bmdm = op["bmdm"];
		bmmc = op["bmmc"];
		drawRyBar(flag);
	});
}

function loadTree(){
	initTree([{'contentid':'ryContent','treeid':'ryTree','inputid':'ry','valueid':'ryValue','url':"./loadRy.jsp?fydm="+dm+"&bmdm="+bmdm+"&nd="+nd+"&dl="+dl}]);
}

function drawRyBar(flag){
	loadTree();
	loadOption("./qysjc_ry_bar.jsp",{'nd':nd,'dl':dl,'dm':dm,'bmdm':bmdm,'bmmc':bmmc},false,function(op){
		$("#barChart").parent().unmask();
		rybar.clear();
		rybar.hideLoading();
		rybar.setOption(op);
		drawNdBar(op["rydm"],op["rymc"],flag);
	});
}

function drawNdBar(rydm,rymc,flag){
	loadJbqk(rydm);
	loadAjList(flag,rydm,'','');
	$("#rymc").html(rymc);
	$("#fgmc").html(rymc);
	loadOption("./qysjc_nd_bar.jsp",{'nd':nd,'dm':dm,'yhdm':rydm,'yhxm':rymc},false,function(op){
		$("#bar2Chart").parent().unmask();
		ndbar.clear();
		ndbar.hideLoading();
		ndbar.setOption(op);
	});
}

function loadAjList(flag,rydm,kssj,jssj){
	loadOption(contextPath+"/webapp/spxt/qysjc/qysjc_grid.jsp",{'nd':nd,'kssj':kssj,'jssj':jssj,'dm':dm,'yhdm':rydm},true,function(mess){
		$("#sjcgrid").parent().unmask();
		$("#sjcgridtitle").html(mess.sjcgridtitle);
		$("div.list_lh").find("ul").html(mess.sjcgrid).css("margin-top", 0);
		if(flag){
			$("div.list_lh").scroll({speed:24,rowHeight:34},function(){});
		}
	});
}

function loadJbqk(rydm){
	loadOption("./qysjc_jbqk.jsp",{'yhdm':rydm},true,function(mess){
		$("#jbqk").parent().unmask();
		$("#yhxm").html(mess.yhxm);
		$("#yhbm").html(mess.yhbm);
		$("#yhzw").html(mess.yhzw);
		$("#flzw").html(mess.flzw);
	});
}

function doFc(baseid,fydm,bmdm,kssj,jssj){
	var param = "BASEID="+baseid+"&FYDM="+fydm+"&KSSJ="+kssj+"&JSSJ="+jssj+"&CBBM1="+bmdm;
	window.open(contextPath+'/webapp/fc/fc.jsp?'+param);
}

//切换年度--联动
function changeNd(val){
	nd = val;
	loadData(false);
}

//改变部门--联动
function changeBm(dm,mc){
	bmdm = dm;
	bmmc = mc;
	drawRyBar(false);
}

function switchType(val){
	var type = $("input[name='type']:checked").val(); 
	$("#barChart").parent().mask("数据加载中，请稍后...");
	loadOption("./qysjc_ry_bar.jsp",{'nd':nd,'dl':type,'dm':dm,'bmdm':bmdm,'bmmc':bmmc},false,function(op){
		$("#barChart").parent().unmask();
		rybar.clear();
		rybar.hideLoading();
		rybar.setOption(op);
	});
}

function treeFilter(inputid,valueid){
	var rydms = $('#'+valueid).val();
	var type = $("input[name='type']:checked").val();
	hideMenu('ryContent');
	//多一个参数
	$("#barChart").parent().mask("数据加载中，请稍后...");
	loadOption("./qysjc_ry_bar.jsp",{'nd':nd,'dl':type,'dm':dm,'bmdm':bmdm,'bmmc':bmmc,'rydms':rydms},false,function(op){
		$("#barChart").parent().unmask();
		rybar.clear();
		rybar.hideLoading();
		rybar.setOption(op);
		drawNdBar(op["rydm"],op["rymc"],false);
	});
}

var compPanel = new Ext.Panel({ 
	region : 'center', 
	layout : 'fit', 
	html : '<iframe id="ifrm" name="ifrm" src="" frameborder="0" style="width:100%;height:100%;margin:0px" ></iframe>' 
}); 
	
var compWin = new Ext.Window({ 
	title : "人员对比", 
	layout : "fit", 
	id : "compWin", 
	iconCls : 'icon_pro', 
	width : 1000, 
	height : 500, 
	closeAction : "hide", 
	modal : true, 
	animate : true, 
	resizable : true, 
	//maximized : true, 
	border : false, 
	items : [compPanel], 
	rendererTo:Ext.getBody() 
}); 

function compareRy(inputid,valueid){
	var zTree = $.fn.zTree.getZTreeObj("ryTree");
	var nodes = zTree.getCheckedNodes(true);
	var v = "";
	for (var i=0, l=nodes.length; i<l; i++) {
		v += nodes[i].id + ",";
	}
	if (v.length > 0 ) v = v.substring(0, v.length-1);
	
	hideMenu('ryContent');
	compWin.show();
	document.getElementById('ifrm').src = "./qysjc_db.jsp?nd="+nd+"&fydm="+dm+"&bmdm="+bmdm+"&dl="+dl+"&rydm="+v;
}

</script>

<body>
<!-- 引入头部 -->
<%
	request.setAttribute("MENU_TITLE", "全院收结存");
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
	 	 		<td class="tab_left"></td>
	 	 		<td class="tab_center" style="padding: 0px 8px;"> 
	 	 			<table cellpadding="0" cellspacing="0" border="0" >
	 	 				<tr height="35px" style="" >
	 	 					<td align="left" style="border-bottom: solid 2px #90D3F3;font-size: 26px;color: #000000;font-weight:bolder;">
	 	 						全院各部门收结案情况
	 	 					</td>
	 	 					<td style="border-bottom: solid 2px #90D3F3;">
	 	 						年&nbsp;度：<select id="nd" onchange='changeNd(this.value);' style="height: 20px;width: 60px;"><%=CalendarUtil.getNdOption() %></select>
	 	 					</td>
	 	 				</tr>
	 	 				<tr>
	 	 					<td colspan="2" height="405">
	 	 						<div id="sjcqk"  style="width:549px;height: 100%;border:solid 0px;overflow-x:hidden;overflow-y:auto;" > </div>
	 	 					</td>
	 	 				</tr>
	 	 			</table>
	 	 		</td>
	 	 		<td class="tab_right"></td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td  class="tab_bottom_left"></td>
	 	 		<td  class="tab_bottom_center"></td>
	 	 		<td  class="tab_bottom_right"></td>
	 	 	</tr>
	 	 </table>
	 	
	 	<table style="margin:10px 5px 5px 5px;" cellpadding="0" cellspacing="0" border="0">
	 		<tr>
	 	 		<td  class="tab_top_left"></td>
	 	 		<td  class="tab_top_center"></td>
	 	 		<td  class="tab_top_right"></td>
	 	 	</tr>
	 	 	<tr>
	 	 		<td class="tab_left"></td>
	 	 		<td class="tab_center" style="padding: 0px 8px;"> 
	 	 				<table cellpadding="0" cellspacing="0" border="0" id='jbqk' width="549px" height="450px">
	 	 				<tr height="35px" >
	 	 					<td align="left" style="border-bottom: solid 2px #90D3F3;font-size: 26px;color: #000000;font-weight:bolder;">
	 	 						<span id='fgmc' ></span>法官基本情况
	 	 					</td>
	 	 				</tr>
	 	 				<tr>
	 	 					<td height="415px" valign="top">
	 	 						<table style='margin-top:10px; font-size:14px;line-height: 30px' cellpadding='0' cellspacing='1' align='center' bgcolor='#CCCCCC' width="100%" >
				 	 				<tr bgcolor='#ffffff'>
				 	 					<td rowspan='4' width='200px;'>
				 	 						<img alt="" src="">
				 	 					</td>
				 	 					<td width="130px">姓名</td>
				 	 					<td align='center'><span id='yhxm'></span></td>
				 	 				</tr>
				 	 				<tr bgcolor='#ffffff'>
				 	 					<td>部门</td>
				 	 					<td align='center'><span id='yhbm'></span></td>
				 	 				</tr>
				 	 				<tr bgcolor='#ffffff'>
				 	 					<td>职务</td>
				 	 					<td align='center'><span id='yhzw'></span></td>
				 	 				</tr>
				 	 				<tr bgcolor='#ffffff'>
				 	 					<td>审判职称</td>
				 	 					<td align='center'><span id='flzw'></span></td>
				 	 				</tr>
				 	 			</table>
	 	 					</td>
	 	 				</tr>
	 	 			</table>
	 	 		</td>
	 	 		<td class="tab_right"></td>
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
				 	 			<div style="position: absolute;right: 55px;font-size:12px;z-index:1000;top:35px;">
	 	 							<input type="radio" name="type" id="radio1" class="css-checkbox" value="sa" onchange="switchType('sa')" checked/>
	 	 							<label for="radio1" class="css-label">收案</label>
	 	 							<input type="radio" name="type" id="radio2" class="css-checkbox" value="ja" onchange="switchType('ja')" />
	 	 							<label for="radio2" class="css-label">结案</label>
	 	 							<input type="radio" name="type" id="radio3" class="css-checkbox" value="wj" onchange="switchType('wj')" />
	 	 							<label for="radio3" class="css-label">未结</label>
	 	 							|
	 	 							<input type="hidden" id='ryValue' /> 
	 	 							<span id='ry' style="cursor: pointer;" onclick="showMenu('ry','ryContent'); return false;">选择人员</span>
	 	 						</div>
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
								<div id="bar2Chart" style="width: 628px;height: 450px;border:solid 0px;"></div>
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
				 	 		<td class="tab_left"></td>
				 	 		<td class="tab_center" style="padding: 0px 8px;"> 
				 	 			<table cellpadding="0" cellspacing="0" border="0" >
	 	 							<tr height="35px" style="" >
	 	 								<td align="left" style="border-bottom: solid 2px #90D3F3;font-size: 26px;color: #000000;font-weight:bolder;">
	 	 									<span id="rymc"></span>法官办案清单
	 	 								</td>
	 	 							</tr>
	 	 							<tr>
	 	 								<td height="415px">
	 	 									<div style="height:400px;width:612px; text-align:left; border:solid 0px;">
					 	 						<div id='sjcgrid' class="list_lh" style="height:100%;width:100%;">
						 	 						<ul style="width:595px; "></ul>
					 	 						</div>
				 	 						</div>
	 	 								</td>
	 	 							</tr>
	 	 						</table>
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
	 	</table>
	 </div>
</div>

<div id="ryContent" class="menuContent" style="display: none; position: absolute;">
	<ul id="ryTree" class="ztree" style="margin-top: 0px; width: 180px; height: 300px;"></ul>
	<table style="border: 0px solid #CCCCCC;" width="100%" height="30">
		<tr>
			<td align="left" style='font-size: 12px;padding-left: 5px;' width="120px">
				<a href="javascript:void(0);" onclick="javascript:selectAll('ryTree')" style="color:#000000;font-size: 13px;">全选</a>
				<a href="javascript:void(0);" onclick="javascript:clearAll('ryTree')" style="color:#000000;font-size: 13px;">清空</a>
			</td>
			<td align="right" style='font-size: 12px;padding-right:5px;' width="180px">
				<a href="javascript:void(0);" onclick="javascript:treeFilter('ry','ryValue')" style="color:#000000;font-size: 13px;">确认</a>
				<a href="javascript:void(0);" onclick="javascript:hideMenu('ryContent')" style="color:#000000;font-size: 13px;">取消</a>
				<a href="javascript:void(0);" onclick="javascript:compareRy('ry','ryValue')" style="color:#000000;font-size: 13px;">对比</a>
			</td>
		</tr>
	</table>
</div>

</body>
</html>