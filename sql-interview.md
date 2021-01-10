1.  如表一所示，该表存在一条重复记录，需要根据以下要求编写SQL  
a)  通过SQL代码实现，查询出该表的所有记录（重复记录只显示一条）  
b)  通过SQL代码删除表一的重复记录（重复记录只保留一条）  
表一：t03_acct_trade_detail 账户交易明细表

| cust_id（客户id） | acct_no（账户id） | org_name（所属机构） | amt（交易金额） | txn_dt（交易日期） | current_bal（当前余额） |
| :--- | :--- | :---: | :--- | :--- | :--- |
| 6000121 | 9000000001 | 上海分行 | 100.00 | 20120701 | 20000 |
| 6000121 | 9000000001 | 上海分行 | 100.00 | 20120701 | 20000 |
| 6000122 | 9000000002 | 宁波分行 | 200.00 | 20120701 | 30000 |

请写出实现的SQL语句

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

2.  根据表一和表二的样例数据，请写出SQL查询结果。  
表一 （a）

| pno（pk） | pamt | date2 |
| :--- | :--- | :--- |
| 01001 | 100 | 2005-01-01 |
| 01002 | 150 | 2005-02-01 |

表二 （b）

| eno（pk） | pno | eamt | date2 |
| :--- | :--- | :--- | :--- |
| 0101001 | 01001 | 10 | 2005-01-05 |
| 0201001 | 01001 | -15 | 2005-01-21 |
| 0301001 | 01001 | -5 | 2005-02-11 |
| 0101002 | 01001 | 50 | 2005-02-11 |

SQL代码如下：

    SELECT
    	count( a.pno ),
    	count( * ) 
    FROM
    	b
    	LEFT JOIN a ON b.pno = a.pno;
    SELECT
    	count( b.pno ),
    	count( * ) 
    FROM
    	a
    	LEFT JOIN b ON a.pno = b.pno;
请写出运行结果

[SQL Fiddle][4]

