<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Date"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.CalendarUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	
	String fydm = StringUtils.trim(request.getParameter("fy"));
	if("".equals(fydm)){
		fydm = "42";
	}
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月");
	String jssj = sdf.format(new Date());
	String kssj = jssj.substring(0,4)+"年01月";
	
	String gzOption = "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>湖北法院数据管理平台</title>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/jquery.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/fixedTable.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/ztree/jquery.ztree.core-3.5.min.js"></script>
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/ztree/css/demo.css" type="text/css">
<script type="text/javascript" src="<%=CONTEXT_PATH%>/webapp/fc/tree.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/loadEcharts.js"></script>
<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/resources/css/hbcenter_flat.css">
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.css" type="text/css" />
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/css/bootstrap.min.css" type="text/css" />
<script type='text/javascript' src='<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.js'></script>
<script type='text/javascript' src='<%=CONTEXT_PATH%>/resources/js/bootstrap.min.js'></script>
<script src="<%=CONTEXT_PATH%>/resources/DatePicker/WdatePicker.js"></script>

</head>
<body>
<%
	request.setAttribute("MENU_TITLE", "数据质量");
%>

<jsp:include page="../../inc/head.jsp"></jsp:include>
<div style="width: 30%;height: 40px">
	<ul class="nav nav-tabs">
		<li class="active"><a  href="http://localhost:8080/webapp/spxt/sjzl/sjzl.jsp" style="color:black">数据对比</a></li>
		<li><a href="https://www.baidu.com/" style="color:black">xml监控</a></li>
		<li><a href="https://www.baidu.com/" style="color:black">解压监控</a></li>
	</ul>
</div>
<div style="margin:0px 5px;padding: 0px;">
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
		<tr>
			<td width="235px" >
				<table cellpadding="0" cellspacing="0" border="0">
	 	 			<tr><td class="tab_top_left"></td><td class="tab_top_center"></td><td class="tab_top_right"></td></tr>
	 	 			<tr>
	 	 				<td class="tab_left"></td>
	 	 				<td class="tab_center">
	 	 					<input type="hidden" id="ywcbValue">
							<input type="hidden" id="ywcb">
							<div id="ywcbContent" class="menuContent" style="position:relative;overflow-x:hidden;overflow-y:auto;height:500px;">
								<ul id="ywcbTree" class="ztree" style="margin-top:0px;width:210px;height:100%;padding:0px;"></ul>
							</div>
	 	 				</td>
	 	 				<td class="tab_right"></td>
	 	 			</tr>
	 	 			<tr>
						<td class="tab_bottom_left"></td><td class="tab_bottom_center"></td><td class="tab_bottom_right">
							<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>
						</td>
					</tr>
	 	 		</table>
			</td>
			<td valign="top" style="border: 1px solid #2FBBDC;">
				<div id="tableContent" style='background-color: #F4F4F4;'>
					
	 	 			<!-- 
	 	 			<div style="width: 100%;height: 30px;font-size: 13px;">
	 	 			<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td align="center" >
								跳转至：<select id='jump' style='width:80px;' class='s_select' onchange="loadTable(this.value)"></select> 页 | 
								<span id="page"></span>
								每页显示：
								<select id='limit' style='width:70px;height: 20px;' class='s_select' onchange="loadTable('1')">
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="50" selected="selected">50</option>
									<option value="100">100</option>
									<option value="150">150</option>
									<option value="250">250</option>
									<option value="500">500</option>
									<option value="1000">1000</option>
								</select>
							</td>
							<td width="100" align="right" style="padding-right: 15px;">
								<input type="button" value="导出" onclick="javascript:doExport()" class="s_btn">
							</td>
						</tr>
					</table>
	 	 			</div>
	 	 			-->
	 	 			<div style="width: 100%;height: 30px;font-size: 13px;background-color: #F4F4F4;">
	 	 			<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
						<tr></tr>
						<tr>
							<td align="center" >
							<%--  &nbsp;&nbsp;
								统计月份
								<input type="text" id="kssj" value="<%=kssj%>" readonly class='selDate'/>
								至
								<input type="text" id="jssj" value="<%=jssj%>" readonly class='selDate'/>
							
							&nbsp;&nbsp;  --%>
							规则：
							<input type="hidden" id="gz" /> 
							<input type="text" id="gz_text" style="width: 350px;" value="" onclick="showMenu('gz_text','gz_content'); return false;" readonly class='s_input_tree' />
	
							&nbsp;&nbsp;
							<input type="button" value="查询" onclick="javascript:doCx()" class="s_btn">
							&nbsp;&nbsp;
							<input type="button" value="导出" onclick="javascript:doExport('table')" class="s_btn">
							</td>

						</tr>
					</table> 
	 	 			</div>
	 	 			<div id="table" style="width:100%;height: 500px;overflow-y:auto;overflow-x:hidden;"></div>
				</div>
			</td>
		</tr>
	</table>
