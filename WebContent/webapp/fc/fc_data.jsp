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
	List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY");
	Map<String,String> fymap = new HashMap<String,String>();
	for(Map<String,Object> map:fylist){
		fymap.put(map.get("DM").toString(),map.get("MC").toString());
	}
	
	String baseid = StringUtils.trim(request.getParameter("BASEID"));
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	String kssj = StringUtils.trim(request.getParameter("KSSJ"));
	String jssj = StringUtils.trim(request.getParameter("JSSJ"));
	
	String start=StringUtils.trim(request.getParameter("start"));
	String limit = StringUtils.trim(request.getParameter("limit"));
	
	
	
	Enumeration en = request.getParameterNames();
	StringBuffer sb = new StringBuffer();
	while (en.hasMoreElements()) {
		String name = StringUtils.trim(en.nextElement());
		if ("".equals(name)||"ver".equals(name)||"KSSJ".equals(name)||"JSSJ".equals(name)||"FLAG".equals(name)||"BASEID".equals(name)||
				"submitform".equals(name)||"etc".equals(name)||"start".equals(name)||"limit".equals(name)
				|| "ZW".equals(name)) {
			continue;
		}
		String val = StringUtils.trim(request.getParameter(name));
		if(name.equals("XFTZ")){
			sb.append(" AND "+name+" LIKE '%"+val+"%'");
		}else{
			if(val.contains(",")){
				String[] vals = val.split(",");
				String cond = "";
				for(int i=0;i<vals.length;i++){
					String vv = vals[i];
					if("null".equals(vv)){
						cond +=" isnull("+name+",'') = '' or";
					}else if(!"".equals(vv)){
						cond +=" "+name+" LIKE '"+vv+"%' or";
					}
				}
				if(cond.endsWith("or")){
					cond = cond.substring(0,cond.lastIndexOf("or"));
					sb.append(" AND ( "+cond+")");
				}
			}else{
				if("null".equals(val)){
					sb.append(" AND isnull("+name+",'') = '' ");
				}else if(!"".equals(val)){
					sb.append(" AND "+name+" LIKE '"+val+"%'");
				}
			}
		}
	}
	
	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	int totalCounts = 0;
	int totalPages = 0;
	int cuPage = 0;
	List<Map<String,Object>> list0 = bi09.queryForList("select BASEID,FIELD,FIELDMC,COND from T_BASE where BASEID = '"+baseid+"'");
	Map<String,Integer> vmap = new HashMap<String,Integer>();
	String fieldmc = "法院,案号,立案日期,案由描述,当事人,结案日期";
	String field = "FYDM,AH,LARQ,AYMS,DSR,JARQ";
	if(list0.size()>0){
		String cond = StringUtils.trim(list0.get(0).get("COND"));
		field =  StringUtils.trim(list0.get(0).get("FIELD"));
		fieldmc = StringUtils.trim(list0.get(0).get("FIELDMC"));
		if(field==null||"".equals(field)){
			field = "FYDM,AH,LARQ,AYMS,DSR,JARQ";
			fieldmc = "法院,案号,立案日期,案由描述,当事人,结案日期";
		}
		cond = cond.replace("@KSSJ@",kssj).replace("@JSSJ@",jssj).replace("@COND@",sb.toString());
		
		PaginateJdbc pdbc = WebAppContext.getBeanEx("bi09PaginateJdbc");
		PageBean pb = new PageBean();
		pb.setCurrentPage(Integer.valueOf(start));
	   	pb.setStartRow((Integer.valueOf(start)-1)*Integer.valueOf(limit));
	    pb.setLen(Integer.valueOf(limit));
	    String sql = "select "+field+" "+cond;
	    System.out.println("fc data sql-->"+sql);
		pb.setHql(sql);    
		pb = pdbc.getList(pb);
		list = pb.getResult();
		totalCounts = pb.getTotalRows();
		totalPages = pb.getTotalPage();
		cuPage = pb.getCurrentPage();
	}
	
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
			tb.append("<th class='table-header-th' width='120'>"+mcs[i]+"</th>");
		}else if(fi.contains("RQ")||fi.contains("SJ")){
			tb.append("<th class='table-header-th' width='70'>"+mcs[i]+"</th>");
		}else if(fi.contains("KTURL")){
			tb.append("<th class='table-header-th' width='70'>"+mcs[i]+"</th>");
		}else{
			tb.append("<th class='table-header-th'><input type='text' value='"+mcs[i]+"' readonly></th>");
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
				tb.append("<td width='120' align='left' >"+fymap.get(value)+"</td>");
			}else if(fi.contains("RQ")||fi.contains("SJ")){
				tb.append("<td width='70' align='center' >"+value+"</td>");
			}else if(fi.contains("KTURL")){
				if(value.equals("")){
					tb.append("<td width='70' align='center' >--</td>");
				}else{
					tb.append("<td width='70' align='center' ><a href='#' onClick=\"javaScript:showVideo('"+value+"')\"><img src='"+CONTEXT_PATH+"/resources/images/browser.gif'></a></td>");
				}
			}else{
				tb.append("<td ><input type='text' value='"+value+"' title='"+value+"' readonly></td>");
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