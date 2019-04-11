<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="tdh.framework.util.StringUtils"%>

<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	String kssj = StringUtils.trim(request.getParameter("kssj"));
	 	String jssj = StringUtils.trim(request.getParameter("jssj"));
	 	
	 	JdbcTemplateExt dbc= WebAppContext.getBeanEx(JSUtils.BI09_JDBCTEMPLATE_EXT);	
		List<Map<String,Object>> fy_List = dbc.queryForList("SELECT substring(FJM,1,2) DM,NAME_CITY MC FROM DC_CITY where FJM like '"+JSUtils.fjm.substring(0,1)+"[0-9A-Z]' and datalength(FJM) = 2 ");
		JdbcTemplateExt xdbc= WebAppContext.getBeanEx(JSUtils.XDB_JDBCTEMPLATE_EXT);
	 	String sql = "SELECT SUBSTRING(FY,1,2) DM,COUNT(*) SL FROM TR_DD WHERE "
	 		+"  DDSJ >= '"+kssj+" 00:00:00' AND DDSJ <= '"+jssj+" 23:59:59' "
	 		+" and XMLTYPE='ASS' AND (ZT = '3' OR ZT = '4' AND (SBYY LIKE '规则%' OR SBYY LIKE '采用的结案案由未在%')) and FY like '"+JSUtils.fjm.substring(0,1)+"%' GROUP BY SUBSTRING(FY,1,2)";
	 	System.out.println("rk sql-->"+sql);
		List<Map<String, Object>> list = xdbc.queryForList(sql);
		//System.out.println("rk list size-->-->"+list.size());
	 	Map<String,Object> dmap = new HashMap<String,Object>();
	 	if(list!=null){
	 		for(Map<String,Object> mm:list){
		 		dmap.put(mm.get("DM").toString(),mm.get("SL"));
			}
	 	}
	 	
	 	sql = "SELECT SUBSTRING(FY,1,2) DM,COUNT(*) SL FROM TR_DD WHERE   DDSJ >= '"+StringUtils.formatDate(new Date(),"yyyyMMdd")
 			+"' and XMLTYPE='ASS' AND (ZT = '4' AND (SBYY NOT LIKE '规则%' AND SBYY NOT LIKE '采用的结案案由未在%')) and FY like '"+JSUtils.fjm.substring(0,1)+"%' GROUP BY SUBSTRING(FY,1,2)";
 		//System.out.println("rk sql-->"+sql);
		List<Map<String, Object>> list2 = xdbc.queryForList(sql);
		//System.out.println("rk list size-->-->"+list.size());
 		Map<String,Object> dmap2 = new HashMap<String,Object>();
 		if(list2 != null){
	 		for(Map<String,Object> mm:list2){
		 		dmap2.put(mm.get("DM").toString(),mm.get("SL"));
			}
 		}
 		
 		//等待入库
 		sql = "SELECT SUBSTRING(FY,1,2) DM,COUNT(*) SL FROM TR_DD WHERE   DDSJ >= '"+StringUtils.formatDate(new Date(),"yyyyMMdd")
			+"' and XMLTYPE='ASS' AND (ZT = '1' OR ZT = '2') and FY like '"+JSUtils.fjm.substring(0,1)+"%' GROUP BY SUBSTRING(FY,1,2)";
		//System.out.println("rk sql-->"+sql);
		List<Map<String, Object>> list3 = xdbc.queryForList(sql);
		//System.out.println("rk list size-->-->"+list.size());
		Map<String,Object> dmap3 = new HashMap<String,Object>();
		if(list3 != null){
	 		for(Map<String,Object> mm:list3){
		 		dmap3.put(mm.get("DM").toString(),mm.get("SL"));
			}
		}
 	
	 	JSONObject jo = new JSONObject();
	 	for(int i=0;i<fy_List.size();i++){
			Map<String,Object> map = fy_List.get(i);
			//jo.put(map.get("DM")+"_trdd",0);
			//if(dmap.containsKey(map.get("DM"))){
				jo.put(map.get("DM")+"_rk",dmap.get(map.get("DM"))==null?0:dmap.get(map.get("DM")));
				jo.put(map.get("DM")+"_rk_sb",dmap2.get(map.get("DM"))==null?0:dmap2.get(map.get("DM")));
				jo.put(map.get("DM")+"_rk_wait",dmap3.get(map.get("DM"))==null?0:dmap3.get(map.get("DM")));
			//}
		}
	 	
		out.print(jo.toString());
 %>

                    
                    