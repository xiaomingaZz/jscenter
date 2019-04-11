<%@page import="tdh.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="java.util.Date"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String nd = StringUtils.trim(request.getParameter("nd"));
	String mc = StringUtils.trim(request.getParameter("mc"));
	String cx = StringUtils.trim(request.getParameter("cx"));
	String ajlx = StringUtils.trim(request.getParameter("lx"));
	String dm = StringUtils.trim(request.getParameter("dm"));
	String fjm = StringUtils.trim(request.getParameter("fjm"));
	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");

	String []tjyf = CalendarUtil.getKssjJssj(nd);
	String kssj = tjyf[0];
	String jssj = tjyf[1];
	
	String column = "";
	if("".equals(cx)){
		if("".equals(ajlx)){
			column = " SUM(GPS)+SUM(Z_GPS) GPS,SUM(FHS)+SUM(Z_FHS) FHS,SUM(GPFHS)+SUM(Z_GPS)+SUM(Z_FHS) GPFHS ";
		}else if("xs".equals(ajlx)){
			column = " SUM(XSGPS)+SUM(Z_XS_GPS) GPS,SUM(XSFHS)+SUM(Z_XS_FHS) FHS,SUM(XSGPFHS)+SUM(Z_XS_GPS)+SUM(Z_XS_FHS) GPFHS ";
		}else if("ms".equals(ajlx)){
			column = " SUM(MSGPS)+SUM(Z_MS_GPS) GPS,SUM(MSFHS)+SUM(Z_MS_FHS) FHS,SUM(MSGPFHS)+SUM(Z_MS_GPS)+SUM(Z_MS_FHS) GPFHS ";
		}else if("xz".equals(ajlx)){
			column = " SUM(XZGPS)+SUM(Z_XZ_GPS) GPS,SUM(XZFHS)+SUM(Z_XZ_FHS) FHS,SUM(XZGPFHS)+SUM(Z_XZ_GPS)+SUM(Z_XZ_FHS) GPFHS ";
		}
	}else if("es".equals(cx)){
		if("".equals(ajlx)){
			column = " SUM(GPS) GPS,SUM(FHS) FHS,SUM(GPFHS) GPFHS ";
		}else if("xs".equals(ajlx)){
			column = " SUM(XSGPS) GPS,SUM(XSFHS) FHS,SUM(XSGPFHS) GPFHS ";
		}else if("ms".equals(ajlx)){
			column = " SUM(MSGPS) GPS,SUM(MSFHS) FHS,SUM(MSGPFHS) GPFHS ";
		}else if("xz".equals(ajlx)){
			column = " SUM(XZGPS) GPS,SUM(XZFHS) FHS,SUM(XZGPFHS) GPFHS ";
		}
	}else if("zs".equals(cx)){
		if("".equals(ajlx)){
			column = " SUM(Z_GPS) GPS,SUM(Z_FHS) FHS,SUM(Z_GPS)+SUM(Z_FHS) GPFHS ";
		}else if("xs".equals(ajlx)){
			column = " SUM(Z_XS_GPS) GPS,SUM(Z_XS_FHS) FHS,SUM(Z_XS_GPS)+SUM(Z_XS_FHS) GPFHS ";
		}else if("ms".equals(ajlx)){
			column = " SUM(Z_MS_GPS) GPS,SUM(Z_MS_FHS) FHS,SUM(Z_MS_GPS)+SUM(Z_MS_FHS) GPFHS ";
		}else if("xz".equals(ajlx)){
			column = " SUM(Z_XZ_GPS) GPS,SUM(Z_XZ_FHS) FHS,SUM(Z_XZ_GPS)+SUM(Z_XZ_FHS) GPFHS ";
		}
	}

	List<Map<String,Object>> fylist = new ArrayList<Map<String,Object>>();
	String sql = "";
	String dxsql = "";
	if(dm.length() == 2 || dm.length() == 4 && dm.endsWith("00")){
		mc = "江苏省";
		dxsql = "select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 2 AND FJM LIKE '"+fjm.substring(0,1)+"%' order by FJM ";
		sql = "select substring(ID_FYDM,1,2) DM,"+column+" from FACT_GPFH_JSGY "
				+" where ID_MTH>='"+kssj+"' and ID_MTH<= '"+jssj+"' "
				+" AND ID_FYDM LIKE '"+fjm+"%'"
				+" group by substring(ID_FYDM,1,2)";
	}else{
		dxsql = "select FJM DM,NAME_CITY from DC_CITY where DATALENGTH(FJM) = 3 AND FJM LIKE '"+fjm+"%' order by FJM ";
		sql = "select substring(ID_FYDM,1,3) DM,"+column+" from FACT_GPFH_JSGY "
		+" where ID_MTH>='"+kssj+"' and ID_MTH<= '"+jssj+"' "
		+" AND ID_FYDM LIKE '"+fjm+"%'"
		+" group by substring(ID_FYDM,1,3)";
	}
	//System.out.println("gpfh map sql-->"+sql+"\n"+dxsql);
	fylist = bi09.queryForList(dxsql);
	List<Map<String,Object>> list = bi09.queryForList(sql);

	
	String[] color = JSUtils.MAP_COLOR_ARRAY;
	String splist = "";
	int max=100;
	
	String value = "";
	String gpvalue = "";
	String fhvalue = "";
	String gpfhvalue = "";
	int count=1;
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> map= fylist.get(i);
		String _mc = map.get("NAME_CITY").toString();
		String _dm = map.get("DM").toString();
		if(_dm.length() == 1 || _dm.endsWith("0") ){
			continue;
		}
		int gps = 0;
		int fhs = 0;
		int gpfhs = 0;
		for(Map<String,Object> mm:list){
			if(_dm.equals(mm.get("DM"))){
				gps = mm.get("GPS")!=null?Integer.valueOf(mm.get("GPS").toString()):0;
				fhs = mm.get("FHS")!=null?Integer.valueOf(mm.get("FHS").toString()):0;
				gpfhs = mm.get("GPFHS")!=null?Integer.valueOf(mm.get("GPFHS").toString()):0;
				break;
			}
		}
		if(max < gpfhs){
			max = gpfhs;
		}
		//gpvalue += "{name:\""+mc+"\",value:"+gps+",id:\""+i+"\",tip:'"+mc+"：改判"+gps+"件'},"; 
		//fhvalue += "{name:\""+mc+"\",value:"+fhs+",id:\""+i+"\",tip:'"+mc+"：发回"+fhs+"件'},"; 
		//gpfhvalue += "{name:\""+mc+"\",value:"+gpfhs+",id:\""+i+"\",tip:'"+mc+"：改发合计"+gpfhs+"件'},";
		
		//gpvalue += "{name:\""+mc+"\",value:"+count+",id:\""+i+"\",tip:'"+mc+"<br>---------<br>改判"+gps+"件'},"; 
		//fhvalue += "{name:\""+mc+"\",value:"+count+",id:\""+i+"\",tip:'"+mc+"<br>---------<br>发回"+fhs+"件'},"; 
		//gpfhvalue += "{name:\""+mc+"\",value:"+count+",id:\""+i+"\",tip:'"+mc+"<br>---------<br>改发合计"+gpfhs+"件'},";
		
		value += "{name:\""+_mc+"\",value:"+count+",id:\""+i+"\",tip:'"+_mc+"<br>---------<br>被改判:"+gps+"件<br>被发回:"+fhs+"件'},";
		splist +=  "{start:"+count+",end:"+count+",label:\""+_mc+"\",color:\""+color[i]+"\"},"; 
		count++;
	}
	
	//for(int i=0;i<5;i++){
	//	splist +=  "{start:"+(max/5*i)+",end:"+(max/5*(i+1))+",label:\""+(max/5*i)+"-"+(max/5*(i+1))+"\",color:\""+color[i]+"\"},"; 
	//}
	
	if(value.endsWith(",")){
		value=value.substring(0,value.length()-1);
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
	color:['#FF7F50','#54FF9F','#0099FF'],
    legend: {
    	show:false,
        data:['改判数','发回数','改发合计'],
        textStyle:{color:'blue'},
        orient : 'vertical' ,
        x:'right',
        y:'10',
        selectedMode:'single',
        selected: {'改判数':true,'发回数' : false,'改发合计':false}
    },
    series : [
    	{
            name: "案件数",
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
          /*{
            name: "改判数",
            type: 'map',
            mapType: 'DT',
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
            data:[<%=gpvalue %>]
        },
        {
            name: "发回数",
            type: 'map',
            mapType: 'DT',
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
            data:[<%=fhvalue %>]
        },
        {
            name: "改发合计",
            type: 'map',
            mapType: 'DT',
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
            data:[<%=gpfhvalue %>]
        }*/
    ]
};
