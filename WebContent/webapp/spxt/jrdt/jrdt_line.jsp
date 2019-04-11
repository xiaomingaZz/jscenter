<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String stime = StringUtils.trim(request.getParameter("stime"));
	String etime = "";
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		mc = "全省";
 	}else if(dm.endsWith("00")){
 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
	}
	
	
	JSONObject json = new JSONObject();
	String sql ="select YMD ,HM from DC_SPXT_SSDT a where YMD = '"+sdf.format(new Date())+"' and HM = (select max(HM) from DC_SPXT_SSDT where YMD=a.YMD) "+
		" and FYDM like '"+dm+"%' "+ "group by YMD,HM";
	List<Map<String, Object>> list1=bi09.queryForList(sql);
	Map<String, Object> mm = new HashMap<String, Object>();
	if(list1!=null&&list1.size()>0){
		mm = list1.get(0);
	}
	if(mm.get("HM")!=null){
		etime = sdf.format(new Date())+mm.get("HM").toString();
	}else{
		etime = sdf.format(new Date())+"09:00";
	}
	
	sql = "select HM ";
	List<List<String>> series = new ArrayList<List<String>>();
	List<String> xdata=new ArrayList<String>();
	String[] fields = "N_SAS,N_JAS".split(",");
	for(int i=0;i<fields.length;i++){
		sql = sql + ", SUM("+fields[i]+") " +fields[i] ;
		series.add(new ArrayList<String>());
	}
	sql =sql +" from DC_SPXT_SSDT where YMD = '"+etime.substring(0, 8)+"' and HM <= '"+etime.substring(8)+"' ";
	if(!stime.equals("")){
		sql =sql + " and HM > '"+stime.substring(8)+"'";
	}
	sql += " and FYDM like '"+dm+"%' group by HM order by HM";
	List<Map<String, Object>> list=bi09.queryForList(sql);
	if(list!=null&&list.size()>0){
		for(int i=0;i<list.size();i++ ){
			Map<String, Object> map = list.get(i);
			xdata.add(map.get("HM").toString());
			for(int j=0;j<fields.length;j++){
				List<String> data = series.get(j);
				if(map.get(fields[j])!=null){
					data.add(map.get(fields[j]).toString());
				}else{
					data.add("0");
				}
			}
		}
	}else if(stime.equals("")){
		xdata.add("09:00");
		for(int j=0;j<fields.length;j++){
			series.get(j).add("0");
		}
	}
	json.put("city",mc);
	json.put("stime", etime);
	json.put("series",JSONArray.fromObject(series));
	json.put("xdata",JSONArray.fromObject(xdata));
	out.print(json);
%>
                    