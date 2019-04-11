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
	
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	fydm = "21";
	String kssj = "201601";
	String jssj = "201604";
	List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY like '"+fydm+"%' and isnull(SFJY,'0') <> '1' order by DM_CITY");
	
	Map<String,Integer> vmap = new HashMap<String,Integer>();
	String sql = "";
	sql = "SELECT ID_FYDM DM,SUM(SL) SL FROM FACT_SJZL WHERE "
	//	+" ID_MTH >= '"+kssj+"' AND ID_MTH <='"+jssj+"' "
		+"  ID_FYDM LIKE '"+fydm+"%' GROUP BY ID_FYDM";
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