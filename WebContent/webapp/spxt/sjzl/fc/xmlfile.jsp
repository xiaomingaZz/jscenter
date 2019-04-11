<%@page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@page import="tdh.spring.SpringContextHolder"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.*" %>

<%@ page import="javax.servlet.ServletOutputStream" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
	String ahdm = request.getParameter("ahdm");
	Object wjmc = "";
	ServletOutputStream outStream = null;
	try {
		if(StringUtils.isNotBlank(ahdm)){
			String sql = "SELECT nr,ahdm FROM xml_aj where ahdm = '"+ahdm+"' ";
	//		JdbcTemplate jdbcTemplate = (JdbcTemplate)SpringContextHolder.getBean("jdbcTemplate");
			JdbcTemplate jdbcTemplate = WebAppContext.getBeanEx("centerjdbcTemplate");
			List<Map<String,Object>> list = jdbcTemplate.queryForList(sql);
			StringBuffer errHtml = new StringBuffer();
			System.out.println("list的值是：---" + list + "，当前方法=JspClass.jsp_service_method()");
			if(list!=null){
				if(list.size()>0){
					Object obj =  list.get(0).get("nr");
					wjmc =  list.get(0).get("ahdm");
					if(obj!=null){
						//System.out.print(obj.getClass().getName());
						response.setContentType("text/xml");
						response.setHeader("Content-disposition", "inline; filename=\"" + ahdm + "\"");
						outStream = response.getOutputStream();
						//没有压缩，所以不需要解压
//						ByteArrayOutputStream outpu = deCompress(new ByteArrayInputStream((byte[])obj));
						outStream.write((byte[])obj);
						outStream.flush();
					}else{
						errHtml.append("<div style=\"border:1px solid red\">详情信息:</br>&nbsp;&nbsp;");
						errHtml.append("库中该案号的内容为空,查询sql:").append(sql).append("</br>库链接请根据jdbc(jgpt)库查询：</br>&nbsp;&nbsp;");
					}
				}else{
					out.print("<h1>没有查到该xml("+ahdm+")信息</h1>");
				}
			}else{
				out.print("<div style=\"border:1px solid red\">获取数据库连接失败</div>");
			}
		}else{
			out.print("<h1>案号不能为空</h1>");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(outStream!=null){
			try{
				outStream.close();
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				outStream = null;
			}
		}
		out.clear();
		out = pageContext.pushBody();
	}
%>
<%!
public ByteArrayOutputStream deCompress(InputStream in) {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    ZipInputStream zipIn = null;
    try {
      CheckedInputStream csumi = new CheckedInputStream(in, new CRC32());
      zipIn = new ZipInputStream(new BufferedInputStream(csumi));
      byte[] bytes = new byte[1024];
      while ((zipIn.getNextEntry()) != null) {
        int x;
        while ((x = zipIn.read(bytes)) != -1) {
          baos.write(bytes, 0, x);
        }
      }
      csumi.close();
    } catch (Exception e1) {
      e1.printStackTrace();
    } finally {
      try {
        if (zipIn != null)
          zipIn.close();
      } catch (IOException e1) {
        e1.printStackTrace();
      }
    }
    return baos;
}

%>
