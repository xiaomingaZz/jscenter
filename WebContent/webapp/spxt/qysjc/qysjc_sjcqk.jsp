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
	String dm = StringUtils.trim(request.getParameter("dm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	String []tjyf = CalendarUtil.getKssjJssjDay(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];

	String cond  = " AND FYDM = '"+dm+"' AND BCYSFTJ = '0' AND XTAJLX <>'15'";
	String sql1 = "select CBBM1 DM,COUNT(AHDM) SL from ETL_CASE where AJZT>='300' AND LARQ >='"+kssj+"' and LARQ <='"+jssj+"' "+cond+" group by CBBM1";
	String sql2 = "select CBBM1 DM,COUNT(AHDM) SL from ETL_CASE where AJZT>='800' AND JARQ >='"+kssj+"' and JARQ <='"+jssj+"' "+cond+" group by CBBM1";
	String sql3 = "select CBBM1 DM,COUNT(AHDM) SL from ETL_CASE where AJZT>='300' AND AJZT < '800' AND (LARQ <='"+jssj+"' or (AJZT >='800' AND JARQ > '"+jssj+"')) "+cond+" group by CBBM1";
	System.out.println(sql3);
	//本期数据
	String sql = "select BMDM,ISNULL(BMJC,BMMC) BMMC from ETL_DEPART where DWDM = '"+dm+"' order by PXH";
	//System.out.println("sql-->"+sql);
	List<Map<String,Object>> bmlist = bi09.queryForList(sql);
	List<Map<String,Object>> salist = bi09.queryForList(sql1);
	List<Map<String,Object>> jalist = bi09.queryForList(sql2);
	List<Map<String,Object>> wjlist = bi09.queryForList(sql3);
	
	StringBuffer sb = new StringBuffer();
	
	sb.append("<table style='margin-top:2px;font-size:18px;border-left:solid 1px #b5b5b5;border-right:solid 1px #b5b5b5;border-top:solid 1px #b5b5b5; ' cellpadding='0' cellspacing='1' align='center' >");
	sb.append("<colgroup width='62px'></colgroup>");
	sb.append("<colgroup width='180px'></colgroup>");
	sb.append("<colgroup width='110px'></colgroup>");
	sb.append("<colgroup width='110px'></colgroup>");
	sb.append("<colgroup width='110px'></colgroup>");
	sb.append("<tr bgcolor='#87CEFA' style='font-weight:bold;font-size:14px;line-height:24px;'>");
	sb.append("<td style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'>序号</td>");
	sb.append("<td style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'>部门</td>");
	sb.append("<td style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'>收案</td>");
	sb.append("<td style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'>结案</td>");
	sb.append("<td style='border-bottom: solid 1px #b5b5b5;'>未结</td>");
	sb.append("</tr>");
	
	String dm_ = "";
	String mc_ = "";
	if(bmlist.size()>0){
		int xh = 0;
		for(Map<String,Object> map : bmlist){
			String bmdm = (String)map.get("BMDM");
			String bmmc = (String)map.get("BMMC");
			int sa = 0;
			int ja = 0;
			int wj = 0;
			for(Map<String,Object> m : salist){
				if(bmdm.equals(m.get("DM"))){
					sa = m.get("SL")==null?0:Integer.valueOf(m.get("SL").toString());
					break;
				}
			}
			for(Map<String,Object> m : jalist){
				if(bmdm.equals(m.get("DM"))){
					ja = m.get("SL")==null?0:Integer.valueOf(m.get("SL").toString());
					break;
				}
			}
			for(Map<String,Object> m : wjlist){
				if(bmdm.equals(m.get("DM"))){
					wj = m.get("SL")==null?0:Integer.valueOf(m.get("SL").toString());
					break;
				}
			}
			if(sa == 0 && ja == 0 && wj == 0){
				continue;
			}else if(dm_.equals("")){
				dm_ = bmdm;
				mc_ = bmmc;
			}
			sb.append("<tr class='table_row' style='font-size:14px;line-height:23px;'>");
			sb.append("<td style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'>"+(++xh)+"</td>");
			sb.append("<td align='left' style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'><a href='javascript:void(0);' onclick='changeBm(\""+bmdm+"\",\""+bmmc+"\")'>"+bmmc+"</a></td>");
			sb.append("<td style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'><a href='javascript:void(0);' onclick='doFc(\"JS0002\",\""+dm+"\",\""+bmdm+"\",\""+kssj+"\",\""+jssj+"\")'>"+sa+"</a></td>");
			sb.append("<td style='border-bottom: solid 1px #b5b5b5;border-right: solid 1px #b5b5b5;'><a href='javascript:void(0);' onclick='doFc(\"JS0003\",\""+dm+"\",\""+bmdm+"\",\""+kssj+"\",\""+jssj+"\")'>"+ja+"</a></td>");
			sb.append("<td style='border-bottom: solid 1px #b5b5b5;'><a href='javascript:void(0);' onclick='doFc(\"JS00WJ\",\""+dm+"\",\""+bmdm+"\",\""+kssj+"\",\""+jssj+"\")'>"+wj+"</a></td>");
			sb.append("</tr>");
		}
	}

	JSONObject jo = new JSONObject();
	jo.put("sjcqk",sb.toString());
	jo.put("bmdm",dm_);
	jo.put("bmmc",mc_);
	out.print(jo.toString());
	
%>

