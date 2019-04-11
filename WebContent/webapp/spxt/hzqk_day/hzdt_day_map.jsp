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
	//String dm = StringUtils.trim(request.getParameter("dm"));
	String dm = JSUtils.fydm;
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	String mc = StringUtils.trim(request.getParameter("mc"));

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	String column = "SUM(SAS)";
	String where = " where ID_DAY >= '"+kssj+"' AND ID_DAY <= '"+jssj+"' ";
	String name = "";
	if("sas".equals(dl)){
		column = " SUM(SAS) ";
		name = "新收";
	}else if("jas".equals(dl)){
		column = " SUM(JAS) ";
		name = "结案";
	}else if("wjs".equals(dl)){
		column = " SUM(WJS) ";
		where = " WHERE ID_DAY = '"+jssj+"'";
		name = "未结";
	}

	List<Map<String,Object>> fylist = new ArrayList<Map<String,Object>>();
	String sql = "";
	if(dm.length() == 2 || dm.length() == 4 && dm.endsWith("00")){
		mc = JSUtils.fymc;
		fylist = bi09.queryForList("select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 2 AND FJM LIKE '"+fjm.substring(0,1)+"%'  order by FJM ");
		sql = "SELECT substring(ID_FYDM,1,2) DM,SUM(SAS) AS SAS,SUM(JAS) AS JAS, "
		       +" SUM(CASE ID_DAY when '"+jssj+"' then WJS else 0 end) as WJS"
		       +" FROM  FACT_SJC_DAY "
		       +" WHERE ID_DAY>='"+kssj+"' and ID_DAY<= '"+jssj+"' and  ID_FYDM like '"+fjm.substring(0,1)+"%'  GROUP BY substring(ID_FYDM,1,2) ";
	}else if(dm.length() == 4){
		fylist = bi09.queryForList("select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 3 AND FJM LIKE '"+fjm+"%' order by FJM ");
		sql = "SELECT substring(ID_FYDM,1,3) DM,SUM(SAS) AS SAS,SUM(JAS) AS JAS, "
		       +" SUM(CASE ID_DAY when '"+jssj+"' then WJS else 0 end) as WJS"
		       +" FROM  FACT_SJC_DAY "
		       +" WHERE ID_DAY>='"+kssj+"' and ID_DAY<= '"+jssj+"' and  ID_FYDM like '"+fjm+"%'  GROUP BY substring(ID_FYDM,1,3) ";
	}
	
    //System.out.println("hzdt map sql-->"+sql);
    List<Map<String,Object>> list = bi09.queryForList(sql);
	
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	int max=100;
	
	String value = "";
	int count=1;
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
		if(max < sas){
			max = sas;
		}
		value += "{name:\""+_mc+"\",value:"+count+",id:\""+i+"\",tip:'"+_mc+"<br>---------<br>收案:"+sas+"件<br>结案:"+jas+"件<br>未结:"+wjs+"件'},"; 
		splist +=  "{start:"+count+",end:"+count+",label:\""+_mc+"\",color:\""+color[i]+"\"},"; 
		count++;
	}
	
	
	if(value.endsWith(",")){
		value=value.substring(0,value.length()-1);
		splist=splist.substring(0,splist.length()-1);
	}
%>

option = {
    tooltip : {
        trigger: 'item',
         textStyle:{fontSize:16,align:'left'},
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
    title : {show:false,x:'left',text: '<%=mc %>',
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
