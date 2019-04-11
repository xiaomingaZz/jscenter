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
	 	
	 	String  kssj = StringUtils.trim(request.getParameter("kssj"));
		String  jssj = StringUtils.trim(request.getParameter("jssj"));
		String  maxjssj = StringUtils.trim(request.getParameter("maxjssj"));
		
	 	String mc = StringUtils.trim(request.getParameter("mc"));
	 	String dl = StringUtils.trim(request.getParameter("dl"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	String fjm = StringUtils.trim(request.getParameter("fjm"));
	 	
	 	String  zw = StringUtils.trim(request.getParameter("zw"));
		if("".equals(mc)){
			mc = "全省";
		}
		
		String ytzname = "";
		if(!"1111".equals(zw) && !"0000".equals(zw)){
			if("1".equals(zw.substring(0,1))){
				ytzname += "院长";
			}
			if("1".equals(zw.substring(1,2))){
				if(ytzname.length() > 0){
					ytzname += "、";
				}
				ytzname += "副院长";
			}
			if("1".equals(zw.substring(2,3))){
				if(ytzname.length() > 0){
					ytzname += "、";
				}
				ytzname += "庭长";
			}
			if("1".equals(zw.substring(3,4))){
				if(ytzname.length() > 0){
					ytzname += "、";
				}
				ytzname += "副庭长";
			}
			
		}else{
			ytzname = "院庭长";
			zw = "1111";
		}
	 	
	 	String name = "收案";
	 	String baseid = "";
		String column = "SUM(SAS_SPZ_"+zw+") SPZ,SUM(SAS_CBR_"+zw+") CBR ";
		String where = " where ID_DAY >='"+kssj+"' AND ID_DAY <='"+jssj+"'  ";
		if("sas".equals(dl)){
			name = "收案";
			baseid = "JSYTZ1";
			column = "SUM(SAS_SPZ_"+zw+") SPZ,SUM(SAS_CBR_"+zw+") CBR ";
		}else if("jas".equals(dl)){
			name = "结案";
			baseid = "JSYTZ2";
			column = "SUM(JAS_SPZ_"+zw+") SPZ,SUM(JAS_CBR_"+zw+") CBR ";
		}
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	
	 	String sql = "select "+column+" from FACT_YTZBA_SAJA "
	 				+ where 
 					+ " and ID_FYDM like '"+fjm+"%' ";
	 	System.out.println("ytzba day pie2 sql-->"+sql);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String data1 ="";
	 	int spz = 0;
	 	int cbr = 0;
	 	int total = 0;
	 	if(list != null && list.size() > 0){
	 		if(list.get(0).get("SPZ") != null){
	 			spz = (Integer)list.get(0).get("SPZ");
	 		}
	 		if(list.get(0).get("CBR") != null){
	 			cbr = (Integer)list.get(0).get("CBR");
	 		}
	 	}
	 	data1 = data1 +"{'baseid':'"+baseid+"','name':'"+"审判长"+"','value':"+spz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'"+zw+"_spz'},";
	 	data1 = data1 +"{'baseid':'"+baseid+"','name':'"+"承办人"+"','value':"+cbr+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'"+zw+"_cbr'},";
	 	total = total + spz + cbr;
 %>
option = {
     title : {show:true,x:'center',text: '<%=mc %><%=ytzname %><%=name %>情况(按合议庭角色)(<%=total %>)',
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
        data:["审判长","承办人"]
    },
    series : [
        {
            name:'收案数',
            type:'pie',
            radius : [80,160],
            center: ['50%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=data1%>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    