<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
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

	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String start=StringUtils.trim(request.getParameter("start"));
	String limit = StringUtils.trim(request.getParameter("limit"));
	JdbcTemplateExt dbc = WebAppContext.getBeanEx(JSUtils.DBC_JDBCTEMPLATE_EXT);
	List<Map<String, Object>> fylist = dbc.queryForList("select * from DC_CITY");
	Map<String, Object> city = new HashMap<String, Object>();
	for (Map<String, Object> map : fylist) {
		city.put(map.get("FJM").toString(), map.get("MC"));
	}
	
	PaginateJdbc pdbc = WebAppContext.getBeanEx(JSUtils.XdbPaginateJdbc);
	PageBean pb = new PageBean();
	pb.setCurrentPage(Integer.valueOf(start));
   	pb.setStartRow((Integer.valueOf(start)-1)*Integer.valueOf(limit));
    pb.setLen(Integer.valueOf(limit));
	pb.setHql("SELECT FY,DDSJ,AJBS,AH,AJZT,LARQ,JARQ from TR_DD where DDSJ >= '"+ StringUtils.formatDate(new Date(), "yyyyMMdd")+ "' and XMLTYPE='ASS' and FY like '" + fjm + "%' order by DDSJ ");    
	pb = pdbc.getList(pb);
    List<Map<String,Object>> list = pb.getResult();
	StringBuffer sb = new StringBuffer();
	sb.append("<table width='100%' cellpadding='0' cellspacing='0' class='table-body'>");
	sb.append("<tr class='table-header table-header-row'>");
	sb.append("<td  colspan='2' class=''>法院/地区</td>");
	sb.append("<td  class=''>到达时间</td>");
	sb.append("<td  class=''>案件标识</td>");
	sb.append("<td  class=''>案号</td>");
	//sb.append("<td  class=''>案件状态</td>");
	sb.append("<td class=''>立案日期</td>");
	sb.append("<td  class=''>结案日期</td>");
	sb.append("</tr>");
	for (int i = 0; i < list.size(); i++) {
		Map<String, Object> mm = list.get(i);
		sb.append("<tr class='table-row " + (i % 2 == 0 ? "" : "odd")+ "'>");
		sb.append("<td class='table-cell-rownumber '>" + (i + 1)+ "</td>");
		sb.append("<td class='table-cell-mc' width='100'>"+ city.get(mm.get("FY")) + "</td>");
		sb.append("<td class='table-cell' width='130'>"+ StringUtils.formatDate((Date) mm.get("DDSJ"),"yyyy-MM-dd HH:mm:ss") + "</td>");
		sb.append("<td class='table-cell' width='100' >"+ (mm.get("AJBS")==null?"":mm.get("AJBS")) + "</td>");
		sb.append("<td class='table-cell-mc' width='200'>"+ (mm.get("AH")==null?"":mm.get("AH")) + "</td>");
		//sb.append("<td class='table-cell' width='50' >"+ (mm.get("AJZT")==null?"":mm.get("AJZT")) + "</td>");
		sb.append("<td class='table-cell' width='80'>"+ (mm.get("LARQ")==null?"":mm.get("LARQ")) + "</td>");
		sb.append("<td class='table-cell' width='80' >"+ (mm.get("JARQ")==null?"":mm.get("JARQ")) + "</td>");
		sb.append("</tr>");
	}
	sb.append("</table>");
	JSONObject json = new JSONObject();
    json.put("table", sb.toString());
    json.put("totalCounts", pb.getTotalRows());
    json.put("totalPages", pb.getTotalPage());
    json.put("cuPage", pb.getCurrentPage());
    out.print(json);
%>