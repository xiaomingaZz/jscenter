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

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	List<Map<String,Object>> fylist = bi09.queryForList("select FJM DM,NAME_CITY MC from DC_CITY");
	Map<String,String> fymap = new HashMap<String,String>();
	for(Map<String,Object> map:fylist){
		fymap.put(map.get("DM").toString(),map.get("MC").toString());
	}
	
	String flag = StringUtils.trim(request.getParameter("flag"));
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	
	String start=StringUtils.trim(request.getParameter("start"));
	String limit = StringUtils.trim(request.getParameter("limit"));
	
	String sql = "";
	if("trans_fail".equals(flag)){
		sql = "SELECT * FROM TR_DD WHERE "
			+"DDSJ >= '"+StringUtils.formatDate(new java.util.Date(),"yyyyMMdd")+"' "
			+" AND XMLTYPE = 'ASS' and ZT = '0' AND FY LIKE '"+fydm+"%' ";
	}else{
		sql = "SELECT * FROM TR_DD WHERE "
			+"DDSJ >= '"+StringUtils.formatDate(new java.util.Date(),"yyyyMMdd")+"' "
			+" AND XMLTYPE = 'ASS' and ZT = '4' AND (SBYY NOT LIKE '规则%' AND SBYY NOT LIKE '采用的结案案由未在%') AND FY LIKE '"+fydm+"%' ";
	}
	
	
	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	int totalCounts = 0;
	int totalPages = 0;
	int cuPage = 0;
	Map<String,Integer> vmap = new HashMap<String,Integer>();
	String fieldmc = "法院,到达时间,案号或文件名,失败原因";
	String field = "FY,DDSJ,AH,SBYY";
		
	PaginateJdbc pdbc = WebAppContext.getBeanEx("xdbPaginateJdbc");
	PageBean pb = new PageBean();
	pb.setCurrentPage(Integer.valueOf(start));
   	pb.setStartRow((Integer.valueOf(start)-1)*Integer.valueOf(limit));
    pb.setLen(Integer.valueOf(limit));
    System.out.println("fc data sql-->"+sql);
	pb.setHql(sql);    
	pb = pdbc.getList(pb);
	list = pb.getResult();
	totalCounts = pb.getTotalRows();
	totalPages = pb.getTotalPage();
	cuPage = pb.getCurrentPage();
	
	StringBuffer tb = new StringBuffer();
	tb.append("<table id='detail' width='100%' cellpadding='0' cellspacing='0' class='table-body' >");
	tb.append("<thead>");
	tb.append("<tr class='table-header table-header-row'>");
	tb.append("<th class='table-header-th table-cell-rownumber'></th>");
	String[] mcs = fieldmc.split(",");
	String[] fields = field.split(",");
	
	for(int i =0;i< mcs.length;i++){
		String fi = StringUtils.trim(fields[i]);
		if(fi.contains("FY")){
			tb.append("<th class='table-header-th' width='10%'>"+mcs[i]+"</th>");
		}else if(fi.contains("RQ")||fi.contains("SJ")){
			tb.append("<th class='table-header-th' width='15%'>"+mcs[i]+"</th>");
		}else if(fi.contains("AH")){
			tb.append("<th class='table-header-th' width='20%' >"+mcs[i]+"</th>");
		}else{
			tb.append("<th class='table-header-th' ><input type='text' value='"+mcs[i]+"' readonly></th>");
		}
	}
	tb.append("</tr>");
	tb.append("</thead>");
	
	tb.append("<tbody>");
 	
	String CONTEXT_PATH=WebUtils.getContextPath(request);
	for(int i=0;i<list.size();i++){
		tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
    	tb.append("<td class='table-cell-rownumber'>"+(i+1)+"</td>");
		Map<String,Object> map = list.get(i);
		for(int j=0;j<fields.length;j++){
			String fi = StringUtils.trim(fields[j]);
			if(fi.contains(".")){
				fi=fi.substring(fi.lastIndexOf("."));
			}
			String value = StringUtils.trim(map.get(fields[j]));
			if(fi.contains("FY")){
				tb.append("<td align='left' >"+fymap.get(value)+"</td>");
			}else if(fi.contains("RQ")||fi.contains("SJ")){
				tb.append("<td align='left' >"+value+"</td>");
			}else if(fi.contains("AH")){
				String xmlname = StringUtils.trim(map.get("XMLNAME"));
				String sbyy = StringUtils.trim(map.get("SBYY"));
				String ah = StringUtils.trim(map.get("AH"));
				if("trans_fail".equals(flag)){
					tb.append("<td align= 'left' >"+xmlname+"</td>");
				}else{
					tb.append("<td align= 'left' ><a href='javascript:void(0);' onclick=\"showXml('"+ah+"','"+xmlname+"','"+sbyy+"')\">"+value+"</a></td>");
				}
				
			}else{
				tb.append("<td align='left'>"+value+"</td>");
			}
		}
    	tb.append("</tr>");
	}
	tb.append("</tbody>");
	tb.append("</table>");
	JSONObject json = new JSONObject();
    json.put("table", tb.toString());
    json.put("totalCounts",totalCounts );
    json.put("totalPages",totalPages );
    json.put("cuPage",cuPage );
    out.print(json);
%>