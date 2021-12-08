1.  根据表一和表二的样例数据，请写出SQL语句运行结果

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
| 0501001 | 01002 | 60 | 2005-02-11 |
| 0501002 | 01002 | 70 | 2005-03-11 |
| 0601001 | 01003 | 80 | 2005-02-11 |
| 0601002 | 01003 | 90 | 2005-03-11 |

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

[SQL Fiddle][1]

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
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0501001', '01002', 60, TO_DATE( '2005-02-11', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0501002', '01002', 70, TO_DATE( '2005-03-11', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0601001', '01003', 80, TO_DATE( '2005-02-11', 'yyyy-mm-dd' ) );
    INSERT INTO b ( eno, pno, eamt, date2 )
    VALUES
    	( '0601002', '01003', 90, TO_DATE( '2005-03-11', 'yyyy-mm-dd' ) );
**Query 1**:

    SELECT
    	a.pno,
    	a.pamt,
    	b.eno 
    FROM
    	a LEFT OUTER
    	JOIN b ON a.pno = b.pno

**[Results][2]**:

    |   PNO | PAMT |     ENO |
    |-------|------|---------|
    | 01001 |  100 | 0101001 |
    | 01001 |  100 | 0201001 |
    | 01001 |  100 | 0301001 |
    | 01001 |  100 | 0101002 |
    | 01002 |  150 | 0501001 |
    | 01002 |  150 | 0501002 |
**Query 2**:

    
    SELECT
    	a.pno,
    	a.pamt,
    	b.eno 
    FROM
    	a LEFT OUTER
    	JOIN b ON a.pno = b.pno 
    	AND b.pno = '01001'

**[Results][3]**:

    |   PNO | PAMT |     ENO |
    |-------|------|---------|
    | 01001 |  100 | 0101001 |
    | 01001 |  100 | 0201001 |
    | 01001 |  100 | 0301001 |
    | 01001 |  100 | 0101002 |
    | 01002 |  150 |  (null) |
**Query 3**:

    
    SELECT
    	a.pno,
    	a.pamt,
    	b.eno 
    FROM
    	a LEFT OUTER
    	JOIN b ON a.pno = b.pno 
    WHERE
    	b.pno = '01001'

**[Results][4]**:

    |   PNO | PAMT |     ENO |
    |-------|------|---------|
    | 01001 |  100 | 0101001 |
    | 01001 |  100 | 0201001 |
    | 01001 |  100 | 0301001 |
    | 01001 |  100 | 0101002 |

  [1]: http://sqlfiddle.com/#!4/97c777/2
  [2]: http://sqlfiddle.com/#!4/97c777/2/0
  [3]: http://sqlfiddle.com/#!4/97c777/2/1
  [4]: http://sqlfiddle.com/#!4/97c777/2/2
