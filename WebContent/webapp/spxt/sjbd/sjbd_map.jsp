<%@page import="tdh.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
	String date = sdf.format(new Date());
	String []tjyf = CalendarUtil.getKssjJssj(date);
	String kssj = tjyf[0];
	String jssj = tjyf[1];	 
	String dm = JSUtils.fydm;
	String mc = StringUtils.trim(request.getParameter("mc"));
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	String sql = "",sjbd_sql="";
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm))
	{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DATALENGTH(DM_CITY) = 4 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjbd_sql = "select substring(ID_FYDM,1,4) ID_FYDM,SUM(N_SAS_ZX) SAS_ZX,SUM(N_JAS_ZX) JAS_ZX,SUM(N_WJS_ZX) WJS_ZX,SUM(N_SAS_SP) SAS_SP,SUM(N_JAS_SP) JAS_SP,SUM(N_WJS_SP) WJS_SP from AAM_SJCOMP where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' GROUP BY substring(ID_FYDM,1,4)";
	}else if(dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm.substring(0,2)+"%00' and DATALENGTH(DM_CITY) = 6 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjbd_sql = "select ID_FYDM,SUM(N_SAS_ZX) SAS_ZX,SUM(N_JAS_ZX) JAS_ZX,SUM(N_WJS_ZX) WJS_ZX,SUM(N_SAS_SP) SAS_SP,SUM(N_JAS_SP) JAS_SP,SUM(N_WJS_SP) WJS_SP from AAM_SJCOMP where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"00%' GROUP BY substring ID_FYDM";
	}else{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm+"%' and DM_CITY<>'"+dm+"' and isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjbd_sql = "select ID_FYDM,SUM(N_SAS_ZX) SAS_ZX,SUM(N_JAS_ZX) JAS_ZX,SUM(N_WJS_ZX) WJS_ZX,SUM(N_SAS_SP) SAS_SP,SUM(N_JAS_SP) JAS_SP,SUM(N_WJS_SP) WJS_SP from AAM_SJCOMP where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' and ID_FYDM<>'"+dm+"' GROUP BY substring ID_FYDM";
	}
	
	List<Map<String,Object>> citylist = bi09.queryForList(sql);
	List<Map<String,Object>> datalist = bi09.queryForList(sjbd_sql);
	
	String count = "";
	String value = "";

	int i = 0;
  	for(Map<String,Object> row : citylist){
  	    String code = row.get("FYDM").toString();
  	    String name = row.get("FYDC").toString();
  		String sas_zx = "0", sas_sp = "0", sas_cy="0";
  	    if(datalist!=null && datalist.size()>0){
	  	    for(Map<String,Object> map:datalist){
	  	    	String objCode = map.get("FYDM")!=null?map.get("FYDM").toString():"";
	  	    	if(objCode.equals(code) && objCode.length()>0){
	  	    		sas_zx = map.get("SAS_ZX").toString();
	  	    		sas_sp = map.get("SAS_SP").toString();
	  	    		sas_cy = StringUtils.formatDouble(Double.parseDouble(sas_zx)-Double.parseDouble(sas_sp),"#0");
	  	    	}
	  	    }
  	    }
    	value += "{name:'"+name+"',value:'"+i+"',id:\""+i+"\",tip:'"+name+"(收案)<br>---------<br>中心库:"+sas_zx+"件<br>审判库:"+sas_sp+"件<br>差异数:"+sas_cy+"件'},"; 
		splist +=  "{start:"+i+",end:"+i+",label:\""+name+"\",color:\""+color[i]+"\"},"; 
		i++;
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
    series : [
          {
            name: "差异数",
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
