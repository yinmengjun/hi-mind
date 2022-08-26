SELECT
	department_id,
	first_name,
	last_name,
	salary 
FROM
	(
	SELECT
		department_id,
		first_name,
		last_name,
		salary,
		ROW_NUMBER () OVER ( PARTITION BY department_id ORDER BY salary DESC ) rn 
	FROM
		hr.employees 
	) 
WHERE
	rn <= 3 
ORDER BY
	department_id,
	salary DESC,
	last_name;