<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.CalendarUtil"%>
<%@page import="tdh.util.*"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	String kssj = StringUtils.trim(request.getParameter("kssj"));
	 	String jssj = StringUtils.trim(request.getParameter("jssj"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	String fjm = StringUtils.trim(request.getParameter("fjm"));
	 	String mc = StringUtils.trim(request.getParameter("mc"));
	 	String dl = StringUtils.trim(request.getParameter("dl"));
	 	
	 	if("".equals(mc)){
			mc = "全省";
		}
	 	
	 	String cond = " ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+jssj+"' ";
	 	String name = "收案";
		String column = "SUM(SAS)";
		String baseid="JSDSAS";
		if("sas".equals(dl)){
			name = "收案";
			column = "sum(SAS)";
		}else if("jas".equals(dl)){
			name = "结案";
			column = "sum(JAS)";
			baseid = "JSDJAS";
		}else if("wjs".equals(dl)){
			name = "未结";
			column = "sum(WJS)";
			baseid = "JSDWJS";
			cond = " ID_DAY = '"+jssj+"' ";
		}
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	
	 	List<Map<String, Object>> series = new ArrayList<Map<String, Object>>();
	 	series = bi09.queryForList("SELECT CODE_AJXZ dm,NAME_AJXZ name FROM DIM_AJXZ ");
	 	
		String sql = "select ID_AJLX DM,ID_SPCX DM2,"+column+" NUM from FACT_SJC_DAY "
			+" where "+ cond+" and ID_FYDM like '"+fjm+"%' group by ID_AJLX,ID_SPCX ";
		//System.out.println("hzdt pie1 sql-->"+sql);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String x = "";
	 	String data1 ="";
	 	
	 	//构造数据
	 	Map<String,Map<String,Integer>> datamap = new HashMap<String,Map<String,Integer>>();
	 	for(Map<String,Object> m : list){
	 		String ajxz = (String)m.get("DM");
	 		String cx = (String)m.get("DM2");
	 		int num = (Integer)m.get("NUM");
	 		if(datamap.get(ajxz) == null){
	 			Map<String,Integer> map = new HashMap<String,Integer>();
	 			map.put(cx,num);
	 			
	 			datamap.put(ajxz,map);
	 		}else{
	 			datamap.get(ajxz).put(cx,num);
	 		}
	 	}
	 	
	 	//计算总数
	 	Map<String,Integer> dmap = new HashMap<String,Integer>();
	 	int total = 0;
	 	for(String s : datamap.keySet()){
	 		int count = 0;
	 		for(String ss : datamap.get(s).keySet()){
	 			count += datamap.get(s).get(ss);
	 			total += datamap.get(s).get(ss);
	 		}
	 		dmap.put(s,count);
	 	}
	 	
	 	
	 	List<Map<String,Object>> relist = new ArrayList<Map<String,Object>>();
	 	for(int i = 0 ; i < series.size() ; i++){
	 		Map<String,Object> mm = series.get(i);
	 		String _dm = (String)mm.get("dm");
	 		String _name = (String)mm.get("name");
	 		int num = 0;
	 		num = dmap.get(_dm) == null?0:dmap.get(_dm);
	 		
	 		Map<String,Object> reMap = new HashMap<String,Object>();
	 		reMap.put("DM",_dm);
	 		reMap.put("MC",_name);
	 		reMap.put("DATA",num);
	 		relist.add(reMap);
	 	}
	 	
	 	JSONObject json = new JSONObject();
		VelocityContext context = new VelocityContext();
		context.put("bqlist",relist);
		context.put("title",mc+"案件类型"+name+"组成情况("+total+")");
		
		json.put("pie",VelocityUtils.write("/anychart/pie.xml",context, request));
	 	out.print(json.toString());
 %>
                    