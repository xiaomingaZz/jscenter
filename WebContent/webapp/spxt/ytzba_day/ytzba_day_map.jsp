<%@page import="tdh.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String  kssj = StringUtils.trim(request.getParameter("kssj"));
	String  jssj = StringUtils.trim(request.getParameter("jssj"));
	String  maxjssj = StringUtils.trim(request.getParameter("maxjssj"));
	String  dl = StringUtils.trim(request.getParameter("dl"));
	String  dm = StringUtils.trim(request.getParameter("dm"));
	String  fjm = StringUtils.trim(request.getParameter("fjm"));
	String  mc = StringUtils.trim(request.getParameter("mc"));
	
	String  zw = StringUtils.trim(request.getParameter("zw"));
	if("0000".equals(zw)){
		zw = "1111";
	}
	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	String where = " where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+maxjssj+"' ";
	String whereTj = " where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+jssj+"' ";
	List<Map<String,Object>> fylist = new ArrayList<Map<String,Object>>();
	String sql = "";
	String sqlWj = "";
	String sqlTj = "";
	
	if(dm.length() == 2 || dm.length() == 4 && dm.endsWith("00")){
		mc = "江苏省";
		fylist = bi09.queryForList("select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 2 AND FJM LIKE '"+fjm.substring(0,1)+"%' order by FJM ");
		sql = "select substring(ID_FYDM,1,2) DM,SUM(SAS_"+zw+") AS SAS,SUM(JAS_"+zw+") AS JAS "
				+" from FACT_YTZBA_SAJA "
				+where 
				+" group by substring(ID_FYDM,1,2)";
		sqlWj = "select substring(ID_FYDM,1,2) DM,"
		       +" SUM(CASE ID_DAY when '"+maxjssj+"' then WJS_"+zw+" else 0 end) as WJS"
				+" from FACT_YTZBA_WJ "
				+where 
				+" group by substring(ID_FYDM,1,2)";
		sqlTj = "select substring(ID_FYDM,1,2) DM,SUM(SAS_"+zw+") AS SAS,SUM(JAS_"+zw+") AS JAS "
				+" from FACT_YTZBA_SAJA "
				+whereTj
				+" group by substring(ID_FYDM,1,2)";
	}else{
		fylist = bi09.queryForList("select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 3 AND FJM LIKE '"+fjm+"%' order by FJM ");
		sql = "select substring(ID_FYDM,1,3) DM,SUM(SAS_"+zw+") AS SAS,SUM(JAS_"+zw+") AS JAS "
				+" from FACT_YTZBA_SAJA "
				+where 
				+" AND ID_FYDM LIKE '"+fjm+"%'"
				+" group by substring(ID_FYDM,1,3)";
		sqlWj = "select substring(ID_FYDM,1,3) DM,"
		       +" SUM(CASE ID_DAY when '"+maxjssj+"' then WJS_"+zw+" else 0 end) as WJS"
				+" from FACT_YTZBA_WJ "
				+where
				+" group by substring(ID_FYDM,1,3)";
		sqlTj = "select substring(ID_FYDM,1,3) DM,SUM(SAS_"+zw+") AS SAS,SUM(JAS_"+zw+") AS JAS "
				+" from FACT_YTZBA_SAJA "
				+whereTj
				+" group by substring(ID_FYDM,1,3)";
	}
	
	Map<String,Integer> saMap = new HashMap<String,Integer>();
	Map<String,Integer> jaMap = new HashMap<String,Integer>();
	Map<String,Integer> wjMap = new HashMap<String,Integer>();
	Map<String,Integer> satjMap = new HashMap<String,Integer>();
	Map<String,Integer> jatjMap = new HashMap<String,Integer>();
	
	System.out.println("ytzba day map sql-->"+sql);
	System.out.println("ytzba day map sqlWj-->"+sqlWj);
	List<Map<String,Object>> list = bi09.queryForList(sql);
	List<Map<String,Object>> listWj = bi09.queryForList(sqlWj);
	
	for(Map<String,Object> map : list){
		String dx = (String)map.get("DM");
		int sas = 0,jas = 0;
		if(map.get("JAS") != null){
			jas = (Integer)map.get("JAS");
		}
		if(map.get("SAS") != null){
			sas = (Integer)map.get("SAS");
		}
		jaMap.put(dx,jas);
		saMap.put(dx,sas);
	}
	for(Map<String,Object> map : listWj){
		String dx = (String)map.get("DM");
		int num = 0;
		if(map.get("WJS") != null){
			num = (Integer)map.get("WJS");
		}
		wjMap.put(dx,num);
	}
	
	String value = "";
	String splist = "";
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	
	if(jssj.equals(maxjssj)){
		//统计截止时间即最大未结时间
		
		int count = 1;
		for(int i=0;i<fylist.size();i++){
			Map<String,Object> map= fylist.get(i);
			String dx = (String)map.get("DM");
			String _mc = map.get("NAME_CITY").toString();
			int sas = saMap.get(dx)==null?0:saMap.get(dx);
			int jas = jaMap.get(dx)==null?0:jaMap.get(dx);
			int wjs = wjMap.get(dx)==null?0:wjMap.get(dx);
			int sls = jas+wjs;
			
			value += "{name:\""+_mc+"\",value:"+count+",id:\""+i+"\",tip:'"+_mc+"<br>---------<br>受理:"+sls+"件<br>收案:"+sas+"件<br>结案:"+jas+"件'},"; 
			splist +=  "{start:"+count+",end:"+count+",label:\""+_mc+"\",color:\""+color[i]+"\"},"; 
			count++;
		}
	}else{
		
		List<Map<String,Object>> listTj = bi09.queryForList(sqlTj);
		for(Map<String,Object> map : listTj){
			String dx = (String)map.get("DM");
			int sas = 0,jas = 0;
			if(map.get("JAS") != null){
				jas = (Integer)map.get("JAS");
			}
			if(map.get("SAS") != null){
				sas = (Integer)map.get("SAS");
			}
			jatjMap.put(dx,jas);
			satjMap.put(dx,sas);
		}
		
		int count = 1;
		for(int i=0;i<fylist.size();i++){
			Map<String,Object> map= fylist.get(i);
			String dx = (String)map.get("DM");
			String _mc = map.get("NAME_CITY").toString();
			int sas = saMap.get(dx)==null?0:saMap.get(dx);
			int jas = jaMap.get(dx)==null?0:jaMap.get(dx);
			int wjs = wjMap.get(dx)==null?0:wjMap.get(dx);
			int jcs = jas+wjs-sas;
			
			int sastj = satjMap.get(dx)==null?0:satjMap.get(dx);
			int jastj = jatjMap.get(dx)==null?0:jatjMap.get(dx);
			
			int sls = sastj+jcs;
			
			value += "{name:\""+_mc+"\",value:"+count+",id:\""+i+"\",tip:'"+_mc+"<br>---------<br>受理:"+sls+"件<br>收案:"+sastj+"件<br>结案:"+jastj+"件'},"; 
			splist +=  "{start:"+count+",end:"+count+",label:\""+_mc+"\",color:\""+color[i]+"\"},"; 
			count++;
		}
		
	}
	
	if(value.endsWith(",")){
		value=value.substring(0,value.length()-1);
		splist=splist.substring(0,splist.length()-1);
	}
%>

option = {
    tooltip : {
        trigger: 'item',
         textStyle:{fontSize:26,align:'left'},
        formatter:function(param){
        	return param['data']['tip'];
        }
    },
    dataRange:{
    	show:false,
    	x:'left',
        y:'bottom',
        precision:0,
        splitList:[<%=splist %>]
    },
    title : {show:true,x:'left',text: '<%=mc %>',
	     textStyle:{
		    fontSize: 22,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    
    series : [
          {
            name: "案件数",
            type: 'map',
            mapType: '<%=dm %>',
            selectedMode : 'single',
            itemStyle:{
                normal:{
                	label:{show:true,textStyle:{fontSize:15,color:'#333333'}},
                    borderColor:'aqua',
                    borderWidth:1.0
                },
                emphasis:{
                	label:{show:true}
                }
            },
            data:[<%=value %>]
        }
    ]
};
