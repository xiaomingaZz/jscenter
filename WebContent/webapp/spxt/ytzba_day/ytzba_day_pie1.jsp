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
		String where = " where ID_DAY >='"+kssj+"' AND ID_DAY <='"+jssj+"'  ";
		String baseid="";
		if("sas".equals(dl)){
			name = "收案";
			if("1111".equals(zw) || "0000".equals(zw)){
				column = "sum(SAS_1000) YZ,sum(SAS_0100) FYZ,sum(SAS_0010) TZ,sum(SAS_0001) FTZ ";
			}else{
				if("1".equals(zw.substring(0,1))){
					column += "sum(SAS_1000) YZ,";
				}
				if("1".equals(zw.substring(1,2))){
					column += "sum(SAS_0100) FYZ,";
				}
				if("1".equals(zw.substring(2,3))){
					column += "sum(SAS_0010) TZ,";
				}
				if("1".equals(zw.substring(3,4))){
					column += "sum(SAS_0001) FTZ,";
				}
				column = column.substring(0,column.length() - 1);
			}
			
			baseid = "JSYTZ1";
		}else if("jas".equals(dl)){
			name = "结案";
			if("1111".equals(zw) || "0000".equals(zw)){
				column = "sum(JAS_1000) YZ,sum(JAS_0100) FYZ,sum(JAS_0010) TZ,sum(JAS_0001) FTZ ";
			}else{
				if("1".equals(zw.substring(0,1))){
					column += "sum(JAS_1000) YZ,";
				}
				if("1".equals(zw.substring(1,2))){
					column += "sum(JAS_0100) FYZ,";
				}
				if("1".equals(zw.substring(2,3))){
					column += "sum(JAS_0010) TZ,";
				}
				if("1".equals(zw.substring(3,4))){
					column += "sum(JAS_0001) FTZ,";
				}
				column = column.substring(0,column.length() - 1);
			}
			
			baseid = "JSYTZ2";
		}
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 	
		String sql = "";
		sql = "select "+column+" from FACT_YTZBA_SAJA "
			+ where
			+" and ID_FYDM like '"+fjm+"%' ";
		
		System.out.println("ytzba pie1 sql-->"+sql);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String data1 ="";
	 	int total = 0;
	 	
	 	int yz = 0,fyz = 0,tz = 0, ftz = 0;
	 	if(list.size() > 0){
	 		Map<String,Object> m = list.get(0);
	 		yz = m.get("YZ")==null?0:(Integer)m.get("YZ");
	 		fyz = m.get("FYZ")==null?0:(Integer)m.get("FYZ");
	 		tz = m.get("TZ")==null?0:(Integer)m.get("TZ");
	 		ftz = m.get("FTZ")==null?0:(Integer)m.get("FTZ");
	 		
	 		total = yz + fyz + tz + ftz;
	 		data1 += "{'baseid':'"+baseid+"','name':'院长','value':"+yz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'1000_spzcbr'},";
	 		data1 += "{'baseid':'"+baseid+"','name':'副院长','value':"+fyz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'0100_spzcbr'},";
	 		data1 += "{'baseid':'"+baseid+"','name':'庭长','value':"+tz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'0010_spzcbr'},";
	 		data1 += "{'baseid':'"+baseid+"','name':'副庭长','value':"+ftz+",'dm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'0001_spzcbr'},";
	 	}
	 	
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
                    