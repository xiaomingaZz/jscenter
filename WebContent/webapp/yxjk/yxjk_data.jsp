<%@page import="tdh.util.JSUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="tdh.framework.util.StringUtils"%>

<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	JdbcTemplateExt dbc= WebAppContext.getBeanEx(JSUtils.BI09_JDBCTEMPLATE_EXT);	
		List<Map<String,Object>> fy_List = dbc.queryForList("SELECT substring(FJM,1,2) DM,NAME_CITY MC FROM DC_CITY where FJM like '"+JSUtils.fjm.substring(0,1)+"[0-9A-Z]' and datalength(FJM) = 2 ");
		JdbcTemplateExt xdbc= WebAppContext.getBeanEx(JSUtils.XDB_JDBCTEMPLATE_EXT);
	 	String sql = "SELECT SUBSTRING(FY,1,2) DM,COUNT(*) SL FROM TR_DD WHERE   DDSJ >= '"+StringUtils.formatDate(new Date(),"yyyyMMdd")
	 		+"' and XMLTYPE='ASS' and FY like '"+JSUtils.fjm.substring(0,1)+"%' GROUP BY SUBSTRING(FY,1,2)";
	 	List<Map<String, Object>> list = xdbc.queryForList(sql);
	 	Map<String,Object> dmap = new HashMap<String,Object>();
	 	if(list!=null){
	 		for(Map<String,Object> mm:list){
		 		dmap.put(mm.get("DM").toString(),mm.get("SL"));
			}
	 	}
	 	JSONObject jo = new JSONObject();
	 	for(int i=0;i<fy_List.size();i++){
			Map<String,Object> map = fy_List.get(i);
			jo.put(map.get("DM"),0);
			if(dmap.containsKey(map.get("DM"))){
				jo.put(map.get("DM"),dmap.get(map.get("DM")));
			}
		}
	 	String sql2 = "Select count(*) SL from TR_DD WHERE RKSJ >='"+StringUtils.formatDate(new Date(),"yyyyMMdd")+"' and XMLTYPE='ASS' and DDSJ >= '"+StringUtils.formatDate(new Date(),"yyyyMMdd")+"'";	
 		List<Map<String, Object>> list2 = xdbc.queryForList(sql2);
	 	if(list2!=null&&list2.size()>0){
	 		jo.put("RK",list2.get(0).get("SL"));
	 	}else{
	 		jo.put("RK",0);
	 	}
	 	
	 	

		 StringBuilder chart1 = new StringBuilder();
		 StringBuilder chart2 = new StringBuilder();
		 StringBuilder chart3 = new StringBuilder();
		 StringBuilder chart4 = new StringBuilder();
		 StringBuilder chart5 = new StringBuilder();
		 StringBuilder chart6 = new StringBuilder();
		   
		   chart1.append("<div style=\"float:center;width:80px;margin-top:20px;\">");
		   chart1.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   /*chart1.append("<tr style=\"height:25px;background:349DFF;\">");
		   chart1.append("<td style=\"color:#ffffff;\">").append("武汉").append("</td>");
		   chart1.append("</tr>");
		   chart1.append("<tr style=\"height:25px;background:#ffffff;\">");
		   chart1.append("<td>").append(2000).append("</td>");
		   chart1.append("</tr>");
		   chart1.append("</table>");
		   chart1.append("<br>");
		   chart1.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   chart1.append("<tr style=\"height:25px;background:349DFF;\">");
		   chart1.append("<td style=\"color:#ffffff;\">").append("黄石").append("</td>");
		   chart1.append("</tr>");
		   chart1.append("<tr style=\"height:25px;background:#ffffff;\">");
		   chart1.append("<td>").append(1200).append("</td>");
		   chart1.append("</tr>");
		   chart1.append("</table>");
		   chart1.append("<br>");
		   chart1.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   chart1.append("<tr style=\"height:25px;background:349DFF;\">");
		   chart1.append("<td style=\"color:#ffffff;\">").append("十堰").append("</td>");
		   chart1.append("</tr>");
		   chart1.append("<tr style=\"height:25px;background:#ffffff;\">");
		   chart1.append("<td>").append(1300).append("</td>");
		   chart1.append("</tr>");*/
		   for(int i=0;i<fy_List.size();i++){
				Map<String,Object> map = fy_List.get(i);
				String dm = (String)map.get("DM");
				String mc = (String)map.get("MC");
				Integer sl = dmap.get(dm)==null?0:(Integer)dmap.get(dm);
				chart1.append("<tr style=\"height:25px;background:349DFF;\">");
				chart1.append("<td style=\"color:#ffffff;\">").append(mc).append("</td>");
				chart1.append("</tr>");
				chart1.append("<tr style=\"height:25px;background:#ffffff;\">");
				chart1.append("<td>").append(sl).append("</td>");
				chart1.append("</tr>");
		   }
		   chart1.append("</table>");
		   chart1.append("</div>");
		   
		   chart2.append("<div style=\"float:center;width:80px;margin-top:20px;\">");
		   chart2.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   chart2.append("<tr style=\"height:25px;background:349DFF;\">");
		   chart2.append("<td style=\"color:#ffffff;\">").append("瑞达前置").append("</td>");
		   chart2.append("</tr>");
		   chart2.append("<tr style=\"height:25px;background:#ffffff;\">");
		   chart2.append("<td>").append(1998).append("</td>");
		   chart2.append("</tr>");
		   chart2.append("</table>");
		   chart2.append("</div>");
		   
		   chart3.append("<div style=\"float:center;width:80px;margin-top:20px;\">");
		   chart3.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   chart3.append("<tr style=\"height:25px;background:349DFF;\">");
		   chart3.append("<td style=\"color:#ffffff;\">").append("服务队列").append("</td>");
		   chart3.append("</tr>");
		   chart3.append("</table>");
		   chart3.append("</div>");
		   
		   chart4.append("<div style=\"float:center;width:140px;margin-top:20px;border:solid 2px green;\">");
		   chart4.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"140\" style=\"text-align:center;border-collapse:separate;empty-cells:show;font-size:12px;\">");
		   chart4.append("<td>");
		   chart4.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"65\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   //今日到达TR_DD表的数据
		   Integer toTrdd = 0;
		   for(int i=0;i<fy_List.size();i++){
				Map<String,Object> map = fy_List.get(i);
				String dm = (String)map.get("DM");
				String mc = (String)map.get("MC");
				Integer sl = dmap.get(dm)==null?0:(Integer)dmap.get(dm);
				toTrdd += sl;
				chart4.append("<tr style=\"height:25px;background:349DFF;\">");
				chart4.append("<td style=\"color:#ffffff;\">").append(mc).append("</td>");
				chart4.append("</tr>");
				chart4.append("<tr style=\"height:25px;background:#ffffff;\">");
				chart4.append("<td>").append(sl).append("</td>");
				chart4.append("</tr>");
		   }
		   chart4.append("</table>");
		   chart4.append("</td>");
		   
		   chart4.append("<td>");
		   chart4.append("<table  cellspacing=\"1\" cellpadding=\"0\" width=\"75\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   chart4.append("<tr style=\"height:25px;background:green;\">");
		   chart4.append("<td style=\"color:#ffffff;\">").append("交换中心").append("</td>");
		   chart4.append("</tr>");
		   chart4.append("<tr style=\"height:25px;background:#ffffff;\">");
		   chart4.append("<td>").append(toTrdd).append("</td>");
		   chart4.append("</tr>");
		   chart4.append("</table>");
		   chart4.append("</td>");
		   
		   chart4.append("</table>");
		   chart4.append("</div>");
		   
		   chart5.append("<div style=\"float:center;width:80px;margin-top:20px;\">");
		   chart5.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   chart5.append("<tr style=\"height:25px;background:349DFF;\">");
		   chart5.append("<td style=\"color:#ffffff;\">").append("司法中心").append("</td>");
		   chart5.append("</tr>");
		   chart5.append("<tr style=\"height:25px;background:#ffffff;\">");
		   chart5.append("<td>").append(1998).append("</td>");
		   chart5.append("</tr>");
		   chart5.append("</table>");
		   chart5.append("</div>");
		   
		   chart6.append("<div style=\"float:center;width:80px;margin-top:20px;\">");
		   chart6.append("<table cellspacing=\"1\" cellpadding=\"0\" width=\"80\" style=\"text-align:center;border-collapse:separate;empty-cells:show;background:#5E87AE;font-size:12px;\">");
		   chart6.append("<tr style=\"height:25px;background:349DFF;\">");
		   chart6.append("<td style=\"color:#ffffff;\">").append("数据上报").append("</td>");
		   chart6.append("</tr>");
		   chart6.append("<tr style=\"height:25px;background:#ffffff;\">");
		   chart6.append("<td>").append(1998).append("</td>");
		   chart6.append("</tr>");
		   chart6.append("</table>");
		   chart6.append("</div>");
		   
		   
		 JSONObject json = new JSONObject();
		 json.put("chart1",chart1.toString());
		 json.put("chart2",chart2.toString());
		 json.put("chart3",chart3.toString());
		 json.put("chart4",chart4.toString());
		 json.put("chart5",chart5.toString());
		 json.put("chart6",chart6.toString());
		 out.print(json.toString());
 %>

                    
                    