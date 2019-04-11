<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.CalendarUtil"%>
<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	String nd = StringUtils.trim(request.getParameter("nd"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	String fjm = StringUtils.trim(request.getParameter("fjm"));
	 	String mc = StringUtils.trim(request.getParameter("mc"));
	 	String  cx = StringUtils.trim(request.getParameter("cx"));
		String  ajlx = StringUtils.trim(request.getParameter("lx"));
	 	
		if("".equals(mc)){
			mc = "全省";
		}
		
	 	String name = "收案";
	 	String cname = "案件类型";
	 	String column = "SUM(SAS)";
		if("".equals(cx)){
			if("".equals(ajlx)){
				column = " SUM(XSGPFHS)+SUM(Z_XS_GPFHS) XSGPFHS,SUM(MSGPFHS)+SUM(Z_MS_GPFHS) MSGPFHS,SUM(XZGPFHS)+SUM(Z_XZ_GPFHS) XZGPFHS ";
			}else if("xs".equals(ajlx)){
				column = " SUM(XSGPFHS)+SUM(Z_XS_GPFHS) XSGPFHS,0 MSGPFHS,0 XZGPFHS ";
				cname = "刑事";
			}else if("ms".equals(ajlx)){
				column = " 0 XSGPFHS,SUM(MSGPFHS)+SUM(Z_MS_GPFHS) MSGPFHS,0 XZGPFHS ";
				cname = "民事";
			}else if("xz".equals(ajlx)){
				column = " 0 XSGPFHS,0 MSGPFHS,SUM(XZGPFHS)+SUM(Z_XZ_GPFHS) XZGPFHS ";
				cname = "行政";
			}
		}else if("es".equals(cx)){
			cname = "二审";
			if("".equals(ajlx)){
				column = " SUM(XSGPFHS) XSGPFHS,SUM(MSGPFHS) MSGPFHS,SUM(XZGPFHS) XZGPFHS ";
			}else if("xs".equals(ajlx)){
				column = " SUM(XSGPFHS) XSGPFHS,0 MSGPFHS,0 XZGPFHS ";
				cname = "刑事二审";
			}else if("ms".equals(ajlx)){
				column = " 0 XSGPFHS,SUM(MSGPFHS) MSGPFHS,0 XZGPFHS ";
				cname = "民事二审";
			}else if("xz".equals(ajlx)){
				column = " 0 XSGPFHS,0 MSGPFHS,SUM(XZGPFHS) XZGPFHS ";
				cname = "行政二审";
			}
			
		}else if("zs".equals(cx)){
			cname = "再审";
			if("".equals(ajlx)){
				column = " SUM(Z_XS_GPFHS) XSGPFHS,SUM(Z_MS_GPFHS) MSGPFHS,SUM(Z_XZ_GPFHS) XZGPFHS ";
			}else if("xs".equals(ajlx)){
				column = " SUM(Z_XS_GPFHS) XSGPFHS,0 MSGPFHS,0 XZGPFHS ";
				cname = "刑事再审";
			}else if("ms".equals(ajlx)){
				column = " 0 XSGPFHS,SUM(Z_MS_GPFHS) MSGPFHS,0 XZGPFHS ";
				cname = "民事再审";
			}else if("xz".equals(ajlx)){
				column = " 0 XSGPFHS,0 MSGPFHS,SUM(Z_XZ_GPFHS) XZGPFHS ";
				cname = "行政再审";
			}
			
		}
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	String []tjyf = CalendarUtil.getKssjJssj(nd);
		String kssj = tjyf[0];
		String jssj = tjyf[1];
		String []tjyf2 = CalendarUtil.getKssjJssj(String.valueOf(Integer.parseInt(nd) - 1));
		String kssj2 = tjyf2[0];
		String jssj2 = tjyf2[1];
	 	
	 	String sql = "select "+column+" from FACT_GPFH_JSGY "
	 				+ " where ID_MTH >= '"+kssj+"' AND ID_MTH <= '"+jssj+"'  "
 					+ " and ID_FYDM like '"+fjm+"%' ";
	 	//System.out.println("sql pie2-->"+sql);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String data1 ="";
	 	int xsgpfhs = 0;
 		int msgpfhs = 0;
 		int xzgpfhs = 0;
 		int total = 0;
	 	if(list != null && list.size() > 0){
	 		Map<String,Object> map = list.get(0);
	 		
	 		if(map.get("XSGPFHS") != null){
	 			xsgpfhs = (Integer)map.get("XSGPFHS");
	 		}
	 		if(map.get("MSGPFHS") != null){
	 			msgpfhs = (Integer)map.get("MSGPFHS");
	 		}
	 		if(map.get("XZGPFHS") != null){
	 			xzgpfhs = (Integer)map.get("XZGPFHS");
	 		}
	 	}
	 	total += xsgpfhs+msgpfhs+xzgpfhs;
	 	data1 = data1 +"{'name':'"+"刑事"+"','value':"+xsgpfhs+"},";
	 	data1 = data1 +"{'name':'"+"民事"+"','value':"+msgpfhs+"},";
	 	data1 = data1 +"{'name':'"+"行政"+"','value':"+xzgpfhs+"},";
 %>
option = {
     title : {show:true,x:'center',text: '<%=mc %><%=cname %>被改判发回组成(<%=total %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    tooltip : {
    	show:true,
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient : 'vertical' ,
        x : 'left',
        y : 'center',
        data:["刑事","民事","行政"]
    },
    series : [
        {
            name:'被改判发回数',
            type:'pie',
            radius : [80,160],
            center: ['50%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=data1.substring(0,data1.length()-1) %>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    