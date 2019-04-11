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
	 	String type = StringUtils.trim(request.getParameter("type"));
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		
		String cond = "";
		String typemc = "";
		String[] baseid = new String[]{"JS0004","JS0005","JS0006"};
		if(type.equals("ss")){
			typemc = "诉讼";
			cond = " XTAJLX not like '5%' ";
		}else {
			baseid = new String[]{"JS0007","JS0008","JS0009"};
			typemc = "执行";
			cond = " XTAJLX like '5%' ";
		}
		
		if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
			mc = "全省";
	 	}else if(dm.endsWith("00")){
	 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
			if(fylist.size()>0){
				mc = fylist.get(0).get("MC").toString();
			}
		}
		
	 	String sql = "select SUM(CASE WHEN dateadd(month,12,LARQ)<getdate() THEN 1 ELSE 0 END) SL_12,"+
			"SUM(CASE WHEN dateadd(month,18,LARQ)<getdate() THEN 1 ELSE 0 END) SL_18,SUM(CASE WHEN dateadd(month,36,LARQ)<getdate() THEN 1 ELSE 0 END) SL_36  "+
			"from ETL_CASE_CCQ where isnull(LARQ,'')>'' and "+cond+" and FYDM like '"+dm+"%'";
	 	
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String data1 ="";
	 	int sl_12=0,sl_18=0,sl_36=0;
	 	if(list.size()>0){
	 		Map<String,Object> mm=list.get(0);
	 		sl_12 = mm.get("SL_12")!=null?Integer.valueOf(mm.get("SL_12").toString()):0;
			sl_18 = mm.get("SL_18")!=null?Integer.valueOf(mm.get("SL_18").toString()):0;
			sl_36 = mm.get("SL_36")!=null?Integer.valueOf(mm.get("SL_36").toString()):0;
	 	}
	 	data1 = "{'baseid':'"+baseid[0]+"','name':'12个月以上','value':"+sl_12+",'ctdm':"+dm+",'bmdm':''},"+
	 			"{'baseid':'"+baseid[1]+"','name':'18个月以上','value':"+sl_18+",'ctdm':"+dm+",'bmdm':''},"+
	 			"{'baseid':'"+baseid[2]+"','name':'36个月以上','value':"+sl_36+",'ctdm':"+dm+",'bmdm':''}";
 %>
option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=mc+typemc %>案件分布(<%=sl_12 %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    xAxis : [{type : 'category',axisLabel: {rotate: 0 },data : ['12个月以上','18个月以上','36个月以上']}],
    legend: {
        data:['案件数'],
        x:'right'
    },
    grid:{'x':40,'x2':25,'y':55,'y2':30},
    yAxis : [{type : 'value'}],
    series : [
        {
            name:'案件数',
            type:'bar',
            barWidth:50,
            itemStyle: {
                normal: {
                	label : {show: true, position: 'inside'},
                    color: function(params) {
                        var colorList = [<%=JSUtils.COLOR_STR %> ];
                        return colorList[params.dataIndex]
                    }
                }
            },
            data:[<%=data1 %>]
        }
    ]
};
                    