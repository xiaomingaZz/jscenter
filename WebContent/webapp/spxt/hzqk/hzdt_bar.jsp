<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	String ajlx = StringUtils.trim(request.getParameter("ajlx"));
	
	String []tjyf = CalendarUtil.getKssjJssj(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	String []tjyf2 = CalendarUtil.getKssjJssj2(kssj,jssj);
	String kssj2 = tjyf2[0];
	String jssj2 = tjyf2[1];
	
	if("".equals(mc)){
		mc = "全省";
	}
	int rotate = 0;
	
	String baseid = "";
	String name = "收案";
	String cond = " ID_MTH >='"+kssj+"' AND ID_MTH <='"+jssj+"' ";
	String cond2 = " ID_MTH >='"+kssj2+"' AND ID_MTH <='"+jssj2+"' ";
	String column = "SUM(SAS)";
	if("sas".equals(dl)){
		name = "收案";
		column = "sum(SAS)";
		baseid = "JS0002";
	}else if("jas".equals(dl)){
		name = "结案";
		column = "sum(JAS)";
		baseid = "JS0003";
	}else if("wjs".equals(dl)){
		name = "未结";
		column = "sum(WJS)";
		baseid = "JS00WJ";
		cond = " ID_MTH ='"+jssj+"' ";
		cond2 = " ID_MTH ='"+jssj2+"' ";
	}
	
	if(!"".equals(ajlx)){
		if("xsys".equals(ajlx)){
			cond += " AND ID_AJLX = '1011' ";
			cond2 += " AND ID_AJLX = '1011' ";
		}else if("msys".equals(ajlx)){
			cond += " AND ID_AJLX = '2021' ";
			cond2 += " AND ID_AJLX = '2021' ";
		}else if("xzys".equals(ajlx)){
			cond += " AND ID_AJLX = '6031' ";
			cond2 += " AND ID_AJLX = '6031' ";
		}
	}
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	
	//System.out.println("kssj-jssj-->"+kssj+"  "+jssj);
	//System.out.println("kssj2-jssj2-->"+kssj2+"  "+jssj2);

	List<Map<String,Object>> fylist = new ArrayList<Map<String,Object>>();
	String sql = "";
	String sql_tq = "";
	if(dm.length() == 2){
		sql = "select substring(ID_YWCB,1,2) FYDM,"+column+" NUM from FACT_SJC where "
			+ cond
			+ " group by substring(ID_YWCB,1,2)";
		sql_tq = "select substring(ID_YWCB,1,2) FYDM,"+column+" NUM from FACT_SJC where "
			+ cond2
			+ " group by substring(ID_YWCB,1,2)";
		fylist = bi09.queryForList("select DM_CITY,FJM DM ,NAME_CITY from DC_CITY where DATALENGTH(DM_CITY) = 4 AND ISNULL(SFJY,'') <> '1' order by DM_CITY asc ");
	}else{
		if(dm.endsWith("00")){
			rotate = 30;
			mc = "省院及中院";
			sql = "select substring(ID_YWCB,1,3) FYDM,"+column+" NUM from FACT_SJC where "
				+ cond
			  	+" and ID_YWCB like '"+fjm.substring(0,1)+"_0%' group by substring(ID_YWCB,1,3)";
			sql_tq = "select substring(ID_YWCB,1,3) FYDM,"+column+" NUM from FACT_SJC where "
				+ cond2
		  	  	+" and ID_YWCB like '"+fjm.substring(0,1)+"_0%' group by substring(ID_YWCB,1,3)";
			fylist = bi09.queryForList("select DM_CITY, FJM DM ,NAME_CITY from DC_CITY where FJM like  '"+fjm.substring(0,1)+"_0'  AND ISNULL(SFJY,'') <> '1' order by DM_CITY asc ");
		}else{
			sql = "select substring(ID_YWCB,1,3) FYDM,"+column+" NUM from FACT_SJC where "
				+ cond
			  	+" and ID_YWCB like '"+fjm+"%' group by substring(ID_YWCB,1,3)";
			sql_tq = "select substring(ID_YWCB,1,3) FYDM,"+column+" NUM from FACT_SJC where "
				+ cond2
		  	  	+" and ID_YWCB like '"+fjm+"%' group by substring(ID_YWCB,1,3)";
			fylist = bi09.queryForList("select DM_CITY, FJM DM ,NAME_CITY from DC_CITY where FJM like  '"+fjm+"%' AND FJM <> '"+fjm+"'  AND ISNULL(SFJY,'') <> '1' order by DM_CITY asc ");
		}
	}
	//System.out.println("hzdt bar sql-->"+sql);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	List<Map<String,Object>> list2 = bi09.queryForList(sql_tq);
	String xdata = "",data1 = "",data2 = "",xValue="",data3 = "";
	int total = 0;
	for(int i = 0 ; i < fylist.size() ; i++){
		Map<String,Object> mm = fylist.get(i);
		String ctmc = mm.get("NAME_CITY").toString();
		String ctdm = mm.get("DM_CITY").toString();
		int num =0;
		for(Map<String,Object> map:list){
			if(map.get("FYDM").equals(mm.get("DM"))){
				if(map.get("NUM") != null){
					num = Integer.valueOf(map.get("NUM").toString());
				}
				break;
			}
		}
		int num2 =0;
		for(Map<String,Object> map:list2){
			if(map.get("FYDM").equals(mm.get("DM"))){
				if(map.get("NUM") != null){
					num2 = Integer.valueOf(map.get("NUM").toString());
				}
				break;
			}
		}
		total += num;
		
		xdata = xdata+"'"+ctmc+"',";
		//data1 = data1+num+",";
		//data2 = data2+num2+",";
		data1 += "{'baseid':'"+baseid+"','name':'"+ctmc+"','value':"+num+",'dm':'"+ctdm+"','kssj':'"+kssj+"','jssj':'"+jssj+"'},";
		data2 += "{'baseid':'"+baseid+"','name':'"+ctmc+"','value':"+num2+",'dm':'"+ctdm+"','kssj':'"+kssj2+"','jssj':'"+jssj2+"'},";
		data3 += (num - num2)+",";
		xValue = xValue + "'" + mm.get("DM") + "',";
	}
	
	xValue = xValue.substring(0,xValue.length() - 1);
	
	String []color = JSUtils.MAP_COLOR_ARRAY;
	String colorArray = "";
	for(String s : color){
		colorArray += "'"+s+"',";
	}
	colorArray = colorArray.substring(0,colorArray.length() - 1);
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=mc %>案件<%=name %>分布情况(<%=total %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
	xAxisValue : [<%=xValue%>],
	color:['#7D26CD','#FF7F50','#EE2C2C'],
	grid:{x:50,x2:40},
    xAxis : [{
	    	type : 'category',
	    	axisLabel: {rotate: <%=rotate %> },
	    	data : [<%=xdata.substring(0,xdata.length()-1) %>]
    	}],
    legend: {
        data:['本期','同期','增幅'],
        x:'right'
    },
    yAxis : [{
    		name : '案件数',
    		type : 'value'
    	},{
    		name : '增幅',
            axisLabel : {
                formatter: '{value} '
            }
    	}],
    series : [
        {
            name:'本期',
            type:'bar',
            data:[<%=data1.substring(0,data1.length()-1) %>]
        },{
            name:'同期',
            type:'bar',
            data:[<%=data2.substring(0,data2.length()-1) %>]
        },{
        	name:'增幅',
        	yAxisIndex: 1,
        	type:'line',
        	data:[<%=data3.substring(0,data3.length()-1) %>]
        }
    ]
};
                    