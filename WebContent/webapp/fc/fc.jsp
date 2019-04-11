<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Date"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	StringBuilder sb = new StringBuilder();
	Enumeration en = request.getParameterNames();
	while (en.hasMoreElements()) {
		String name = StringUtils.trim(en.nextElement());
		if ("".equals(name)
				||"ver".equals(name)
				||"FYDM".equals(name)
				||"FLAG".equals(name)
				||"OBJECTID".equals(name)
				||"LX".equals(name)
				||"submitform".equals(name)) {
			continue;
		}
		String val = StringUtils.trim(request.getParameter(name));
		if(!"".equals(val)){
			sb.append(name).append("=").append(val).append("&");
		}
	}
	String param = "";
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	if(sb.length()>0){
		sb = sb.delete(sb.length()-1,sb.length());
	}
	
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
<script type="text/javascript" src="<%=CONTEXT_PATH%>/webapp/fc/tree.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/resources/js/loadEcharts.js"></script>
<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/resources/css/jscenter.css">
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.css" type="text/css" /> 
<script type='text/javascript' src='<%=CONTEXT_PATH%>/resources/loadmask/jquery.loadmask.js'></script>

</head>
<body>
<div style="height:125px;margin:0px;padding:0px;background:url(<%=CONTEXT_PATH%>/resources/images/logo-left.png);width:100%"></div>
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
	 	 			<tr><td class="tab_bottom_left"></td><td class="tab_bottom_center"></td><td class="tab_bottom_right"></td></tr>
	 	 		</table>
			</td>
			<td valign="top" style="border: 1px solid #2FBBDC;">
				<div id="tableContent">
					<div id="table" style="width:100%;height: 500px;overflow-y:auto;overflow-x:hidden;"></div>
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
								<input type="button" value="导出" onclick="javascript:doExport('table');" class="s_btn">
							</td>
						</tr>
					</table>
	 	 			</div>
				</div>
			</td>
		</tr>
	</table>
</div>
<jsp:include page="/webapp/export/xls.jsp"></jsp:include>
<script type="text/javascript">
	var contextPath = '<%=CONTEXT_PATH%>';
	var param = '<%=sb.toString()%>';
	
	$(document).ready(function(){
		//bindRq();
		initTree([{'contentid':'ywcbContent','treeid':'ywcbTree','inputid':'ywcb','selected':['<%=fydm%>'],'expand':true,'hide':false,
			'valueid':'ywcbValue','onClick':ywcbClick,'url':contextPath+'/webapp/fc/fc_tree.jsp?'+param+"&FYDM="+<%=fydm%>}]);
		sizeChange(true);
		loadTable(1,true);
	});

	function ywcbClick(value){
		loadTable(1,false);
	}
	
	function loadData(url,args,callback){
		$.ajax({type: "POST",url: url+"&etc="+new Date().getTime(),data: args,'dataType':'json',success: function(msg){callback(msg);}});
	}

	function loadTable(page,first){
		var fydm=$('#ywcbValue').val();
		if(fydm==null||fydm==''||ywcb==undefined){
			fydm = '<%=fydm%>';
		}
		var limit = $("#limit option:selected").val(); 
		$("#tableContent").mask("正在加载数据,请稍候..."); 
		loadData('./fc_data.jsp?'+param,{'start':page,'limit':limit,'FYDM':fydm},function(json){
			$("#tableContent").unmask();
			$("#table").html(json.table);
			if(first){
				$("#detail").FixedHead({ tableLayout: "fixed" });
			}else{
				$("#detail").sizeChange();
			}
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
	}
	
	function sizeChange(first){
		var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		// 125 log高度 22 上下边框高度 5 最下边距
		$("#ywcbContent").css({'height':h-125-22-5});
		// 125 log高度 30 分页区高度 2 div 边框高度 5 最下边距
		// 235 承办宽度 10 左右边距
		$("#table").css({'height':h-125-30-2-5,'width':w-235-10});
		if(!first){
			$("#detail").sizeChange();
		}
	}
	
	window.onresize = function(){sizeChange(false);};
	
	function showVideo(url){
		var width = window.screen.availWidth - 10;
		var height = window.screen.availHeight - 30;
		var Left_size = (screen.width) ? (screen.width - width) / 2 : 0;
		var Top_size = (screen.height) ? (screen.height - height) / 2 : 0;
		window.open(url, '_blank', 'width=' + width + 'px, height=' + height + 'px, left=' + Left_size + 'px, top=' + Top_size + 'px,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}
</script>
</html>