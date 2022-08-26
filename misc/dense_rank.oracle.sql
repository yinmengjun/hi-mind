SELECT
	DENSE_RANK ( 15500,.05 ) WITHIN GROUP ( ORDER BY salary DESC, commission_pct ) "Dense Rank" 
FROM
	hr.employees;
SELECT
	department_id,
	last_name,
	salary,
	DENSE_RANK () OVER ( PARTITION BY department_id ORDER BY salary ) DENSE_RANK 
FROM
	hr.employees 
WHERE
	department_id = 60 
ORDER BY
	DENSE_RANK,
	last_name;