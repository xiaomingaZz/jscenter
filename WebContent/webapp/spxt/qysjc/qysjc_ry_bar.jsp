<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	String bmdm = StringUtils.trim(request.getParameter("bmdm"));
	String bmmc = StringUtils.trim(request.getParameter("bmmc"));
	String rydms = StringUtils.trim(request.getParameter("rydms"));
	
	String ryCond = "";
	if(!"".equals(rydms)){
		for(String rydm : rydms.split(",")){
			ryCond += " YHDM = '"+rydm+"' or";
		}
		if(ryCond.length() > 0){
			ryCond = " AND ("+ryCond.substring(0,ryCond.length() - 2)+" ) ";
		}
	}
	
	String []tjyf = CalendarUtil.getKssjJssjDay(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	
	String baseid = "JS0001";
	String sql = "";
	String title = "";
	if("sa".equals(dl)){
		title = "收案";
		sql = "select YHDM,YHXM,COUNT(AHDM) NUM from ETL_USER LEFT JOIN ETL_CASE ON ETL_CASE.FYDM = ETL_USER.DWDM"
		+" AND ETL_CASE.CBR = ETL_USER.YHDM AND ETL_CASE.FYDM ='"+dm+"' AND AJZT>='300' AND LARQ >='"+kssj+"' AND LARQ <= '"+jssj+"'"
		+" AND BCYSFTJ = '0' AND XTAJLX <>'15' where CBBM1= '"+bmdm+"' "+ ryCond+" group by YHDM,YHXM ORDER BY YHDM";
	}else if("ja".equals(dl)){
		baseid = "JS0002";
		title = "结案";
		sql = "select YHDM,YHXM,COUNT(AHDM) NUM from ETL_USER LEFT JOIN ETL_CASE ON ETL_CASE.FYDM = ETL_USER.DWDM"
		+" AND ETL_CASE.CBR = ETL_USER.YHDM AND ETL_CASE.FYDM ='"+dm+"' AND AJZT>='800' AND JARQ >='"+kssj+"' and JARQ <='"+jssj+"' "
		+" AND BCYSFTJ = '0' AND XTAJLX <>'15' where CBBM1 = '"+bmdm+"' "+ ryCond+" group by YHDM,YHXM"+" ORDER BY YHDM";
	}else if("wj".equals(dl)){
		baseid = "JS0003";
		title = "未结";
		sql = "select YHDM,YHXM,COUNT(AHDM) NUM from ETL_USER LEFT JOIN ETL_CASE ON ETL_CASE.FYDM = ETL_USER.DWDM"
		+" AND ETL_CASE.CBR = ETL_USER.YHDM AND ETL_CASE.FYDM ='"+dm+"' AND AJZT>='300' AND AJZT <'800' AND (LARQ <='"+jssj+"' OR (AJZT >='800' AND JARQ > '"+jssj+"')) "
		+" AND BCYSFTJ = '0' AND XTAJLX <>'15' where CBBM1 = '"+bmdm+"' "+ ryCond+" group by YHDM,YHXM"+" ORDER BY YHDM";
	}
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	
	System.out.println("==>"+sql);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String xdata = "";
	String data1 = "";
	int total = 0;
	int rotate = 0;
	int count = 0;
	String dm_="";
	String mc_="";
	for(Map<String,Object> mm : list){
		String ctmc = mm.get("YHXM").toString();
		String ctdm = mm.get("YHDM").toString();
		int num =0;
		if(mm.get("NUM") != null){
			num = Integer.valueOf(mm.get("NUM").toString());
		}
		if(num > 0){
			++count;
			total += num;
			xdata += ",'"+ctmc+"'";
			data1 += ",{'baseid':'"+baseid+"','name':'"+ctmc+"','value':"+num+",'dm':'"+ctdm+"','kssj':'"+kssj+"','jssj':'"+jssj+"'}";
			if(dm_.equals("")){
				dm_ = ctdm;
				mc_ = ctmc;
			}
		}
	}
	if(count>20){
		rotate = 30;
	}
	
	if(data1.startsWith(",")){
		xdata = xdata.substring(1);
		data1 = data1.substring(1);
	}
	
%>

option = {
	rydm:'<%=dm_ %>',
	rymc:'<%=mc_ %>',
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=bmmc %>人员<%=title %>情况(<%=total %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
	//color:['#7D26CD','#FF7F50','#EE2C2C'],
	grid:{x:50,x2:40},
    xAxis : [{
	    	type : 'category',
	    	axisLabel: {rotate: <%=rotate %> },
	    	data : [<%=xdata %>]
    	}],
    
    yAxis : [{
    		name : '案件数',
    		type : 'value'
    	}],
    series : [
        {
            name:'案件数',
            type:'bar',
            barMaxWidth:40,
            itemStyle: {
                normal: {
                    color: function(params) {
                        var colorList = [
								'#C1232B','#B5C334','#FCCE10','#E87C25','#27727B',
								'#FE8463','#9BCA63','#FAD860','#F3A43B','#60C0DD',
								'#D7504B','#C6E579','#F4E001','#F0805A','#26C0C0',
								'#ff7f50', '#87cefa', '#da70d6', '#32cd32', '#6495ed', 
								'#ff69b4', '#ba55d3', '#cd5c5c', '#ffa500', '#40e0d0', 
								'#1e90ff', '#ff6347', '#7b68ee', '#00fa9a', '#ffd700', 
								'#6b8e23', '#ff00ff', '#3cb371', '#b8860b', '#30e0e0',
								'#C1232B','#B5C334','#FCCE10','#E87C25','#27727B',
								'#FE8463','#9BCA63','#FAD860','#F3A43B','#60C0DD',
								'#D7504B','#C6E579','#F4E001','#F0805A','#26C0C0',
								'#ff7f50', '#87cefa', '#da70d6', '#32cd32', '#6495ed', 
								'#ff69b4', '#ba55d3', '#cd5c5c', '#ffa500', '#40e0d0', 
								'#1e90ff', '#ff6347', '#7b68ee', '#00fa9a', '#ffd700', 
								'#6b8e23', '#ff00ff', '#3cb371', '#b8860b', '#30e0e0'
								
                        ];
                        return colorList[params.dataIndex]
                    }
                }
            },
            data:[<%=data1 %>]
        }
    ]
};
                    