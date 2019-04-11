<%@page import="net.sf.json.JSONObject"%>
<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		mc = "全省";
		dm = JSUtils.fydm;
	}else if(dm.endsWith("00")){
 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
	}
	
	String tjrq =  sdf.format(new Date());
	
	List<Map<String,Object>> list = bi09.queryForList("select sum(N_SAS) N_SAS,sum(N_JAS) N_JAS,sum(N_NSAS) N_NSAS,sum(N_NJAS) N_NJAS,sum(N_WJS) N_WJS "+
		" from DC_SPXT_SJC where TJRQ = '"+tjrq+"' and FYDM like '"+dm+"%' ");
	StringBuffer sb = new StringBuffer();
	int sa=0,ja=0,n_sa=0,n_ja=0,wj=0;
	if(list.size()>0){
		Map<String,Object> map = list.get(0);
		sa = Integer.valueOf(map.get("N_SAS")==null?"0":map.get("N_SAS").toString());
		ja = Integer.valueOf(map.get("N_JAS")==null?"0":map.get("N_JAS").toString());
		n_sa = Integer.valueOf(map.get("N_NSAS")==null?"0":map.get("N_NSAS").toString());
		n_ja = Integer.valueOf(map.get("N_NJAS")==null?"0":map.get("N_NJAS").toString());
		wj = Integer.valueOf(map.get("N_WJS")==null?"0":map.get("N_WJS").toString());
	}
	sb.append("<table align='center' width='450' cellpadding='0' cellspacing='0' border='0' >");
	sb.append("<tr align='right'>");
	sb.append("<td style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td width='220px' style='border-bottom: dashed 1px #b5b5b5;padding-left:5px;font-size:22px;line-height:42px;'>新收</td>");
	sb.append("<td style='border-bottom:dashed 1px #b5b5b5;padding:5px;font-size:28px;line-height:42px;font-weight:bolder;'>");
	sb.append("<a href = 'javascript:void(0)' style='color: #CD4147' onclick = \"javascript:doFc('JS0001','"+dm+"','"+tjrq+"','','','SA')\">"+sa+"</a>");
	sb.append("</td>");
	sb.append("<td width='30px' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	sb.append("<tr align='right' >");
	sb.append("<td style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td width='220px' style='border-bottom: dashed 1px #b5b5b5;padding-left:5px;font-size:22px;line-height:42px;'>审结</td>");
	sb.append("<td style='border-bottom:dashed 1px #b5b5b5;padding:5px;font-size:28px;line-height:42px;font-weight:bolder;'>");
	sb.append("<a href = 'javascript:void(0)' style='color: #CD4147' onclick = \"javascript:doFc('JS0001','"+dm+"','"+tjrq+"','','','JA')\">"+ja+"</a>");
	sb.append("</td>");
	sb.append("<td width='30px' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	sb.append("<tr align='right' >");
	sb.append("<td style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td width='220px' style='border-bottom: dashed 1px #b5b5b5;padding-left:5px;font-size:22px;line-height:42px;'>今年累计收案</td>");
	sb.append("<td style='border-bottom:dashed 1px #b5b5b5;padding:5px;font-size:28px;line-height:42px;font-weight:bolder;color: #CD4147'>"+n_sa+"</td>");
	sb.append("<td width='30px' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	sb.append("<tr align='right' >");
	sb.append("<td style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td width='220px' style='border-bottom: dashed 1px #b5b5b5;padding-left:5px;font-size:22px;line-height:42px;'>今年累计结案</td>");
	sb.append("<td style='border-bottom:dashed 1px #b5b5b5;padding:5px;font-size:28px;line-height:42px;font-weight:bolder;color: #CD4147'>"+n_ja+"</td>");
	sb.append("<td width='30px' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	sb.append("<tr align='right'>");
	sb.append("<td style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td width='220px' style='border-bottom: dashed 0px #b5b5b5;padding-left:5px;font-size:22px;line-height:42px;'>当前未结</td>");
	sb.append("<td style='border-bottom:dashed 0px #b5b5b5;padding:5px;font-size:28px;line-height:42px;font-weight:bolder;color: #CD4147'>"+wj+"</td>");
	sb.append("<td width='30px' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	sb.append("</table>");
	JSONObject jo = new JSONObject();
	jo.put("table",sb.toString());
	jo.put("city",mc);
	out.print(jo);
%>

