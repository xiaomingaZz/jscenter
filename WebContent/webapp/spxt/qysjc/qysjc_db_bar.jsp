<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	String fydm = StringUtils.trim(request.getParameter("fydm"));
	String bmdm = StringUtils.trim(request.getParameter("bmdm"));
	String rydms = StringUtils.trim(request.getParameter("rydm"));
	
	String ryCond1 = "";
	String ryCond2 = "";
	if(!"".equals(rydms)){
		for(String rydm : rydms.split(",")){
			ryCond1 += " YHDM = '"+rydm+"' or";
			ryCond2 += " CBR = '"+rydm+"' or";
		}
		if(ryCond1.length() > 0){
			ryCond1 = " AND ("+ryCond1.substring(0,ryCond1.length() - 2)+" ) ";
			ryCond2 = " AND ("+ryCond2.substring(0,ryCond2.length() - 2)+" ) ";
		}
	}
	
	String baseid = "JS0001";
	String title = "";
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	String sql1 = "select YHDM,YHXM from ETL_USER where DWDM = '"+fydm+"' AND YHBM = '"+bmdm+"' "+ryCond1 +" ORDER BY YHDM";
	List<Map<String,Object>> rylist = bi09.queryForList(sql1);
	String sql = "select CBR,COUNT(AHDM) NUM from ETL_CASE where FYDM = '"+fydm+"' and CBBM1 = '"+bmdm+"' AND BCYSFTJ = '0' AND XTAJLX <>'15' "+ryCond2;
	if("sa".equals(dl)){
		baseid = "JS0001";
		title = "收案";
		sql += " AND AJZT>='300' AND LARQ >='@KSSJ@' AND LARQ <= '@JSSJ@' group by CBR ";
	}else if("ja".equals(dl)){
		baseid = "JS0002";
		title = "结案";
		sql += " AND AJZT>='800' AND JARQ >='@KSSJ@' and JARQ <= '@JSSJ@' group by CBR ";
	}else if("wj".equals(dl)){
		baseid = "JS0003";
		title = "未结";
		sql += " AND AJZT>='300' AND AJZT <'800' AND (LARQ <='@JSSJ@' OR (AJZT >='800' AND JARQ > '@JSSJ@')) group by CBR ";
	}
	System.out.println(sql);
	String series = "";
	String xdata = "";
	for(Map<String,Object> map:rylist){
		String mc = map.get("YHXM").toString();
		xdata +=",'"+mc+"'";
	}
	
	for(int i = Integer.parseInt(nd) - 4;i <= Integer.parseInt(nd); i++){
		String []tjyf = CalendarUtil.getKssjJssjDay(String.valueOf(i));
		List<Map<String,Object>> list = bi09.queryForList(sql.replaceAll("@KSSJ@",tjyf[0]).replaceAll("@JSSJ@",tjyf[1]));
		series +=",{name:'"+i+"',type:'bar',barMaxWidth:40";
		String data = "";
		for(Map<String,Object> map:rylist){
			
			String mc = map.get("YHXM").toString();
			String dm = map.get("YHDM").toString();
			Object num = 0;
			for(Map<String,Object> mm:list){
				if(dm.equals(mm.get("CBR"))){
					num = mm.get("NUM");
					break;
				}
			}
			data += ",{'baseid':'"+baseid+"','name':'"+mc+"','value':"+num+",'fydm':'"+fydm+"','bmdm':'"+bmdm+"','yhdm':'"+dm+"','kssj':'"+tjyf[0]+"','jssj':'"+tjyf[1]+"'}";
		}
		if(data.startsWith(",")){
			data = data.substring(1);
		}
		series += ",data:["+data+"]";
		series +="}";
	}
	
	int rotate = 0;
	if(rylist.size()>20){
		rotate = 30;
	}
	
	if(xdata.startsWith(",")){
		xdata = xdata.substring(1);
		series = series.substring(1);
	}
	System.out.println(series);
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '人员<%=title %>对比情况',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
	grid:{x:40,x2:20,h2:30},
    xAxis : [{type : 'category',axisLabel: {rotate: <%=rotate %> },data : [<%=xdata %>]}],
    yAxis : [{name : '案件数',type : 'value'}],
    color : ['#C1232B','#B5C334','#FCCE10','#E87C25','#27727B'],
    series : [<%=series %>]
};
                    