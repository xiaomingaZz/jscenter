<%@page import="tdh.util.JSUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	
	String  mc = StringUtils.trim(request.getParameter("mc"));
	String dm=StringUtils.trim(request.getParameter("dm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	List<Map<String,Object>> fylist ;
	String sql ="";
	String tjrq = sdf.format(new Date());
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
		sql = "select substring(FYDM,1,4) FYDM,sum(N_SAS) N_SAS,sum(N_JAS) N_JAS from DC_SPXT_SJC where TJRQ = '" +tjrq+"' group by substring(FYDM,1,4)";
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DATALENGTH(DM_CITY) = 4 AND DM_CITY like '"+JSUtils.fydm+"%' AND isnull(SFJY,'')<>'1' order by DM_CITY asc ");
		mc = "全省";
	}else if(dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		sql = "select FYDM,sum(N_SAS) N_SAS,sum(N_JAS) N_JAS from DC_SPXT_SJC where TJRQ = '" +tjrq+"' and FYDM like '"+dm.substring(0,2)+"%00' group by substring(FYDM,1,4)";
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DM_CITY like '"+dm.substring(0,2)+"%00' and DATALENGTH(DM_CITY) = 6 AND isnull(SFJY,'')<>'1' order by DM_CITY asc ");
		mc = "省院及中级法院";
	}else{
		sql = "select FYDM ,sum(N_SAS) N_SAS,sum(N_JAS) N_JAS from DC_SPXT_SJC where TJRQ = '"+tjrq+"' and FYDM like '"+dm+"%' group by FYDM";
		fylist = bi09.queryForList("select DM_CITY ,NAME_CITY from DC_CITY where DM_CITY like  '"+dm+"%' and DM_CITY<>'"+dm+"' AND isnull(SFJY,'')<>'1' order by DM_CITY asc ");
	}
	
	List<Map<String,Object>> list = bi09.queryForList(sql);
	String xdata = "",data1 = "",data2="";
	int max = 10;
	int sa_sl=0;
	int ja_sl=0;
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> mm = fylist.get(i);
		String ctmc = mm.get("NAME_CITY").toString();
		String ctdm = mm.get("DM_CITY").toString();
		int sa =0 ,ja =0;
		for(Map<String,Object> map:list){
			if(map.get("FYDM").equals(ctdm)){
				sa = map.get("N_SAS")!=null?Integer.valueOf(map.get("N_SAS").toString()):0;
				ja = map.get("N_JAS")!=null?Integer.valueOf(map.get("N_JAS").toString()):0;
				break;
			}
		}
		sa_sl += sa;
		ja_sl += ja;
		if(max<sa){
			max = sa;
		}
		if(max < ja){
			max = ja;
		}
		xdata += "'"+ctmc+"',";
		data1 += "{'baseid':'JS0001','name':'"+ctmc+"','value':"+sa+",'dm':'"+ctdm+"','kssj':'"+tjrq+"','lx':'SA'},";
		data2 += "{'baseid':'JS0001','name':'"+ctmc+"','value':"+ja+",'dm':'"+ctdm+"','kssj':'"+tjrq+"','lx':'JA'},";
	}
	if(xdata.endsWith(",")){
		xdata=xdata.substring(0,xdata.length()-1);
		data1=data1.substring(0,data1.length()-1);
		data2=data2.substring(0,data2.length()-1);
	}
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '<%=mc %>案件收案结分布图(收案:<%=sa_sl %>,结案:<%=ja_sl %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
	color:[<%=JSUtils.COLOR_STR %>],
	grid:{x:50,x2:30,y2:30},
    xAxis : [{type : 'category',axisLabel: {rotate: 0 },data : [<%=xdata %>]}],
    legend: {
        data:['收案数','结案数'],
        x:'right'
    },
    yAxis : [{type : 'value',max:<%=max+10 %>}],
    series : [
        {
            name:'收案数',
            type:'bar',
            data:[<%=data1 %>]
        },{
            name:'结案数',
            type:'bar',
            data:[<%=data2 %>]
        }
    ]
};
                    