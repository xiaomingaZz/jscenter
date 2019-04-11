<%@page import="tdh.util.JSUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	String mc = StringUtils.trim(request.getParameter("mc"));
	 	String type = StringUtils.trim(request.getParameter("type"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	
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
		
	 	List<Map<String, Object>> series = new ArrayList<Map<String, Object>>();
	 	Map<String, Object> m = new HashMap<String, Object>();
		m.put("name","刑事");m.put("dm", "1");
		series.add(m);
		Map<String, Object> m1 = new HashMap<String, Object>();
		m1.put("name","民事");m1.put("dm", "2");
		series.add(m1);
		Map<String, Object> m2 = new HashMap<String, Object>();
		m2.put("name","行政");m2.put("dm", "3");
		series.add(m2);
		Map<String, Object> m3 = new HashMap<String, Object>();
		m3.put("name","赔偿");m3.put("dm", "4");
		series.add(m3);
		Map<String, Object> m4 = new HashMap<String, Object>();
		m4.put("name","执行");m4.put("dm", "5");
		series.add(m4);
		Map<String, Object> m5 = new HashMap<String, Object>();
		m5.put("name","申诉申请再审");m5.put("dm", "6");
		series.add(m5);
		
	
		
		String sql = "";
		String name="";
		String tjrq = sdf.format(new Date());
		String lx = "SA";
		if(type.equals("sa")){
			name = "收案数";
			lx = "SA";
			sql = "select subString(XTAJLX,1,1) DM,sum(N_SAS) SL from DC_SPXT_SJC where TJRQ = '"+tjrq+"' and FYDM like '"+dm+"%' group by subString(XTAJLX,1,1)";
		}else{
			name = "结案数";
			lx = "JA";
			sql = "select subString(XTAJLX,1,1) DM,sum(N_JAS) SL from DC_SPXT_SJC where TJRQ = '"+tjrq+"' and FYDM like '"+dm+"%' group by subString(XTAJLX,1,1)";
		}
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String data1 ="";
	 	int sa_sl = 0;
	 	int z_sl = 0;
	 	for(Map<String,Object> map:list){
	 		z_sl += map.get("SL")!=null?Integer.valueOf(map.get("SL").toString()):0;
	 	}
	 	int t_sl = 0;
	 	for(int i=0;i<series.size();i++){
	 		Map<String,Object> mm = series.get(i);
	 		String lxdm = mm.get("dm").toString();
	 		String lxmc = mm.get("name").toString();
	 		int sl = 0;
	 		for(Map<String,Object> map:list){
	 			if(mm.get("dm").equals(map.get("DM"))){
	 				sl = map.get("SL")!=null?Integer.valueOf(map.get("SL").toString()):0;
	 				break;
	 			}
	 		}
	 		sa_sl +=sl;
	 		data1 += "{'baseid':'JS0001','name':'"+lxmc+"','value':"+sl+",'dm':'"+dm+"','kssj':'"+tjrq+"','lx':'"+lx+"','ajlx':'"+lxdm+"'},";
	 	}
	 	data1 += "{'baseid':'JS0021','name':'其他','value':"+(z_sl-sa_sl)+",'dm':'"+dm+"','kssj':'"+tjrq+"','lx':'"+lx+"','ajlx':''},";
 %>
option = {
     title : {show:true,x:'center',text: '<%=mc %>案件类型组成情况(<%=z_sl %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    tooltip : {show:true,trigger: 'item',formatter:'{a}<br>{b} : {c} ({d}%)'},
    legend: {
        orient : 'vertical' ,
        x : 'left',
        y : 'center',
        data:["刑事","民事","行政","执行","赔偿","申诉申请再审","其他"]
    },
    series : [
        {
            name:'<%=name %>',
            type:'pie',
            radius : [0,170],
            center: ['50%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=data1.substring(0,data1.length()-1) %>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    