<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@page import="tdh.util.CalendarUtil"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String cx = StringUtils.trim(request.getParameter("cx"));
	String ajlx = StringUtils.trim(request.getParameter("lx"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	
	if("".equals(mc)){
		mc = "全省";
	}
	
	String []tjyf = CalendarUtil.getKssjJssj(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	
	String column = "";
	if("".equals(ajlx)){
		column = " sum(SAS) SAS,sum(JAS) JAS,sum(GPS) GPS,SUM(FHS) FHS,"
				+"SUM(Z_SAS) Z_SAS,SUM(Z_JAS) Z_JAS,SUM(Z_GPS) Z_GPS,SUM(Z_FHS) Z_FHS ";
	}else if("xs".equals(ajlx)){
		column = " sum(XSSAS) SAS,sum(XSJAS) JAS,sum(XSGPS) GPS,SUM(XSFHS) FHS,"
			+"SUM(Z_XS_SAS) Z_SAS,SUM(Z_XS_JAS) Z_JAS,SUM(Z_XS_GPS) Z_GPS,SUM(Z_XS_FHS) Z_FHS ";
	}else if("ms".equals(ajlx)){
		column = " sum(SAS) SAS,sum(JAS) JAS,sum(GPS) GPS,SUM(FHS) FHS,"
			+"SUM(Z_MS_SAS) Z_SAS,SUM(Z_MS_JAS) Z_JAS,SUM(Z_MS_GPS) Z_GPS,SUM(Z_MS_FHS) Z_FHS ";
	}else if("xz".equals(ajlx)){
		column = " sum(SAS) SAS,sum(JAS) JAS,sum(GPS) GPS,SUM(FHS) FHS,"
			+"SUM(Z_XZ_SAS) Z_SAS,SUM(Z_XZ_JAS) Z_JAS,SUM(Z_XZ_GPS) Z_GPS,SUM(Z_XZ_FHS) Z_FHS ";
	}

	//本期数据
	String sql = "select "+column
				+" from FACT_GPFH_JSGY where ID_MTH >='"+kssj+"' AND ID_MTH <='"+jssj+"' "
				+" AND ID_FYDM like '"+fjm+"%' ";
	List<Map<String,Object>> list = bi09.queryForList(sql);
	//System.out.println("sql-->"+sql);
	StringBuffer sb = new StringBuffer();
	int sas=0,jas=0,gps=0,fhs=0;
	int z_sas=0,z_jas=0,z_gps=0,z_fhs=0;
	if(list.size()>0){
		Map<String,Object> map = list.get(0);
		if(map.get("SAS") != null){
			sas = Integer.valueOf(map.get("SAS").toString());
		}
		if(map.get("JAS") != null){
			jas = Integer.valueOf(map.get("JAS").toString());
		}
		if(map.get("GPS") != null){
			gps = Integer.valueOf(map.get("GPS").toString());
		}
		if(map.get("FHS") != null){
			fhs = Integer.valueOf(map.get("FHS").toString());
		}
		if(map.get("Z_SAS") != null){
			z_sas = Integer.valueOf(map.get("Z_SAS").toString());
		}
		if(map.get("Z_JAS") != null){
			z_jas = Integer.valueOf(map.get("Z_JAS").toString());
		}
		if(map.get("Z_GPS") != null){
			z_gps = Integer.valueOf(map.get("Z_GPS").toString());
		}
		if(map.get("Z_FHS") != null){
			z_fhs = Integer.valueOf(map.get("Z_FHS").toString());
		}
	}
	sb.append("<table cellpadding='0' cellspacing='0' border='0' align='center'>");
	sb.append("<colgroup width='18px'></colgroup>");
	sb.append("<colgroup width='120'></colgroup>");
	sb.append("<colgroup width='90'></colgroup>");
	sb.append("<colgroup width='30px'></colgroup>");
	sb.append("<colgroup width='120px'></colgroup>");
	sb.append("<colgroup width='60px'></colgroup>");
	sb.append("<colgroup width='30px'></colgroup>");
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("二审收案");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(sas);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>再审收案"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(z_sas);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("二审结案");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(jas);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>再审结案"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(z_jas);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("被二审改判");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(gps);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>被再审改判"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(z_gps);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("被二审发回");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 0px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(fhs);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>被再审发回"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 0px #b5b5b5;padding:3px 0px;font-size:22px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(z_fhs);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("</tr>");
	
	out.print(sb.toString());
%>

