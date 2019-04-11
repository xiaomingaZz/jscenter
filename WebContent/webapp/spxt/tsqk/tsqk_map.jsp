<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String mc = StringUtils.trim(request.getParameter("mc"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String type = StringUtils.trim(request.getParameter("type"));

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

	List<Map<String,Object>> fylist ;
	String sql="";
	String field1 = "";
	String field2 ="";
	
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)||dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DATALENGTH(DM_CITY) = 4 ");
		field1 = "substring(FYDM,1,4)";
		field2 = "substring(ID_FYDM,1,4)";
		mc = "江苏省";
		dm = JSUtils.fydm;
	}else{
		if(dm.length()==6){
			dm = dm.substring(0,4);
		}
		fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
		if(fylist.size()>0){
			mc = fylist.get(0).get("MC").toString();
		}
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DM_CITY like '"+dm+"%' ");
		field1 = "FYDM";
		field2 = "ID_FYDM";
	}
	String ktrq = sdf.format(new Date());
	if("jr".equals(type)){
		sql = "select "+field1+" DM,COUNT(AHDM) SL FROM DC_SPXT_KTQD where KTRQ='"+ktrq+"' and FYDM like '"+dm+"%' GROUP BY "+field1;	
	}else{
		sql = "select "+field2+" DM,SUM(KTSL) SL FROM DC_SPXT_KT where subString(ID_MTH,1,4) ='"+ktrq.substring(0,4)+"' and ID_FYDM like '"+dm+"%' GROUP BY "+field2;
	}
	
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	String cvalue = "";
	int count = 1;
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> map= fylist.get(i);
		String ctmc = map.get("NAME_CITY").toString();
		String ctdm = map.get("DM_CITY").toString();
		int sl = 0;
		for(Map<String,Object> mm:list){
			if(ctdm.equals(mm.get("DM"))){
				sl = mm.get("SL")!=null?Integer.valueOf(mm.get("SL").toString()):0;
				break;
			}
		}
		cvalue += "{name:\""+ctmc+"\",value:"+count+",id:\""+ctdm+"\",tip:'"+ctmc+"<br>---------<br>开庭案件:"+sl+"件'},"; 
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
        textStyle:{fontSize:26},
        formatter:function(param){
        	return param['data']['tip'];
        }
    },
    dataRange:{
    	show:false,
    	x:'left',
        y:'bottom',
        splitList:[<%=splist %>]
    },
    title : {show:true,x:'left',text: '<%=mc %>',
	     textStyle:{
		   fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
    series : [
          {
            name: "开庭数",
            type: 'map',
            mapType: '<%=dm %>',
            selectedMode : 'single',
            itemStyle:{
                normal:{
                	label:{show:true,textStyle:{fontSize:15}},
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
