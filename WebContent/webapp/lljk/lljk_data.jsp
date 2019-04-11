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
	 	
	 	JdbcTemplateExt dbc= WebAppContext.getBeanEx(JSUtils.BI09_JDBCTEMPLATE_EXT);	
		List<Map<String,Object>> fy_List = dbc.queryForList("SELECT substring(FJM,1,2) DM FROM DC_CITY where FJM like '"+JSUtils.fjm.substring(0,1)+"[0-9A-Z]' and datalength(FJM) = 2 ");
		JdbcTemplateExt xdbc= WebAppContext.getBeanEx(JSUtils.XDB_JDBCTEMPLATE_EXT);
	 	String sql = "SELECT SUBSTRING(FY,1,2) DM,COUNT(*) SL FROM TR_DD WHERE   DDSJ >= '"+StringUtils.formatDate(new Date(),"yyyyMMdd")
	 		+"' and XMLTYPE='ASS' and FY like '"+JSUtils.fjm.substring(0,1)+"%' GROUP BY SUBSTRING(FY,1,2)";
	 	List<Map<String, Object>> list = xdbc.queryForList(sql);
	 	Map<String,Object> dmap = new HashMap<String,Object>();
	 	if(list!=null){
	 		for(Map<String,Object> mm:list){
		 		dmap.put(mm.get("DM").toString(),mm.get("SL"));
			}
	 	}
	 	JSONObject jo = new JSONObject();
	 	for(int i=0;i<fy_List.size();i++){
			Map<String,Object> map = fy_List.get(i);
			jo.put(map.get("DM"),0);
			if(dmap.containsKey(map.get("DM"))){
				jo.put(map.get("DM"),dmap.get(map.get("DM")));
			}
		}
	 	String sql2 = "Select count(*) SL from TR_DD WHERE RKSJ >='"+StringUtils.formatDate(new Date(),"yyyyMMdd")+"' and XMLTYPE='ASS' and DDSJ >= '"+StringUtils.formatDate(new Date(),"yyyyMMdd")+"'";	
 		List<Map<String, Object>> list2 = xdbc.queryForList(sql2);
	 	if(list2!=null&&list2.size()>0){
	 		jo.put("RK",list2.get(0).get("SL"));
	 	}else{
	 		jo.put("RK",0);
	 	}
	 	//jo.put("time",StringUtils.formatDate(new Date(),"hh:mm"));
	 	out.print(jo);
 %>

                    
                    