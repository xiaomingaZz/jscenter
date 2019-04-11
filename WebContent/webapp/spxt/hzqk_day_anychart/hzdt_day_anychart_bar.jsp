<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.*"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
	String kssj = StringUtils.trim(request.getParameter("kssj"));
	String jssj = StringUtils.trim(request.getParameter("jssj"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	String ajlx = StringUtils.trim(request.getParameter("ajlx"));
	
	String lastyear = String.valueOf(Integer.parseInt(jssj.substring(0,4)) - 1);
	String kssj2 = (Integer.parseInt(lastyear) - 1) + kssj.substring(4,8);
	String jssj2 = lastyear + jssj.substring(4,8);
	
	if("".equals(mc)){
		mc = "全省";
	}
	int rotate = 0;
	
	String baseid = "";
	String name = "收案";
	String cond = " ID_DAY >='"+kssj+"' AND ID_DAY <='"+jssj+"' ";
	String cond2 = " ID_DAY >='"+kssj2+"' AND ID_DAY <='"+jssj2+"' ";
	String column = "SUM(SAS)";
	if("sas".equals(dl)){
		name = "收案";
		column = "sum(SAS)";
		baseid = "JSDSAS";
	}else if("jas".equals(dl)){
		name = "结案";
		column = "sum(JAS)";
		baseid = "JSDJAS";
	}else if("wjs".equals(dl)){
		name = "未结";
		column = "sum(WJS)";
		baseid = "JSDWJS";
		cond = " ID_DAY ='"+jssj+"' ";
		cond2 = " ID_DAY ='"+jssj2+"' ";
	}
	
	String ajlxname = "";
	String xtajlx = "";
	if(!"".equals(ajlx)){
		if("xsys".equals(ajlx)){
			cond += " AND ID_XTAJLX = '11' ";
			cond2 += " AND ID_XTAJLX = '11' ";
			ajlxname = "刑事一审";
			xtajlx = "11";
		}else if("msys".equals(ajlx)){
			cond += " AND ID_XTAJLX = '21' ";
			cond2 += " AND ID_XTAJLX = '21' ";
			ajlxname = "民事一审";
			xtajlx = "21";
		}else if("xzys".equals(ajlx)){
			cond += " AND ID_XTAJLX = '31' ";
			cond2 += " AND ID_XTAJLX = '31' ";
			ajlxname = "行政一审";
			xtajlx = "31";
		}
	}
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	
	//System.out.println("kssj-jssj-->"+kssj+"  "+jssj);
	//System.out.println("kssj2-jssj2-->"+kssj2+"  "+jssj2);

	List<Map<String,Object>> fylist = new ArrayList<Map<String,Object>>();
	String sql = "";
	String sql_tq = "";
	if(dm.length() == 2){
		sql = "select substring(ID_FYDM,1,2) FYDM,"+column+" NUM from FACT_SJC_DAY where "
			+ cond
			+ " group by substring(ID_FYDM,1,2)";
		sql_tq = "select substring(ID_FYDM,1,2) FYDM,"+column+" NUM from FACT_SJC_DAY where "
			+ cond2
			+ " group by substring(ID_FYDM,1,2)";
		fylist = bi09.queryForList("select DM_CITY,FJM DM ,NAME_CITY from DC_CITY where DATALENGTH(DM_CITY) = 4 AND ISNULL(SFJY,'') <> '1' order by DM_CITY asc ");
	}else{
		if(dm.endsWith("00")){
			rotate = 30;
			mc = "省院及中院";
			sql = "select substring(ID_FYDM,1,3) FYDM,"+column+" NUM from FACT_SJC_DAY where "
				+ cond
			  	+" and ID_FYDM like '"+fjm.substring(0,1)+"_0%' group by substring(ID_FYDM,1,3)";
			sql_tq = "select substring(ID_FYDM,1,3) FYDM,"+column+" NUM from FACT_SJC_DAY where "
				+ cond2
		  	  	+" and ID_FYDM like '"+fjm.substring(0,1)+"_0%' group by substring(ID_FYDM,1,3)";
			fylist = bi09.queryForList("select DM_CITY, FJM DM ,NAME_CITY from DC_CITY where FJM like  '"+fjm.substring(0,1)+"_0'  AND ISNULL(SFJY,'') <> '1' order by DM_CITY asc ");
		}else{
			sql = "select substring(ID_FYDM,1,3) FYDM,"+column+" NUM from FACT_SJC_DAY where "
				+ cond
			  	+" and ID_FYDM like '"+fjm+"%' group by substring(ID_FYDM,1,3)";
			sql_tq = "select substring(ID_FYDM,1,3) FYDM,"+column+" NUM from FACT_SJC_DAY where "
				+ cond2
		  	  	+" and ID_FYDM like '"+fjm+"%' group by substring(ID_FYDM,1,3)";
			fylist = bi09.queryForList("select DM_CITY, FJM DM ,NAME_CITY from DC_CITY where FJM like  '"+fjm+"%' AND FJM <> '"+fjm+"'  AND ISNULL(SFJY,'') <> '1' order by DM_CITY asc ");
		}
	}
	//System.out.println("hzdt bar sql-->"+sql);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	List<Map<String,Object>> list2 = bi09.queryForList(sql_tq);
	String xdata = "",data1 = "",data2 = "",xValue="",data3 = "";
	int total = 0;
	
	List<Map<String,Object>> bqlist = new ArrayList<Map<String,Object>>();
	List<Map<String,Object>> tqlist = new ArrayList<Map<String,Object>>();
	for(int i = 0 ; i < fylist.size() ; i++){
		Map<String,Object> mm = fylist.get(i);
		String ctmc = mm.get("NAME_CITY").toString();
		String ctdm = mm.get("DM_CITY").toString();
		int num =0;
		for(Map<String,Object> map:list){
			if(map.get("FYDM").equals(mm.get("DM"))){
				if(map.get("NUM") != null){
					num = Integer.valueOf(map.get("NUM").toString());
				}
				break;
			}
		}
		Map<String,Object> bqmap = new HashMap<String,Object>();
		bqmap.put("DM",ctdm);
		bqmap.put("MC",ctmc);
		bqmap.put("DATA",num);
		bqlist.add(bqmap);
		
		int num2 =0;
		for(Map<String,Object> map:list2){
			if(map.get("FYDM").equals(mm.get("DM"))){
				if(map.get("NUM") != null){
					num2 = Integer.valueOf(map.get("NUM").toString());
				}
				break;
			}
		}
		
		Map<String,Object> tqmap = new HashMap<String,Object>();
		tqmap.put("DM",ctdm);
		tqmap.put("MC",ctmc);
		tqmap.put("DATA",num2);
		tqlist.add(tqmap);
		
		
		total += num;
		
	}
	
	JSONObject json = new JSONObject();
	
	VelocityContext context = new VelocityContext();
	context.put("bqlist",bqlist);
	context.put("tqlist",tqlist);
	context.put("title",mc+ajlxname+"案件"+name+"分布情况("+total +")");
	
	json.put("bar",VelocityUtils.write("/anychart/bar.xml",context, request));
	out.print(json.toString());
	
%>
                  