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
	
	String sql = "",sjbd_sql="";
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm))
	{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DATALENGTH(DM_CITY) = 4 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjbd_sql = "select substring(ID_FYDM,1,4) ID_FYDM,SUM(N_SAS_ZX) SAS_ZX,SUM(N_JAS_ZX) JAS_ZX,SUM(N_WJS_ZX) WJS_ZX,SUM(N_SAS_SP) SAS_SP,SUM(N_JAS_SP) JAS_SP,SUM(N_WJS_SP) WJS_SP from AAM_SJCOMP where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' GROUP BY substring(ID_FYDM,1,4)";
	}else if(dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm.substring(0,2)+"%00' and DATALENGTH(DM_CITY) = 6 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjbd_sql = "select ID_FYDM,SUM(N_SAS_ZX) SAS_ZX,SUM(N_JAS_ZX) JAS_ZX,SUM(N_WJS_ZX) WJS_ZX,SUM(N_SAS_SP) SAS_SP,SUM(N_JAS_SP) JAS_SP,SUM(N_WJS_SP) WJS_SP from AAM_SJCOMP where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"00%' GROUP BY  ID_FYDM";
	}else{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm+"%' and DM_CITY<>'"+dm+"' and isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjbd_sql = "select ID_FYDM,SUM(N_SAS_ZX) SAS_ZX,SUM(N_JAS_ZX) JAS_ZX,SUM(N_WJS_ZX) WJS_ZX,SUM(N_SAS_SP) SAS_SP,SUM(N_JAS_SP) JAS_SP,SUM(N_WJS_SP) WJS_SP from AAM_SJCOMP where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' and ID_FYDM<>'"+dm+"' GROUP BY  ID_FYDM";
	}
	List<Map<String, Object>> citysList = bi09.queryForList(sql);
	List<Map<String, Object>> series = new ArrayList<Map<String, Object>>();
	List<Map<String,Object>> list = bi09.queryForList(sjbd_sql);
	for(Map<String,Object> cityMap:citysList){
		String fymc = cityMap.get("FYDC")!=null?cityMap.get("FYDC").toString():"";
		String _fydm = cityMap.get("FYDM")!=null?cityMap.get("FYDM").toString():"";
		if(list!=null && list.size()>0){
			for(Map<String,Object> map:list){
				String idfydm = map.get("ID_FYDM")!=null?map.get("ID_FYDM").toString():"";
				if(!idfydm.equals("")&&idfydm.equals(_fydm)){
					String sas_zx = map.get("SAS_ZX")!=null?map.get("SAS_ZX").toString():"";
					String sas_sp = map.get("SAS_SP")!=null?map.get("SAS_SP").toString():"";
					
					data1 += sas_zx + ",";
					data2 += sas_sp + ",";
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
        data:['中心库','审判库'],
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
            name:'中心库',
            barMaxWidth:50,
            type:'bar',
            data:[<%=data1 %>]
        },{
            name:'审判库',
            type:'bar',
            barMaxWidth:50,
            data:[<%=data2 %>]
        }
    ]
};
                    