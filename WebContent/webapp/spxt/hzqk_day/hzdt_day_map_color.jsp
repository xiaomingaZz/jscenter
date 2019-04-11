<%@page import="tdh.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String kssj = StringUtils.trim(request.getParameter("kssj"));
	String jssj = StringUtils.trim(request.getParameter("jssj"));
	String dl = StringUtils.trim(request.getParameter("dl"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String lx = StringUtils.trim(request.getParameter("lx"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	
	if(dm.length() == 6){
		dm = dm.substring(0,4);
		fjm = fjm.substring(0,2);
	}

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	String lastyear = String.valueOf(Integer.parseInt(jssj.substring(0,4)) - 1);
	String kssj2 = (Integer.parseInt(lastyear) - 1) + kssj.substring(4,8);
	String jssj2 = lastyear + jssj.substring(4,8);
	
	String name = "";
	String cond = "";
	if("xs".equals(lx)){
		cond = " AND ID_XTAJLX = '11' ";
		name = "刑事";
	}else if("ms".equals(lx)){
		cond = " AND ID_XTAJLX = '21' ";
		name = "民事";
	}else if("xz".equals(lx)){
		cond = " AND ID_XTAJLX = '31' ";
		name = "行政";
	}
	
	String column = "SUM(SAS)";
	String where = " where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+jssj+"' ";
	
	if("sas".equals(dl)){
		column = " SUM(SAS) ";
		name += "新收";
	}else if("jas".equals(dl)){
		column = " SUM(JAS) ";
		name += "结案";
	}else if("wjs".equals(dl)){
		column = " SUM(WJS) ";
		where = " WHERE ID_DAY = '"+jssj+"'";
		name += "未结";
	}

	List<Map<String,Object>> fylist = new ArrayList<Map<String,Object>>();
	String sql = "";
	String sql_tq = "";
	if(dm.length() == 2 || dm.length() == 4 && dm.endsWith("00")){
		mc = "江苏省";
		fylist = bi09.queryForList("select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 2 AND FJM LIKE '"+fjm.substring(0,1)+"%' order by FJM ");
		sql = "SELECT substring(ID_FYDM,1,2) DM,SUM(SAS) AS SAS,SUM(JAS) AS JAS, "
		       +" SUM(CASE ID_DAY when '"+jssj+"' then WJS else 0 end) as WJS"
		       +" FROM  FACT_SJC_DAY "
		       +" WHERE ID_DAY>='"+kssj+"' and ID_DAY<= '"+jssj+"' and  ID_FYDM like '"+fjm.substring(0,1)+"%'  "
		       +cond
		       +" GROUP BY substring(ID_FYDM,1,2) ";
		sql_tq = "SELECT substring(ID_FYDM,1,2) DM,SUM(SAS) AS SAS,SUM(JAS) AS JAS, "
		       +" SUM(CASE ID_DAY when '"+jssj+"' then WJS else 0 end) as WJS"
		       +" FROM  FACT_SJC_DAY "
		       +" WHERE ID_DAY>='"+kssj2+"' and ID_DAY<= '"+jssj2+"' and  ID_FYDM like '"+fjm.substring(0,1)+"%'  "
		       +cond
		       +" GROUP BY substring(ID_FYDM,1,2) ";
	}else if(dm.length() == 4){
		fylist = bi09.queryForList("select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 3 AND FJM LIKE '"+fjm+"%' order by FJM ");
		sql = "SELECT substring(ID_FYDM,1,3) DM,SUM(SAS) AS SAS,SUM(JAS) AS JAS, "
		       +" SUM(CASE ID_DAY when '"+jssj+"' then WJS else 0 end) as WJS"
		       +" FROM  FACT_SJC_DAY "
		       +" WHERE ID_DAY>='"+kssj+"' and ID_DAY<= '"+jssj+"' and  ID_FYDM like '"+fjm+"%'  "
		       +cond
		       +" GROUP BY substring(ID_FYDM,1,3) ";
		sql_tq = "SELECT substring(ID_FYDM,1,3) DM,SUM(SAS) AS SAS,SUM(JAS) AS JAS, "
		       +" SUM(CASE ID_DAY when '"+jssj+"' then WJS else 0 end) as WJS"
		       +" FROM  FACT_SJC_DAY "
		       +" WHERE ID_DAY>='"+kssj2+"' and ID_DAY<= '"+jssj2+"' and  ID_FYDM like '"+fjm+"%'  "
		       +cond
		       +" GROUP BY substring(ID_FYDM,1,3) ";
	}
	
    //System.out.println("hzdt map sql-->"+sql);
    List<Map<String,Object>> list = bi09.queryForList(sql);
    List<Map<String,Object>> list2 = bi09.queryForList(sql_tq);
	
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	Double max = 0.0;
	Double min = 0.0;
	
	String value = "";
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> map= fylist.get(i);
		String _mc = map.get("NAME_CITY").toString();
		String _dm = map.get("DM").toString();
		if(_dm.length()==1 || _dm.endsWith("0")){
			continue;
		}
		int sas = 0, jas = 0, wjs = 0;
		for(Map<String,Object> mm:list){
			if(_dm.equals(mm.get("DM"))){
				sas = mm.get("SAS")!=null?Integer.valueOf(mm.get("SAS").toString()):0;
				jas = mm.get("JAS")!=null?Integer.valueOf(mm.get("JAS").toString()):0;
				wjs = mm.get("WJS")!=null?Integer.valueOf(mm.get("WJS").toString()):0;
				break;
			}
		}
		int sas2 = 0, jas2 = 0, wjs2 = 0;
		for(Map<String,Object> mm:list2){
			if(_dm.equals(mm.get("DM"))){
				sas2 = mm.get("SAS")!=null?Integer.valueOf(mm.get("SAS").toString()):0;
				jas2 = mm.get("JAS")!=null?Integer.valueOf(mm.get("JAS").toString()):0;
				wjs2 = mm.get("WJS")!=null?Integer.valueOf(mm.get("WJS").toString()):0;
				break;
			}
		}
		
		int cz = 0;
		Double tbl = 0.0;;
		String sj = "增长";
		
		if("sas".equals(dl)){
			cz = sas - sas2;
			if(sas2 > 0){
				tbl = Double.parseDouble(StringUtils.formatDouble(cz*1.0/sas2*100,"#0.00"));
			}
		}else if("jas".equals(dl)){
			cz = jas - jas2;
			if(jas2 > 0){
				tbl = Double.parseDouble(StringUtils.formatDouble(cz*1.0/jas2*100,"#0.00"));
			}
		}else if("wjs".equals(dl)){
			cz = wjs - wjs2;
			if(wjs2 > 0){
				tbl = Double.parseDouble(StringUtils.formatDouble(cz*1.0/wjs2*100,"#0.00"));
			}
		}
		
		if(max < tbl){
			max = tbl;
		}
		if(min > cz){
			min = tbl;
			sj = "下降";
		}
		//value += "{name:\""+_mc+"\",value:"+cz+",id:\""+i+"\",tip:'"+_mc+"<br>---------<br>收案:"+sas+"件<br>结案:"+jas+"件<br>未结:"+wjs+"件'},";
		value += "{name:\""+_mc+"\",value:"+tbl+",id:\""+i+"\",tip:'"+_mc+"<br>---------<br>"+name+"<br>同比"+sj+"<br>"+Math.abs(tbl)+"%("+cz+"件)'},"; 
	}
	
	
	if(value.endsWith(",")){
		value=value.substring(0,value.length()-1);
	}
%>

option = {
    tooltip : {
        trigger: 'item',
        textStyle:{fontSize:20,align:'left'},
        zlevel:99999,
        enterable:true,
        formatter:function(param){
        	return param['data']['tip'];
        }
    },
    dataRange:{
    	max:<%=max %>,
    	min:<%=min %>,
    	//splitNumber:5,
    	show:true,
    	calculable:true,
    	x:'left',
        y:'400',
        color:['red','orange','#97FFFF','#87CEEB','#5CACEE'],
        //color:["#ff7f50", "#87cefa", "#da70d6", "#32cd32", "#6495ed"],
        precision:2
    },
    title : {show:true,x:'left',text: '江苏法院',
	     textStyle:{
		    fontSize: 20,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		}
	},
    /*legend: {
        data:['新收数','结案数'],
        textStyle:{color:'blue'},
        x:'center',
        y:'10',
        selectedMode:'single',
        selected: {'新收数':true,'结案数' : false}
    },*/
    series : [
          {
            name: "收案数",
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
