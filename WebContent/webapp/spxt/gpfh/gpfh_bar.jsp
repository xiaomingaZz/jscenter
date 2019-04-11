<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.CalendarUtil"%>
<%
	String  nd = StringUtils.trim(request.getParameter("nd"));
	String  mc = StringUtils.trim(request.getParameter("mc"));
	String  dm = StringUtils.trim(request.getParameter("dm"));
	String  fjm = StringUtils.trim(request.getParameter("fjm"));
	String  cx = StringUtils.trim(request.getParameter("cx"));
	String  ajlx = StringUtils.trim(request.getParameter("lx"));
	
	if("".equals(mc)){
		mc = "全省";
	}
	
	String name = "";
	String column = "SUM(SAS)";
	String xtajlx = "";
	if("".equals(cx)){
		if("".equals(ajlx)){
			column = " SUM(GPS)+SUM(Z_GPS) GPS,SUM(FHS)+SUM(Z_FHS) FHS,SUM(JAS)+SUM(Z_JAS) JAS ";
			xtajlx = "[1-3][2-3]";
		}else if("xs".equals(ajlx)){
			name = "刑事";
			column = " SUM(XSGPS)+SUM(Z_XS_GPS) GPS,SUM(XSFHS)+SUM(Z_XS_FHS) FHS,SUM(XSJAS)+SUM(Z_XS_JAS) JAS ";
			xtajlx = "1[2-3]";
		}else if("ms".equals(ajlx)){
			name = "民事";
			column = " SUM(MSGPS)+SUM(Z_MS_GPS) GPS,SUM(MSFHS)+SUM(Z_MS_FHS) FHS,SUM(MSJAS)+SUM(Z_MS_JAS) JAS  ";
			xtajlx = "2[2-3]";
		}else if("xz".equals(ajlx)){
			name = "行政";
			column = " SUM(XZGPS)+SUM(Z_XZ_GPS) GPS,SUM(XZFHS)+SUM(Z_XZ_FHS) FHS,SUM(XZJAS)+SUM(Z_XZ_JAS) JAS  ";
			xtajlx = "3[2-3]";
		}
	}else if("es".equals(cx)){
		name = "二审";
		if("".equals(ajlx)){
			column = " SUM(GPS) GPS,SUM(FHS) FHS,SUM(JAS) JAS ";
			xtajlx = "[1-3]2";
		}else if("xs".equals(ajlx)){
			name = "刑事二审";
			xtajlx = "12";
			column = " SUM(XSGPS) GPS,SUM(XSFHS) FHS,SUM(XSJAS) JAS ";
		}else if("ms".equals(ajlx)){
			name = "民事二审";
			xtajlx = "22";
			column = " SUM(MSGPS) GPS,SUM(MSFHS) FHS,SUM(MSJAS) JAS ";
		}else if("xz".equals(ajlx)){
			name = "行政二审";
			xtajlx = "32";
			column = " SUM(XZGPS) GPS,SUM(XZFHS) FHS,SUM(XZJAS) JAS ";
		}
	}else if("zs".equals(cx)){
		name = "再审";
		if("".equals(ajlx)){
			column = " SUM(Z_GPS) GPS,SUM(Z_FHS) FHS,SUM(Z_JAS) JAS ";
			xtajlx = "[1-3]3";
		}else if("xs".equals(ajlx)){
			name = "刑事再审";
			xtajlx = "13";
			column = " SUM(Z_XS_GPS) GPS,SUM(Z_XS_FHS) FHS,SUM(Z_XS_JAS) JAS ";
		}else if("ms".equals(ajlx)){
			name = "民事再审";
			xtajlx = "23";
			column = " SUM(Z_MS_GPS) GPS,SUM(Z_MS_FHS) FHS,SUM(Z_MS_JAS) JAS ";
		}else if("xz".equals(ajlx)){
			name = "行政再审";
			xtajlx = "33";
			column = " SUM(Z_XZ_GPS) GPS,SUM(Z_XZ_FHS) FHS,SUM(Z_XZ_JAS) JAS ";
		}
	}
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	String []tjyf = CalendarUtil.getKssjJssj(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	String []tjyf2 = CalendarUtil.getKssjJssj(String.valueOf(Integer.parseInt(nd) - 1));
	String kssj2 = tjyf2[0];
	String jssj2 = tjyf2[1];

	List<Map<String,Object>> fylist ;
	String sql ="";
	if(dm.length() == 2){
		sql = "select substring(ID_FYDM,1,2) FYDM,"+column+" from FACT_GPFH_JSGY where "
			+ " ID_MTH >= '"+kssj+"' AND ID_MTH <= '"+jssj+"' group by substring(ID_FYDM,1,2)";
		fylist = bi09.queryForList("select DM_CITY,FJM DM ,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 2 AND ISNULL(SFJY,'')<>'1' order by FJM asc ");
	}else{
		if(dm.endsWith("00")){
			mc = "省院及中院";
			sql = "select substring(ID_FYDM,1,3) FYDM,"+column+" from FACT_GPFH_JSGY where ID_MTH >= '"+kssj+"' AND ID_MTH <= '"+jssj+"' "
			  +"and ID_FYDM like '"+fjm.substring(0,1)+"_0%' group by substring(ID_FYDM,1,3)";
			fylist = bi09.queryForList("select DM_CITY,FJM DM ,NAME_CITY from DC_CITY where FJM like  '"+fjm.substring(0,1)+"_0' AND ISNULL(SFJY,'')<>'1' order by DM_CITY asc ");
		}else{
			sql = "select substring(ID_FYDM,1,3) FYDM,"+column+" from FACT_GPFH_JSGY where ID_MTH >= '"+kssj+"' AND ID_MTH <= '"+jssj+"' "
			  +"and ID_FYDM like '"+fjm+"%' group by substring(ID_FYDM,1,3)";
			fylist = bi09.queryForList("select DM_CITY ,FJM DM ,NAME_CITY from DC_CITY where FJM like  '"+fjm+"%' AND FJM <> '"+fjm+"' AND ISNULL(SFJY,'')<>'1' order by DM_CITY asc ");
		}
		
	}
	//System.out.println("gpfh bar sql-->"+sql);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String xdata = "",data1 = "",data2="",data3="";
	int total1 = 0,total2 = 0;
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> mm = fylist.get(i);
		int gps =0 ,fhs =0,jas = 0;
		String ctmc = mm.get("NAME_CITY").toString();
		String ctdm = mm.get("DM_CITY").toString();
		
		for(Map<String,Object> map:list){
			if(map.get("FYDM").equals(mm.get("DM"))){
				if(map.get("GPS") != null){
					gps = Integer.valueOf(map.get("GPS").toString());
				}
				if(map.get("FHS") != null){
					fhs = Integer.valueOf(map.get("FHS").toString());
				}
				if(map.get("JAS") != null){
					jas = Integer.valueOf(map.get("JAS").toString());
				}
				break;
			}
		}
		total1 += gps;
		total2 += fhs;
		xdata = xdata+"'"+mm.get("NAME_CITY")+"',";
		//data1 = data1+gps+",";
		//data2 = data2+fhs+",";
		data1 += "{'baseid':'JS0010','name':'"+ctmc+"','value':"+gps+",'dm':'"+ctdm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','ajlx':'"+xtajlx+"'},";
		data2 += "{'baseid':'JS0011','name':'"+ctmc+"','value':"+fhs+",'dm':'"+ctdm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','ajlx':'"+xtajlx+"'},";
		if(jas > 0){
			data3 = data3+StringUtils.formatDouble((gps+fhs)*1.0/jas*100,"#0.00")+",";
		}else{
			data3 = data3+"0,";
		}
		
	}
	
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=mc %><%=name %>案件被改判发回重审情况(被改判:<%=total1 %>;被发回:<%=total2 %>)',
    subtext: '改判发回率：(被改判数+被发回数)/被收案数*100',
    subtextStyle:{
    	color:'blue',
    	align:'right',
    	baseline:'bottom'
    },
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    xAxis : [{type : 'category',axisLabel: {rotate: 0 },data : [<%=xdata.substring(0,xdata.length()-1) %>]}],
    legend: {
        data:['被改判数','被发回数','改判发回率'],
        x:'right'
    },
    color:['#FF7F50','#54FF9F'],
	grid:{x:50,x2:40},
    yAxis : [{
    		type : 'value',
    		name : '件'
    	},{
    		name : '改判发回率%',
            axisLabel : {
                formatter: '{value} '
            }
    	}
    ],
    series : [
        {
            name:'被改判数',
            type:'bar',
            data:[<%=data1.substring(0,data1.length()-1) %>]
        },{
            name:'被发回数',
            type:'bar',
            data:[<%=data2.substring(0,data2.length()-1) %>]
        },{
        	name:'改判发回率',
        	yAxisIndex: 1,
        	type:'line',
        	data:[<%=data3.substring(0,data3.length()-1) %>]
        }
    ]
};
                    