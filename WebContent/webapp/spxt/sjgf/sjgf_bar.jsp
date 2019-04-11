<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	
	String dm = StringUtils.trim(request.getParameter("dm"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
	String date = sdf.format(new Date());
	String []tjyf = CalendarUtil.getKssjJssj(date);
	String kssj = tjyf[0];
	String jssj = tjyf[1];	 	
 	
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	
	String citys = "",data1="",data2="";
	
	String sql = "",sjzl_sql="";
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm))
	{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DATALENGTH(DM_CITY) = 4 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjzl_sql = "select substring(ID_FYDM,1,4) ID_FYDM,SUM(N_BGFS) BGFS,SUM(N_JAS)-SUM(N_BGFS) GFS from FACT_SJZL where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' GROUP BY substring(ID_FYDM,1,4)";
	}else if(dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm.substring(0,2)+"%00' and DATALENGTH(DM_CITY) = 6 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjzl_sql = "select substring(ID_FYDM,1,6) ID_FYDM,SUM(N_BGFS) BGFS,SUM(N_JAS)-SUM(N_BGFS) GFS from FACT_SJZL where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%00' GROUP BY substring(ID_FYDM,1,6)";
	}else{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm+"%' and DM_CITY<>'"+dm+"' and isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjzl_sql = "select ID_FYDM,SUM(N_BGFS) BGFS,SUM(N_JAS)-SUM(N_BGFS) GFS from FACT_SJZL where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' and ID_FYDM<>'"+dm+"' GROUP BY ID_FYDM";
	}
	List<Map<String, Object>> citysList = bi09.queryForList(sql);
	List<Map<String, Object>> series = new ArrayList<Map<String, Object>>();
	List<Map<String,Object>> list = bi09.queryForList(sjzl_sql);
	for(Map<String,Object> cityMap:citysList){
		String fymc = cityMap.get("FYDC")!=null?cityMap.get("FYDC").toString():"";
		String _fydm = cityMap.get("FYDM")!=null?cityMap.get("FYDM").toString():"";
		if(list!=null && list.size()>0){
			for(Map<String,Object> map:list){
				String idfydm = map.get("ID_FYDM")!=null?map.get("ID_FYDM").toString():"";
				if(!idfydm.equals("")&&idfydm.equals(_fydm)){
					String bgfs = map.get("BGFS")!=null?map.get("BGFS").toString():"";
					String gfs = map.get("GFS")!=null?map.get("GFS").toString():"";
					
					data1 += gfs + ",";
					data2 += bgfs + ",";
				}
			}
		}else{
			data1 += "0,";
			data2 += "0,";
		}
		citys += "'"+fymc + "',";
	}
	citys = citys.substring(0, citys.length()-1);
	data1 = data1.substring(0, data1.length()-1);
	data2 = data2.substring(0, data2.length()-1);
%>

option = {
    tooltip : {trigger: 'axis'},
    title : {show:true,x:'center',text: '',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20' 
		} 
	},
	color:['#22BEEF','#FA8564'],
	grid:{x:50,x2:30,y:75,y2:40},
    xAxis : [{
	    	type : 'category',
	    	axisLabel: {rotate: 20 },
	    	data : [<%=citys %>]
    	}],
    legend: {
        data:['合格','不合格'],
        x:'right',
        y:'25',
        'textStyle':{'color':0x777777,'fontSize':13}
    },
    yAxis : [{
    		name : '案件数',
    		type : 'value'
    	}],
    series : [
        {
            name:'合格',
            barMaxWidth:50,
            type:'bar',
            data:[<%=data1%>]
        },{
            name:'不合格',
            type:'bar',
            barMaxWidth:50,
            data:[<%=data2%>]
        }
    ]
};
                    