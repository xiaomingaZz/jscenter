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
		mc = JSUtils.fymc;
		dm = JSUtils.fydm;
	}else if(dm.endsWith("00")){
 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
	}
	
	String tjrq =  sdf.format(new Date());
	String sql = "select sum(N_SAS) N_SAS,sum(N_JAS) N_JAS,sum(N_NSAS) N_NSAS,sum(N_NJAS) N_NJAS,sum(N_WJS) N_WJS "+
	" from DC_SPXT_SJC where TJRQ = '"+tjrq+"' and FYDM like '"+dm+"%' ";
	System.out.println("jrdt data sql-->"+sql);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	int sa=0,ja=0,n_sa=0,n_ja=0,wj=0;
	if(list.size()>0){
		Map<String,Object> map = list.get(0);
		sa = Integer.valueOf(map.get("N_SAS")==null?"0":map.get("N_SAS").toString());
		ja = Integer.valueOf(map.get("N_JAS")==null?"0":map.get("N_JAS").toString());
		n_sa = Integer.valueOf(map.get("N_NSAS")==null?"0":map.get("N_NSAS").toString());
		n_ja = Integer.valueOf(map.get("N_NJAS")==null?"0":map.get("N_NJAS").toString());
		wj = Integer.valueOf(map.get("N_WJS")==null?"0":map.get("N_WJS").toString());
	}
	
	JSONObject jo = new JSONObject();
	jo.put("city",mc);
	jo.put("jr_sa",sa);
	jo.put("jr_ja",ja);
	jo.put("nl_sa",n_sa);
	jo.put("nl_ja",n_ja);
	jo.put("jr_wj",wj);
	out.print(jo);
%>

