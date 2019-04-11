<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@page import="tdh.util.CalendarUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String  kssj = StringUtils.trim(request.getParameter("kssj"));
	String  jssj = StringUtils.trim(request.getParameter("jssj"));
	String  maxjssj = StringUtils.trim(request.getParameter("maxjssj"));
	
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	
	String  zw = StringUtils.trim(request.getParameter("zw"));
	if("".equals(mc)){
		mc = "全省";
	}
	
	String ytzname = "";
	String rscond = "";
	if(!"1111".equals(zw) && !"0000".equals(zw)){
		if("1".equals(zw.substring(0,1))){
			ytzname += "院长";
			rscond += " FLZW = '09_01050-1' ";
		}
		if("1".equals(zw.substring(1,2))){
			if(rscond.length() > 0){
				ytzname += "、";
				rscond += " or ";
			}
			ytzname += "副院长";
			rscond += " FLZW = '09_01050-2' ";
		}
		if("1".equals(zw.substring(2,3))){
			if(rscond.length() > 0){
				ytzname += "、";
				rscond += " or ";
			}
			ytzname += "庭长";
			rscond += " FLZW = '09_01050-3' ";
		}
		if("1".equals(zw.substring(3,4))){
			if(rscond.length() > 0){
				ytzname += "、";
				rscond += " or ";
			}
			ytzname += "副庭长";
			rscond += " FLZW = '09_01050-4' ";
		}
		
		if(rscond.length() > 0){
			rscond = " AND ("+rscond+")";
		}
	}else{
		rscond = " AND FLZW LIKE '09_01050-[1234]' ";
		zw = "1111";
	}
	
	String name = "";
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	String []tjyf2 = CalendarUtil.getKssjJssj2(kssj,jssj);
	String kssj2 = tjyf2[0];
	
	String jssj2 = tjyf2[1];
	String maxjssj2 = (Integer.parseInt(maxjssj.substring(0,4)) - 1)+maxjssj.substring(4);
	
	//本期数据
	String sql = "select sum(SAS_"+zw+") SAS,sum(JAS_"+zw+") JAS "
				+" from FACT_YTZBA_SAJA where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+maxjssj+"' "
				+" AND ID_FYDM like '"+fjm+"%' "
				;
	String sqlWj = "select  SUM(WJS_"+zw+") as WJS "
				+" from FACT_YTZBA_WJ where ID_DAY = '"+maxjssj+"' "
				+" AND ID_FYDM like '"+fjm+"%' "
				;
	String sqlTj = "select sum(SAS_"+zw+") SAS,sum(JAS_"+zw+") JAS "
				+" from FACT_YTZBA_SAJA where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+jssj+"' "
				+" AND ID_FYDM like '"+fjm+"%' ";
	List<Map<String,Object>> list = bi09.queryForList(sql);
	List<Map<String,Object>> listWj = bi09.queryForList(sqlWj);
	//同期数据
	String sql_tq = "select sum(SAS_"+zw+") SAS,sum(JAS_"+zw+") JAS "
				+" from FACT_YTZBA_SAJA where ID_DAY >= '"+kssj2+"' AND ID_DAY <= '"+maxjssj2+"' "
				+" AND ID_FYDM like '"+fjm+"%' "
				;
	String sql_tqbq = "select sum(SAS_"+zw+") SAS,sum(JAS_"+zw+") JAS "
				+" from FACT_YTZBA_SAJA where ID_DAY >= '"+kssj2+"' AND ID_DAY <= '"+maxjssj+"' "
				+" AND ID_FYDM like '"+fjm+"%' ";
	String sqlTj_tq = "select sum(SAS_"+zw+") SAS,sum(JAS_"+zw+") JAS "
				+" from FACT_YTZBA_SAJA where ID_DAY >= '"+kssj2+"' AND ID_DAY <= '"+jssj2+"' "
				+" AND ID_FYDM like '"+fjm+"%' ";
	List<Map<String,Object>> list_tq = bi09.queryForList(sql_tq);
	List<Map<String,Object>> list_tqbq = bi09.queryForList(sql_tqbq);
	//System.out.println("sql-->"+sql+"\n"+sql_tq);
	StringBuffer sb = new StringBuffer();
	int sa=0,ja=0,wj=0,jc=0,sls=0;
	int sa_tq=0,ja_tq=0,wj_tq=0,jc_tq=0,sls_tq=0;
	String sa_bl="-",ja_bl="-",jc_bl="-",sls_bl="-";
	String sa_sj = "",ja_sj = "",jc_sj = "",sls_sj="";
	String sa_color = "green",ja_color="color",jc_color="color",sls_color="color";
	if(list.size()>0){
		Map<String,Object> map = list.get(0);
		if(map.get("SAS") != null){
			sa = Integer.valueOf(map.get("SAS").toString());
		}
		if(map.get("JAS") != null){
			ja = Integer.valueOf(map.get("JAS").toString());
		}
	}
	if(listWj.size()>0){
		Map<String,Object> map = listWj.get(0);
		if(map.get("WJS") != null){
			wj = Integer.valueOf(map.get("WJS").toString());
		}
	}
	jc = ja+wj -sa;
	sls = ja+wj;
	//同期
	if(list_tq.size()>0){
		Map<String,Object> map = list_tq.get(0);
		if(map.get("SAS") != null){
			sa_tq = Integer.valueOf(map.get("SAS").toString());
		}
		if(map.get("JAS") != null){
			ja_tq = Integer.valueOf(map.get("JAS").toString());
		}
	}
	int sa_tqbq = 0,ja_tqbq = 0;
	if(list_tqbq.size()>0){
		Map<String,Object> map = list_tqbq.get(0);
		if(map.get("SAS") != null){
			sa_tqbq = Integer.valueOf(map.get("SAS").toString());
		}
		if(map.get("JAS") != null){
			ja_tqbq = Integer.valueOf(map.get("JAS").toString());
		}
	}
	jc_tq = ja_tqbq + wj - sa_tqbq;
	sls_tq = ja_tq + jc_tq;
	
	//人数
	String sqlRs = "SELECT COUNT(*) NUM FROM ETL_USER WHERE DWDM LIKE '"+dm+"%'" + rscond 
				+" AND ISNULL(SFJY,'')<>'1' "
	;
	System.out.println("sqlRs-->"+sqlRs);
	List<Map<String,Object>> list_rs = bi09.queryForList(sqlRs);
	int rs = 0;
	if(list_rs != null && list_rs.size() > 0){
		Map<String,Object> m = list_rs.get(0);
		if(m.get("NUM") != null){
			rs = (Integer)m.get("NUM");
		}
	}
	//----------------------------------------------
	String rjbas = "-";
	if(jssj.equals(maxjssj)){
		
	}else{
		List<Map<String,Object>> listTj = bi09.queryForList(sqlTj);
		List<Map<String,Object>> listTj_tq = bi09.queryForList(sqlTj_tq);
		int satj = 0,jatj = 0;
		int satj_tq = 0,jatj_tq = 0;
		if(listTj.size()>0){
			Map<String,Object> map = listTj.get(0);
			if(map.get("SAS") != null){
				satj = Integer.valueOf(map.get("SAS").toString());
			}
			if(map.get("JAS") != null){
				jatj = Integer.valueOf(map.get("JAS").toString());
			}
		}
		
		if(listTj_tq.size()>0){
			Map<String,Object> map = listTj_tq.get(0);
			if(map.get("SAS") != null){
				satj_tq = Integer.valueOf(map.get("SAS").toString());
			}
			if(map.get("JAS") != null){
				jatj_tq = Integer.valueOf(map.get("JAS").toString());
			}
		}
		//System.out.println("==>"+sqlTj_tq);
		//System.out.println("==>"+listTj+"  "+listTj_tq);
		//System.out.println("====>"+satj+"  "+jatj+"  "+satj_tq+"  "+jatj_tq);
		sa = satj;
		ja = jatj;
		sa_tq = satj_tq;
		ja_tq = jatj_tq;
		sls = sa + jc;
		sls_tq = ja_tq + jc_tq;
		
	}
	
	//计算同比 升降
	if(sls_tq > 0){
		if(sls-sls_tq > 0){
			sls_sj = "+";
			sls_color="red";
		}
		sls_bl = StringUtils.formatDouble((sls-sls_tq)*1.0/sls_tq*100,"#0.00");
	}
	if(sa_tq > 0){
		if(sa-sa_tq > 0){
			sa_sj = "+";
			sa_color="red";
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
	if(jc_tq > 0){
		if(jc-jc_tq > 0){
			jc_sj = "+";
			jc_color = "red";
		}
		jc_bl = StringUtils.formatDouble((jc-jc_tq)*1.0/jc_tq*100,"#0.00");
	}
	
	if("sls".equals(dl)){
		name = "受理";
		rjbas = StringUtils.formatDouble((jc+sa)*1.0/rs,"#0.00");
	}else if("sas".equals(dl)){
		name = "收案";
		rjbas = StringUtils.formatDouble((sa)*1.0/rs,"#0.00");
	}else if("jas".equals(dl)){
		name = "结案";
		rjbas = StringUtils.formatDouble((ja)*1.0/rs,"#0.00");
	}
	
	
	
	
	sb.append("<table cellpadding='0' cellspacing='0' border='0' align='center'>");
	sb.append("<colgroup width='18px'></colgroup>");
	sb.append("<colgroup width='70'></colgroup>");
	sb.append("<colgroup width='150'></colgroup>");
	sb.append("<colgroup width='30px'></colgroup>");
	sb.append("<colgroup width='120px'></colgroup>");
	sb.append("<colgroup width='60px'></colgroup>");
	sb.append("<colgroup width='30px'></colgroup>");
	
	String size = "30";
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("受理");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(sls);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>件</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>同比"+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 1px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: "+sls_color+"'>");
	sb.append(sls_sj+sls_bl);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>%</td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<td align='right' style='padding: 3px 2px;font-size:22px;line-height:42px;color:#000000; '><div style='width:18px;height:18px;background:#EE7942;'></div></td>");
	sb.append("<td align='left' style='border-bottom: dashed 1px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>");
	sb.append("新收");
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
	sb.append("审结");
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
	sb.append("数量");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 0px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(rs);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>人</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'>人均"+name+"</td>");
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom:dashed 0px #b5b5b5;padding:3px 0px;font-size:"+size+"px;line-height:42px;font-weight:bolder;color: #CD4147'>");
	sb.append(rjbas);
	sb.append("</td>");
	sb.append("<td align='right' style='border-bottom: dashed 0px #b5b5b5;padding: 3px 0px;font-size:22px;line-height:42px;'></td>");
	sb.append("</tr>");
	
	JSONObject jo = new JSONObject();
	jo.put("ajqk",sb.toString());
	jo.put("info","说明：办理案件为：院、庭领导担任审判长或承办人身份的案件，对既为审判长又为承办人的只统计一次。");
	out.print(jo.toString());
%>

