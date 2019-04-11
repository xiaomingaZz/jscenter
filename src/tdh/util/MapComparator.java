package tdh.util;

import java.util.Comparator;
import java.util.Map;

public class MapComparator<T extends Map<String, Object>> implements Comparator<T> {
	public String[] sortFields=null;
	public boolean descending=false;
	@SuppressWarnings("unused")
	@Override
	public int compare(T arg0, T arg1) {
		for(int i=0; i<sortFields.length;i++){
		 	String id0=arg0.get(sortFields[i]).toString();
        	String id1=arg1.get(sortFields[i]).toString();
			int result=id0.compareTo(id1);
			if(descending){
				return -result;
			}else{
				return result;
			}
		}
		return 0;
	}

}
