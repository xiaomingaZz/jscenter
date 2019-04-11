<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	String type =StringUtils.trim(request.getParameter("type"));
	String  mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	List<Map<String,Object>> fylist ;
	String sql = "";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	String ktrq = sdf.format(new Date());
	
	String title="";
	String field1 = "";
	String field2 = "";
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DATALENGTH(DM_CITY) = 4 AND isnull(SFJY,'')<>'1' order by DM_CITY asc ");
		mc = "全省";
		field1 = "substring(FYDM,1,4)";
		field2 = "substring(ID_FYDM,1,4)";
		dm = JSUtils.fydm;
	}else if(dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DM_CITY like '"+dm.substring(0,2)+"%00' and DATALENGTH(DM_CITY) = 6 AND isnull(SFJY,'')<>'1'  order by DM_CITY asc ");
		mc = "省院及中级法院";
		field1 = "FYDM";
		field2 = "ID_FYDM";
		dm = JSUtils.fydm+"%00";
	}else{
		if(dm.length()==6){
			dm = dm.substring(0,4);
		}
		fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DM_CITY like  '"+dm+"%' and DM_CITY<>'"+dm+"' AND isnull(SFJY,'')<>'1' order by DM_CITY asc ");
		field1 = "FYDM";
		field2 = "ID_FYDM";
	}
	String baseid = "JS0012";
	if("jr".equals(type)){
		baseid = "JS0012";
		title = mc+"今日开庭情况";
		sql = "select "+field1+" DM,COUNT(*) SL FROM DC_SPXT_KTQD where KTRQ='"+ktrq+"' and FYDM like '"+dm+"%' GROUP BY "+field1;
	}else{
		baseid = "JS0013";
		title = mc+"年累开庭情况";
		sql = "select "+field2+" DM,SUM(KTSL) SL FROM DC_SPXT_KT where subString(ID_MTH,1,6) >= '"+ktrq.substring(0,4)+"01' and subString(ID_MTH,1,6) <= '"+ktrq.substring(0,6)+"' and ID_FYDM like '"+dm+"%' GROUP BY "+field2;
	}
	
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String xdata = "";
	String value0 = "";
	int tsl = 0;
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> mm = fylist.get(i);
		String ctmc = mm.get("NAME_CITY").toString();
		String ctdm = mm.get("DM_CITY").toString();
		int sl = 0;
		for(Map<String,Object> map:list){
			if(map.get("DM").equals(ctdm)){
				sl = map.get("SL")!=null?Integer.valueOf(map.get("SL").toString()):0;
				break;
			}
		}
		tsl +=sl;
		xdata = xdata+"'"+ctmc+"',";
		if("jr".equals(type)){
			value0 += "{'baseid':'"+baseid+"','name':'"+ctmc+"','value':"+sl+",'dm':'"+ctdm+"','kssj':'"+ktrq+"','jssj':''},";
		}else{
			value0 += "{'baseid':'"+baseid+"','name':'"+ctmc+"','value':"+sl+",'dm':'"+ctdm+"','kssj':'"+ktrq.substring(0,4)+"01','jssj':'"+ktrq.substring(0,6)+"'},";
		}
		
	}
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=title %>(<%=tsl %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    xAxis : [{type : 'category',axisLabel: {rotate: 0 },data : [<%=xdata.substring(0,xdata.length()-1) %>]}],
    legend: {data:['开庭数'],x:'right'},
    grid:{'x':40,'x2':25,'y':55,'y2':30},
    yAxis : [{type : 'value'}],
    series : [
        {
            name:'开庭数',
            type:'bar',
            barWidth:50,
            itemStyle: {
                normal: {
                	label : {show: true, position: 'inside'},
                	color: function(params) {
                        var colorList = [<%=JSUtils.COLOR_STR %>];
                        return colorList[params.dataIndex]
                    }
                }
            },
            data:[<%=value0.substring(0,value0.length()-1) %>]
        }
    ]
};
                    