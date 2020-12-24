1.  如表一所示，该表存在一条重复记录，需要根据以下要求编写SQL  
a)  通过SQL代码实现，查询出该表的所有记录（重复记录只显示一条）  
b)  通过SQL代码删除表一的重复记录（重复记录只保留一条）  
表一：t03_acct_trade_detail 账户交易明细表

| cust_id（客户id） | acct_no（账户id） | org_name（所属机构） | amt（交易金额） | txn_dt（交易日期） | current_bal（当前余额） |
| :--- | :--- | :---: | :--- | :--- | :--- |
| 6000121 | 9000000001 | 上海分行 | 100.00 | 20120701 | 20000 |
| 6000121 | 9000000001 | 上海分行 | 100.00 | 20120701 | 20000 |
| 6000122 | 9000000002 | 宁波分行 | 200.00 | 20120701 | 30000 |

请写出实现的SQL语句：

[SQL Fiddle][1]

**Oracle 11g R2 Schema Setup**:

    CREATE TABLE t03_acct_trade_detail (
    	cust_id VARCHAR2 ( 30 ),
    	acct_no VARCHAR2 ( 30 ),
    	org_name VARCHAR2 ( 30 ),
    	amt NUMBER ( 18, 2 ),
    	txn_dt VARCHAR2 ( 30 ),
    	current_bal NUMBER 
    );
    INSERT INTO t03_acct_trade_detail ( cust_id, acct_no, org_name, amt, txn_dt, current_bal )
    VALUES
    	( '6000121', '9000000001', '上海分行', 100.00, '20120701', 20000 );
    INSERT INTO t03_acct_trade_detail ( cust_id, acct_no, org_name, amt, txn_dt, current_bal )
    VALUES
    	( '6000121', '9000000001', '上海分行', 100.00, '20120701', 20000 );
    INSERT INTO t03_acct_trade_detail ( cust_id, acct_no, org_name, amt, txn_dt, current_bal )
    VALUES
    	( '6000122', '9000000002', '宁波分行', 200.00, '20120701', 30000 );
**Query 1**:

    SELECT
    	* 
    FROM
    	t03_acct_trade_detail a 
    WHERE
    	a.ROWID = (
    	SELECT
    		MIN( b.ROWID ) 
    	FROM
    		t03_acct_trade_detail b 
    	WHERE
    		b.cust_id = a.cust_id 
    		AND b.acct_no = a.acct_no 
    	)

**[Results][2]**:

    | CUST_ID |    ACCT_NO | ORG_NAME | AMT |   TXN_DT | CURRENT_BAL |
    |---------|------------|----------|-----|----------|-------------|
    | 6000121 | 9000000001 |     上海分行 | 100 | 20120701 |       20000 |
    | 6000122 | 9000000002 |     宁波分行 | 200 | 20120701 |       30000 |
**Query 2**:

    
    DELETE 
    FROM
    	t03_acct_trade_detail a 
    WHERE
    	a.ROWID > (
    	SELECT
    		MIN( b.ROWID ) 
    	FROM
    		t03_acct_trade_detail b 
    	WHERE
    		b.cust_id = a.cust_id 
    	AND b.acct_no = a.acct_no 
    	)

**[Results][3]**:


  [1]: http://sqlfiddle.com/#!4/8cce1/1
  [2]: http://sqlfiddle.com/#!4/8cce1/1/0
  [3]: http://sqlfiddle.com/#!4/8cce1/1/1

2.  根据表二和表三的样例数据，请写出SQL查询结果。  
表二 （a）

| pno（pk） | pamt | date2 |
| :--- | :--- | :--- |
| 01001 | 100 | 2005-01-01 |
| 01002 | 150 | 2005-02-01 |
