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
	 	String type = StringUtils.trim(request.getParameter("type"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	
	 	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
			mc = "全省";
		}else if(dm.endsWith("00")){
	 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
			if(fylist.size()>0){
				mc = fylist.get(0).get("MC").toString();
			}
		}
	 	
		String sql = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String ktrq = sdf.format(new Date());
		String legend="";
		String baseid = "JS0012";
		if("jr".equals(type)){
			legend = mc+"今日开庭";
			sql = "select subString(XTAJLX,1,1) DM ,COUNT(AHDM) SL from DC_SPXT_KTQD where KTRQ='"+ktrq+"' and FYDM like '"+dm+"%' group by subString(XTAJLX,1,1)";
		}else{
			legend = mc+"年累开庭";
			baseid = "JS0013";
			sql = "select subString(ID_XTAJLX,1,1) DM ,SUM(KTSL) SL from DC_SPXT_KT where ID_MTH >='"+ktrq.substring(0,4)+"01' and ID_MTH <='"+
			ktrq.substring(0,6)+"'  and ID_FYDM like '"+dm+"%' group by subString(ID_XTAJLX,1,1)";
		}
		
		List<Map<String,Object>> list = bi09.queryForList(sql);
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("1","刑事");m.put("2","民事");m.put("3","行政");
		
		String xdata = "";
		String value0 ="";
		int tsl =0;
	 	int ot = 0;
	 	if(list==null||list.size()==0){
	 		xdata = "'刑事','民事','行政','其他'";
	 		value0 += "{'baseid':'"+baseid+"','name':'刑事','value':0,'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ajlx':'1'},";
	 		value0 += "{'baseid':'"+baseid+"','name':'民事','value':0,'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ajlx':'2'},";
	 		value0 += "{'baseid':'"+baseid+"','name':'行政','value':0,'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ajlx':'3'},";
	 		value0 += "{'baseid':'"+baseid+"','name':'其他','value':0,'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ajlx':'[4-9]'},";
	 	}else{
	 		for(Map<String,Object> map:list){
				int sl = map.get("SL")!=null?Integer.valueOf(map.get("SL").toString()):0;
				String lxdm = map.get("DM").toString();
				if(m.containsKey(lxdm)){
					String lxmc = StringUtils.trim(m.get(map.get("DM")));
					xdata += "'"+lxmc+"',";
					if("jr".equals(type)){
						value0 += "{'baseid':'"+baseid+"','name':'"+lxmc+"','value':"+sl+",'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ajlx':'"+lxdm+"'},";
					}else{
						value0 += "{'baseid':'"+baseid+"','name':'"+lxmc+"','value':"+sl+",'dm':'"+dm+"','kssj':'"+ktrq.substring(0,4)+"01','jssj':'"+ktrq.substring(0,6)+"','ajlx':'"+lxdm+"'},";
					}
				}else{
					ot +=sl;
				}
				tsl += sl;
			}
			if(ot>0){
				xdata += "'其他'";
				if("jr".equals(type)){
					value0 += "{'baseid':'"+baseid+"','name':'其他','value':"+ot+",'dm':'"+dm+"','kssj':'"+ktrq+"','jssj':'','ajlx':'[4-9]'}";
				}else{
					value0 += "{'baseid':'"+baseid+"','name':'其他','value':"+ot+",'dm':'"+dm+"','kssj':'"+ktrq.substring(0,4)+"01','jssj':'"+ktrq.substring(0,6)+"','ajlx':'[4-9]'}";
				}
			}else if(xdata.endsWith(",")){
				xdata = xdata.substring(0,xdata.length()-1);
				value0 = value0.substring(0,value0.length()-1);
			}
		 	
	 	}
		
 %>
option = {
     title : {show:true,x:'center',text: '<%=legend %>类型分布(<%=tsl %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    tooltip : {
    	show:true,
        trigger: 'item'
    },
    legend: {
        orient : 'vertical' ,
        x : 'left',
        y : 'center',
        data:[<%=xdata %>]
    },
    series : [
        {
            name:'开庭数',
            type:'pie',
            radius : [0,170],
            center: ['50%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=value0 %>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    