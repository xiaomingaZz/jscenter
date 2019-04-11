<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.CalendarUtil"%>
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
	 	series = bi09.queryForList("SELECT CODE_SPCX dm,NAME_SPCX name FROM DIM_SPCX ");
	 	
	 	String sql = "select ID_SPCX DM,SUBSTRING(ID_XTAJLX,1,1) DM2,"+column+" NUM from FACT_SJC_DAY "
	 				+ " where "
	 				+ cond
 					+ " and ID_FYDM like '"+fjm+"%' "
 					+ " group by ID_SPCX,SUBSTRING(ID_XTAJLX,1,1) ";
	 	//System.out.println("sql pie2-->"+sql);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String x = "";
	 	String data1 ="";
	 	
	 	//构造数据
	 	Map<String,Map<String,Integer>> datamap = new HashMap<String,Map<String,Integer>>();
	 	for(Map<String,Object> m : list){
	 		String cx = (String)m.get("DM");
	 		String ajlx = (String)m.get("DM2");
	 		int num = (Integer)m.get("NUM");
	 		if(datamap.get(cx) == null){
	 			Map<String,Integer> map = new HashMap<String,Integer>();
	 			map.put(ajlx,num);
	 			
	 			datamap.put(cx,map);
	 		}else{
	 			datamap.get(cx).put(ajlx,num);
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
	 	
	 	for(int i = 0 ; i < series.size() ; i++){
	 		Map<String,Object> mm = series.get(i);
	 		String _dm = (String)mm.get("dm");
	 		String _name = (String)mm.get("name");
	 		int num = 0;
	 		num = dmap.get(_dm) == null?0:dmap.get(_dm);
	 		int xs = 0,ms = 0,xz = 0;
	 		Map<String,Integer> xmx = datamap.get(_dm);
	 		if(xmx != null){
	 			if(xmx.get("1") != null){
	 				xs = xmx.get("1");
	 			}
				if(xmx.get("2") != null){
					ms = xmx.get("2");
	 			}
				if(xmx.get("3") != null){
					xz = xmx.get("3");
				}
	 		}
	 		if("4".equals(_dm)){
	 			//data1 = data1 +"{'name':'"+_name+"','value':"+num
	 			//+",'tip':'"+_name+":"+num+"("+StringUtils.formatDouble(num*1.0/total*100,"#0.00")+"%)"
	 			//+"<br>---------<br>其他:"+num+"件'},";
	 			
	 			data1 += "{'baseid':'"+baseid+"',name:\""+_name+"\",value:"+num+",tip:'"+_name+":"+num+"("+StringUtils.formatDouble(num*1.0/total*100,"#0.00")+"%)"
	 			+"<br>---------<br>刑事:"+xs+"件<br>民事:"+ms+"件<br>行政:"+xz+"件','ctdm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','spcx':'"+_dm+"'},";
	 			
	 		}else{
	 			data1 += "{'baseid':'"+baseid+"',name:\""+_name+"\",value:"+num+",tip:'"+_name+":"+num+"("+StringUtils.formatDouble(num*1.0/total*100,"#0.00")+"%)"
	 			+"<br>---------<br>刑事:"+xs+"件<br>民事:"+ms+"件<br>行政:"+xz+"件','ctdm':'"+dm+"','kssj':'"+kssj+"','jssj':'"+jssj+"','spcx':'"+_dm+"'},";
	 			//data1 = data1 +"{'name':'"+_name+"','value':"+num
	 			//+",'tip':'"+_name+":"+num+"("+StringUtils.formatDouble(num*1.0/total*100,"#0.00")+"%)"
	 			//+"<br>---------<br>刑事:"+xs+"件<br>民事:"+ms+"件<br>行政:"+xz+"件'},";
	 		}
	 		
 			
	 	}
	 	x = "'一审','二审','再审','其他'";
 %>
option = {
     title : {show:false,x:'center',text: '<%=mc %>审判程序<%=name %>组成情况(<%=total %>)',
	     textStyle:{
		    fontSize: 20,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    tooltip : {
    	show:true,
        trigger: 'item',
        formatter:function(param){
        	return param['data']['tip'];
        }
        //formatter:"{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient : 'vertical' ,
        x : 'left',
        y : 'center',
        data:[<%=x %>]
    },
    series : [
        {
            name:'收案数',
            type:'pie',
            radius : [50,100],
            center: ['60%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=data1.substring(0,data1.length()-1) %>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    