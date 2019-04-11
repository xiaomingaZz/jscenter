<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.util.JSUtils"%>
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
	List<Map<String,Object>> fylist = bi09.queryForList("select GZID, GZMC from DIM_JYGZ");
	Map<String,String> fymap = new HashMap<String,String>();
	for(Map<String,Object> map:fylist){
//		fymap.put(map.get("DM").toString(),StringUtils.trim(map.get("MC"))+"_"+StringUtils.trim(map.get("GZ")));
		fymap.put(map.get("GZID").toString(),StringUtils.trim(map.get("GZMC")));
	}
	
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	String kssj = StringUtils.trim(request.getParameter("kssj"));
	String jssj = StringUtils.trim(request.getParameter("jssj"));
	String gzs = StringUtils.trim(request.getParameter("GZ"));
	if("".equals(kssj)){
		kssj = "201601";
		jssj = "201604";
	}
	
	String start=StringUtils.trim(request.getParameter("start"));
	String limit = StringUtils.trim(request.getParameter("limit"));
	
	String gzid = JSUtils.convertDmByGz(gzs);
	
	String sql = "";
	if(StringUtils.isEmpty(gzs)){
	sql = "SELECT ID_GZ GZ,SUM(SL) SL FROM FACT_SJZL WHERE "
	//	+" ID_MTH >= '"+kssj+"' AND ID_MTH <= '"+jssj+"' "
		+" ID_FYDM LIKE '"+fydm+"%' GROUP BY ID_GZ";
	}else{
		sql = "SELECT ID_GZ GZ,SUM(SL) SL FROM FACT_SJZL WHERE "
			+" ID_GZ = '"+gzid+"' AND  "
			+" ID_FYDM LIKE '"+fydm+"%' GROUP BY ID_GZ";
	}
	
	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	int totalCounts = 0;
	int totalPages = 0;
	int cuPage = 0;
	Map<String,Integer> vmap = new HashMap<String,Integer>();
	String fieldmc = "规则说明,数量";
	String field = "GZ,SL";
		
	list = bi09.queryForList(sql);
	/*PaginateJdbc pdbc = WebAppContext.getBeanEx("bi09PaginateJdbc");
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
	*/
	StringBuffer tb = new StringBuffer();
	tb.append("<table id='detail' width='100%' cellpadding='0' cellspacing='0' class='table-body' >");
	tb.append("<thead>");
	tb.append("<tr class='table-header table-header-row'>");
	tb.append("<th class='table-header-th table-cell-rownumber'></th>");
	String[] mcs = fieldmc.split(",");
	String[] fields = field.split(",");
	
	for(int i =0;i< mcs.length;i++){
		String fi = StringUtils.trim(fields[i]);
		if(fi.contains("GZ")){
			tb.append("<th class='table-header-th' width='15%'>规则</th>");
			tb.append("<th class='table-header-th' width='70%'>"+mcs[i]+"</th>");
		}else if(fi.contains("SL")){
			tb.append("<th class='table-header-th' >"+mcs[i]+"</th>");
		}
	}
	tb.append("</tr>");
	tb.append("</thead>");
	
	tb.append("<tbody>");
 	
	String CONTEXT_PATH=WebUtils.getContextPath(request);
	
	int sum = 0;
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
			if(fi.contains("GZ")){
				if(fymap.get(value) != null){
					tb.append("<td align='left' width='15%'>"+value+"</td>");
					tb.append("<td align='left' width='70%'>"+fymap.get(value)+"</td>");
				}else{
					tb.append("<td align='left' width='15%'>"+value+"</td>");
					tb.append("<td align='left' width='70%'>"+value+"</td>");
				}
				
			}else if(fi.contains("SL")){
				String gz = StringUtils.trim(map.get("GZ"));
				tb.append("<td align= 'center' ><a href='javascript:void(0)' onclick=\"doFc('"+fydm+"','"+gz+"','"+kssj+"','"+jssj+"')\" > "+value+"</td>");
				sum += Integer.parseInt(value);
			}
		}
    	tb.append("</tr>");
	}
	
	//合计
	tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
   	tb.append("<td class='table-cell-rownumber'></td>");
   	tb.append("<td align='left' width='85%' colspan='2'>合计</td>");
   	tb.append("<td align= 'center' >"+sum+"</td>");
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