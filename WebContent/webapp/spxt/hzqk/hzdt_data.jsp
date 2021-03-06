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
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	if("".equals(mc)){
		mc = "全省";
	}
	
	String []tjyf = CalendarUtil.getKssjJssj(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	String []tjyf2 = CalendarUtil.getKssjJssj2(kssj,jssj);
	String kssj2 = tjyf2[0];
	String jssj2 = tjyf2[1];

	//本期数据
	String sql = "select sum(SAS) N_SAS,sum(JAS) N_JAS "
				+" ,SUM(CASE ID_MTH when '"+jssj+"' then WJS else 0 end) as N_WJS "
				+" from FACT_SJC "
				+" where ID_MTH >= '"+kssj+"' AND ID_MTH <= '"+jssj+"' AND ID_YWCB like '"+fjm+"%' ";
	List<Map<String,Object>> list = bi09.queryForList(sql);
	//同期数据
	String sql_tq = "select sum(SAS) N_SAS,sum(JAS) N_JAS"
				+" ,SUM(CASE ID_MTH when '"+jssj2+"' then WJS else 0 end) as N_WJS"
				+" from FACT_SJC "
				+" where ID_MTH >= '"+kssj2+"' AND ID_MTH <= '"+jssj2+"' AND ID_YWCB like '"+fjm+"%' ";
	List<Map<String,Object>> list_tq = bi09.queryForList(sql_tq);
	//System.out.println("sql-->"+sql+"\n"+sql_tq);
	StringBuffer sb = new StringBuffer();
	int sa=0,ja=0,wj=0;
	int sa_tq=0,ja_tq=0,wj_tq=0;
	String sa_bl="-",ja_bl="-",wj_bl="-";
	String sa_sj = "",ja_sj = "",wj_sj = "";
	String sa_color = "green",ja_color="green",wj_color="green";
	if(list.size()>0){
		Map<String,Object> map = list.get(0);
		if(map.get("N_SAS") != null){
			sa = Integer.valueOf(map.get("N_SAS").toString());
		}
		if(map.get("N_JAS") != null){
			ja = Integer.valueOf(map.get("N_JAS").toString());
		}
		if(map.get("N_WJS") != null){
			wj = Integer.valueOf(map.get("N_WJS").toString());
		}
	}
	if(list_tq.size()>0){
		Map<String,Object> map = list_tq.get(0);
		if(map.get("N_SAS") != null){
			sa_tq = Integer.valueOf(map.get("N_SAS").toString());
		}
		if(map.get("N_JAS") != null){
			ja_tq = Integer.valueOf(map.get("N_JAS").toString());
		}
		if(map.get("N_WJS") != null){
			wj_tq = Integer.valueOf(map.get("N_WJS").toString());
		}
	}
	if(sa_tq > 0){
		if(sa-sa_tq > 0){
			sa_sj = "+";
			sa_color = "red";
		}
		sa_bl = StringUtils.formatDouble((sa-sa_tq)*1.0/sa_tq*100,"#0.00");
	}
	if(ja_tq > 0){
		if(ja-ja_tq > 0){
			ja_sj = "+";
			ja_color = "red";
		}
		ja_bl = StringUtils.formatDouble((ja-ja_tq)*1.0/ja_tq*100,"#0.00");
	}
	if(wj_tq > 0){
		if(wj-wj_tq > 0){
			wj_sj = "+";
			wj_color = "red";
		}
		wj_bl = StringUtils.formatDouble((wj-wj_tq)*1.0/wj_tq*100,"#0.00");
	}
	
	int fys = 0;
	int fgrs = 0;
	List<Map<String,Object>> fysList = bi09.queryForList("SELECT COUNT(*) NUM FROM DC_CITY WHERE FJM LIKE '"+fjm+"%' AND JB = 3 AND ISNULL(SFJY,'')<>'1' ");
	List<Map<String,Object>> fgrsList = bi09.queryForList("SELECT sum(FGRS) NUM FROM DC_CITY WHERE FJM LIKE '"+fjm+"%' and JB = 3 AND ISNULL(SFJY,'')<>'1' ");
	if(fysList != null && fysList.size() > 0){
		fys = (Integer)fysList.get(0).get("NUM");
	}
	if(fgrsList != null && fgrsList.size() > 0){
		if(fgrsList.get(0).get("NUM") != null){
			fgrs = (Integer)fgrsList.get(0).get("NUM");
		}
	}
	
	sb.append("<table cellpadding='0' cellspacing='0' border='0' align='center'>");
	sb.append("<colgroup width='18px'></colgroup>");
	sb.append("<colgroup width='50'></colgroup>");
	sb.append("<colgroup width='140'></colgroup>");
	sb.append("<colgroup width='30px'></colgroup>");
	sb.append("<colgroup width='130px'></colgroup>");
	sb.append("<colgroup width='50px'></colgroup>");
	sb.append("<colgroup width='30px'></colgroup>");
	
	String size = "30";
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("法院");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(fys);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>家</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>法官"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(fgrs);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>人</td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("收案");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(sa);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>同比"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: "+sa_color+"'>");
	sb.append(sa_sj+sa_bl);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>%</td>");
	sb.append("</tr>");
	
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("结案");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(ja);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>同比"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: "+ja_color+"'>");
	sb.append(ja_sj+ja_bl);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>%</td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("未结");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 0px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(wj);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>同比"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 0px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: "+wj_color+"'>");
	sb.append(wj_sj+wj_bl);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>%</td>");
	sb.append("</tr>");
	sb.append("</table>");
	
	JSONObject jo = new JSONObject();
	jo.put("ajqk",sb.toString());
	jo.put("info","说明：当前数据统计期为"+nd+"年"+kssj.substring(4,6)+"月到"+jssj.substring(4,6)+"月，"
			+"去年同期数据统计期为"+(Integer.parseInt(nd)-1)+"年"+kssj2.substring(4,6)+"月到"+jssj.substring(4,6)+"月（前半个月同比数据有可能是下降的）。");
	
	out.print(jo.toString());
	
%>

