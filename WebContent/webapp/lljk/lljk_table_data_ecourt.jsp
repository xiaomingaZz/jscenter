<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="tdh.framework.util.StringUtils"%>
<%@ page import="tdh.service.CourtService"%>

<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	String kssj = StringUtils.trim(request.getParameter("kssj"));
	 	String jssj = StringUtils.trim(request.getParameter("jssj"));
	 	
	 	JdbcTemplateExt dbc= WebAppContext.getBeanEx(JSUtils.BI09_JDBCTEMPLATE_EXT);	
		List<Map<String,Object>> fy_List = dbc.queryForList("SELECT substring(FJM,1,2) DM,NAME_CITY MC FROM DC_CITY where FJM like '"+JSUtils.fjm.substring(0,1)+"[0-9A-Z]' and datalength(FJM) = 2 ");
		
		CourtService cs = new CourtService();
	 	Map<String,Integer> dmap = new HashMap<String,Integer>();
	 	cs.getEcourtData(dmap,kssj,jssj);
	 	
	 	JSONObject jo = new JSONObject();
	 	for(int i=0;i<fy_List.size();i++){
			Map<String,Object> map = fy_List.get(i);
			//jo.put(map.get("DM"),0);
			//if(dmap.containsKey(map.get("DM"))){
				jo.put(map.get("DM")+"_ecourt",dmap.get(map.get("DM"))==null?0:dmap.get(map.get("DM")));
			//}
		}
	 	
		out.print(jo.toString());
 %>

                    
                    