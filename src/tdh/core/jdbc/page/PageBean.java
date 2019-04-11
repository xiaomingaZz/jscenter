package tdh.core.jdbc.page;


public class PageBean {
  /** 每页最大记录数. */
  private int limit;

  /** 每页开始索引记录(第一页的start=0). */
  private int startRow;

  private String sql;

  private String countSql;

  private String hql;

  private String countHql;



  public PageBean() {
  }
  
  /**
   * @return the limit
   */
  public int getLimit() {
    return limit;
  }

  /**
   * @param limit
   *          the limit to set
   */
  public void setLimit(int limit) {
    this.limit = limit;
  }

  public int getStartRow() {
    return startRow;
  }

  public void setStartRow(int startRow) {
    this.startRow = startRow;
  }

  public String getSql() {
    return sql;
  }

  public void setSql(String sql) {
    this.sql = sql;
  }

  public String getCountSql() {
    return countSql;
  }

  public void setCountSql(String countSql) {
    this.countSql = countSql;
  }

  public String getHql() {
    return hql;
  }

  public void setHql(String hql) {
    this.hql = hql;
  }

  public String getCountHql() {
    return countHql;
  }

  public void setCountHql(String countHql) {
    this.countHql = countHql;
  }
}