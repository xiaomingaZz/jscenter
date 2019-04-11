<%@page import="tdh.frame.web.util.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>湖北法院数据管理平台(流量监控)</title>
<jsp:include page="../inc/resources.jsp"></jsp:include>
<style type="text/css">
	body{
		background: url("../../resources/images/bj.jpg") no-repeat center top;
	}
	.logo_bg{
		background: url("");
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
</style>
</head>
<body>
<%
	request.setAttribute("MENU_TITLE", "流量监控");
%>
	<jsp:include page="../inc/head.jsp"></jsp:include>
	<table id='jk' width="100%" cellpadding="0" cellspacing="0" border="0" >
		<tr><td></td></tr>
		<tr height="189">
			<td align="center" valign="middle" height="189">
				<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
					<tr >
						<td ></td>
						<td width="248"></td>
						<td width="189" height="189" style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/jhpt_02.png') no-repeat;" align="center">
							<font size="6" style="font-weight: bold;color: #FFFFFF">交换平台</font><br>
							<font color="#FFFFFF">( <font size="3" style="color: #ff1313" id="H"></font> )</font>
						</td>
						<td width="6"></td>
						<td width="105" >
							<table	width="100%" height="20" cellpadding="0" cellspacing="0" border="0">
								<tr height="20">
									<td id="RK_line" style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-x center;" width="85" align="center">
										<font size="2" style="color: #ff1313" id="RK_zl"></font><br><br>
									</td>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/arrow_right.png') no-repeat center;;" width="20"></td>
								</tr>
							</table>
						</td>
						<td width="6"></td>
						<td width="189" height="189" style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/zxk_02.png') no-repeat;" align="center">
							<font size="5" style="font-weight: bold;color: #FFFFFF">司法数据<br>中心</font>
							<font color="#FFFFFF">( <font size="3" style="color: #ff1313" id="RK"></font> )</font>
						</td>
						<td width="8"></td>
						<td width="240"  height="189">
							<table	width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" >
								<tr height="25px"><td colspan="3"></td></tr>
								<tr>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-x center;" width="75"></td>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/arrow_right.png') no-repeat center;" width="20"></td>
									<td align="left">&nbsp;
										<font size="3" style="font-weight: bold;">最高院</font>
										<font color="#FFFFFF">(<font size="3" style="color: #ff1313" >5048</font>)</font>
									</td>
								</tr>
								<tr>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-x center;" width="75"></td>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/arrow_right.png') no-repeat center;" width="20"></td>
									<td align="left">&nbsp;
										<font size="3" style="font-weight: bold;">查控</font>
										<font color="#FFFFFF">(<font size="3" style="color: #ff1313" >5623</font>)</font>
									</td>
								</tr>
								<tr>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-x center;" width="75"></td>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/arrow_right.png') no-repeat center;" width="20"></td>
									<td align="left">&nbsp;
										<font size="3" style="font-weight: bold;">征信</font>
										<font color="#FFFFFF">(<font size="3" style="color: #ff1313" >124</font>)</font>
									</td>
								</tr>
								<tr>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-x center;" width="75"></td>
									<td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/arrow_right.png') no-repeat center;" width="20"></td>
									<td align="left">&nbsp;
										<font size="3" style="font-weight: bold;">公开</font>
										<font color="#FFFFFF">(<font size="3" style="color: #ff1313" >6426</font>)</font>
									</td>
								</tr>
								<tr height="25px"><td colspan="3"></td></tr>
							</table>
						</td>
						<td></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="5"><td height="5"></td></tr>
		<tr height="90">
			<td width="100%" height="90">
				<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
					<tr >
						<td ></td>
						<td width="248"></td>
						<td width="189" height="90">
							<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
								<tr><td style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/arrow_top.png') no-repeat center;" height="20"></td></tr>
								<tr><td id='v_line' style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;" height="70" align="center">
									<font size="2" id='H_zl'></font>
								</td></tr>
							</table>
						</td>
						<td width="556"></td>
						<td></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="8">
			<td width="100%" height="8">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
					<tr>
						<td></td>
						<td id='h_line' width="1208" style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-x center;" height="8"></td>
						<td></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="70">
			<td width="100%" height="70">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
					<tr>
						<td></td>
						<td width="1275" height="70">
							<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
								<tr align="center">
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H0_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H1_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H2_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H3_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H4_zl'></font>&nbsp;
									</td>
									<td width="75" height="70"  
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H5_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H6_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H7_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H8_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='H9_zl'></font>&nbsp;
									</td>
									<td width="75" height="70"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='HA_zl'></font>&nbsp;
									</td>
									<td width="75" height="70"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='HB_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='HC_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='HD_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='HE_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='HF_zl'></font>&nbsp;
									</td>
									<td width="75" height="70" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/line.png') repeat-y center;">
										<font size="2" id='HG_zl'></font>&nbsp;
									</td>
								</tr>
							</table>
						</td>
						<td></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="80">
			<td width="100%" height="80">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
					<tr>
						<td></td>
						<td width="1275" height="70">
							<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
								<tr align="center">
									<td width="75" height="44"  id='H0_p'
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_07.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 高院</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_01.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 武汉</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_03.png') no-repeat bottom; " >
										<font style="font-size:14px;font-weight: bold;"> 黄石</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_05.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 十堰</font>
									</td>
									<td width="75" height="44" background=""
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_07.png') no-repeat bottom; " >
										<font style="font-size:14px;font-weight: bold;"> 荆州</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_01.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 宜昌</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_03.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 襄阳</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_05.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 鄂州</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_07.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 荆门</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_01.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 黄冈</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_03.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 孝感</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_05.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 咸宁</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_07.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 恩施</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_01.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 汉江</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_03.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 随州</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_05.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 海事</font>
									</td>
									<td width="75" height="44" 
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_07.png') no-repeat bottom;" >
										<font style="font-size:14px;font-weight: bold;"> 铁路</font>
									</td>
								</tr>
								<tr align="center" >
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_08.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H0')"><font style="font-size:14px;" color="#ff1313" id='H0'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_02.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H1')"><font style="font-size:14px;" color="#ff1313" id='H1'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_04.png') no-repeat top; " >
										<a href="#" onclick="javascript:doFc('H2')"><font style="font-size:14px;" color="#ff1313" id='H2'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_06.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H3')"><font style="font-size:14px;" color="#ff1313" id='H3'> 0</font></a>
									</td>
									<td width="75" height="26"background=""
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_08.png') no-repeat top; " >
										<a href="#" onclick="javascript:doFc('H4')"><font style="font-size:14px;" color="#ff1313" id='H4'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_02.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H5')"><font style="font-size:14px;" color="#ff1313" id='H5'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_04.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H6')"><font style="font-size:14px;" color="#ff1313" id='H6'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_06.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H7')"><font style="font-size:14px;" color="#ff1313" id='H7'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_08.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H8')"><font style="font-size:14px;" color="#ff1313" id='H8'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_02.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('H9')"><font style="font-size:14px;" color="#ff1313" id='H9'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_04.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('HA')"><font style="font-size:14px;" color="#ff1313" id='HA'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_06.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('HB')"><font style="font-size:14px;" color="#ff1313" id='HB'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_08.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('HC')"><font style="font-size:14px;" color="#ff1313" id='HC'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_02.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('HD')"><font style="font-size:14px;" color="#ff1313" id='HD'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_04.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('HE')"><font style="font-size:14px;" color="#ff1313" id='HE'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_06.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('HF')"><font style="font-size:14px;" color="#ff1313" id='HF'> 0</font></a>
									</td>
									<td width="75" height="26"
										style="background: url('<%=CONTEXT_PATH%>/resources/images/lljk/lc_08.png') no-repeat top;" >
										<a href="#" onclick="javascript:doFc('HG')"><font style="font-size:14px;" color="#ff1313" id='HG'> 0</font></a>
									</td>
								</tr>
							</table>
						</td>
						<td></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td></td></tr>
	</table>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='RK_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H0_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H1_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H2_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H3_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H4_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H5_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H6_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H7_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H8_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='H9_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='HA_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='HB_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='HC_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='HD_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='HE_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='HF_img'>
	<img src="<%=CONTEXT_PATH%>/resources/images/lljk/point.png" style="position: absolute;display: none;top:8;left:8;" id='HG_img'>
