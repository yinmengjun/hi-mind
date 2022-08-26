SELECT
	COUNT( * ) "Total" 
FROM
	hr.employees;
SELECT
	COUNT( * ) "Allstars" 
FROM
	hr.employees 
WHERE
	commission_pct > 0;
SELECT
	COUNT( commission_pct ) "Count" 
FROM
	hr.employees;
SELECT
	COUNT( DISTINCT manager_id ) "Managers" 
FROM
	hr.employees;
SELECT
	COUNT( ALL manager_id ) "Managers" 
FROM
	hr.employees;
SELECT
	last_name,
	salary,
	COUNT( * ) OVER ( ORDER BY salary RANGE BETWEEN 50 PRECEDING AND 150 FOLLOWING ) AS mov_count 
FROM
	hr.employees 
ORDER BY
	salary,
	last_name;