</div>

<!--  -->
<div id="gz_content" class="menuContent" style="display: none; position: absolute;z-index:99999;background-color: yellow;scroll:auto;overflow:auto;">
	<ul id="gz_tree" class="ztree" style="margin-top: 0px; width: 350px; height: 260px;overflow:auto;"></ul>
	<table style="border: 1px solid #CCCCCC;">
		<tr>
			<td style='font-size: 12px;'>
				<a href="#" style="color:#000000;" onclick="javascript:treeclear('gz_text','gz')">清空</a>
				<a href="#" style="color:#000000;" onclick="javascript:hideMenu('gz_content')">关闭</a>
			</td>
		</tr>
	</table>
</div>



<jsp:include page="/webapp/export/xls.jsp"></jsp:include>
<script type="text/javascript">
	var contextPath = '<%=CONTEXT_PATH%>';
	var fydm = '<%=fydm%>';
	
	function bindRq() {
		
		$("#kssj").bind("click",function() {
			WdatePicker({
				dateFmt : "yyyy年MM月"
			});
		});
		
		$("#jssj").bind("click",function() {
			WdatePicker({
				dateFmt : "yyyy年MM月"
			});
		});
		
	}
	
	$(document).ready(function(){
		bindRq();
		//initTree([{'contentid':'ywcbContent','treeid':'ywcbTree','inputid':'ywcb','selected':['<%=fydm%>'],'expand':true,'hide':false,
		//	'valueid':'ywcbValue','onClick':ywcbClick,'url':contextPath+'/webapp/spxt/sjzl/sjzl_tree.jsp?'+"FYDM="+fydm}]);
		
		//initTree([{'contentid':'gzContent','treeid':'gz_tree','inputid':'gz_text','expand':true,'hide':true,
		//	'valueid':'gz','url':contextPath+'/webapp/spxt/sjzl/sjzl_gz_tree.jsp'}]);
		
		var wds = new Array();
		
			
		wds.push({
			'contentid':'ywcbContent',
			'treeid':'ywcbTree',
			'inputid':'ywcb',
			'selected':['<%=fydm%>'],
			'expand':true,
			'hide':false,
			'valueid':'ywcbValue',
			'onClick':ywcbClick,
			'url':contextPath+'/webapp/spxt/sjzl/sjzl_tree.jsp?'+"FYDM="+fydm
		});
			
		wds.push({
			'contentid':'gz_content',
			'treeid':'gz_tree',
			'inputid':'gz_text',
			'expand':true,
			'hide':true,
			'valueid':'gz',
			'url':contextPath+'/webapp/spxt/sjzl/sjzl_gz_tree.jsp'
		});
		
		initTree(wds);
		
		sizeChange(true);
		loadTable(1,true);
	});

	function ywcbClick(value){
		loadTable(1,false);
	}
	
	function doCx(){
		var gz=$('#gz_text').val();
		loadTable(1,true,true,gz);
	}
	
	function loadData(url,args,callback){
		$.ajax({type: "POST",url: url+"?etc="+new Date().getTime(),data: args,'dataType':'json',success: function(msg){callback(msg);}});
	}

	function loadTable(page,first,flag,gz){
		var fydm=$('#ywcbValue').val();
		if(fydm==null||fydm==''||ywcb==undefined){
			fydm = '<%=fydm%>';
		}
		var limit = $("#limit option:selected").val(); 
		$("#tableContent").mask("正在加载数据,请稍候..."); 
		if(flag){
			loadData('sjzl_data.jsp',{'FYDM':fydm,'GZ':gz},function(json){
				$("#tableContent").unmask();
				$("#table").html(json.table);
				if(first){
					$("#detail").FixedHead({ tableLayout: "fixed" });
				}else{
					$("#detail").sizeChange();
				}
			});
		}else{
			loadData('sjzl_num.jsp',{'FYDM':fydm},function(json){
				$("#tableContent").unmask();
				$("#table").html(json.table);
				if(first){
					$("#detail").FixedHead({ tableLayout: "fixed" });
				}else{
					$("#detail").sizeChange();
				}
			});
		}
	}
	
	
	function sizeChange(first){
		var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		// 125 log高度 22 上下边框高度 5 最下边距
		$("#ywcbContent").css({'height':h-80-22-5});
		// 125 log高度 30 分页区高度 2 div 边框高度 5 最下边距
		// 235 承办宽度 10 左右边距
		$("#table").css({'height':h-80-30-2-5,'width':w-235-10});
		if(!first){
			$("#detail").sizeChange();
		}
	}
	
	
	window.onresize = function(){sizeChange(false);};
	
	function doFc(fydm,gz,kssj,jssj){
		window.open('fc/sjzl_fc.jsp?fy='+fydm+'&gz='+gz+'&kssj='+kssj+'&jssj='+jssj);
	}
	
</script>
</html>