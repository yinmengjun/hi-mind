SELECT
	MAX( salary ) "Maximum" 
FROM
	hr.employees;
SELECT
	manager_id,
	last_name,
	salary,
	MAX( salary ) OVER ( PARTITION BY manager_id ) AS mgr_max 
FROM
	hr.employees 
ORDER BY
	manager_id,
	last_name,
	salary;
SELECT
	manager_id,
	last_name,
	salary 
FROM
	( SELECT manager_id, last_name, salary, MAX( salary ) OVER ( PARTITION BY manager_id ) AS rmax_sal FROM hr.employees ) 
WHERE
	salary = rmax_sal 
ORDER BY
	manager_id,
	last_name,
	salary;