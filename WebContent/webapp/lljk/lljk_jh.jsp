<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	String fjm = StringUtils.trim(request.getParameter("fjm"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>湖北法院数据中心(流量监控)</title>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/jquery-1.7.2.min.js"></script>
<link href="<%=CONTEXT_PATH%>/resources/js/loadmask/jquery.loadmask.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/loadmask/jquery.loadmask.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/tc.all.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/ztree/jquery.ztree.core-3.5.min.js"></script>
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/ztree/css/demo.css" type="text/css">
<script type="text/javascript" src="<%=CONTEXT_PATH%>/webapp/ssdt/ywcbtree.js"></script>
<style type="text/css">
	body{
		background: url("<%=CONTEXT_PATH%>/resources/images/bj.jpg");
		background-repeat: no-repeat; 
		background-repeat: repeat-x;
	}
	body,table,tr,td{
		font-size:12px;
		font-family: "Microsoft YaHei";
		vertical-align: middle;
		margin: 0px;
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
	.table-body {
		border:1px solid #CCCCCC; 
		border-collapse: collapse;
		background-color: #FFFFFF;
	}
	
	.table-body tbody tr.odd td {
		background-color:#F0F0F6;
	}
	
	.table-header{height: 27px;text-align: center;background-color: #e0f0f0; }
	
	.table-header-row,.table-row {
  		overflow: hidden;
  		cursor: default;
  		border:1px solid #CCCCCC;
  		height: 28px;
  		text-align: center;
  		padding: 4px;
	}
	
	.table-header-cell{
		height: 25px;
		min-width: 50px;
	}
	
	.table-header-cell div{
		margin:auto;
	}
	
	.table-header-row td,.table-row td{
  		border:1px solid #CCCCCC;
  		font-size: 12px;
	}
	
	.table-cell-mc {
		padding: 0 4px;
		text-align: left;
		min-width: 100px;
	}
	
  	.table-cell-rownumber {
  		background:url("<%=CONTEXT_PATH%>/resources/images/zl/height_btl_07.png");
  		background-color:#F4F4F4;
  		width: 20px;
  		text-align: center;
  	}
  	
</style>
</head>
<body style="overflow-x:auto;overflow-y:hidden;">
	<table border="0px" style="border-style: solid #CCCCCC;" cellpadding="0" cellspacing="0" width="100%">
		<tr height="80"><td width="100%" style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk_top.png') no-repeat;"></td></tr>
		<tr id='table'>
			<td width="100%" height="100%">
			<div style="OVERFLOW-Y: auto; OVERFLOW-X:auto; width: 100%;border: 0px solid B8CBF6; ">
				<table border="0px"  cellpadding="0" cellspacing="0" width="100%" height="100%" style="vertical-align: top;min-width: 1000px" >
					<tr height="100%" valign="top">
						<td height="100%" width='210px' style="table-layout:inherit;vertical-align: top;">
							<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
								<tr height="100%" valign="top">
									<td width="100%" height="100%" valign="top">
										<input type="hidden" id="ywcb">
										<div id="ywcbContent" class="menuContent" style="position: relative;">
											<ul id="ywcbTree" class="ztree" style="margin-top:0px; width:210px;height:100%;padding: 0px;"></ul>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td height="100%" style="padding: 0px;vertical-align: top;" id="jkview">
							<div id='jktable' style="overflow-x:hidden;overflow-y:auto;background-color: #FFFFFF;"></div>
							<table width="100%" height="30" cellpadding="0" cellspacing="0" border="0">
								<tr height="30">
									<td align="center">
										跳转至：
										<select id='jump' style='width:80px;height: 23px;border: 1px solid #CCCCCC;text-align: center;' onchange="loadTable(this.value)">
											 
										</select> 页 | 
										<span id="page"></span>
										每页显示：
										<select id='limit' style='width:50px;height: 23px;border: 1px solid #CCCCCC;text-align: center;' onchange="loadTable('1')">
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
								</tr>
							</table>
						</td>	
					</tr>
				</table>
				</div>
			</td>
		</tr>
	</table>
	<iframe id="forExport" name="forExport" style="display:none;" ></iframe>
</body>
<script type="text/javascript">
	var expUrl = "",expFCUrl="";
	$(document).ready(function(){
		initTree([{'contentid':'ywcbContent','treeid':'ywcbTree','valueid':'ywcb','args':{'fjm':'<%=fjm%>'},'selected':['<%=fjm%>'],'onClick':ywcbClick,'url':'<%=CONTEXT_PATH%>/webapp/fy_json.jsp'}]);
		sizeChange();
		loadTable(1);
	});

	function ywcbClick(value){
		loadTable(1);
	}
	
	function loadData(url,args,callback){
		$.ajax({
			type: "POST",
			url: url+"?etc="+new Date().getTime(),
			data: args,
			success: function(msg){
				callback(eval('('+msg+')'));
			}
		});
	}

	function loadTable(page){
		var fjm=$('#ywcb').val();
		if(fjm==null||fjm==''||fjm==undefined){
			fjm = '<%=fjm %>';
		}
		var limit = document.getElementById("limit"); 
		var limitSel = limit.options[limit.selectedIndex]; 
		$("#jkview").mask("正在加载数据,请稍候..."); 
		loadData('<%=CONTEXT_PATH%>/webapp/lljk/lljk_jh_fc.jsp',{'fjm':fjm,'start':page,'limit':limitSel.value},function(json){
			$("#jkview").unmask();
			document.getElementById("jktable").innerHTML=json.table;
			var cuPage = json.cuPage;
			var totalPages= json.totalPages;
			var totalCounts = json.totalCounts;
			var page="";
			if(cuPage==1){
				page = "首  页 | 上一页 ";
			}else{
				page = "<a href=\"#\" onclick=\"javascript:loadTable('1')\">首  页</a> ";
				page = page+ " | <a href=\"#\" onclick=\"javascript:loadTable('"+(cuPage-1)+"')\">上一页</a> ";
			}
			if(cuPage==totalPages){
				page = page + "| 下一页 |尾  页";
			}else{
				page = page + "| <a href=\"#\" onclick=\"javascript:loadTable('"+(cuPage+1)+"')\">下一页</a> ";
				page = page + "| <a href=\"#\" onclick=\"javascript:loadTable('"+totalPages+"')\">尾页</a> ";
			}
			page = page + " | 第"+cuPage+"/"+totalPages+"页  | 共"+totalCounts+"条数据 | ";
			document.getElementById("page").innerHTML=page;
			var jump =  document.getElementById("jump");
			jump.options.length=0;
			for(var i=1;i<=totalPages;i++){
				var option = document.createElement("option");
				if(i==cuPage){
					option.setAttribute("selected","selected");
				}
				option.setAttribute("value",i);//设置option属性值 
				option.appendChild(document.createTextNode(i)); 
				jump.appendChild(option);//向select增加option 				    
			}
		});
		expUrl = "<%=CONTEXT_PATH%>/webapp/zlbg/gzsm_tj2excel.jsp?fjm="+fjm;
	}
	
	function sizeChange(){
		var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		$("#ywcbContent").css({'height':h-80});
		$("#jktable").css({'height':h-80-30});
	}
	
	window.onresize = sizeChange;
	//var times = setInterval("loadTable(false)",5*60*1000);

	//导出
	function doExport(){
		$("#forExport").attr("src", expUrl);
	}
	//导出反查
	function doExportFC(){
		$("#forExport").attr("src", expFCUrl);
	}
</script>
</html>