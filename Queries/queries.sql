-- Retirement eligibility
SELECT first_name, last_name
  FROM employees
 WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
  FROM employees
 WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create retiring_2requirements table from selected results
SELECT emp_no,
	   first_name, last_name
  INTO retiring_2requirements
  FROM employees
 WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check table
SELECT *
  FROM retiring_2requirements;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
	   dept_manager.emp_no,
	   dept_manager.from_date,
	   dept_manager.to_date
  FROM departments
	   INNER JOIN dept_manager
	   ON departments.dept_no = dept_manager.dept_no;

-- Joining retiring_2requirements and dept_emp tables
SELECT retiring_2requirements.emp_no,
	   retiring_2requirements.first_name,
	   retiring_2requirements.last_name,
	   dept_emp.to_date
  FROM retiring_2requirements
       LEFT JOIN dept_emp
       ON retiring_2requirements.emp_no = dept_emp.emp_no;

-- Joining retiring_2requirements and dept_emp tables with aliases
SELECT rr.emp_no,
	   rr.first_name,
	   rr.last_name,
	   de.to_date
  FROM retiring_2requirements AS rr
       LEFT JOIN dept_emp AS de
       ON rr.emp_no = de.emp_no;

-- Joining departments and dept_manager tables with aliases
SELECT d.dept_name,
	   dm.emp_no,
	   dm.from_date,
	   dm.to_date
  FROM departments AS d
	   INNER JOIN dept_manager AS dm
	   ON d.dept_no = dm.dept_no;

-- Create new table by joining retiring_2requirements and dept_emp
SELECT rr.emp_no,
	   rr.first_name,
	   rr.last_name,
	   de.to_date
  INTO current_2requirements
  FROM retiring_2requirements AS rr
	   LEFT JOIN dept_emp AS de
       ON rr.emp_no = de.emp_no
 WHERE de.to_date = '9999-01-01';

SELECT * FROM current_2requirements;

-- DROP TABLE current_2requirements;

-- Employee count by department number
SELECT de.dept_no,
	   COUNT(cr.emp_no)
  INTO retiring_2requirements_count
  FROM current_2requirements AS cr
  	   LEFT JOIN dept_emp AS de
	   ON cr.emp_no = de.emp_no
 GROUP BY de.dept_no
 ORDER BY de.dept_no;

-- Check the to_date in salaries
SELECT *
  FROM salaries
 ORDER BY to_date DESC;

-- Modify a previous query to add gender and to_date
SELECT e.emp_no,
	   e.first_name, e.last_name,
	   e.gender,
	   s.salary,
	   de.to_date
  INTO emp_info
  FROM employees AS e
  	   INNER JOIN salaries AS s
	   ON (e.emp_no = s.emp_no)
	   INNER JOIN dept_emp AS de
	   ON (e.emp_no = de.emp_no)
 WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
   AND (de.to_date = '9999-01-01');

-- DROP TABLE emp_info;

-- List of managers per department
SELECT dm.dept_no, d.dept_name,
	   dm.emp_no,
	   cr.last_name, cr.first_name,
	   dm.from_date, dm.to_date
  INTO manager_info
  FROM dept_manager AS dm
	   INNER JOIN departments AS d
	   ON (dm.dept_no = d.dept_no)
	   INNER JOIN current_2requirements AS cr
	   ON (dm.emp_no = cr.emp_no);

-- Department retirees
SELECT cr.emp_no,
	   cr.first_name, cr.last_name,
	   d.dept_name
  INTO dept_info
  FROM current_2requirements AS cr
  	   INNER JOIN dept_emp AS de
	   ON (cr.emp_no = de.emp_no)
	   INNER JOIN departments AS d
	   ON (de.dept_no = d.dept_no);

-- Possible retirees for sales department
SELECT rr.emp_no,
	   rr.first_name, rr.last_name,
	   d.dept_name
  FROM retiring_2requirements AS rr
       INNER JOIN dept_emp AS de
	   ON (rr.emp_no = de.emp_no)
	   INNER JOIN departments AS d
	   ON (de.dept_no = d.dept_no)
 WHERE d.dept_name = 'Sales';

-- Possible retirees for sales and development departments
SELECT rr.emp_no,
	   rr.first_name, rr.last_name,
	   d.dept_name
  FROM retiring_2requirements AS rr
       INNER JOIN dept_emp AS de
	   ON (rr.emp_no = de.emp_no)
	   INNER JOIN departments AS d
	   ON (de.dept_no = d.dept_no)
 WHERE d.dept_name IN ('Sales', 'Development');