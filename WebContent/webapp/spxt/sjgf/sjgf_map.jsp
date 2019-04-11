<%@page import="tdh.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String dm = JSUtils.fydm;
	String mc = StringUtils.trim(request.getParameter("mc"));
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
	String date = sdf.format(new Date());
	String []tjyf = CalendarUtil.getKssjJssj(date);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	String sql = "",sjzl_sql="";
	if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm))
	{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DATALENGTH(DM_CITY) = 4 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjzl_sql = "select substring(ID_FYDM,1,4) ID_FYDM,SUM(SL) BGFS from FACT_SJZL where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' GROUP BY substring(ID_FYDM,1,4)";
		mc = JSUtils.fymc;
		dm = JSUtils.fydm;
	}else if(dm.equals(JSUtils.fydm+"00")||dm.equals(JSUtils.fydm+"0000")){
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm.substring(0,2)+"%00' and DATALENGTH(DM_CITY) = 6 AND isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjzl_sql = "select substring(ID_FYDM,1,6) ID_FYDM,SUM(SL) BGFS from FACT_SJZL where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%00' GROUP BY substring(ID_FYDM,1,6)";
	}else{
		sql = "select DM_CITY FYDM,NAME_CITY FYDC from DC_CITY where DM_CITY like '"+dm+"%' and DM_CITY<>'"+dm+"' and isnull(SFJY,'')<>'1' order by DM_CITY asc";
		sjzl_sql = "select ID_FYDM,SUM(SL) BGFS from FACT_SJZL where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%' and ID_FYDM<>'"+dm+"' GROUP BY ID_FYDM";
	}
	
	List<Map<String,Object>> citylist = bi09.queryForList(sql);
	List<Map<String,Object>> datalist = bi09.queryForList(sjzl_sql);
	
	String count = "";
	String value = "";

	int i = 0;
	int max = 0;
  	for(Map<String,Object> row : citylist){
  	    String code = row.get("FYDM").toString();
  	    String name = row.get("FYDC").toString();
  		int bhgs = 0;
  	    if(datalist!=null && datalist.size()>0){
	  	    for(Map<String,Object> map:datalist){
	  	    	String objCode = map.get("ID_FYDM")!=null?map.get("ID_FYDM").toString():"";
	  	    	if(objCode.equals(code) && objCode.length()>0){
	  	    		bhgs = (Integer)map.get("BGFS");
	  	    	}
	  	    }
	  	  if(max < bhgs){
	  	    	max = bhgs;
	  	    }
  	    }
  	    
    	value += "{name:'"+name+"',value:'"+bhgs+"',id:\""+i+"\",tip:'"+name+"<br>---------<br>不合格:"+bhgs+"件'},"; 
		splist +=  "{start:"+i+",end:"+i+",label:\""+name+"\",color:\""+color[i]+"\"},"; 
		i++;
  	}
	
  	max = max + 50;
  	
	if(value.endsWith(",")){
		value=value.substring(0,value.length()-1);
		splist=splist.substring(0,splist.length()-1);
	}
%>

option = {
	CITY:"<%=mc%>",
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
        max:<%=max %>,
        min:0,
        precision:0//,
        //splitList:[<%=splist %>]
    },
    title : {show:false,x:'left',text: '<%=mc %>',
	     textStyle:{
		    fontSize: 20,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20',
		    fontFimaly:'微软雅黑'
		} 
	},
    series : [
          {
            name: "合格数",
            type: 'map',
            mapType: '42',
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
