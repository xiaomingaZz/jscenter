<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	
	String  mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String type = StringUtils.trim(request.getParameter("type"));
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	List<Map<String,Object>> fylist ;
	String sql = "";
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
	int rotate = 0;
	boolean bm = false;
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		sql = "select substring(FYDM,1,4) DM,SUM(CASE WHEN dateadd(month,12,LARQ) < getdate() THEN 1 ELSE 0 END) SL_12,"+
			"SUM(CASE WHEN dateadd(month,18,LARQ)<getdate() THEN 1 ELSE 0 END) SL_18,SUM(CASE WHEN dateadd(month,36,LARQ)<getdate() THEN 1 ELSE 0 END) SL_36 "+
			"from ETL_CASE_CCQ where isnull(LARQ,'')>'' and "+cond+" and FYDM like '32%' group by substring(FYDM,1,4)";
		fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DATALENGTH(DM_CITY) = 4 AND isnull(SFJY,'')<>'1' order by DM_CITY asc ");
		mc = "全省";
	}else if(dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
		bm = true;
		sql = "select isnull(CBBM1,'') DM,SUM(CASE WHEN dateadd(month,12,LARQ) < getdate() THEN 1 ELSE 0 END) SL_12,"+
		"SUM(CASE WHEN dateadd(month,18,LARQ)<getdate() THEN 1 ELSE 0 END) SL_18,SUM(CASE WHEN dateadd(month,36,LARQ)<getdate() THEN 1 ELSE 0 END) SL_36 "+
		"from ETL_CASE_CCQ where isnull(LARQ,'')>'' and "+cond+" and FYDM like '"+dm+"%' group by isnull(CBBM1,'')";
		fylist = bi09.queryForList("select BMDM DM ,BMMC MC from ETL_DEPART where DWDM like '"+dm+"%' AND isnull(SFJY,'')<>'1' order by BMDM asc ");
		rotate = 10;
	}else{
		if(dm.length()==6){
			dm = dm.substring(0,4);
		}
		fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
		sql = "select FYDM DM,SUM(CASE WHEN dateadd(month,12,LARQ)<getdate() THEN 1 ELSE 0 END) SL_12,"+
			"SUM(CASE WHEN dateadd(month,18,LARQ)<getdate() THEN 1 ELSE 0 END) SL_18,SUM(CASE WHEN dateadd(month,36,LARQ)<getdate() THEN 1 ELSE 0 END) SL_36 "+
			"from ETL_CASE_CCQ where isnull(LARQ,'')>'' and "+cond+" and FYDM like '"+dm+"%' group by FYDM";
		fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DATALENGTH(DM_CITY) = 6 and DM_CITY like '"+dm+"%' AND isnull(SFJY,'')<>'1' order by DM_CITY asc ");
	}
	
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String xdata = "";
	String value0 = "",value1 = "",value2 = "",value3 = "";
	int tsl =0 ;
	
	if(bm){
		Map<String,Map<String,Integer>> rep = new HashMap<String,Map<String,Integer>>();
		for(Map<String,Object> map:list){
			int sl_12 = map.get("SL_12")!=null?Integer.valueOf(map.get("SL_12").toString()):0;
			int sl_18 = map.get("SL_18")!=null?Integer.valueOf(map.get("SL_18").toString()):0;
			int sl_36 = map.get("SL_36")!=null?Integer.valueOf(map.get("SL_36").toString()):0;
			Map<String,Integer> mm = new HashMap<String,Integer>();
			mm.put("SL_12",sl_12);mm.put("SL_18",sl_18);mm.put("SL_36",sl_36);
			rep.put(StringUtils.trim(map.get("DM")),mm);
		}
		Map<String,Object> map = new HashMap<String,Object>();
		for(Map<String,Object> mm:fylist){
			map.put(mm.get("DM").toString(),mm.get("MC"));
		}
		
		Iterator<Map.Entry<String,Map<String,Integer>>> it = rep.entrySet().iterator();
		int o_sl_12 = 0,o_sl_18=0,o_sl_36=0;
		while(it.hasNext()){
			Map.Entry<String,Map<String,Integer>> en = it.next();
			String ctdm = en.getKey();
			Map<String,Integer> mm = en.getValue();
			String ctmc = StringUtils.trim(map.get(ctdm));
			if(ctmc==null||ctmc.equals("")){
				ctmc = ctdm;
				if(ctdm.equals("")){
					o_sl_12=mm.get("SL_12");
					o_sl_18=mm.get("SL_18");
					o_sl_36=mm.get("SL_36");
					continue;
				}
			}
			int sl_12=mm.get("SL_12");
			int sl_18=mm.get("SL_18");
			int sl_36=mm.get("SL_36");
			xdata += "'"+ctmc+"',";
			value1 += "{'baseid':'"+baseid[0]+"','name':'"+ctmc+"','value':"+sl_12+",'ctdm':'"+dm+"','bmdm':'"+ctdm+"'},";
			value2 += "{'baseid':'"+baseid[1]+"','name':'"+ctmc+"','value':"+sl_18+",'ctdm':'"+dm+"','bmdm':'"+ctdm+"'},";
			value3 += "{'baseid':'"+baseid[2]+"','name':'"+ctmc+"','value':"+sl_36+",'ctdm':'"+dm+"','bmdm':'"+ctdm+"'},";
			tsl +=sl_12;
		}
		if(o_sl_12!=0||o_sl_18!=0||o_sl_36!=0){
			xdata += "'其他部门'";
			value1 += "{'baseid':'"+baseid[0]+"','name':'其他部门','value':"+o_sl_12+",'ctdm':'"+dm+"','bmdm':'null'}";
			value2 += "{'baseid':'"+baseid[1]+"','name':'其他部门','value':"+o_sl_18+",'ctdm':'"+dm+"','bmdm':'null'}";
			value3 += "{'baseid':'"+baseid[2]+"','name':'其他部门','value':"+o_sl_36+",'ctdm':'"+dm+"','bmdm':'null'}";
		}
	}else{
		for(int i=0;i<fylist.size();i++){
			Map<String,Object> mm = fylist.get(i);
			int sl_12=0,sl_18=0,sl_36=0;
			String ctmc = StringUtils.trim(mm.get("MC"));
			String ctdm = StringUtils.trim(mm.get("DM"));
			for(Map<String,Object> map:list){
				if(map.get("DM").equals(ctdm)){
					sl_12 = map.get("SL_12")!=null?Integer.valueOf(map.get("SL_12").toString()):0;
					sl_18 = map.get("SL_18")!=null?Integer.valueOf(map.get("SL_18").toString()):0;
					sl_36 = map.get("SL_36")!=null?Integer.valueOf(map.get("SL_36").toString()):0;
					break;
				}
			}
			tsl +=sl_12;
			xdata += "'"+ctmc+"',";
			value1 += "{'baseid':'"+baseid[0]+"','name':'"+ctmc+"','value':"+sl_12+",'ctdm':'"+ctdm+"','bmdm':''},";
			value2 += "{'baseid':'"+baseid[1]+"','name':'"+ctmc+"','value':"+sl_18+",'ctdm':'"+ctdm+"','bmdm':''},";
			value3 += "{'baseid':'"+baseid[2]+"','name':'"+ctmc+"','value':"+sl_36+",'ctdm':'"+ctdm+"','bmdm':''},";
		}
	}
	
	if(xdata.endsWith(",")){
		xdata=xdata.substring(0,xdata.length()-1);
		value1=value1.substring(0,value1.length()-1);
		value2=value2.substring(0,value2.length()-1);
		value3=value3.substring(0,value3.length()-1);
	}
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=mc+typemc %>案件分布(<%=tsl %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    xAxis : [{type : 'category',axisLabel: {rotate: <%=rotate %> },data : [<%=xdata%>]}],
    legend: {data:[{name:'12个月以上'},{'name':'18个月以上'},{name:'36个月以上'}], x:'right'},
    grid:{'x':40,'x2':25,'y':55,'y2':40},
    color:['#FF7F50','#da70d6','#32cd32'],
    yAxis : [{type : 'value'}],
    series : [{name:'12个月以上',type:'bar',data:[<%=value1%>]},
    		  {name:'18个月以上',type:'bar',data:[<%=value2%>]},
    		  {name:'36个月以上',type:'bar',data:[<%=value3%>]}]
};
                    