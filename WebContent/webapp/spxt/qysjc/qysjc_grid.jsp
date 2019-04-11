<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.CalendarUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String kssj = StringUtils.trim(request.getParameter("kssj"));
	String jssj = StringUtils.trim(request.getParameter("jssj"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String yhdm = StringUtils.trim(request.getParameter("yhdm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	if(kssj.equals("")&&jssj.equals("")){
		String []tjyf = CalendarUtil.getKssjJssjDay(nd);
		kssj = tjyf[0];
		jssj = tjyf[1];
	}

	//结案数据清单
	String sql = "select AH,HYCY,JAFSSM,JARQ FROM ETL_CASE "
				+" where AJZT >='800' AND JARQ >= '"+kssj+"' AND JARQ <= '"+jssj+"' "
				+" AND FYDM = '"+dm+"' AND CBR = '"+yhdm+"' order by JARQ ";
	List<Map<String,Object>> list = bi09.queryForList(sql);
	
	StringBuffer sbtitle = new StringBuffer();
	StringBuffer sb = new StringBuffer();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
	if(list.size()>0){
		int xh = 1;
		for(Map<String,Object> map : list){
			String ah = (String)map.get("AH");
			String hytcy = StringUtils.trim(map.get("HYCY"));
			
			sb.append("<li id='"+(xh)+"'>");
			sb.append("<table align='center' width='100%' cellpadding='0' cellspacing='0' border='0' style = 'font-size:15px;' >");
			sb.append("<tr style='line-height:24px;'>");
			sb.append("<td width='18px'><div style='width:15px;height:15px;background:#EE7942;'></div></td>");
			sb.append("<td align='left' width='300px' style='padding-left:5px;'>"+ah+"</td>");
			sb.append("<td align='right' width='140px' >"+hytcy+"</td>");
			sb.append("<td align='right' width='' >");
			sb.append(sdf1.format(sdf.parse(map.get("JARQ").toString())));
			sb.append("</td>");
			sb.append("</tr>");
			sb.append("</table>");
			sb.append("</li>");
			xh++;
		}
	}
	
	JSONObject jo = new JSONObject();
	jo.put("sjcgrid",sb.toString());
	out.print(jo.toString());
	
%>

