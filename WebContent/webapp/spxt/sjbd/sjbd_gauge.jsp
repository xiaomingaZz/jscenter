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
	 	
		String dm = StringUtils.trim(request.getParameter("dm"));
		String mc = StringUtils.trim(request.getParameter("mc"));
	 	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		String date = sdf.format(new Date());
		String []tjyf = CalendarUtil.getKssjJssj(date);
		String kssj = tjyf[0];
		String jssj = tjyf[1];	 	
	 	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
	 	
	 	String sas_zx = "0",jas_zx="0",wjs_zx="0",sas_sp = "0",jas_sp="0",wjs_sp="0";
	 	List<Map<String, Object>> series = new ArrayList<Map<String, Object>>();
		String sql = "select SUM(N_SAS_ZX) SAS_ZX,SUM(N_JAS_ZX) JAS_ZX,SUM(N_WJS_ZX) WJS_ZX,SUM(N_SAS_SP) SAS_SP,SUM(N_JAS_SP) JAS_SP,SUM(N_WJS_SP) WJS_SP from AAM_SJCOMP where ID_MTH >='"+kssj+"' and ID_MTH <= '"+jssj+"' and ID_FYDM LIKE '"+dm+"%'";
		List<Map<String,Object>> list = bi09.queryForList(sql);
		if(list!=null && list.size()>0){
			Map<String,Object> map = list.get(0);
			if(map.get("SAS_ZX")!=null){
				sas_zx = map.get("SAS_ZX").toString();//中心库收案数
			}
			if(map.get("JAS_ZX")!=null){
				jas_zx = map.get("JAS_ZX").toString();//中心库结案数
			}
			if(map.get("WJS_ZX")!=null){
				wjs_zx = map.get("WJS_ZX").toString();//中心库未结数
			}
			if(map.get("SAS_SP")!=null){
				sas_sp = map.get("SAS_SP").toString();//审判库收案数
			}
			if(map.get("JAS_SP")!=null){
				jas_sp = map.get("JAS_SP").toString();//审判库结案数
			}
			if(map.get("WJS_SP")!=null){
				wjs_sp = map.get("WJS_SP").toString();//审判库未结数
			}
		}
		String wzl = "0";
		if(!sas_sp.equals("0")){
			wzl = StringUtils.formatDouble(Double.parseDouble(sas_zx)/Double.parseDouble(sas_sp)*100.0,"#0.00");
		}else if(!sas_zx.equals("0")){
			wzl = StringUtils.formatDouble(100.0,"#0.00");
		}else{
			wzl = StringUtils.formatDouble(0.0,"#0.00");
		}
%>

option = {
	SAS_ZX:"<%=sas_zx %>",
	SAS_SP:"<%=sas_sp %>",
	SAS_CY:"<%=Integer.parseInt(sas_zx)-Integer.parseInt(sas_sp) %>",
	JAS_ZX:"<%=jas_zx %>",
	JAS_SP:"<%=jas_sp %>",
	JAS_CY:"<%=Integer.parseInt(jas_zx)-Integer.parseInt(jas_sp) %>",
	
    tooltip : {
        formatter: "{a} <br/>{b} : {c}%"
    },
    series : [
        {
            name:'完整率',
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
            data:[{value: <%=wzl%>,name:'完整率'}]
        }
    ]
};

                    