</body>
<script type="text/javascript">
	var imgObj = {"H0":0,"H1":1,"H2":2,"H3":3,"H4":4,"H5":5,"H6":6,"H7":7,"H8":8,"H9":9,"HA":10,"HB":11,"HC":12,"HD":13,"HE":14,"HF":15,"HG":16};
	var timesObj={};
	var temp={};
	var times2 ;
	var s_x=0;
	var s_y=0;
	var h_x=0;
	var h_y=0;
	var v_x=0;
	var v_y=0;
	var r_x=0;
	var r_y=0;
	$(document).ready(function(){
		temp={};
		sizeChange();
		loaddata();
	});
	
	function loaddata(){
		loadOption("<%=CONTEXT_PATH%>/webapp/lljk/lljk_data.jsp",{},true,function(json){
			var tozl=0;
			var to=0;
			for(var fi in json){
				if(fi!='RK'){
					to = to+json[fi];
				}
				document.getElementById(fi).innerHTML=json[fi];	
				if(fi!=undefined&&temp[fi]!=null&&temp[fi]!=undefined){
					var zl = json[fi]-temp[fi];
					if(zl>0){
						$("#"+fi+"_img").show();
						var tim;
						if(fi!='RK'){
							$("#"+fi+"_img").offset({'top':Math.ceil(s_y),'left':Math.ceil(s_x+imgObj[fi]*75+75/2-4)});
							tim= setInterval("setPosition('"+fi+"')",10);
						}else{
							$("#"+fi+"_img").offset({'top':r_y,'left':r_x});
							tim= setInterval("setPosition2('"+fi+"')",10);
						}
						timesObj[fi]=tim;
						document.getElementById(fi+'_zl').innerHTML="+"+zl;
					}else{
						document.getElementById(fi+'_zl').innerHTML="";
					}
					if(fi!='RK'){
						tozl = tozl+zl;
					}
				}else{
					$("#"+fi+"_img").show();
					var tim;
					if(fi!='RK'){
						$("#"+fi+"_img").offset({'top':Math.ceil(s_y),'left':Math.ceil(s_x+imgObj[fi]*75+75/2-4)});
						tim= setInterval("setPosition('"+fi+"')",10);
					}else{
						$("#"+fi+"_img").offset({'top':Math.ceil(r_y),'left':Math.ceil(r_x)});
						tim= setInterval("setPosition2('"+fi+"')",10);
					}
					timesObj[fi]=tim;
				}
			}
			if(tozl>0){
				document.getElementById('H_zl').innerHTML="+"+tozl;
			}else{
				document.getElementById('H_zl').innerHTML="";
			}
			document.getElementById('H').innerHTML=to;
			temp=json;
		});
	}
	
	function setPosition(id){
		var index = imgObj[id];
		var h0 =$("#"+id+"_img");
		var h0_x = h0.offset().left;
		var h0_y = h0.offset().top;
		if(Math.ceil(h0_x)==Math.ceil(s_x+index*75+75/2-4)){
			h0_y = Math.ceil(h0_y-5)<Math.ceil(h_y)?h_y:h0_y-5;
		}else if(Math.ceil(h0_x)==Math.ceil(v_x)){
			h0_x = Math.ceil(v_x);
			h0_y = Math.ceil(h0_y-5)<=Math.ceil(v_y)?v_y:h0_y-5;
		}
		if(Math.ceil(h0_y)==Math.ceil(h_y)){
			h0_y = Math.ceil(h_y);
			if(Math.ceil(h0_x)>Math.ceil(v_x)){
				h0_x = Math.ceil(h0_x-5)<Math.ceil(v_x)?Math.ceil(v_x):Math.ceil(h0_x-5);
			}else if(Math.ceil(h0_x)<Math.ceil(v_x)){
				h0_x = Math.ceil(h0+5)>Math.ceil(v_x)?Math.ceil(v_x):Math.ceil(h0_x+5);
			}
		}else if(Math.ceil(h0_y)<=Math.ceil(v_y)){
			h0.hide();
			window.clearInterval(timesObj[id]);
			delete timesObj[id];
			return;
		}
		h0.offset({'top':h0_y,'left':h0_x});
	}
	
	function setPosition2(id){
		var h0 =$("#"+id+"_img");
		var h0_x = h0.offset().left;
		if(h0_x<r_x+80){
			h0_x=h0_x+1;
		}else{
			h0.hide();
			window.clearInterval(timesObj[id]);
			delete timesObj[id];
			return;
		}
		h0.offset({'left':h0_x});
	}
	
	function doFc(fjm){
		window.open("<%=CONTEXT_PATH%>/webapp/lljk/lljk_jh.jsp?fjm="+fjm);
	}
	
	function sizeChange(){
		var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var w=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		if(h<540){
			h = 540;
		}
		if(w<1275){
			w=1275;
		}
		$("#jk").css({'height':h-80-16,'width':w-16});
		s_x = Math.ceil($('#H0_p').offset().left);
		s_y = Math.ceil($('#H0_p').offset().top);
		h_x = Math.ceil($("#h_line").offset().left);
		h_y = Math.ceil($("#h_line").offset().top);
		v_x = Math.ceil($("#v_line").offset().left + (189-8)/2);
		v_y = Math.ceil($("#v_line").offset().top-20);
		r_x = Math.ceil($("#RK_line").offset().left);
		r_y = Math.ceil($("#RK_line").offset().top+20-4);
	}
	
	//var times = setInterval("loaddata()",10*1000);
	window.onresize = sizeChange;
</script>
</html>