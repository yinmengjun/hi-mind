SELECT
	AVG( salary ) "Average" 
FROM
	hr.employees;
SELECT
	AVG( commission_pct ) 
FROM
	hr.employees 
WHERE
	employee_id IN ( 144, 145, 146 );
SELECT
	AVG( COALESCE( commission_pct, 0 ) ) 
FROM
	hr.employees 
WHERE
	employee_id IN ( 144, 145, 146 );
SELECT
	manager_id,
	last_name,
	hire_date,
	salary,
	AVG( salary ) OVER ( PARTITION BY manager_id ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) AS c_mavg 
FROM
	hr.employees 
ORDER BY
	manager_id,
	hire_date,
	salary;