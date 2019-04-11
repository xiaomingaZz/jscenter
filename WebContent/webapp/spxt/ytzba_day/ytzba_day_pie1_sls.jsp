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
	 	
	 	String [][]dx = new String[][]{
	 			{"1","院长","1000"},
	 			{"2","副院长","0100"},
	 			{"3","庭长","0010"},
	 			{"4","副庭长","0001"}
	 	};
	 	
	 	Map<String,String> zwMap = new HashMap<String,String>();
	 	for(String []arr : dx){
	 		zwMap.put(arr[0],arr[2]);
	 	}
	 	
	 	String name = "收案";
		String column = "";
		String columnWj = "";
		String where = " where ID_DAY >='"+kssj+"' AND ID_DAY <='"+maxjssj+"'  ";
		String whereWj = " where ID_DAY = '"+maxjssj+"'  ";
		String whereTj = " where ID_DAY >='"+kssj+"' AND ID_DAY <='"+jssj+"'  ";
		String baseid="";
		
		name = "受理";
		if("1111".equals(zw) || "0000".equals(zw)){
			column = "sum(SAS_1000) YZSA,sum(SAS_0100) FYZSA,sum(SAS_0010) TZSA,sum(SAS_0001) FTZSA, "
				+"sum(JAS_1000) YZJA,sum(JAS_0100) FYZJA,sum(JAS_0010) TZJA,sum(JAS_0001) FTZJA ";
			columnWj = "sum(WJS_1000) YZWJ,sum(WJS_0100) FYZWJ,sum(WJS_0010) TZWJ,sum(WJS_0001) FTZWJ ";
		}else{
			column = "";
			if("1".equals(zw.substring(0,1))){
				column += "sum(SAS_1000) YZSA,sum(JAS_1000) YZJA,";
				columnWj = "sum(WJS_1000) YZWJ,";
			}
			if("1".equals(zw.substring(1,2))){
				column += "sum(SAS_0100) FYZSA,sum(JAS_0100) FYZJA,";
				columnWj = "sum(WJS_0100) FYZWJ,";
			}
			if("1".equals(zw.substring(2,3))){
				column += "sum(SAS_0010) TZSA,sum(JAS_0010) TZJA,";
				columnWj = "sum(WJS_0010) TZWJ,";
			}
			if("1".equals(zw.substring(3,4))){
				column += "sum(SAS_0001) FTZSA,sum(JAS_0001) FTZJA,";
				columnWj = "sum(WJS_0001) FTZWJ,";
			}
			column = column.substring(0,column.length() - 1);
			columnWj = columnWj.substring(0,columnWj.length() - 1);
		}
		
		
		baseid = "JSYTZ0";
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	
		String sql = "select "+column+" from FACT_YTZBA_SAJA "
			+ where
			+" and ID_FYDM like '"+fjm+"%' ";
		String sqlWj = "select "+columnWj+" from FACT_YTZBA_WJ "
			+ whereWj
			+" and ID_FYDM like '"+fjm+"%' ";
		String sqlTj = "select "+column+" from FACT_YTZBA_SAJA "
		+ whereTj
		+" and ID_FYDM like '"+fjm+"%' ";
		System.out.println("ytzba day pie1 sls sql-->"+sql);
		System.out.println("ytzba day pie1 sls sqlWj-->"+sqlWj);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	List<Map<String,Object>> listWj = bi09.queryForList(sqlWj);
	 	String data1 ="";
	 	int total = 0;
	 	
	 	int yz = 0,fyz = 0,tz = 0, ftz = 0;
	 	int yzsa = 0,fyzsa = 0,tzsa = 0, ftzsa = 0;
	 	int yzja = 0,fyzja = 0,tzja = 0, ftzja = 0;
	 	int yzwj = 0,fyzwj = 0,tzwj = 0, ftzwj = 0;
	 	int yzsatj = 0,fyzsatj = 0,tzsatj = 0, ftzsatj = 0;
	 	if(list.size() > 0){
	 		Map<String,Object> m = list.get(0);
	 		yzsa = m.get("YZSA")==null?0:(Integer)m.get("YZSA");
	 		fyzsa = m.get("FYZSA")==null?0:(Integer)m.get("FYZSA");
	 		tzsa = m.get("TZSA")==null?0:(Integer)m.get("TZSA");
	 		ftzsa = m.get("FTZSA")==null?0:(Integer)m.get("FTZSA");
	 		
	 		yzja = m.get("YZJA")==null?0:(Integer)m.get("YZJA");
	 		fyzja = m.get("FYZJA")==null?0:(Integer)m.get("FYZJA");
	 		tzja = m.get("TZJA")==null?0:(Integer)m.get("TZJA");
	 		ftzja = m.get("FTZJA")==null?0:(Integer)m.get("FTZJA");
	 		
	 	}
	 	
	 	if(listWj.size() > 0){
	 		Map<String,Object> m = listWj.get(0);
	 		yzwj = m.get("YZWJ")==null?0:(Integer)m.get("YZWJ");
	 		fyzwj = m.get("FYZWJ")==null?0:(Integer)m.get("FYZWJ");
	 		tzwj = m.get("TZWJ")==null?0:(Integer)m.get("TZWJ");
	 		ftzwj = m.get("FTZWJ")==null?0:(Integer)m.get("FTZWJ");
	 	}
	 	
	 	if(jssj.equals(maxjssj)){
	 		yz = yzja + yzwj;
	 		fyz = fyzja + fyzwj;
	 		tz = tzja + tzwj;
	 		ftz = ftzja + ftzwj;
	 	}else{
	 		System.out.println("ytzba day pie1 sls sqlTj-->"+sqlTj);
	 		List<Map<String,Object>> listTj = bi09.queryForList(sqlTj);
	 		if(listTj.size() > 0){
		 		Map<String,Object> m = listTj.get(0);
		 		yzsatj = m.get("YZSA")==null?0:(Integer)m.get("YZSA");
		 		fyzsatj = m.get("FYZSA")==null?0:(Integer)m.get("FYZSA");
		 		tzsatj = m.get("TZSA")==null?0:(Integer)m.get("TZSA");
		 		ftzsatj = m.get("FTZSA")==null?0:(Integer)m.get("FTZSA");
		 	}
	 		
	 		yz = yzsatj + yzja + yzwj - yzsa;
	 		fyz = fyzsatj + fyzja + fyzwj - fyzsa;
	 		tz = tzsatj + tzja + tzwj - tzsa;
	 		ftz = ftzsatj + ftzja + ftzwj - ftzsa;
	 	}
	 	
	 	total = yz + fyz + tz + ftz;
 		data1 += "{'baseid':'"+baseid+"','name':'院长','value':"+yz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'1000_spzcbr'},";
 		data1 += "{'baseid':'"+baseid+"','name':'副院长','value':"+fyz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'0100_spzcbr'},";
 		data1 += "{'baseid':'"+baseid+"','name':'庭长','value':"+tz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'0010_spzcbr'},";
 		data1 += "{'baseid':'"+baseid+"','name':'副庭长','value':"+ftz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'0001_spzcbr'},";
	 	
 %>
option = {
     title : {show:true,x:'center',text: '<%=mc %><%=ytzname %><%=name %>情况(按职务)(<%=total %>)',
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
        data:["院长","副院长","庭长","副庭长"]
    },
    series : [
        {
            name:'案件数',
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
                    