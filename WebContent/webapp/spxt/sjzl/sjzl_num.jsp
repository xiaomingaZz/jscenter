<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="tdh.util.JSUtils"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
	/**
	 *	数据质量情况
	 **/
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	
	String start=StringUtils.trim(request.getParameter("start"));
	String limit = StringUtils.trim(request.getParameter("limit"));
	
	String sql = "";
	sql = "SELECT ID_FYDM FYDM,XSD_SL,GZ_SL FROM FACT_ZLJC WHERE "
	//	+" ID_MTH >= '"+kssj+"' AND ID_MTH <= '"+jssj+"' "
		+" ID_FYDM LIKE '"+fydm+"%'";
	
	
	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	int totalCounts = 0;
	int totalPages = 0;
	int cuPage = 0;
	Map<String,Integer> vmap = new HashMap<String,Integer>();
	String fieldmc = "法院,XSD校验失败数量,规则校验失败数量";
	String field = "FYDM,XSD_SL,GZ_SL";
		
	list = bi09.queryForList(sql);
	StringBuffer tb = new StringBuffer();
	tb.append("<table id='detail' width='100%' cellpadding='0' cellspacing='0' class='table-body' >");
	tb.append("<thead>");
	tb.append("<tr class='table-header table-header-row'>");
	tb.append("<td class='table-header-th table-cell-rownumber'></td>"); 
	String[] mcs = fieldmc.split(",");
	String[] fields = field.split(",");
	
	for(int i =0;i< mcs.length;i++){
		String fi = StringUtils.trim(fields[i]);
		tb.append("<td class='table-header-th' >"+mcs[i]+"</td>");
	}
	tb.append("</tr>");
	tb.append("</thead>");
	
	tb.append("<tbody>");
 	
	String CONTEXT_PATH=WebUtils.getContextPath(request);
	
	int xsdnum = 0;
	int gznum = 0;
	int i = 0;
	for(i = 0;i < list.size(); i++){
		tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
    	tb.append("<td class='table-cell-rownumber'>"+(i+1)+"</td>");
		Map<String,Object> map = list.get(i);
		for(int j=0;j<fields.length;j++){
			String fi = StringUtils.trim(fields[j]);
			if(fi.contains(".")){
				fi=fi.substring(fi.lastIndexOf("."));
			}
			String value = StringUtils.trim(map.get(fields[j]));
			String fymc = JSUtils.convertCityByDm(value);
			if(fi.contains("XSD")){
				xsdnum += Integer.parseInt(value);
				tb.append("<td align= 'center' ><a href='javascript:void(0)' onclick=\"loadTable(1,true,true)\" > "+value+"</td>");
			}else if(fi.contains("GZ")){
				gznum += Integer.parseInt(value);
				tb.append("<td align= 'center' ><a href='javascript:void(0)' onclick=\"loadTable(1,true,true)\" > "+value+"</td>");
			}else{
				tb.append("<td align= 'center' > "+fymc+"</td>");
				
			}
			/* if(fi.contains("GZ")){
					tb.append("<td align='left' width='15%'>"+value+"</td>");
					tb.append("<td align='left' width='70%'>"+value+"</td>");
			}else if(fi.contains("SL")){ */
		//		sum += Integer.parseInt(value);
	//		}
		}
    	tb.append("</tr>");
	}
	
	//合计
	tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
   	tb.append("<td class='table-cell-rownumber'></td>");
   	tb.append("<td align='left' width='85%' colspan='1'>合计</td>");
   	tb.append("<td align= 'center' >"+xsdnum+"</td>");
   	tb.append("<td align= 'center' >"+gznum+"</td>");
   	tb.append("</tr>");
   	
	tb.append("</tbody>");
	tb.append("</table>");
	JSONObject json = new JSONObject();
    json.put("table", tb.toString());
    json.put("totalCounts",totalCounts );
    json.put("totalPages",totalPages );
    json.put("cuPage",cuPage );
    out.print(json);
%>