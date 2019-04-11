<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.CalendarUtil"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String kssj = StringUtils.trim(request.getParameter("kssj"));
	String jssj = StringUtils.trim(request.getParameter("jssj"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	String ajlx = StringUtils.trim(request.getParameter("ajlx"));
	
	if("".equals(mc)){
		mc = "全省";
	}
	
	String lastyear = String.valueOf(Integer.parseInt(jssj.substring(0,4)) - 1);
	String kssj2 = lastyear + kssj.substring(4,8);
	String jssj2 = lastyear + jssj.substring(4,8);
	
	String name = "收案";
	String column = "SUM(SAS)";
	if("sas".equals(dl)){
		name = "收案";
		column = "sum(SAS)";
	}else if("jas".equals(dl)){
		name = "结案";
		column = "sum(JAS)";
	}else if("wjs".equals(dl)){
		name = "未结";
		column = "sum(WJS)";
	}
	
	String ajlxname = "";
	String cond = "";
	if(!"".equals(ajlx)){
		if("xsys".equals(ajlx)){
			cond += " AND ID_XTAJLX = '11' ";
			ajlxname = "刑事一审";
		}else if("msys".equals(ajlx)){
			cond += " AND ID_XTAJLX = '21' ";
			ajlxname = "民事一审";
		}else if("xzys".equals(ajlx)){
			cond += " AND ID_XTAJLX = '31' ";
			ajlxname = "行政一审";
		}
	}
	
	Map<String,Integer> datamap = new HashMap<String,Integer>();
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	
	String value1 = "";
	String value2 = "";
	
	String year = jssj.substring(0,4);
	String day = jssj.substring(6,8);
	String month = jssj.substring(4,6);
	int months = Integer.parseInt(month);
	String sftjr = CalendarUtil.sftjr;
	String sftjrend = String.valueOf(Integer.parseInt(sftjr) - 1);
	if(Integer.parseInt(day) > Integer.parseInt(sftjr)){
		months += 1;
	}
	
	for(int i = 1; i <= months ; i++){
		String tjcond = "";
		if(i == months){
			if(i == 1){
				tjcond = " ID_DAY >= '"+lastyear + "12"+sftjr+"' AND ID_DAY <='"+year+"01"+day+"' ";
			}else if(i > 1 && i < 10){
				tjcond = " ID_DAY >= '"+year + "0"+(i-1)+sftjr+"' AND ID_DAY <='"+year+"0"+i+day+"' ";
			}else if(i == 10){
				tjcond = " ID_DAY >= '"+year + "0"+(i-1)+sftjr+"' AND ID_DAY <='"+year+i+day+"' ";
			}else{
				tjcond = " ID_DAY >= '"+year +(i-1)+sftjr+"' AND ID_DAY <='"+year+i+day+"' ";
			}
		}else{
			if(i == 1){
				tjcond = " ID_DAY >= '"+lastyear + "12"+sftjr+"' AND ID_DAY <='"+year+"01"+sftjrend+"' ";
			}else if(i > 1 && i < 10){
				tjcond = " ID_DAY >= '"+year + "0"+(i-1)+sftjr+"' AND ID_DAY <='"+year+"0"+i+sftjrend+"' ";
			}else if(i == 10){
				tjcond = " ID_DAY >= '"+year + "0"+(i-1)+sftjr+"' AND ID_DAY <='"+year+i+sftjrend+"' ";
			}else{
				tjcond = " ID_DAY >= '"+year +(i-1)+sftjr+"' AND ID_DAY <='"+year+i+sftjrend+"' ";
			}
		}
		
		String sql = "SELECT "+column +" NUM from FACT_SJC_DAY "
					+" WHERE "
					+ tjcond
					+ cond
					+ " AND ID_FYDM LIKE '"+fjm+"%' ";
		//System.out.println("hzdt_day_line sql-->"+sql);
		List<Map<String,Object>> li = bi09.queryForList(sql);
		int num = 0;
		if(li != null && li.size() > 0){
			if(li.get(0).get("NUM") != null){
				num = (Integer)li.get(0).get("NUM");
			}
		}
		value1 += num+",";
	}
	
	for(int i = 1; i <= months ; i++){
		String tjcond = "";
		if(i == months){
			//当前月，只是到当天
			if(i == 1){
				tjcond = " ID_DAY >= '"+(Integer.parseInt(lastyear)-1) + "12"+sftjr+"' AND ID_DAY <='"+lastyear+"01"+day+"' ";
			}else if(i > 1 && i < 10){
				tjcond = " ID_DAY >= '"+lastyear + "0"+(i-1)+sftjr+"' AND ID_DAY <='"+lastyear+"0"+i+day+"' ";
			}else if(months == 10){
				tjcond = " ID_DAY >= '"+lastyear +"0"+(i-1)+sftjr+"' AND ID_DAY <='"+lastyear+i+day+"' ";
			}else{
				tjcond = " ID_DAY >= '"+lastyear +(i-1)+sftjr+"' AND ID_DAY <='"+lastyear+i+day+"' ";
			}
		}else{
			if(i == 1){
				tjcond = " ID_DAY >= '"+(Integer.parseInt(lastyear)-1) + "12"+sftjr+"' AND ID_DAY <='"+lastyear+"01"+sftjrend+"' ";
			}else if(i > 1 && i < 10){
				tjcond = " ID_DAY >= '"+lastyear + "0"+(i-1)+sftjr+"' AND ID_DAY <='"+lastyear+"0"+i+sftjrend+"' ";
			}else if(i == 10){
				tjcond = " ID_DAY >= '"+lastyear + "0"+(i-1)+sftjr+"' AND ID_DAY <='"+lastyear+i+sftjrend+"' ";
			}else{
				tjcond = " ID_DAY >= '"+lastyear +(i-1)+sftjr+"' AND ID_DAY <='"+lastyear+i+sftjrend+"' ";
			}
		}
		
		String sql = "SELECT "+column +" NUM from FACT_SJC_DAY "
					+" WHERE "
					+ tjcond
					+ cond
					+ " AND ID_FYDM LIKE '"+fjm+"%' ";
		//System.out.println("hzdt_day_line sql-->"+sql);
		List<Map<String,Object>> li = bi09.queryForList(sql);
		int num = 0;
		if(li != null && li.size() > 0){
			if(li.get(0).get("NUM") != null){
				num = (Integer)li.get(0).get("NUM");
			}
		}
		value2 += num+",";
	}
	
	value1 = value1.substring(0,value1.length() - 1);
	value2 = value2.substring(0,value2.length() - 1);
	
	
%>
 option = {
    tooltip : {
        trigger: 'axis'
    },
    title : {
        text: '<%=mc+ajlxname %><%=name %>趋势',
        x:'center',
        textStyle:{
		    fontSize: 26,
		    fontWeight: 'bold',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
    },
    color:['#7D26CD','#FF7F50'],
    legend: {
        data:['本期','同期'],
        x:'right'
    },
    grid:{
    	x:'55',
    	y:'55',
    	x2:'25',
    	y2:'55'
    },
    calculable : true,
    xAxis : [
        {
            type : 'category',
            boundaryGap : true,
            data : ['1','2','3','4','5','6','7','8','9','10','11','12']
        }
    ],
    yAxis : [
        {
            type : 'value',
            scale: true,
            name : '数量',
            axisLabel : {
                formatter: '{value}'
            }
        }
    ],
    series : [
        {
            name:'本期',
            type:'line',
            data:[
            <%=value1%>
            ]
        },
        {
            name:'同期',
            type:'line',
            data:[
            	<%=value2%>
            ]
        }
    ]
};                  