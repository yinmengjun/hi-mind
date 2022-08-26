SELECT
	MIN( hire_date ) "Earliest" 
FROM
	hr.employees;
SELECT
	manager_id,
	last_name,
	hire_date,
	salary,
	MIN( salary ) OVER ( PARTITION BY manager_id ORDER BY hire_date RANGE UNBOUNDED PRECEDING ) AS p_cmin 
FROM
	hr.employees 
ORDER BY
	manager_id,
	last_name,
	hire_date,
	salary;