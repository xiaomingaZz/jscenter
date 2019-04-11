<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.system.TsFymc"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
	/**
	 *	数据交换监控
	 **/
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	//全省2位 市4位 单个法院 6位  
	String treeId = request.getParameter("treeid");
	String tjKsrq = request.getParameter("tjksrq");
	String tjJsrq = request.getParameter("tjjsrq");
	if("".equals(tjKsrq)||"null".equals(tjKsrq)){
		Date time = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		tjKsrq = sdf.format(time);
	}
	if("".equals(tjJsrq)||"null".equals(tjJsrq)){
		Date time = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		tjJsrq = sdf.format(time);
	}
	//统计新收
	String xsSql = "SELECT COUNT(1) AS CNT,FYDM FROM DB_TJ WHERE "
		+"AJZT>='300' AND FYDM LIKE '"+treeId+"%' "
		+"AND LARQ>='"+tjKsrq+"'"
		+"AND LARQ<='"+tjJsrq+"' "+
		"GROUP BY FYDM";
	//统计旧存
	String jcSql = "SELECT COUNT(1) AS CNT,FYDM FROM DB_TJ WHERE "
		+"AJZT>='300' AND FYDM LIKE '"+treeId+"%' "
		+"AND LARQ<'"+tjKsrq+"' AND(AJZT<'800' OR (AJZT >='800' && JARQ>'"+tjKsrq+"' ))"
		+"GROUP BY FYDM";
	//统计已结
	String yjSql = "SELECT COUNT(1) AS CNT,FYDM FROM DB_TJ WHERE "
		+"AJZT>='800' AND FYDM LIKE '"+treeId+"%' "
		+"AND JARQ>='"+tjKsrq+"' AND JARQ<='"+tjJsrq+"'"
		+"GROUP BY FYDM";
	//统计未结
	String wjSql = "SELECT COUNT(1) AS CNT,FYDM FROM DB_TJ WHERE "
		+"AJZT>='300' AND FYDM LIKE '"+treeId+"%' "
		+"AND LARQ<='"+tjJsrq+"' AND(AJZT<'800' OR (AJZT >='800' && JARQ>'"+tjJsrq+"' ))"
		+"GROUP BY FYDM";
	String type = request.getParameter("type");
	if("".equals(treeId)||"null".equals(treeId)){
		out.print("<script>");
		out.print("function(){alert('treeid:null');}");
		out.print("</script>");
		return;
	}
	JdbcTemplateExt xdbJdbc = WebAppContext.getBeanEx("xdbjdbcTemplateExt");
	List<Map<String,Object>> fyList = xdbJdbc.queryForList("SELECT FYDM,FYMC FROM TS_FYMC WHERE FYDM LIKE '"+treeId+"%' ORDER BY FYDM");
	if(fyList.size() == 0){
		return;
	}
	Map<String,Map<String,Object>> allFyMap = new HashMap<String,Map<String,Object>>();
	for(Map<String,Object> map : fyList){
		map.put("XS", 0);
		map.put("JC", 0);
		map.put("YJ", 0);
		map.put("WJ", 0);
		map.put("XS+JC", 0);
		map.put("YJ+WJ", 0);
		String fydm = (String)map.get("FYDM");
		allFyMap.put(fydm, map);
	}
	JdbcTemplateExt centerJdbc = WebAppContext.getBeanEx("centerjdbcTemplateExt");
	
	List<Map<String,Object>> xsList = centerJdbc.queryForList(xsSql);
	for(Map<String,Object> map : xsList){
		String fydm = (String)map.get("FYDM");
		int cnt = (Integer)map.get("CNT");
		Map<String,Object> fyMap = allFyMap.get(fydm);
		fyMap.put("XS",cnt);	
	}
	
	List<Map<String,Object>> jcList = centerJdbc.queryForList(jcSql);
	for(Map<String,Object> map : jcList){
		String fydm = (String)map.get("FYDM");
		int cnt = (Integer)map.get("CNT");
		Map<String,Object> fyMap = allFyMap.get(fydm);
		fyMap.put("JC",cnt);	
	}
	
	List<Map<String,Object>> yjList = centerJdbc.queryForList(yjSql);
	for(Map<String,Object> map : yjList){
		String fydm = (String)map.get("FYDM");
		int cnt = (Integer)map.get("CNT");
		Map<String,Object> fyMap = allFyMap.get(fydm);
		fyMap.put("YJ",cnt);	
	}
	
	List<Map<String,Object>> wjList = centerJdbc.queryForList(wjSql);
	for(Map<String,Object> map : wjList){
		String fydm = (String)map.get("FYDM");
		int cnt = (Integer)map.get("CNT");
		Map<String,Object> fyMap = allFyMap.get(fydm);
		fyMap.put("WJ",cnt);	
	}
	//法院数据整理 法院数据累加到市 省
	JdbcTemplateExt bi09Jdbc = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	List<Map<String,Object>> cityList = bi09Jdbc.queryForList("SELECT DM_CITY as FYDM,NAME_CITY as MC FROM DC_CITY "
			+"WHERE DM_CITY LIKE '"+treeId+"%' ORDER BY DM_CITY");
	for(Map<String,Object> map : cityList){
		map.put("XS", 0);
		map.put("JC", 0);
		map.put("YJ", 0);
		map.put("WJ", 0);
		map.put("XS+JC", 0);
		map.put("YJ+WJ", 0);
		String fydm = (String)map.get("FYDM");
		if(allFyMap.get(fydm) == null){
			allFyMap.put(fydm, map);
		}else{
			allFyMap.get(fydm).put("MC", map.get("MC"));
		}
	}
	
	for(String fydm : allFyMap.keySet()){
		if(fydm.length()<6){
			continue;
		}
		Map<String,Object> map = allFyMap.get(fydm);
		int xs = (Integer)map.get("XS");
		int jc = (Integer)map.get("JC");
		int yj = (Integer)map.get("YJ");
		int wj = (Integer)map.get("WJ");
		map.put("XS+JC", xs+jc);
		map.put("YJ+WJ", yj+wj);
		String zyFydm = fydm.substring(0, 4);
		if(allFyMap.get(zyFydm)!=null){
			Map<String,Object> fymap = allFyMap.get(zyFydm);
			fymap.put("XS", xs+(Integer)fymap.get("XS"));
			fymap.put("JC", jc+(Integer)fymap.get("JC"));
			fymap.put("YJ", yj+(Integer)fymap.get("YJ"));
			fymap.put("WJ", wj+(Integer)fymap.get("WJ"));
			fymap.put("XS+JC", xs+jc+(Integer)fymap.get("XS+JC"));
			fymap.put("YJ+WJ", yj+wj+(Integer)fymap.get("YJ+WJ"));
		}
		String gyFydm = fydm.substring(0, 2);
		if(allFyMap.get(gyFydm)!=null){
			Map<String,Object> gymap = allFyMap.get(gyFydm);
			gymap.put("XS", xs+(Integer)gymap.get("XS"));
			gymap.put("JC", jc+(Integer)gymap.get("JC"));
			gymap.put("YJ", yj+(Integer)gymap.get("YJ"));
			gymap.put("WJ", wj+(Integer)gymap.get("WJ"));
			gymap.put("XS+JC", xs+jc+(Integer)gymap.get("XS+JC"));
			gymap.put("YJ+WJ", yj+wj+(Integer)gymap.get("YJ+WJ"));
		}		
	}
	

	String fieldmc = "地区,法院名称,新收,旧存,已结,未结,新收+旧存,已结+未结";
	String field = "MC,FYMC,XS,JC,YJ,WJ,XS+JC,YJ+WJ";
	StringBuffer tb = new StringBuffer();
	tb.append("<table id='detail' width='100%' cellpadding='0' cellspacing='0' class='table-body' >");
	tb.append("<thead>");
	tb.append("<tr class='table-header table-header-row'>");
	tb.append("<th class='table-header-th table-cell-rownumber'></th>");
	String[] mcs = fieldmc.split(",");
	String[] fields = field.split(",");
	for(int i =0;i< mcs.length;i++){
		String fi = StringUtils.trim(fields[i]);
		if(fi.contains("MC")||fi.contains("FYMC")){
			tb.append("<th class='table-header-th' width='60'>"+mcs[i]+"</th>");
		}else if(fi.contains("XS+JC")||fi.contains("YJ_WJ")){
			tb.append("<th class='table-header-th' width='50'>"+mcs[i]+"</th>");
		}else{
			//tb.append("<th class='table-header-th'><input type='text' value='"+mcs[i]+"' readonly></th>");
			tb.append("<th class='table-header-th' width='40'>"+mcs[i]+"</th>");
		}
	}
	tb.append("</tr>");
	tb.append("</thead>");
	
	tb.append("<tbody>");
	int i = 0;
	for(Map<String,Object> map : cityList){
		String fydm = (String)map.get("FYDM");
		Map<String,Object> fyMap = allFyMap.get(fydm);
		i++;
		tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
		tb.append("<td class='table-cell-rownumber'>"+(i+1)+"</td>");
    	for(String key : fields){
    		if("FYMC".equals(key)&&fydm.length()<6){
    			tb.append("<td width='120' align='left' >&nbsp;</td>");
    		}else{
    			tb.append("<td width='120' align='left' >"+fyMap.get(key)+"</td>");
    		}
    		
    	}
    	tb.append("</tr>");
	}
	tb.append("</tbody>");
	tb.append("</table>");
	JSONObject json = new JSONObject();
    json.put("table", tb.toString());
    json.put("totalCounts",fyList.size() );
    json.put("totalPages",1 );
    json.put("cuPage",1 );
    out.print(json);
%>