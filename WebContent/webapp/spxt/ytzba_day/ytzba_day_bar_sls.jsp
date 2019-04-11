<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*,tdh.util.*" pageEncoding="UTF-8"%>

<%

/*
只算审理
*/

	String  kssj = StringUtils.trim(request.getParameter("kssj"));
	String  jssj = StringUtils.trim(request.getParameter("jssj"));
	String  maxjssj = StringUtils.trim(request.getParameter("maxjssj"));
	
	String  mc = StringUtils.trim(request.getParameter("mc"));
	String  dl = StringUtils.trim(request.getParameter("dl"));
	String  dm = StringUtils.trim(request.getParameter("dm"));
	String  fjm = StringUtils.trim(request.getParameter("fjm"));
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
	String column = "";
	String columnWj = "";
	String columnTj = "";
	String where = " where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+maxjssj+"' ";
	String whereTj = " where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+jssj+"' ";
	String baseid = "";
	
	String table = "FACT_YTZBA_SAJA";
	String table2 = "FACT_YTZBA_WJ";
	
	name = "受理";
	if(jssj.equals(maxjssj)){
		//统计的结束天就是统计的那一天，受理数就用：结案数+未结数
		column = "SUM(JAS_"+zw+") JAS ";
		columnWj = " SUM(CASE ID_DAY when '"+jssj+"' then WJS_"+zw+" else 0 end) WJS ";
	}else{
		//统计的结束天是统计天的提前天
		column = "SUM(JAS_"+zw+") JAS,SUM(SAS_"+zw+") SAS ";
		columnWj = " SUM(CASE ID_DAY when '"+maxjssj+"' then WJS_"+zw+" else 0 end) WJS ";
		columnTj = "SUM(SAS_"+zw+") SAS ";
		
	}
	
	baseid = "JSYTZ0";
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	List<Map<String,Object>> fylist ;
	String sql ="";
	String sqlWj = "";
	String sqlTj = "";
	String dxsql = "";
	String rsSql = "";
	if(dm.length() == 2){
		sql = "select substring(ID_FYDM,1,2) DM,"+column+" from  "+table
			+ where
			+ " group by substring(ID_FYDM,1,2)";
		sqlWj = "select substring(ID_FYDM,1,2) DM,"+columnWj+" from "+table2
		+ where
		+ " group by substring(ID_FYDM,1,2)";
		sqlTj = "select substring(ID_FYDM,1,2) DM,"+columnTj+" from "+table
		+ whereTj
		+ " group by substring(ID_FYDM,1,2)";
		dxsql = "select DM_CITY,FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 2 AND ISNULL(SFJY,'')<>'1' order by FJM asc ";
		rsSql = "SELECT substring(FJM,1,2) DM,COUNT(*) NUM FROM ETL_USER WHERE FLZW like '09_01050-[1234]' GROUP BY SUBSTRING(FJM,1,2) ";
	}else{
		if(dm.endsWith("00")){
			mc = "省院及中院";
			sql = "select substring(ID_FYDM,1,3) DM,"+column+" from "+table
				+ where 
				+" and ID_FYDM like '"+fjm.substring(0,1)+"_0%' group by substring(ID_FYDM,1,3)";
			sqlWj = "select substring(ID_FYDM,1,3) DM,"+columnWj+" from "+table2
			+ where 
			+" and ID_FYDM like '"+fjm.substring(0,1)+"_0%' group by substring(ID_FYDM,1,3)";
			sqlTj = "select substring(ID_FYDM,1,3) DM,"+columnTj+" from "+table
			+ whereTj
			+" and ID_FYDM like '"+fjm.substring(0,1)+"_0%' group by substring(ID_FYDM,1,3)";
			dxsql = "select DM_CITY,FJM DM,NAME_CITY from DC_CITY where FJM like  '"+fjm.substring(0,1)+"_0' AND ISNULL(SFJY,'')<>'1' order by FJM asc ";
			rsSql = "SELECT FJM DM,COUNT(*) NUM FROM ETL_USER WHERE FLZW like '09_01050-[1234]' AND FJM like  '"+fjm.substring(0,1)+"_0' AND ISNULL(SFJY,'')<>'1' GROUP BY FJM ";
		}else{
			sql = "select substring(ID_FYDM,1,3) DM,"+column+" from "+table
				+ where 
				+" and ID_FYDM like '"+fjm+"%' group by substring(ID_FYDM,1,3)";
			sqlWj = "select substring(ID_FYDM,1,3) DM,"+columnWj+" from "+table2
			+ where 
			+" and ID_FYDM like '"+fjm+"%' group by substring(ID_FYDM,1,3)";
			sqlTj = "select substring(ID_FYDM,1,3) DM,"+columnTj+" from "+table
			+ whereTj
			+" and ID_FYDM like '"+fjm+"%' group by substring(ID_FYDM,1,3)";
			dxsql = "select DM_CITY,FJM DM,NAME_CITY from DC_CITY where FJM like  '"+fjm+"%' AND FJM <> '"+fjm+"' AND ISNULL(SFJY,'')<>'1' order by FJM asc ";
			rsSql = "SELECT FJM DM,COUNT(*) NUM FROM ETL_USER WHERE FLZW like '09_01050-[1234]' AND FJM LIKE '"+fjm+"%' AND ISNULL(SFJY,'')<>'1' GROUP BY FJM ";
		}
		
	}
	
	fylist = bi09.queryForList(dxsql);
	Map<String,Integer> dataMap = new HashMap<String,Integer>();
	for(Map<String,Object> m : fylist){
		String dx = (String)m.get("DM");
		dataMap.put(dx,0);
	}
	
	List<Map<String,Object>> list_rs = bi09.queryForList(rsSql);
	Map<String,Integer> rsMap = new HashMap<String,Integer>();
	if(list_rs != null && list_rs.size() > 0){
		for(Map m : list_rs){
			rsMap.put((String)m.get("DM"),(Integer)m.get("NUM"));
		}
	}
	
	//System.out.println("ytzba bar dxsql-->"+dxsql);
	//System.out.println("ytzba bar sql-->"+sql);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	List<Map<String,Object>> listWj = bi09.queryForList(sqlWj);
	String xdata = "",data1 = "",data2="";
	int total = 0;
	
	//得到统计数据
	if(jssj.equals(maxjssj)){
		Map<String,Integer> jaMap = new HashMap<String,Integer>();
		Map<String,Integer> wjMap = new HashMap<String,Integer>();
		for(Map<String,Object> map : list){
			String dx = (String)map.get("DM");
			int num = 0;
			if(map.get("JAS") != null){
				num = (Integer)map.get("JAS");
			}
			jaMap.put(dx,num);
		}
		for(Map<String,Object> map : listWj){
			String dx = (String)map.get("DM");
			int num = 0;
			if(map.get("WJS") != null){
				num = (Integer)map.get("WJS");
			}
			wjMap.put(dx,num);
		}
		//得到受理数
		for(Map<String,Object> m : fylist){
			String dx = (String)m.get("DM");
			int jas = jaMap.get(dx)==null?0:jaMap.get(dx);
			int wjs = wjMap.get(dx)==null?0:wjMap.get(dx);
			dataMap.put(dx,jas+wjs);
		}
		
	}else{
		//首先得到SAS JAS WJS
		Map<String,Integer> saMap = new HashMap<String,Integer>();
		Map<String,Integer> jaMap = new HashMap<String,Integer>();
		Map<String,Integer> wjMap = new HashMap<String,Integer>();
		for(Map<String,Object> map : list){
			String dx = (String)map.get("DM");
			int sas = 0,jas=0;
			if(map.get("JAS") != null){
				jas = (Integer)map.get("JAS");
			}
			if(map.get("SAS") != null){
				sas = (Integer)map.get("SAS");
			}
			saMap.put(dx,sas);
			jaMap.put(dx,jas);
		}
		for(Map<String,Object> map : listWj){
			String dx = (String)map.get("DM");
			int num = 0;
			if(map.get("WJS") != null){
				num = (Integer)map.get("WJS");
			}
			wjMap.put(dx,num);
		}
		
		//可以得到起始时间的旧存数
		//再次统计要统计的区间的收案数
		System.out.println("ytzba day bar sls sqlTj-->"+sqlTj);
		Map<String,Integer> satjMap = new HashMap<String,Integer>();
		List<Map<String,Object>> listTj = bi09.queryForList(sqlTj);
		for(Map<String,Object> map : listTj){
			String dx = (String)map.get("DM");
			int num = 0;
			if(map.get("SAS") != null){
				num = (Integer)map.get("SAS");
			}
			satjMap.put(dx,num);
		}
		
		//收案+旧存=受理
		for(Map<String,Object> m : fylist){
			String dx = (String)m.get("DM");
			int jas = jaMap.get(dx)==null?0:jaMap.get(dx);
			int wjs = wjMap.get(dx)==null?0:wjMap.get(dx);
			int sas = saMap.get(dx)==null?0:saMap.get(dx);
			int satj = satjMap.get(dx)==null?0:satjMap.get(dx);
			dataMap.put(dx,jas+wjs-sas+satj);
		}
	}
	
	
	for(int i = 0 ; i < fylist.size() ; i++){
		Map<String,Object> mm = fylist.get(i);
		String dx = (String)mm.get("DM");
		int num =0;
		num = dataMap.get(dx);
		total += num;
		xdata = xdata+"'"+mm.get("NAME_CITY")+"',";
		data1 += "{'baseid':'"+baseid+"','name':'"+mm.get("NAME_CITY")+"','value':"+num+",'dm':'"+mm.get("DM_CITY")+"','kssj':'"+kssj+"','jssj':'"+jssj+"','zw':'"+zw+"_spzcbr'},";
		if(rsMap.get(dx) != null){
			data2 = data2 + StringUtils.formatDouble(num*1.0/rsMap.get(dx),"#0.00")+",";
		}else{
			data2 = data2 + "0.00,";
		}
		
	}
	
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=mc %><%=ytzname %>办案<%=name %>分布情况(<%=total %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
	color:['#FF7F50'],
	grid:{x:50,x2:40},
    xAxis : [{
	    	type : 'category',
	    	axisLabel: {rotate: 0 },
	    	data : [<%=xdata.substring(0,xdata.length()-1) %>]
    	}],
    yAxis : [{
    		type : 'value',
    		name : '件'
    	},{
    		name : '件/人',
            axisLabel : {
                formatter: '{value} '
            }
    	}],
    series : [
        {
            name:'<%=name %>',
            type:'bar',
            //设置柱形不同的颜色
            itemStyle: {
                normal: {
                    color: function(params) {
                        // build a color map as your need.
                        var colorList = [<%=JSUtils.COLOR_STR %>];
                        return colorList[params.dataIndex]
                    }
                }
            },
            data:[<%=data1.substring(0,data1.length()-1) %>]
        },{
        	name:'人均<%=name %>',
        	yAxisIndex: 1,
        	type:'line',
        	data:[<%=data2.substring(0,data2.length()-1) %>]
        }
    ]
};
                    