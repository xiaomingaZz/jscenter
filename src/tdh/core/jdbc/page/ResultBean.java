package tdh.core.jdbc.page;

import java.util.List;

public class ResultBean {
  /** 查询结果的总记录数. */
  private int totalRows;
  
  /**
   * 查询结果集
   */
  private List<?> result;
  public int getTotalRows() {
    return totalRows;
  }
  public void setTotalRows(int totalRows) {
    this.totalRows = totalRows;
  }
  public List<?> getResult() {
    return result;
  }
  public void setResult(List<?> result) {
    this.result = result;
  }
  
  
}
