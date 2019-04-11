<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String yhdm = StringUtils.trim(request.getParameter("yhdm"));
	String yhxm = StringUtils.trim(request.getParameter("yhxm"));
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	String xdata = "",data1 = "";
	int total = 0;
	for(int i = Integer.parseInt(nd) - 4;i <= Integer.parseInt(nd); i++){
		String []tjyf = CalendarUtil.getKssjJssjDay(String.valueOf(i));
		String kssj = tjyf[0];
		String jssj = tjyf[1];
		String sql = "select count(AHDM) NUM FROM ETL_CASE WHERE AJZT >='800' AND CBR = '"+yhdm+"' AND JARQ >='"+kssj+"' AND JARQ <='"+jssj+"' AND BCYSFTJ = '0' AND XTAJLX <>'15' ";
		System.out.println(sql);
		List<Map<String,Object>> list = bi09.queryForList(sql);
		for(Map<String,Object> map : list){
			int num = 0;
			if(map.get("NUM") != null){
				num = Integer.valueOf(map.get("NUM").toString());
			}
			total += num;
			xdata += ",'"+i+"'";
			data1 += ",{'baseid':'','name':'"+i+"','value':"+num+",'yhdm':'"+yhdm+"','kssj':'"+kssj+"','jssj':'"+jssj+"'}";
		}
	}
	String []tjyf = CalendarUtil.getKssjJssjDay(String.valueOf(Integer.parseInt(nd) - 4));
	String kssj = tjyf[0];
	tjyf = CalendarUtil.getKssjJssjDay(String.valueOf(Integer.parseInt(nd)));
	String jssj = tjyf[1];
	xdata += ",'办案总数'";
	data1 += ",{'baseid':'','name':'办案总数','value':"+total+",'yhdm':'"+yhdm+"','kssj':'"+kssj+"','jssj':'"+jssj+"'}";
	
	if(data1.startsWith(",")){
		xdata = xdata.substring(1);
		data1 = data1.substring(1);
	}
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=yhxm %>法官近5年办案情况(<%=total %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
	color:['#7D26CD','#FF7F50','#EE2C2C'],
	grid:{x:40,x2:30,y:50,y2:30},
    xAxis : [{type : 'category',axisLabel: {rotate: 0 },data : [<%=xdata %>]}],
    yAxis : [{name : '案件数',type : 'value'}],
    series : [
        {
            name:'案件数',
            type:'bar',
            barMaxWidth:40,
            itemStyle: {
                normal: {
                    color: function(params) {
                        // build a color map as your need.
                        var colorList = [
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
                    