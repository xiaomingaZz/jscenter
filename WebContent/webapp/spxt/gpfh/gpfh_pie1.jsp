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
	 	
	 	String nd = StringUtils.trim(request.getParameter("nd"));
	 	String mc = StringUtils.trim(request.getParameter("mc"));
	 	String cx = StringUtils.trim(request.getParameter("cx"));
	 	String lx = StringUtils.trim(request.getParameter("lx"));
	 	String dm = StringUtils.trim(request.getParameter("dm"));
	 	String fjm = StringUtils.trim(request.getParameter("fjm"));
	 	
	 	if("".equals(mc)){
			mc = "全省";
		}
	 	
	 	String [][]dx = new String[][]{
	 			{"A","适用法律错误"},
	 			{"B","事实不清证据不足"},
	 			{"C","事实认定错误"},
	 			{"D","二审提出新证据"},
	 			{"F","量刑不当"},
	 			{"G","违反法定程序"},
	 			{"H","其他情形"},
	 			{"X","未填写"}
	 	};
	 	
	 	/**
	 	ID_GPFHYY 前3位
	 	A代表各原因
	 	第二位：1-刑事 2-民事 3-行政
	 	第三位：2-二审 3-再审
	 	*/
	 	String gfcond = "";
	 	String gf = "[A-H]";
	 	String xtajlx = "[1-3][2-3]";
	 	if("".equals(cx)){
	 		if("".equals(lx)){
	 			gf = "[A-H]";
	 		}else if("xs".equals(lx)){
	 			gf = "[A-H]1";
	 			gfcond = "刑事";
	 			xtajlx = "1[2-3]";
	 		}else if("ms".equals(lx)){
	 			gf = "[A-H]2";
	 			gfcond = "民事";
	 			xtajlx = "2[2-3]";
	 		}else if("xz".equals(lx)){
	 			gf = "[A-H]3";
	 			gfcond = "行政";
	 			xtajlx = "3[2-3]";
	 		}
	 	}else if("es".equals(cx)){
	 		xtajlx = "[1-3]2";
	 		if("".equals(lx)){
	 			gf = "[A-H]_2";
	 			gfcond = "二审";
	 		}else if("xs".equals(lx)){
	 			gf = "[A-H]12";
	 			gfcond = "刑事二审";
	 			xtajlx = "12";
	 		}else if("ms".equals(lx)){
	 			gf = "[A-H]22";
	 			gfcond = "民事二审";
	 			xtajlx = "22";
	 		}else if("xz".equals(lx)){
	 			gf = "[A-H]32";
	 			gfcond = "行政二审";
	 			xtajlx = "32";
	 		}
	 	}else if("zs".equals(cx)){
	 		xtajlx = "[1-3]3";
	 		if("".equals(lx)){
	 			gf = "[A-H]_3";
	 			gfcond = "再审";
	 		}else if("xs".equals(lx)){
	 			gf = "[A-H]13";
	 			gfcond = "刑事再审";
	 			xtajlx = "13";
	 		}else if("ms".equals(lx)){
	 			gf = "[A-H]23";
	 			gfcond = "民事再审";
	 			xtajlx = "23";
	 		}else if("xz".equals(lx)){
	 			gf = "[A-H]33";
	 			gfcond = "行政再审";
	 			xtajlx = "33";
	 		}
	 	}
	 	
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 	
		String sql = "select substring(ID_GPFHYY,1,1) DM,sum(GPFHS) NUM from FACT_GPFH_JSGY_YY "
			+" where SUBSTRING(ID_MTH,1,4) = '"+nd+"' "
			//+" AND (ID_GPFHYY LIKE '"+gf+"%' or ID_GPFHYY = 'XXX')"
			+ " AND ID_XTAJLX LIKE '"+xtajlx+"'"
 			+" and ID_FYDM like '"+fjm+"%' group by substring(ID_GPFHYY,1,1) ";
		//System.out.println("gpfh pie1 sql-->"+sql);
	 	List<Map<String,Object>> list = bi09.queryForList(sql);
	 	String data1 ="",data2="";
	 	int total = 0;
	 	for(int i = 0 ; i < dx.length ; i++){
	 		String _dm = dx[i][0];
	 		String _mc = dx[i][1];
	 		int num = 0;
	 		for(Map<String,Object> map:list){
	 			if(_dm.equals(map.get("DM"))){
	 				if(map.get("NUM") != null){
	 					num = Integer.valueOf(map.get("NUM").toString());
	 				}
	 				break;
	 			}
	 		}
	 		total += num;
	 		data1 = data1 +"{'name':'"+_mc+"','value':"+num+"},";
	 	}
	 	
	 	String x = "";
	 	for(String []arr : dx){
	 		x += "'"+arr[1]+"',";
	 	}
	 	x = x.substring(0,x.length() - 1);
 %>
option = {
     title : {show:true,x:'center',text: '<%=mc+gfcond %>被改判发回原因组成(<%=total %>)',
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
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient : 'vertical' ,
        x : 'left',
        y : 'center',
        data:[<%=x %>]
    },
    series : [
        {
            name:'被改判发回数',
            type:'pie',
            radius : [80,160],
            center: ['50%','55%'],
            x:'20%',
            width:'40%',
            data:[<%=data1.substring(0,data1.length()-1) %>],
            itemStyle:{normal:{label:{show:false,textStyle :{fontSize:13},formatter:'{d}%'},labelLine:{show:false}}}
        }
    ]
};
                    