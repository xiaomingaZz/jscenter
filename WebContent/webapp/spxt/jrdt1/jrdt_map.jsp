<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	List<Map<String,Object>> fylist ;
	String sql = "";
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)||dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DATALENGTH(DM_CITY) = 4 and DM_CITY like '"+JSUtils.fydm+"%'");
		sql = "select substring(FYDM,1,4) DM,sum(N_SAS) N_SAS,sum(N_JAS) N_JAS from DC_SPXT_SJC where TJRQ = '"+sdf.format(new Date())+"' group by substring(FYDM,1,4)";
		mc = JSUtils.fymc;
		dm = JSUtils.fydm;
	}else{
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DM_CITY like '"+dm+"%' and DM_CITY like '42%' ");
		sql = "select FYDM DM,sum(N_SAS) N_SAS,sum(N_JAS) N_JAS from DC_SPXT_SJC where TJRQ = '"+sdf.format(new Date())+"' and FYDM like '"+dm+"%' group by FYDM";
	}
	
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	String cvalue="";
	int count=1;
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> map= fylist.get(i);
		String ctmc = map.get("NAME_CITY").toString();
		String ctdm = map.get("DM_CITY").toString();
		int sa = 0;
		int ja = 0;
		for(Map<String,Object> mm:list){
			if(ctdm.equals(mm.get("DM"))){
				sa = mm.get("N_SAS")!=null?Integer.valueOf(mm.get("N_SAS").toString()):0;
				ja = mm.get("N_JAS")!=null?Integer.valueOf(mm.get("N_JAS").toString()):0;
				break;
			}
		}
		cvalue += "{name:\""+ctmc+"\",value:"+count+",id:\""+ctdm+"\",tip:'"+ctmc+"<br>---------<br>新收:"+sa+"件<br>结案:"+ja+"件'},"; 
		splist +=  "{start:"+count+",end:"+count+",label:\""+ctmc+"\",color:\""+color[i]+"\"},"; 
		count++;
	}
	
	if(cvalue.endsWith(",")){
		cvalue=cvalue.substring(0,cvalue.length()-1);
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
		    margin:'0 20 20 20',
		    fontFimaly:'微软雅黑'
		} 
	},
	color:['#FF7F50','#54FF9F'],
    series : [
          {
            name: "地图",
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
            data:[<%=cvalue %>]
        }
    ]
};
