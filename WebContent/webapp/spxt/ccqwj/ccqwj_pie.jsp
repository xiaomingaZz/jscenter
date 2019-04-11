<%@page import="tdh.util.JSUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
	 	String mc = StringUtils.trim(request.getParameter("mc"));
	 	String type = StringUtils.trim(request.getParameter("type"));
	 	String lxtype = StringUtils.trim(request.getParameter("lxtype"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		if(dm==null||dm.equals("")||dm.equals(JSUtils.fydm)){
			mc = "全省";
	 	}else if(dm.endsWith("00")){
	 		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY = '"+dm+"' ");
			if(fylist.size()>0){
				mc = fylist.get(0).get("MC").toString();
			}
		}
		
	 	Map<String, Object> ajlx = new HashMap<String, Object>();
	 	ajlx.put("1","刑事");ajlx.put("2","民事");ajlx.put("3","行政");
	 	ajlx.put("4","赔偿");ajlx.put("6","申诉申请再审");
	
		String sql = "";
		String xdata = "";
		String typemc = "";
		int tsl = 0;
		String value ="";
		String baseid = "JS0004";
			//new String[]{"JS0004","JS0005","JS0006"};
		if(lxtype.equals("ss")){
			typemc = "诉讼";
			if("s_12".equals(type)){
				sql = "select subString(XTAJLX,1,1) DM,COUNT(AHDM) SL from ETL_CASE_CCQ where isnull(LARQ,'')>'' and dateadd(month,12,LARQ) < getdate() "+
					"and FYDM like '"+dm+"%' and XTAJLX not like '5%' group by subString(XTAJLX,1,1)";
			}else if("s_18".equals(type)){
				baseid = "JS0005";
				sql = "select subString(XTAJLX,1,1) DM,COUNT(AHDM) SL from ETL_CASE_CCQ where isnull(LARQ,'')>'' and dateadd(month,18,LARQ)<getdate() "+
					"and FYDM like '"+dm+"%' and XTAJLX not like '5%' group by subString(XTAJLX,1,1)";
			}else{
				baseid = "JS0006";
				sql = "select subString(XTAJLX,1,1) DM,COUNT(AHDM) SL from ETL_CASE_CCQ where isnull(LARQ,'')>'' and dateadd(month,36,LARQ)<getdate() "+
					"and FYDM like '"+dm+"%' and XTAJLX not like '5%' group by subString(XTAJLX,1,1)";
			}
			List<Map<String,Object>> list = bi09.queryForList(sql);
			int osl = 0;
			for(Map<String,Object> map:list){
				int sl = map.get("SL")!=null?Integer.valueOf(map.get("SL").toString()):0;
				String lxdm = map.get("DM")==null?"":map.get("DM").toString();
				if(ajlx.containsKey(lxdm)){
					String lxmc = ajlx.get(lxdm).toString();
					xdata +="'"+lxmc+"',";
					value += "{'baseid':'"+baseid+"',name:\""+lxmc+"\",value:"+sl+",tip:'"+lxmc+"："+sl+"件','ctdm':'"+dm+"','bmdm':'','ajlx':'"+lxdm+"'},"; 
				}else{
					osl = osl + sl;
				}
				tsl = tsl +sl;
	 		}
			xdata +="'其他'";
			value += "{'baseid':'"+baseid+"',name:\"其他\",value:"+osl+",tip:'其他："+osl+"件','ctdm':'"+dm+"','bmdm':'','ajlx':'[7-9]'}"; 
		}else{
			xdata = "'实施类案件','审查类案件'";
			typemc = "执行";
			if("s_12".equals(type)){
				baseid = "JS0007";
				sql = "select XTAJLX DM,COUNT(AHDM) SL from ETL_CASE_CCQ where isnull(LARQ,'')>'' and dateadd(month,12,LARQ) < getdate() "+
					"and FYDM like '"+dm+"%' and XTAJLX like '5%' group by XTAJLX";
			}else if("s_18".equals(type)){
				baseid = "JS0008";
				sql = "select XTAJLX DM,COUNT(AHDM) SL from ETL_CASE_CCQ where isnull(LARQ,'')>'' and dateadd(month,18,LARQ)<getdate() "+
					"and FYDM like '"+dm+"%' and XTAJLX like '5%' group by XTAJLX";
			}else{
				baseid = "JS0009";
				sql = "select XTAJLX DM,COUNT(AHDM) SL from ETL_CASE_CCQ where isnull(LARQ,'')>'' and dateadd(month,36,LARQ)<getdate() "+
					"and FYDM like '"+dm+"%' and XTAJLX like '5%' group by XTAJLX";
			}
			List<Map<String,Object>> list = bi09.queryForList(sql);
			int osl = 0;
			for(Map<String,Object> map:list){
				int sl = map.get("SL")!=null?Integer.valueOf(map.get("SL").toString()):0;
				String lxdm = map.get("DM")==null?"":map.get("DM").toString();
				if(lxdm.equals("51")){
					value += "{'baseid':'"+baseid+"',name:\"实施类案件\",value:"+sl+",tip:'实施类案件："+sl+"件','ctdm':'"+dm+"','bmdm':'','ajlx':'51'},"; 
				}else{
					osl = osl + sl;
				}
				tsl = tsl +sl;
	 		}
			value += "{'baseid':'"+baseid+"',name:\"审查类案件\",value:"+osl+",tip:'审查类案件："+osl+"件','ctdm':'"+dm+"','bmdm':'','ajlx':'5[2-3]'}"; 
		}
		
		
	 	
	 
 %>
option = {
     title : {show:true,x:'center',text: '<%=mc+typemc %>案件类型分布(<%=tsl %>)',
	     textStyle:{
		    fontSize: 26,
		    fontWeight: 'bolder',
		    color: '#000000',
		    margin:'0 20 20 20'  
		} 
	},
    tooltip : {
    	show:true,
        trigger: 'item',
        formatter:function(param){
        	return param['data']['tip'];
        }
    },
    color:[<%=JSUtils.COLOR_STR %>],
    legend: {
        orient : 'vertical' ,
        x : 'left',
        y : 'center',
        data:[<%=xdata %>]
    },
    series : [
        {
            name:'案件数',
            type:'pie',
            radius : [0,170],
            center: ['55%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=value %>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    