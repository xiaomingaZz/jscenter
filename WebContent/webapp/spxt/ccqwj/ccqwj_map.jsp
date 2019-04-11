<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.util.Sort"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	
	String dm = StringUtils.trim(request.getParameter("dm"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	String type = StringUtils.trim(request.getParameter("type"));
	if(StringUtils.isEmpty(type)) type ="ss";
	String typemc = "诉讼";
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	
	List<Map<String,Object>> fylist ;
	String sql = "";
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)||dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DATALENGTH(DM_CITY) = 4 ");
		sql = "select substring(FYDM,1,4) DM,SUM(CASE WHEN dateadd(month,12,LARQ) < getdate() THEN 1 ELSE 0 END) SL_12,"+
			"SUM(CASE WHEN dateadd(month,18,LARQ) < getdate() THEN 1 ELSE 0 END) SL_18,"+
			"SUM(CASE WHEN dateadd(month,36,LARQ) < getdate() THEN 1 ELSE 0 END) SL_36 "+
			"from ETL_CASE_CCQ where isnull(LARQ,'')>'' ";
			if("ss".equals(type)){
				sql +=" and XTAJLX not like '5%' ";
			}else{
				typemc = "执行";
				sql +=" and XTAJLX  like '5%' ";
			}
			sql +=" and FYDM like '32%' group by substring(FYDM,1,4)";
		mc = "江苏省";
		dm = JSUtils.fydm+"00";
	}else{
		if(dm.length()==6){
			dm = dm.substring(0,4);
		}
		
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DM_CITY like '"+dm+"%' ");
		sql = "select FYDM DM,SUM(CASE WHEN dateadd(month,12,LARQ) < getdate() THEN 1 ELSE 0 END) SL_12,"+
			"SUM(CASE WHEN dateadd(month,18,LARQ) < getdate() THEN 1 ELSE 0 END) SL_18,"+
			"SUM(CASE WHEN dateadd(month,36,LARQ) < getdate() THEN 1 ELSE 0 END) SL_36 "+
			"from ETL_CASE_CCQ where isnull(LARQ,'')>'' ";
			if("ss".equals(type)){
				sql +=" and XTAJLX not like '5%' ";
			}else{
				typemc = "执行";
				sql +=" and XTAJLX  like '5%' ";
			}
			sql += " and FYDM like '"+dm+"%' group by FYDM";
	}
	
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	String cvalue="";
	int count=1;
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> map= fylist.get(i);
		String citymc = map.get("NAME_CITY").toString();
		String citydm = map.get("DM_CITY").toString();
		int sl_12=0,sl_18=0,sl_36=0;
		for(Map<String,Object> mm:list){
			if(citydm.equals(mm.get("DM"))){
				sl_12 = mm.get("SL_12")!=null?Integer.valueOf(mm.get("SL_12").toString()):0;
				sl_18 = mm.get("SL_18")!=null?Integer.valueOf(mm.get("SL_18").toString()):0;
				sl_36 = mm.get("SL_36")!=null?Integer.valueOf(mm.get("SL_36").toString()):0;
				break;
			}
		}
		cvalue += "{name:\""+citymc+"\",value:"+count+",id:\""+citydm+"\",tip:'"+citymc+"("+typemc+")<br>---------------<br>12个月以上:"+sl_12+"件<br>18个月以上:"+sl_18+"件<br>36个月以上:"+sl_36+"件'},"; 
		splist +=  "{start:"+count+",end:"+count+",label:\""+citymc+"\",color:\""+color[i]+"\"},"; 
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
		    margin:'0 20 20 20' 
		} 
	},
    series : [
          {
            name: "地图",
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
