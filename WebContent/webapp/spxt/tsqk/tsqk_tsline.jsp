<%@page import="tdh.util.CalendarUtil"%>
<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	Map<String,Integer> datamap = new HashMap<String,Integer>();
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		mc = "全省";
	}else if(dm.endsWith("00")){
 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
	}

	String mth = sdf.format(new Date());
	String[] sjs = CalendarUtil.getKssjJssj(mth.substring(0,4));
	String sql = "select ID_MTH,SUM(KTSL) SL from DC_SPXT_KT where ID_MTH >= '"+sjs[0]+"' and ID_MTH <= '"+sjs[1]+"' and ID_FYDM like '"+dm+"%' group by ID_MTH";
	List<Map<String, Object>> list=bi09.queryForList(sql);
	if(list != null && list.size() > 0){
		for(Map<String,Object> m : list){
			String _mth = (String)m.get("ID_MTH");
			Integer sl = (Integer)m.get("SL");
			datamap.put(_mth,sl);
		}
	}
	String value2 = "";
	int maxm = Integer.valueOf(sjs[1].substring(4));
	for(int i = 1 ; i <= maxm ; i++){
		String mth2 = "";
		if(i <10) {
   		 	mth2 = mth.substring(0,4)+ "0"+i;
   	 	}else{
   	 	 	mth2 = mth.substring(0,4)+i;
   	 	}
   		value2 += datamap.get(mth2)==null?0:datamap.get(mth2);
   		if(i !=  maxm) {
   			value2 += ",";
   		}
	}
%>
 option = {
    tooltip : {trigger: 'axis'},
    title : {
        text: '<%=mc %>庭审次数单月趋势',
        x:'center',
        textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
    },
  	legend: {data:['庭审次数'],x:'right'},
    grid:{x:50,x2:30,y2:30},
    xAxis : [
        {
            type : 'category',
            boundaryGap : true,
            data : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
        }
    ],
    yAxis : [{type:'value',scale: true,name:'数量',axisLabel:{formatter:'{value}'}}],
    series : [{name:'庭审次数', type:'line',data:[<%=value2%>]}]
};                  