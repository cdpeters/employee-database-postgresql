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

-- Create retirement_info table from selected results
SELECT emp_no,
	   first_name, last_name
  INTO retirement_info
  FROM employees
 WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check table
SELECT *
  FROM retirement_info;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
	   dept_manager.emp_no,
	   dept_manager.from_date,
	   dept_manager.to_date
  FROM departments
	   INNER JOIN dept_manager
	   ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	   retirement_info.first_name,
	   retirement_info.last_name,
	   dept_emp.to_date
  FROM retirement_info
       LEFT JOIN dept_emp
       ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables with aliases
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   de.to_date
  FROM retirement_info AS ri
       LEFT JOIN dept_emp AS de
       ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables with aliases
SELECT d.dept_name,
	   dm.emp_no,
	   dm.from_date,
	   dm.to_date
  FROM departments AS d
	   INNER JOIN dept_manager AS dm
	   ON d.dept_no = dm.dept_no;

-- Create new table by joining retirement_info and dept_emp
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   de.to_date
  INTO current_emp
  FROM retirement_info AS ri
	   LEFT JOIN dept_emp AS de
       ON ri.emp_no = de.emp_no
 WHERE de.to_date = '9999-01-01';

SELECT * FROM current_emp;

-- DROP TABLE current_emp;

-- Employee count by department number
SELECT de.dept_no,
	   COUNT(ce.emp_no)
  INTO retirement_count
  FROM current_emp AS ce
  	   LEFT JOIN dept_emp AS de
	   ON ce.emp_no = de.emp_no
 GROUP BY de.dept_no
 ORDER BY de.dept_no;

-- Check the to_date in salaries
SELECT * FROM salaries
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
	   ce.last_name, ce.first_name,
	   dm.from_date, dm.to_date
  INTO manager_info
  FROM dept_manager AS dm
	   INNER JOIN departments AS d
	   ON (dm.dept_no = d.dept_no)
	   INNER JOIN current_emp AS ce
	   ON (dm.emp_no = ce.emp_no);

-- Department retirees
SELECT ce.emp_no,
	   ce.first_name, ce.last_name,
	   d.dept_name
  INTO dept_info
  FROM current_emp AS ce
  	   INNER JOIN dept_emp AS de
	   ON (ce.emp_no = de.emp_no)
	   INNER JOIN departments AS d
	   ON (de.dept_no = d.dept_no);

-- Possible retirees for sales department
SELECT ri.emp_no,
	   ri.first_name, ri.last_name,
	   d.dept_name
  FROM retirement_info AS ri
       INNER JOIN dept_emp AS de
	   ON (ri.emp_no = de.emp_no)
	   INNER JOIN departments AS d
	   ON (de.dept_no = d.dept_no)
 WHERE d.dept_name = 'Sales';

-- Possible retirees for sales and development departments
SELECT ri.emp_no,
	   ri.first_name, ri.last_name,
	   d.dept_name
  FROM retirement_info AS ri
       INNER JOIN dept_emp AS de
	   ON (ri.emp_no = de.emp_no)
	   INNER JOIN departments AS d
	   ON (de.dept_no = d.dept_no)
 WHERE d.dept_name IN ('Sales', 'Development');


