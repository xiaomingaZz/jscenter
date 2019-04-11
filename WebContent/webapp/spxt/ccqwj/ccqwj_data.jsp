<%@page import="net.sf.json.JSONObject"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String type = StringUtils.trim(request.getParameter("type"));
	String start=StringUtils.trim(request.getParameter("start"));
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	String cond = "";
	String typemc = "";
	
	if(type.equals("ss")){
		typemc = "诉讼";
		cond = " XTAJLX not like '5%' ";
	}else {
		typemc = "执行";
		cond = " XTAJLX like '5%' ";
	}
	
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		mc = "全省";
 	}else if(dm.endsWith("00")){
 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
	}
	List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY ");
	Map<String,Object> map = new HashMap<String,Object>();
	for(Map<String,Object> mm:fylist){
		map.put(mm.get("DM").toString(),mm.get("MC"));
	}
	
	PaginateJdbc pdbc = WebAppContext.getBeanEx("bi09PaginateJdbc");
	PageBean pb = new PageBean();
	pb.setCurrentPage(Integer.valueOf(start));
   	pb.setStartRow((Integer.valueOf(start)-1)*Integer.valueOf(30));
    pb.setLen(Integer.valueOf(30));
	pb.setHql("select AH,FYDM,LARQ from ETL_CASE_CCQ where dateadd(yy,1,LARQ)<getdate() and isnull(LARQ,'')>'' and "+cond+" and FYDM like '"+dm+"%'");    
	pb = pdbc.getList(pb);
	List<Map<String,Object>> list = pb.getResult();
	
	StringBuffer sb = new StringBuffer();
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
	if(list!=null){
		for(int i=0;i<list.size();i++){
			Map<String,Object> mm = list.get(i);
			
			String fymc = "";
			if(map.containsKey(mm.get("FYDM"))){
				fymc = map.get(mm.get("FYDM")).toString();
			}else{
				fymc = mm.get("FYDM").toString();
			}
			if(fymc.length()>11){
				fymc = fymc.substring(0,11);
			}
			sb.append("<li id='"+(i+1)+"'>");
			sb.append("<table align='center' width='488' cellpadding='0' cellspacing='0' border='0' style = 'font-size:15px;' >");
			sb.append("<tr style='line-height:24px;'>");
			sb.append("<td width='18px'><div style='width:15px;height:15px;background:#EE7942;'></div></td>");
			sb.append("<td align='left' width='180px' style='padding-left:5px;'>[");
			sb.append(fymc);
			sb.append("]</td>");
			sb.append("<td align='right' width='280px' >");
			sb.append(mm.get("AH"));
			sb.append("</td>");
			sb.append("<td align='right' width='100px' >");
			sb.append(sdf1.format(sdf.parse(mm.get("LARQ").toString())));
			sb.append("</td>");
			sb.append("</tr>");
			sb.append("</table>");
			sb.append("</li>");
			
		}
	}
	JSONObject jo = new JSONObject();
	jo.put("li",sb.toString());
	jo.put("city",mc+typemc);
	jo.put("totalPages",pb.getTotalPage());
	jo.put("cuPage",pb.getCurrentPage());
	out.print(jo);
%>

