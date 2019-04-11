<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="jxl.Workbook"%>
<%@ page import="jxl.write.WritableCellFormat"%>
<%@ page import="jxl.write.WritableFont"%>
<%@ page import="jxl.write.WritableSheet"%>
<%@ page import="jxl.write.WritableWorkbook"%>
<%@page import="jxl.format.Colour"%>
<%
	response.setHeader("Cache-Control","no-cache");     
	response.setHeader("Pragma","no-cache");     
	response.setDateHeader("Expires", 0);
	String filename = "数据导出";

	out.clear();
	out = pageContext.pushBody();
	
	OutputStream sout = null;
	try{
		sout = response.getOutputStream();
		response.reset();
		response.setContentType("application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename="+ java.net.URLEncoder.encode(filename+".xls","UTF-8"));

		JdbcTemplateExt bi09 = WebAppContext.getBeanEx("bi09jdbcTemplateExt");
		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY");
		Map<String,String> fymap = new HashMap<String,String>();
		for(Map<String,Object> map:fylist){
			fymap.put(map.get("DM").toString(),map.get("MC").toString());
		}
		
		String baseid = StringUtils.trim(request.getParameter("BASEID"));
		String fydm = StringUtils.trim(request.getParameter("FYDM"));
		String kssj = StringUtils.trim(request.getParameter("KSSJ"));
		String jssj = StringUtils.trim(request.getParameter("JSSJ"));
		
		String zw = StringUtils.trim(request.getParameter("ZW"));//职务
		String ytzCond = "";
		String js = "";
		if(zw!=null&&!zw.equals("")){
			js = zw.split("_")[1];//角色--spzcbr,spz,cbr,xts
			zw = zw.split("_")[0];
			if("1".equals(zw.substring(0,1))){
				ytzCond += " '09_01050-1' ";
			}
			if("1".equals(zw.substring(1,2))){
				if(ytzCond.length() > 0){
					ytzCond += " , ";
				}
				ytzCond += " '09_01050-2' ";
			}
			if("1".equals(zw.substring(2,3))){
				if(ytzCond.length() > 0){
					ytzCond += " , ";
				}
				ytzCond += " '09_01050-3' ";
			}
			if("1".equals(zw.substring(3,4))){
				if(ytzCond.length() > 0){
					ytzCond += " , ";
				}
				ytzCond += " '09_01050-4' ";
			}
			/*if(ytzCond.length() > 0){
				if("spz".equals(js)){
					ytzCond = " AND BCYSFTJ = '0' AND (SPZ IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) and CBR <> SPZ) ";
				}else if("cbr".equals(js)){
					ytzCond = " AND BCYSFTJ = '0' AND (CBR IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) and CBR <> SPZ) ";
				}else if("xts".equals(js)){
					ytzCond = " AND BCYSFTJ = '0' AND (CBR IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) and CBR = SPZ) ";
				}else{
					ytzCond = " AND BCYSFTJ = '0' AND ( (SPZ IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN("+ytzCond+"))) "
					+" OR (CBR IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) and CBR <> SPZ) )";
				}
			}*/
			
			/*if(ytzCond.length() > 0){
			if("spz".equals(js)){
				ytzCond = " AND BCYSFTJ = '0' AND (SPZ IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) ) ";
			}else if("cbr".equals(js)){
				ytzCond = " AND BCYSFTJ = '0' AND (CBR IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) ) ";
			}else if("xts".equals(js)){
				ytzCond = " AND BCYSFTJ = '0' AND (CBR IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) and CBR = SPZ) ";
			}else{
				ytzCond = " AND BCYSFTJ = '0' AND ( (SPZ IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN("+ytzCond+"))) "
				+" OR (CBR IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) ) )";
			}
		}*/
		
		if(ytzCond.length() > 0){
			if("spz".equals(js)){
				ytzCond = " AND (exists (SELECT YHDM FROM ETL_USER WHERE YHDM = A.SPZ AND FLZW IN ("+ytzCond+")) ) ";
			}else if("cbr".equals(js)){
				ytzCond = " AND (exists (SELECT YHDM FROM ETL_USER WHERE YHDM = A.CBR AND FLZW IN ("+ytzCond+")) ) ";
			}else if("xts".equals(js)){
				ytzCond = " AND (CBR IN (SELECT YHDM FROM ETL_USER WHERE FLZW IN ("+ytzCond+")) and CBR = SPZ) ";
			}else{
				ytzCond = " AND ( (exists (SELECT YHDM FROM ETL_USER WHERE YHDM = A.SPZ AND FLZW IN("+ytzCond+"))) "
				+" OR (exists (SELECT YHDM FROM ETL_USER WHERE YHDM = A.CBR AND FLZW IN ("+ytzCond+")) ) )";
			}
		}
		}
		
		Enumeration en = request.getParameterNames();
		StringBuffer sb = new StringBuffer();
		while (en.hasMoreElements()) {
			String name = StringUtils.trim(en.nextElement());
			if ("".equals(name)||"ver".equals(name)||"KSSJ".equals(name)||"JSSJ".equals(name)||"FLAG".equals(name)||"BASEID".equals(name)||
					"submitform".equals(name)||"etc".equals(name)||"start".equals(name)||"limit".equals(name)
					|| "ZW".equals(name)) {
				continue;
			}
			String val = StringUtils.trim(request.getParameter(name));
			if(name.equals("XFTZ")){
				sb.append(" AND "+name+" LIKE '%"+val+"%'");
			}else{
				if(val.contains(",")){
					String[] vals = val.split(",");
					String cond = "";
					for(int i=0;i<vals.length;i++){
						String vv = vals[i];
						if("null".equals(vv)){
							cond +=" isnull("+name+",'') = '' or";
						}else if(!"".equals(vv)){
							cond +=" "+name+" LIKE '"+vv+"%' or";
						}
					}
					if(cond.endsWith("or")){
						cond = cond.substring(0,cond.lastIndexOf("or"));
						sb.append(" AND ( "+cond+")");
					}
				}else{
					if("null".equals(val)){
						sb.append(" AND isnull("+name+",'') = '' ");
					}else if(!"".equals(val)){
						sb.append(" AND "+name+" LIKE '"+val+"%'");
					}
				}
			}
		}
		
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> list0 = bi09.queryForList("select BASEID,FIELD,FIELDMC,COND from T_BASE where BASEID = '"+baseid+"'");
		Map<String,Integer> vmap = new HashMap<String,Integer>();
		String fieldmc = "法院,案号,立案日期,案由描述,当事人,结案日期";
		String field = "FYDM,AH,LARQ,AYMS,DSR,JARQ";
		if(list0.size()>0){
			String cond = StringUtils.trim(list0.get(0).get("COND"));
			field =  StringUtils.trim(list0.get(0).get("FIELD"));
			fieldmc = StringUtils.trim(list0.get(0).get("FIELDMC"));
			if(field==null||"".equals(field)){
				field = "FYDM,AH,LARQ,AYMS,DSR,JARQ";
				fieldmc = "法院,案号,立案日期,案由描述,当事人,结案日期";
			}
			cond = cond.replace("@KSSJ@",kssj).replace("@JSSJ@",jssj).replace("@COND@",sb.toString());
			
			cond += ytzCond;
			
			list = bi09.queryForList("select "+field+" "+cond);
		}
		
		List<Map<String,Object>> wts = bi09.queryForList("select ID_FYDWT DM,NAME_FYDWT MC from DIM_XF_FYDWT order by ID_FYDWT");
	 	Map<String,Object> wtm = new HashMap<String,Object>();
	 	for(Map<String,Object> m:wts){
	 		wtm.put(m.get("DM").toString(),m.get("MC"));
	 	}
	 	
	 	Map<String,String> xffl = new HashMap<String,String>();
	 	xffl.put("1","来访");xffl.put("2","来信");xffl.put("3","上级交办");
	 	
	 	Map<String,String> yydm = new HashMap<String,String>();
	 	yydm.put("SSXF","涉诉");yydm.put("ZXXF","涉执");yydm.put("DCDB","人民来信");
	 	
	 	Map<String,String> xftz = new HashMap<String,String>();
	 	xftz.put("1","初访、初信");xftz.put("100","群访");xftz.put("21","集团访");
	 	xftz.put("22","无理缠诉");xftz.put("5","重复访");xftz.put("6","上访老户");
	 	xftz.put("60","越级访");xftz.put("8","进京访");xftz.put("2","去省访");
		
		//设置标题字体格式
 		WritableFont wf = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false);//设置写入字体 TIMES 10 加粗
		WritableCellFormat wcf = new WritableCellFormat(wf);//设置CellFormat 
		wcf.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		wcf.setAlignment(jxl.format.Alignment.CENTRE);//水平对齐方式 居中
		wcf.setBackground(Colour.SKY_BLUE);
		//设置字体格式1
		WritableFont wf1 = new WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false);//设置写入字体 TIMES 10 不加粗
		WritableCellFormat wcf1 = new WritableCellFormat(wf1);//设置CellFormat 
		wcf1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		wcf1.setAlignment(jxl.format.Alignment.CENTRE);//水平对齐方式 居中
		wcf1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//垂直对齐方式 居中
		//设置字体格式2
		WritableFont wf2 = new WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false);//设置写入字体 TIMES 10 不加粗
		WritableCellFormat wcf2 = new WritableCellFormat(wf2);//设置CellFormat 
		wcf2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		wcf2.setAlignment(jxl.format.Alignment.LEFT);//水平对齐方式 左对齐
		wcf2.setWrap(true);
		
		WritableWorkbook workbook = Workbook.createWorkbook(sout);
		
		try{
		  	int len = list.size();
		  	int pag = 60000;
		  	int index = len%pag==0?len/pag:len/pag+1;
		  	String[] mcs = fieldmc.split(",");
			String[] fields = field.split(",");
		  	for(int i=0;i<=index;i++){
		  		WritableSheet sheet = workbook.createSheet("数据导出"+i, i);
				sheet.setRowView(0,360);
				for(int j =0;j< mcs.length;j++){
					sheet.addCell(new jxl.write.Label(j, 0, mcs[j], wcf));
					sheet.setColumnView(j,25);
				}
				int row=1;
		  		for(int k=i*pag;k<(i+1)*pag;k++){
		  			sheet.setRowView(row,360);
		  			if(k>=len){
		  				break;
		  			}
		  			Map<String,Object> map = list.get(k);
					for(int j=0;j<fields.length;j++){
						String fi = StringUtils.trim(fields[j]);
						if(fi.contains(".")){
							fi=fi.substring(fi.lastIndexOf("."));
						}
						String value = StringUtils.trim(map.get(fields[j]));
						if(fi.equals("FYDM")){
							value = fymap.get(value);
						}else if(fi.equals("FYDWT")){
							value = wtm.containsKey(value)?wtm.get(value).toString():"其他";
						}else if(fi.equals("YYDM")){
							value = yydm.containsKey(value)?yydm.get(value).toString():"其他";
						}else if(fi.equals("XFFL")){
							value = xffl.containsKey(value)?xffl.get(value).toString():"其他";
						}else if(fi.equals("XFTZ")){
							String tzmc = "";
							if(value!=null&&value.length()>0){
								value = value.substring(value.lastIndexOf("-")+1,value.length()-1);
								String[] tz = value.split(",");
								for(int m=0;m<tz.length;m++){
									tzmc += xftz.get(tz[m])+"、";
								}
								tzmc = tzmc.substring(0,tzmc.length()-1);
							}
							value = tzmc;
						}
						sheet.addCell(new jxl.write.Label(j, row, value, wcf2));
					}
					row++;
		  		}
		  	}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				if(workbook!=null){
					workbook.write();
					workbook.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(sout!=null){
			sout.flush();
			sout.close();
		}
		out.clear();
		out = pageContext.pushBody();
	}
%>
