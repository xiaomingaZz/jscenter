package tdh.util;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

public class Sort {

	/**
	 * 对Map的排序算法
	 * @param list
	 * @param sortfield 参与排序的字段
	 */
	public static void MapListSortOn(List<Map<String, Object>> list,final String sortfield,final boolean desc){
		Collections.sort(list,new Comparator<Map<String,Object>>(){
            public int compare(Map<String, Object> arg0, Map<String, Object> arg1) {
            	
            	String id0=arg0.get(sortfield).toString();
            	String id1=arg1.get(sortfield).toString();
            	if(desc){
            		return id0.compareTo(id1);
            	}else{
            		return id1.compareTo(id0);
            	}
             }
         });
	}
	/**
	 * 对Map的排序算法 递增
	 * @param list
	 * @param sortfield 参与排序的字段
	 */
	public static void MapListSortOnDouble(List<Map<String, Object>> list,final String sortfield,final boolean desc){
		Collections.sort(list,new Comparator<Map<String,Object>>(){
            public int compare(Map<String, Object> arg0, Map<String, Object> arg1) {
            	Double id0=Double.parseDouble(arg0.get(sortfield).toString());
            	Double id1=Double.parseDouble(arg1.get(sortfield).toString());
            	if(desc){
            		 return id0.compareTo(id1);
            	}else{
            		 return id1.compareTo(id0);
            	}
             }
         });
	}
	/**
	 * 对Map的排序算法
	 * @param list
	 * @param sortfield 参与排序的字段
	 */
	public static void MapListSortOnInteger(List<Map<String, Object>> list,final String sortfield,final boolean desc){
		Collections.sort(list,new Comparator<Map<String,Object>>(){
            public int compare(Map<String, Object> arg0, Map<String, Object> arg1) {
            	Integer id0=Integer.parseInt(arg0.get(sortfield).toString());
            	Integer id1=Integer.parseInt(arg1.get(sortfield).toString());
            	if(desc){
           		 	return id0.compareTo(id1);
            	}else{
            		return id1.compareTo(id0);
            	}
             }
         });
	}
	/**
	 * 对Map的排序算法
	 * @param list
	 * @param sortfield 参与排序的字段
	 * @param descending 降序排列
	 */
	public static void MapListSortOn(List<Map<String, Object>> list,String[] sortfields,boolean descending){
		MapComparator<Map<String,Object>> comparator = new MapComparator<Map<String,Object>>();
		comparator.sortFields=sortfields;
		comparator.descending=descending;
 		Collections.sort(list,comparator);
	}
	
	/**
	 * 对Map的排序算法
	 * @param list
	 */
	public static void ListSortString(List<String> list,final boolean descending){
		Collections.sort(list,new Comparator<String>(){
            public int compare(String arg0, String arg1) {
            	if(descending){
            		   return -arg0.compareTo(arg1);
            	}else{
            		   return arg0.compareTo(arg1);
            	}
             }
         });
	}
	
	/**
	 * 对Map的排序算法
	 * @param list
	 */
	public static void ListSortLong(List<Long> list,final boolean descending){
		Collections.sort(list,new Comparator<Long>(){
            public int compare(Long arg0, Long arg1) {
              	if(descending){
         		   return -arg0.compareTo(arg1);
         	}else{
         		   return arg0.compareTo(arg1);
         	}
             }
         });
	}

	/**
	 * 对Map的排序算法
	 * @param list
	 */
	public static void ListSortInteger(List<Integer> list,final boolean descending){
		Collections.sort(list,new Comparator<Integer>(){
            public int compare(Integer arg0, Integer arg1) {
              	if(descending){
         		   return -arg0.compareTo(arg1);
         	}else{
         		   return arg0.compareTo(arg1);
         	}
             }
         });
	}
}
