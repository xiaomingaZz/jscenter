package tdh.util;

import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import tdh.framework.util.StringUtils;
import tdh.web.WebAppContext;

public class CalendarUtil {
	
	public static String sftjr = "21";
	public static Boolean useSftj = true; 
	
	public static String  getNowStr(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 hh:mm:ss,SS");
		return sdf.format(Calendar.getInstance().getTime());
	}
	
	public static Long getNowLong(){
		return Calendar.getInstance().getTimeInMillis();
	}
	
	public static String getFirstDayOfYear(String day){
		return (Integer.parseInt(day.substring(0,4)) - 1)+"12"+sftjr;
	}
	
	public static String getMaxTjDay(){
		String day = "";
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
		try{
			conn = WebAppContext.getNewConn("bi09dataSource");
			st = conn.createStatement();
			rs = st.executeQuery("SELECT MAX(ID_DAY) ID_DAY FROM DIM_DAY ");
			if(rs.next()){
				day = StringUtils.trim(rs.getString("ID_DAY"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtils.closeConn(conn);
		}
		return day;
	}
	
	/**
	 * 到天
	 * @param year
	 * @return
	 */
	public static String[] getKssjJssjDay(String year){
		String []result = new String[]{"",""};
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");

		String ymd = sdf2.format(new Date());
		String nowyear = ymd.substring(0,4);
		String lastyear = String.valueOf(Integer.parseInt(nowyear) - 1);
		String sftjrEnd = String.valueOf(Integer.parseInt(sftjr) - 1);
		String month = ymd.substring(4,6);
		
		if(useSftj){
			//按司法统计月
			if(year.equals(nowyear)){
				
				String day = ymd.substring(6,8);
				if(Integer.parseInt(day) >= Integer.parseInt(sftjr)){
					//超过司法统计日，算下个月
					if("12".equals(month)){
						result[0] = lastyear + "12"+sftjr;
						result[1] = year + "12" + sftjrEnd;
					}else if(Integer.parseInt(month) >= 1 && Integer.parseInt(month) <= 8){
						result[0] = lastyear + "12"+sftjr;
						result[1] = year + "0" + String.valueOf(Integer.parseInt(month) + 1) + sftjrEnd;
					}else{
						result[0] = lastyear + "12"+sftjr;
						result[1] = year + String.valueOf(Integer.parseInt(month) + 1) + sftjrEnd;
					}
				}else{
					result[0] = lastyear + "12"+sftjr;
					result[1] = year + month + sftjrEnd;
				}
				
			}else{
				result[0] = lastyear + "12"+sftjr;
				result[1] = year + "12"+sftjrEnd;
			}
		}else{
			if(year.equals(nowyear)){
				result[0] = lastyear+"12"+sftjr;
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
				result[1] = sdf.format(new Date())+sftjrEnd;
			}else{
				result[0] = lastyear+"12"+sftjr;
				result[1] = year+"12"+sftjrEnd;
			}
		}
		return result;
	}
	
	/**
	 * 根据年度获取开始月份_结束月份，传入的为要统计的年
	 * @param year
	 * @return
	 */
	public static String[] getKssjJssj(String year){
		String []result = new String[]{"",""};
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");

		String ymd = sdf2.format(new Date());
		String nowyear = ymd.substring(0,4);
		String month = ymd.substring(4,6);
		
		if(useSftj){
			//按司法统计月
			if(year.equals(nowyear)){
				
				String day = ymd.substring(6,8);
				if(Integer.parseInt(day) >= Integer.parseInt(sftjr)){
					//超过司法统计日，算下个月
					if("12".equals(month)){
						result[0] = year + "01";
						result[1] = year + "12";
					}else if(Integer.parseInt(month) >= 1 && Integer.parseInt(month) <= 8){
						result[0] = year + "01";
						result[1] = year + "0" + String.valueOf(Integer.parseInt(month) + 1);
					}else{
						result[0] = year + "01";
						result[1] = year + String.valueOf(Integer.parseInt(month) + 1);
					}
				}else{
					result[0] = year + "01";
					result[1] = year + month;
				}
				
			}else{
				result[0] = year + "01";
				result[1] = year + "12";
			}
		}else{
			if(year.equals(nowyear)){
				result[0] = year+"01";
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
				result[1] = sdf.format(new Date());
			}else{
				result[0] = year+"01";
				result[1] = year+"12";
			}
		}
		
		return result;
	}
	
	//获取去年同期月份区间
	public static String[] getKssjJssj2(String kssj,String jssj){
		String []result = new String[]{"",""};
		
		result[0] = (Integer.parseInt(kssj.substring(0,4)) - 1) + kssj.substring(4);
		result[1] = (Integer.parseInt(jssj.substring(0,4)) - 1) + jssj.substring(4);
		
		return result;
	}
	
	public static void main(String[] args) {
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(2);
		df.setGroupingSize(0);
		df.setRoundingMode(RoundingMode.FLOOR);

		//df.f
		System.out.println(df.format(9.99999));
		//System.out.println(String.format("%.2f", 9.99999));

	}
	
	public static String getNdOption(){
		String re = "";
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		String nowyear = sdf.format(new Date());
		int iyear = Integer.parseInt(nowyear);
		for(int i = 0;i < 3 ; i++){
			re += "<option value='"+(iyear-i)+"'>"+(iyear-i)+"</option>";
		}
		
		
		return re;
	}
	
}
