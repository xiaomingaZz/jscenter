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
		String column = "";
		String columnWj = "";
		String where = " where ID_DAY >='"+kssj+"' AND ID_DAY <='"+maxjssj+"'  ";
		String whereWj = " where ID_DAY = '"+maxjssj+"'  ";
		String whereTj = " where ID_DAY >='"+kssj+"' AND ID_DAY <='"+jssj+"'  ";
		name = "受理";
		baseid = "JSYTZ0";
		column = "SUM(SAS_SPZ_"+zw+") SPZSA,SUM(SAS_CBR_"+zw+") CBRSA, "
			+"SUM(JAS_SPZ_"+zw+") SPZJA,SUM(JAS_CBR_"+zw+") CBRJA ";
		columnWj = "SUM(WJS_SPZ_"+zw+") SPZWJ,SUM(WJS_CBR_"+zw+") CBRWJ ";
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	
	 	String sql = "select "+column+" from FACT_YTZBA_SAJA "
	 				+ where 
 					+ " and ID_FYDM like '"+fjm+"%' ";
	 	String sqlWj = "select "+columnWj+" from FACT_YTZBA_WJ "
			+ whereWj
			+ " and ID_FYDM like '"+fjm+"%' ";
	 	String sqlTj = "select "+column+" from FACT_YTZBA_SAJA "
			+ whereTj
			+ " and ID_FYDM like '"+fjm+"%' ";
	 	System.out.println("ytzba day pie2 sls sql-->"+sql);
	 	System.out.println("ytzba day pie2 sls sqlWj-->"+sqlWj);
	 	System.out.println("ytzba day pie2 sls sqlTj-->"+sqlTj);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	List<Map<String,Object>> listWj = bi09.queryForList(sqlWj);
	 	String data1 ="";
	 	int spz = 0;
	 	int cbr = 0;
	 	
	 	int spzsa = 0,cbrsa=0;
	 	int spzja = 0,cbrja=0;
	 	int spzwj = 0,cbrwj=0;
	 	int spzsatj = 0,cbrsatj=0;
	 	int total = 0;
	 	if(list != null && list.size() > 0){
	 		if(list.get(0).get("SPZSA") != null){
	 			spzsa = (Integer)list.get(0).get("SPZSA");
	 		}
	 		if(list.get(0).get("CBRSA") != null){
	 			cbrsa = (Integer)list.get(0).get("CBRSA");
	 		}
	 		if(list.get(0).get("SPZJA") != null){
	 			spzja = (Integer)list.get(0).get("SPZJA");
	 		}
	 		if(list.get(0).get("CBRJA") != null){
	 			cbrja = (Integer)list.get(0).get("CBRJA");
	 		}
	 	}
	 	
	 	if(listWj != null && listWj.size() > 0){
	 		if(listWj.get(0).get("SPZWJ") != null){
	 			spzwj = (Integer)listWj.get(0).get("SPZWJ");
	 		}
	 		if(listWj.get(0).get("CBRWJ") != null){
	 			cbrwj = (Integer)listWj.get(0).get("CBRWJ");
	 		}
	 	}
	 	
	 	if(jssj.equals(maxjssj)){
	 		spz = spzja + spzwj;
	 		cbr = cbrja + cbrwj;
	 	}else{
	 		List<Map<String,Object>> listTj = bi09.queryForList(sqlTj);
	 		if(listTj != null && listTj.size() > 0){
		 		if(listTj.get(0).get("SPZSA") != null){
		 			spzsatj = (Integer)listTj.get(0).get("SPZSA");
		 		}
		 		if(listTj.get(0).get("CBRSA") != null){
		 			cbrsatj = (Integer)listTj.get(0).get("CBRSA");
		 		}
	 		}
	 		
	 		spz = spzja + spzwj - spzsa + spzsatj;
	 		cbr = cbrja + cbrwj - cbrsa + cbrsatj;
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
                    