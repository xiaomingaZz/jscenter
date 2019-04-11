<%@page import="tdh.util.JSUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	String mc = StringUtils.trim(request.getParameter("mc"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
			mc = "全省";
		}else if(dm.endsWith("00")){
	 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
			if(fylist.size()>0){
				mc = fylist.get(0).get("MC").toString();
			}
		}
	 	
		String  ktrq = sdf.format(new Date());
		
		String sql = "select SUM(CASE WHEN isnull(KTZT,'')='' or KTZT = '0' THEN 1 ELSE 0 END) SL_0,SUM(CASE WHEN KTZT='1' THEN 1 ELSE 0 END) SL_1,"+
			"SUM(CASE WHEN KTZT='2' THEN 1 ELSE 0 END) SL_2 from DC_SPXT_KTQD where KTRQ = '"+ktrq+"' and FYDM like '"+dm+"%'";
		
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String data1 ="";
	 	int sl_0=0,sl_1=0,sl_2=0;
	 	if(list.size()>0){
	 		Map<String,Object> mm=list.get(0);
	 		sl_0 = mm.get("SL_0")!=null?Integer.valueOf(mm.get("SL_0").toString()):0;
	 		sl_1 = mm.get("SL_1")!=null?Integer.valueOf(mm.get("SL_1").toString()):0;
	 		sl_2 = mm.get("SL_2")!=null?Integer.valueOf(mm.get("SL_2").toString()):0;
	 	}
	 	data1 += "{'baseid':'JS0012','name':'等待开庭','value':"+sl_0+",'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ktzt':'null,0'},";
	 	data1 += "{'baseid':'JS0012','name':'正在开庭','value':"+sl_1+",'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ktzt':'1'},";
	 	data1 += "{'baseid':'JS0012','name':'已闭庭','value':"+sl_2+",'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ktzt':'2'}";
 %>
option = {
    title : {show:true,x:'center',text: '<%=mc %>今日庭审情况(<%=(sl_0+sl_1+sl_2) %>)',
		textStyle:{fontSize: 26,fontWeight: 'bolder',color: '#000000',margin:'0 20 20 20'}},
    tooltip : {show:true,trigger: 'item',formatter: "{a} <br/>{b} : {c} ({d}%)"},
    legend: {orient : 'vertical',x :'left',y : 'center',data:["正在开庭","等待开庭","已闭庭"]},
    series : [{
            name:'庭审情况',
            type:'pie',
            radius : [0,170],
            center: ['50%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=data1 %>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    