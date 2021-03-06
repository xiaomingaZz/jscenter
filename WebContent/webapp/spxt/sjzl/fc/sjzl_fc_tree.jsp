<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	JdbcTemplateExt export = WebAppContext.getBeanEx("exportjdbcTemplateExt");
	
	String kssj = StringUtils.trim(request.getParameter("kssj"));
	String jssj = StringUtils.trim(request.getParameter("jssj"));
	String gz = StringUtils.trim(request.getParameter("gz"));
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY like '"+fydm+"%' and isnull(SFJY,'0') <> '1' order by DM_CITY");
	
	
	
	
	Map<String,Integer> vmap = new HashMap<String,Integer>();
	String sql = "SELECT FYDM DM,COUNT(*) SL FROM XML_LJJYLOG WHERE ";
	
	sql += " FYDM like '"+fydm+"%' and BH LIKE '%"+gz+"%' "
			
		//	+" AND (SUBSTRING(LARQ,1,6) >='"+kssj+"' and SUBSTRING(LARQ,1,6) <= '"+jssj+"') "
			+  " GROUP BY FYDM";
	
	System.out.println("fc tree sql-->"+sql);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	for(Map<String,Object> mm:list){
		String dm = mm.get("DM").toString();
		int sl = mm.get("SL")==null?0:Integer.valueOf(mm.get("SL").toString());
		vmap.put(dm,sl);
		if(vmap.containsKey(dm.substring(0,4))){
			vmap.put(dm.substring(0,4),sl+vmap.get(dm.substring(0,4)));
		}else{
			vmap.put(dm.substring(0,4),sl);
		}
		if(vmap.containsKey(dm.substring(0,2))){
			vmap.put(dm.substring(0,2),sl+vmap.get(dm.substring(0,2)));
		}else{
			vmap.put(dm.substring(0,2),sl);
		}
	}
			
	JSONArray ja = new JSONArray();
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> mm = fylist.get(i);
		String dm = mm.get("DM").toString();
		String mc = mm.get("MC").toString();
		int sl = vmap.containsKey(dm)?vmap.get(dm):0;
		JSONObject jo = new JSONObject();
		jo.put("id", dm);
		if(dm.endsWith("0000")){
			jo.put("pId",dm.substring(0,dm.length()-4));
		}else{
			jo.put("pId",dm.substring(0,dm.length()-2));
		}
		jo.put("name",mc+"("+sl+")");
		ja.add(jo);
	}
	out.print(ja);
%>