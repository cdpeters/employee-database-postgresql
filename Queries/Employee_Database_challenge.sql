-- DELIVERABLE 1. Number of Retiring Employees by Title
-- Retirement titles table
SELECT e.emp_no,
	   e.first_name, e.last_name,
	   ti.title,
	   ti.from_date, ti.to_date
  INTO retirement_titles
  FROM employees AS e
  	   INNER JOIN titles AS ti
	   ON (e.emp_no = ti.emp_no)
 WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
 ORDER BY e.emp_no;

 -- Unique titles table - use Distinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
       rt.first_name, rt.last_name,
       rt.title
  INTO unique_titles
  FROM retirement_titles AS rt
 WHERE rt.to_date = '9999-01-01'
 ORDER BY rt.emp_no, rt.to_date DESC;

-- Retiring titles table
SELECT COUNT(ut.title) AS count,
	   ut.title
  INTO retiring_titles
  FROM unique_titles AS ut
 GROUP BY ut.title
 ORDER BY count DESC;

--------------------------------------------------------------------------------
-- DELIVERABLE 2. Employees Eligible for the Mentorship Program

SELECT DISTINCT ON (e.emp_no) e.emp_no,
	   e.first_name, e.last_name,
	   e.birth_date,
	   de.from_date, de.to_date,
	   ti.title
  INTO mentorship_eligibility
  FROM employees AS e
  	   INNER JOIN dept_emp AS de
	   ON (e.emp_no = de.emp_no)
	   INNER JOIN titles AS ti
	   ON (e.emp_no = ti.emp_no)
 WHERE (de.to_date = '9999-01-01')
   AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
 ORDER BY e.emp_no, ti.to_date DESC;

--------------------------------------------------------------------------------
-- ADDITIONAL QUERIES OF INTEREST

-- QUESTION 1: How many roles will need to be filled if the employees that meet
-- retirement eligibility choose to retire?

-- First create a table with retirement eligible employees with their titles and
-- departments
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	   e.first_name, e.last_name,
	   ti.title,
	   d.dept_name,
       ti.to_date
  INTO current_retiring
  FROM employees AS e
  	   INNER JOIN titles AS ti
	   ON (e.emp_no = ti.emp_no)
	   INNER JOIN dept_emp AS de
	   ON (e.emp_no = de.emp_no)
	   INNER JOIN departments AS d
	   ON (de.dept_no = d.dept_no)
 WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (ti.to_date = '9999-01-01')
 ORDER BY e.emp_no, ti.to_date DESC;

-- Retirement by department (similar to deliverable 1 retiring_titles)
SELECT COUNT(cr.emp_no) AS count,
	   cr.dept_name
  INTO retiring_dept
  FROM current_retiring AS cr
 GROUP BY cr.dept_name
 ORDER BY count DESC;

-- Total number of positions needing replacing
SELECT SUM(rd.count) AS total_retiring
  FROM retiring_dept AS rd;

--------------------------------------------------------------------------------
-- QUESTION 2: Are there enough qualified, retirement-ready employees to mentor
-- new employees?

-- Assumption: New employees will refer to the most recent year where there is
-- complete hiring data.

-- The following query shows that the most recent year with any data is 2000 but
-- it is not complete (there are only hire dates up to 2000-01-28).
SELECT *
  FROM employees AS e
 ORDER BY e.hire_date DESC;
-- 1999 is the most recent year with complete hiring data. New employees will
-- now refer to employees hired in 1999.

-- First create a table of all employees listed with their current title and
-- hire date
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	   e.first_name, e.last_name,
	   EXTRACT(YEAR FROM e.hire_date)::INTEGER AS hire_year,
	   ti.title
  INTO emp_title_hire_date
  FROM employees AS e
	   INNER JOIN titles AS ti
	   ON (e.emp_no = ti.emp_no)
 ORDER BY e.emp_no, ti.to_date DESC;

-- Gather the new employees (employees hired in 1999) from emp_title_hire_date
-- and employees that meet mentorship eligibility from mentorship_eligibility
-- and group them by title
SELECT mn.title,
	   mn.mentors_needed,
	   em.eligible_mentors
  INTO mentoring_needs
  FROM (SELECT ethd.title,
	           COUNT(ethd.emp_no) AS mentors_needed
          FROM emp_title_hire_date AS ethd
         WHERE ethd.hire_year = 1999
         GROUP BY ethd.title) AS mn
	   INNER JOIN (SELECT me.title,
                          COUNT(me.emp_no) AS eligible_mentors
                     FROM mentorship_eligibility AS me
                    GROUP BY me.title) AS em
	   ON (mn.title = em.title);

--------------------------------------------------------------------------------
-- the departments of the retiring managers
SELECT cr.emp_no,
	   cr.first_name, cr.last_name,
	   cr.title,
	   cr.dept_name
  INTO retiring_managers
  FROM current_retiring AS cr
 WHERE cr.title = 'Manager';

 -------------------------------------------------------------------------------
-- Based on the retiring_dept results, here is a table containing the 3
-- departments with the most employees retiring and their counts by title
SELECT DISTINCT ti.title,
	   COALESCE(dev.development_count, 0) AS development_count,
	   COALESCE(prod.production_count, 0) AS production_count,
	   COALESCE(sales.sales_count, 0) AS sales_count
  INTO top_3_dept_retiring_titles
  FROM titles AS ti
       LEFT JOIN (SELECT cr.title,
		                 COUNT(cr.emp_no) AS development_count
	                FROM current_retiring AS cr
	               WHERE cr.dept_name = 'Development'
	               GROUP BY cr.title) AS dev
	   ON (ti.title = dev.title)
	   LEFT JOIN (SELECT cr.title,
				         COUNT(cr.emp_no) AS production_count
				    FROM current_retiring AS cr
		           WHERE cr.dept_name = 'Production'
		           GROUP BY cr.title) AS prod
	   ON (ti.title = prod.title)
	   LEFT JOIN (SELECT cr.title,
				         COUNT(cr.emp_no) AS sales_count
				    FROM current_retiring AS cr
		           WHERE cr.dept_name = 'Sales'
		           GROUP BY cr.title) AS sales
	   ON (ti.title = sales.title)
 ORDER BY ti.title;

--------------------------------------------------------------------------------
-- -- (optional) table showing percent retiring by department
-- SELECT ce.dept_name,
-- 	     ce.current_employees,
-- 	     re.retiring_employees,
-- 	     TO_CHAR(100 * (re.retiring_employees::FLOAT / ce.current_employees::FLOAT), 'fm00D0%') AS percent_retiring
--   FROM (SELECT d.dept_name,
-- 	             COUNT(de.emp_no) as current_employees
--           FROM dept_emp AS de
--                INNER JOIN departments AS d
--                ON (de.dept_no = d.dept_no)
--          WHERE de.to_date = '9999-01-01'
--          GROUP BY d.dept_name) AS ce
--        INNER JOIN (SELECT cr.dept_name,
-- 	                        COUNT(cr.emp_no) AS retiring_employees
--                      FROM current_retiring AS cr
--                     GROUP BY cr.dept_name) AS re
-- 	     ON (ce.dept_name = re.dept_name)
--  ORDER BY re.retiring_employees DESC;
