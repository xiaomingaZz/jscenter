<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	Enumeration en = request.getParameterNames();
	StringBuffer sb = new StringBuffer();
	while (en.hasMoreElements()) {
		String name = StringUtils.trim(en.nextElement());
		if ("".equals(name)||"ver".equals(name)||"KSSJ".equals(name)||"JSSJ".equals(name)||"FLAG".equals(name)
				||"BASEID".equals(name)||"FYDM".equals(name)||"submitform".equals(name)
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
	
	
	String baseid = StringUtils.trim(request.getParameter("BASEID"));
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	String kssj = StringUtils.trim(request.getParameter("KSSJ"));
	String jssj = StringUtils.trim(request.getParameter("JSSJ"));
	int len = 2;
	if(fydm==null||fydm.equals("")||fydm.length()==2){
		len = 2;
		fydm = JSUtils.fydm;
	}else if(fydm.length()==4){
		len = 4;
	}else{
		len = 6;
	}
	List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DATALENGTH(DM_CITY) >= "+len+" and DM_CITY like '"+fydm+"%' and isnull(SFJY,'0') <> '1' order by DM_CITY");
	List<Map<String,Object>> list0 = bi09.queryForList("select BASEID,COND from T_BASE where BASEID = '"+baseid+"'");
	Map<String,Integer> vmap = new HashMap<String,Integer>();
	if(list0.size()>0){
		String cond = list0.get(0).get("COND").toString();
		cond = cond.replace("@KSSJ@",kssj).replace("@JSSJ@",jssj).replace("@COND@",sb.toString());
		
		List<Map<String,Object>> list = bi09.queryForList("select A.FYDM DM ,COUNT(A.AHDM) SL " +cond+" AND ISNULL(A.FYDM,'')<>'' group by A.FYDM");
		for(Map<String,Object> mm:list){
			String dm = mm.get("DM").toString();
			int sl = mm.get("SL")==null?0:Integer.valueOf(mm.get("SL").toString());
			vmap.put(dm,sl);
			if(vmap.containsKey(dm.substring(0,4))){
				vmap.put(dm.substring(0,4),sl+vmap.get(dm.substring(0,4)));
			}else{
				vmap.put(dm.substring(0,4),sl);
			}
			if(vmap.containsKey(dm.substring(0,2))){
				vmap.put(dm.substring(0,2),sl+vmap.get(dm.substring(0,2)));
			}else{
				vmap.put(dm.substring(0,2),sl);
			}
		}
	}
	
	JSONArray ja = new JSONArray();
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> mm = fylist.get(i);
		String dm = mm.get("DM").toString();
		String mc = mm.get("MC").toString();
		int sl = vmap.containsKey(dm)?vmap.get(dm):0;
		JSONObject jo = new JSONObject();
		jo.put("id", dm);
		jo.put("pId",dm.substring(0,dm.length()-2));
		jo.put("name",mc+"("+sl+")");
		ja.add(jo);
	}
	out.print(ja);
%>