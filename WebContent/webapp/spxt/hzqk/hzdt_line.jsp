<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.CalendarUtil"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	String ajlx = StringUtils.trim(request.getParameter("ajlx"));
	
	if("".equals(mc)){
		mc = "全省";
	}
	
	String []tjyf = CalendarUtil.getKssjJssj(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	String []tjyf2 = CalendarUtil.getKssjJssj2(kssj,jssj);
	String kssj2 = tjyf2[0];
	String jssj2 = tjyf2[1];
	
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
	
	String cond = "";
	if(!"".equals(ajlx)){
		if("xsys".equals(ajlx)){
			cond += " AND ID_AJLX = '1011' ";
		}else if("msys".equals(ajlx)){
			cond += " AND ID_AJLX = '2021' ";
		}else if("xzys".equals(ajlx)){
			cond += " AND ID_AJLX = '6031' ";
		}
	}
	
	Map<String,Integer> datamap = new HashMap<String,Integer>();
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	
	String sql = "select ID_MTH,"+column +" NUM from FACT_SJC  "
				+" where ID_MTH >= '"+kssj2+"' and ID_MTH <= '"+jssj+"' "
				+" and ID_YWCB like '"+fjm+"%' "
				+ cond
				+" group by ID_MTH";
	//System.out.println("SQL LINE-->"+sql);
	List<Map<String, Object>> list=bi09.queryForList(sql);
	if(list != null && list.size() > 0){
		for(Map<String,Object> m : list){
			String _mth = (String)m.get("ID_MTH");
			Integer sl = (Integer)m.get("NUM");
			datamap.put(_mth,sl);
		}
	}
	String value1 = "";
	String value2 = "";
	
	String lastyear = kssj2.substring(0,4);
	for(int i = 1 ; i <= 12 ; i++){
		String mth2 = "";
		if(i <10) {
   		 	mth2 = String.valueOf(lastyear)+ "0"+i;
   	 	}else{
   	 	 	mth2 = String.valueOf(lastyear)+i;
   	 	}
   		Integer val =  datamap.get(mth2)==null?0:datamap.get(mth2);
   		if(val == null)
   			value2 += "0";
   		else
			value2 += val;
   	   
   		if(i !=  12) value2 += ",";
	}
	
	int len = Integer.parseInt(jssj.substring(4,6));
	for(int i = 1 ; i <= len ; i++){
		String mth2 = "";
		if(i <10) {
   		 	mth2 = String.valueOf(nd)+ "0"+i;
   	 	}else{
   	 	 	mth2 = String.valueOf(nd)+i;
   	 	}
   		Integer val =  datamap.get(mth2)==null?0:datamap.get(mth2);
   		if(val == null)
   			value1 += "0";
   		else
			value1 += val;
   	   
   		if(i !=  len) value1 += ",";
	}
%>
 option = {
    tooltip : {
        trigger: 'axis'
    },
    title : {
        text: '<%=mc %><%=name %>趋势',
        x:'center',
        textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
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