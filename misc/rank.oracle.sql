SELECT
	RANK ( 15500,.05 ) WITHIN GROUP ( ORDER BY salary, commission_pct ) "Rank" 
FROM
	hr.employees;
SELECT
	RANK ( 15500 ) WITHIN GROUP ( ORDER BY salary DESC ) "Rank of 15500" 
FROM
	hr.employees;
SELECT
	department_id,
	last_name,
	salary,
	RANK () OVER ( PARTITION BY department_id ORDER BY salary ) RANK 
FROM
	hr.employees 
WHERE
	department_id = 60 
ORDER BY
	RANK,
	last_name;