**Oracle 11g R2 Schema Setup**:

    CREATE TABLE a ( pno VARCHAR2 ( 30 ), pamt NUMBER, date2 DATE );
    INSERT INTO a ( pno, pamt, date2 )
    VALUES
    	( '01001', 100, TO_DATE( '2005-01-01', 'yyyy-mm-dd' ) );
    INSERT INTO a ( pno, pamt, date2 )
    VALUES
    	( '01002', 150, TO_DATE( '2005-02-01', 'yyyy-mm-dd' ) );
    CREATE TABLE b ( eno VARCHAR2 ( 30 ), pno VARCHAR2 ( 30 ), eamt NUMBER, date2 DATE );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0101001', '01001', 10, TO_DATE( '2005-01-05', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0201001', '01001',
    	- 15, TO_DATE( '2005-01-21', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0301001', '01001',
    	- 5, TO_DATE( '2005-02-11', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0101002', '01001', 50, TO_DATE( '2005-02-11', 'yyyy-mm-dd' ) );
**Query 1**:

    SELECT
    	count( a.pno ),
    	count( * ) 
    FROM
    	b
    	LEFT JOIN a ON b.pno = a.pno

**[Results][5]**:

    | COUNT(A.PNO) | COUNT(*) |
    |--------------|----------|
    |            4 |        4 |
**Query 2**:

    
    SELECT
    	count( b.pno ),
    	count( * ) 
    FROM
    	a
    	LEFT JOIN b ON a.pno = b.pno

**[Results][6]**:

    | COUNT(B.PNO) | COUNT(*) |
    |--------------|----------|
    |            4 |        5 |

  [4]: http://sqlfiddle.com/#!4/9e68a/1
  [5]: http://sqlfiddle.com/#!4/9e68a/1/0
  [6]: http://sqlfiddle.com/#!4/9e68a/1/1

3.  根据表一和表二的样例数据，请写出SQL语句运行结果  
表一 （a）

| pno（pk） | pamt | date2 |
| :--- | :--- | :--- |
| 01001 | 100 | 2005-01-01 |
| 01002 | 150 | 2005-02-01 |

表二 （b）

| eno（pk） | pno | eamt | date2 |
| :--- | :--- | :--- | :--- |
| 0101001 | 01001 | 10 | 2005-01-05 |
| 0201001 | 01001 | -15 | 2005-01-21 |
| 0301001 | 01001 | -5 | 2005-02-11 |
| 0101002 | 01001 | 50 | 2005-02-11 |

SQL代码如下：

    SELECT
    	a.pno,
    	a.pamt,
    	b.eno 
    FROM
    	a LEFT OUTER
    	JOIN b ON a.pno = b.pno 
    	AND b.pno = '01001';
    SELECT
    	a.pno,
    	a.pamt,
    	b.eno 
    FROM
    	a LEFT OUTER
    	JOIN b ON a.pno = b.pno 
    WHERE
    	b.pno = '01001';
请写出运行结果

[SQL Fiddle][7]

**Oracle 11g R2 Schema Setup**:

    CREATE TABLE a ( pno VARCHAR2 ( 30 ), pamt NUMBER, date2 DATE );
    INSERT INTO a ( pno, pamt, date2 )
    VALUES
    	( '01001', 100, TO_DATE( '2005-01-01', 'yyyy-mm-dd' ) );
    INSERT INTO a ( pno, pamt, date2 )
    VALUES
    	( '01002', 150, TO_DATE( '2005-02-01', 'yyyy-mm-dd' ) );
    CREATE TABLE b ( eno VARCHAR2 ( 30 ), pno VARCHAR2 ( 30 ), eamt NUMBER, date2 DATE );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0101001', '01001', 10, TO_DATE( '2005-01-05', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0201001', '01001',
    	- 15, TO_DATE( '2005-01-21', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0301001', '01001',
    	- 5, TO_DATE( '2005-02-11', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0101002', '01001', 50, TO_DATE( '2005-02-11', 'yyyy-mm-dd' ) );
**Query 1**:

    SELECT
    	a.pno,
    	a.pamt,
    	b.eno 
    FROM
    	a LEFT OUTER
    	JOIN b ON a.pno = b.pno 
    	AND b.pno = '01001'

**[Results][8]**:

    |   PNO | PAMT |     ENO |
    |-------|------|---------|
    | 01001 |  100 | 0101001 |
    | 01001 |  100 | 0201001 |
    | 01001 |  100 | 0301001 |
    | 01001 |  100 | 0101002 |
    | 01002 |  150 |  (null) |
**Query 2**:

    
    SELECT
    	a.pno,
    	a.pamt,
    	b.eno 
    FROM
    	a LEFT OUTER
    	JOIN b ON a.pno = b.pno 
    WHERE
    	b.pno = '01001'

**[Results][9]**:

    |   PNO | PAMT |     ENO |
    |-------|------|---------|
    | 01001 |  100 | 0101001 |
    | 01001 |  100 | 0201001 |
    | 01001 |  100 | 0301001 |
    | 01001 |  100 | 0101002 |

  [7]: http://sqlfiddle.com/#!4/9e68a/2
  [8]: http://sqlfiddle.com/#!4/9e68a/2/0
  [9]: http://sqlfiddle.com/#!4/9e68a/2/1

4.  通过SQL语句将表一的数据转换成为表二所展现形式  
表一 （a）

| rq | shengfu |
| :--- | :--- |
| 2005-05-09 | 胜 |
| 2005-05-09 | 胜 |
| 2005-05-09 | 负 |
| 2005-05-09 | 负 |
| 2005-05-10 | 胜 |
| 2005-05-10 | 负 |
| 2005-05-10 | 负 |

表二 （b）

| rq | 胜 | 负 |
| :--- | :--- | :--- |
| 2005-05-09 | 2 | 2 |
| 2005-05-10 | 1 | 2 |

请写出实现的SQL语句

[SQL Fiddle][10]

**Oracle 11g R2 Schema Setup**:

    CREATE TABLE a ( rq DATE, shengfu VARCHAR2 ( 30 ) );
    INSERT INTO a ( rq, shengfu )
    VALUES
    	( TO_DATE( '2005-05-09', 'yyyy-mm-dd' ), '胜' );
    INSERT INTO a ( rq, shengfu )
    VALUES
    	( TO_DATE( '2005-05-09', 'yyyy-mm-dd' ), '胜' );
    INSERT INTO a ( rq, shengfu )
    VALUES
    	( TO_DATE( '2005-05-09', 'yyyy-mm-dd' ), '负' );
    INSERT INTO a ( rq, shengfu )
    VALUES
    	( TO_DATE( '2005-05-09', 'yyyy-mm-dd' ), '负' );
    INSERT INTO a ( rq, shengfu )
    VALUES
    	( TO_DATE( '2005-05-10', 'yyyy-mm-dd' ), '胜' );
    INSERT INTO a ( rq, shengfu )
    VALUES
    	( TO_DATE( '2005-05-10', 'yyyy-mm-dd' ), '负' );
    INSERT INTO a ( rq, shengfu )
    VALUES
    	( TO_DATE( '2005-05-10', 'yyyy-mm-dd' ), '负' );
**Query 1**:

    SELECT
    	rq,
    	COUNT( DECODE( shengfu, '胜', shengfu, NULL ) ) AS 胜,
    	COUNT( DECODE( shengfu, '负', shengfu, NULL ) ) AS 负 
    FROM
    	a 
    GROUP BY
    	rq

**[Results][11]**:

    |                   RQ | 胜 | 负 |
    |----------------------|---|---|
    | 2005-05-10T00:00:00Z | 1 | 2 |
    | 2005-05-09T00:00:00Z | 2 | 2 |
**Query 2**:

    
    SELECT
    	rq,
    	COUNT( CASE WHEN shengfu = '胜' THEN shengfu ELSE NULL END ) AS 胜,
    	COUNT( CASE WHEN shengfu = '负' THEN shengfu ELSE NULL END ) AS 负 
    FROM
    	a 
    GROUP BY
    	rq

**[Results][12]**:

    |                   RQ | 胜 | 负 |
    |----------------------|---|---|
    | 2005-05-10T00:00:00Z | 1 | 2 |
    | 2005-05-09T00:00:00Z | 2 | 2 |
**Query 3**:

    
    SELECT
    	rq,
    	COUNT( CASE shengfu WHEN '胜' THEN shengfu ELSE NULL END ) AS 胜,
    	COUNT( CASE shengfu WHEN '负' THEN shengfu ELSE NULL END ) AS 负 
    FROM
    	a 
    GROUP BY
    	rq

**[Results][13]**:

    |                   RQ | 胜 | 负 |
    |----------------------|---|---|
    | 2005-05-10T00:00:00Z | 1 | 2 |
    | 2005-05-09T00:00:00Z | 2 | 2 |

  [10]: http://sqlfiddle.com/#!4/f31d5/1
  [11]: http://sqlfiddle.com/#!4/f31d5/1/0
  [12]: http://sqlfiddle.com/#!4/f31d5/1/1
  [13]: http://sqlfiddle.com/#!4/f31d5/1/2

5.  如表一所示，该表记录了客户所持银行卡的消费信息。通过SQL语句计算一年内，客户每月的消费金额。  
查询结果格式如下：

| cust_id（客户号） | month（月份） | amt（消费金额） |
| :--- | :--- | :--- |
