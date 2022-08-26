SELECT
	SUM( salary ) "Total" 
FROM
	hr.employees;
SELECT
	manager_id,
	last_name,
	salary,
	SUM( salary ) OVER ( PARTITION BY manager_id ORDER BY salary RANGE UNBOUNDED PRECEDING ) l_csum 
FROM
	hr.employees 
ORDER BY
	manager_id,
	last_name,
	salary,
	l_csum;
SELECT
	manager_id,
	last_name,
	salary,
	SUM( salary ) OVER ( PARTITION BY manager_id ORDER BY salary RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) l_csum 
FROM
	hr.employees 
ORDER BY
	manager_id,
	last_name,
	salary,
	l_csum;