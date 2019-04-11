<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.JSUtils,tdh.util.CalendarUtil"%>
<%
	 	response.setHeader("Cache-Control", "no-cache");
	 	response.setHeader("Pragma", "no-cache");
	 	response.setDateHeader("Expires", 0);
	 	
		String nd = StringUtils.trim(request.getParameter("nd"));
		String dm = StringUtils.trim(request.getParameter("dm"));
		String mc = StringUtils.trim(request.getParameter("mc"));
	 	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		String date = sdf.format(new Date());
		String []tjyf = CalendarUtil.getKssjJssj(date);
		String kssj = tjyf[0];
		String jssj = tjyf[1];	 	
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	
	 	String bgfs = "0", gfs = "0";
	 	List<Map<String, Object>> series = new ArrayList<Map<String, Object>>();
		String sql = "select SUM(N_BGFS) BGFS,SUM(N_JAS)-SUM(N_BGFS) GFS from FACT_SJZL where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%'";
		List<Map<String,Object>> list = bi09.queryForList(sql);
		if(list!=null && list.size()>0){
			Map<String,Object> map = list.get(0);
			if(map.get("BGFS")!=null){
				bgfs = map.get("BGFS").toString();//不规范数
			}
			if(map.get("GFS")!=null){
				gfs = map.get("GFS").toString();//规范数
			}
		}
		String hgl = "0";
		if(!bgfs.equals("0")){
			hgl = StringUtils.formatDouble(Double.parseDouble(gfs)/(Double.parseDouble(bgfs)+Double.parseDouble(gfs))*100,"#0.00");
		}else if(!hgl.equals("0")){
			hgl = StringUtils.formatDouble(100.0,"#0.00");
		}else{
			hgl = StringUtils.formatDouble(0.0,"#0.00");
		}
%>

option = {
	GFS:"<%=gfs %>",
	BGFS:"<%=bgfs %>",
    tooltip : {
        formatter: "{a} <br/>{b} : {c}%"
    },
    series : [
        {
            name:'合格率',
            type:'gauge',
            radius : '87%',
            center: ['50%', '50%'],
            splitNumber: 5,       // 分割段数，默认为5
            axisLine: {            // 坐标轴线
                lineStyle: {       // 属性lineStyle控制线条样式
                    color: [[0.2, '#ff4500'],[0.8, '#48b'],[1, '#228b22']], 
                    width: 8
                }
            },
            axisTick: {            // 坐标轴小标记
                splitNumber: 10,   // 每份split细分多少段
                length :12,        // 属性length控制线长
                lineStyle: {       // 属性lineStyle控制线条样式
                    color: 'auto'
                }
            },
            axisLabel: {           // 坐标轴文本标签，详见axis.axisLabel
                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                    color: 'auto'
                }
            },
            splitLine: {           // 分隔线
                show: true,        // 默认显示，属性show控制显示与否
                length :30,         // 属性length控制线长
                lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                    color: 'auto'
                }
            },
            pointer : {
                width : 5
            },
            title : {
                show : true,
                offsetCenter: [0, 32],       // x, y，单位px
                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                    fontWeight: 'bolder',
                    fontSize:13
                }
            },
            detail : {
                formatter:'{value}%',
                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                    color: 'auto',
                    fontSize:18
                }
            },
            data:[{value: <%=hgl%>,name:'合格率'}]
        }
    ]
};

                    