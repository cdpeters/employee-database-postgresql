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
SELECT COUNT(ut.title) AS ct,
	   ut.title
  INTO retiring_titles
  FROM unique_titles AS ut
 GROUP BY ut.title
 ORDER BY ct DESC;


-- DELIVERABLE 2. Employees Eligible for the Mentorship Program
--
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


-- Deliverable 3.

-- Question 1: How many roles will need to be filled if the employees that meet
-- retirement eligibility choose to retire?

-- First create a table with retirement eligible employees with their titles and
-- departments
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	   e.first_name, e.last_name,
	   ti.title,
	   d.dept_name,
       ti.to_date
  INTO retiring_title_dept
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

-- the number of retirement eligible employees by department
SELECT rtd.dept_name,
  	   COUNT(rtd.emp_no) AS ct
  FROM retiring_title_dept AS rtd
 GROUP BY rtd.dept_name
 ORDER BY ct DESC;

-- Question 2: Are there enough qualified, retirement-ready employees to mentor
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


-- First create a table of all employees listed with their titles and hire dates
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	   e.first_name, e.last_name,
	   EXTRACT('year' FROM e.hire_date)::INTEGER AS hire_year,
	   ti.title
  INTO titles_by_hire
  FROM employees AS e
	   INNER JOIN titles AS ti
	   ON (e.emp_no = ti.emp_no)
 ORDER BY e.emp_no, ti.to_date DESC;

-- Next, use the table created in Deliverable 2 to count the number of employees
-- that are eligible to be mentors and group them by title
SELECT me.title,
       COUNT(me.emp_no) AS eligible_mentors
  INTO mentors_title
  FROM mentorship_eligibility AS me
 GROUP BY me.title

-- Create a similar table with new employees (employees hired in 1999) that
-- would need a mentor grouped by title
SELECT tbh.title,
	   COUNT(tbh.emp_no) AS mentors_needed
  INTO mentors_needed_title
  FROM titles_by_hire AS tbh
 WHERE tbh.hire_year = 1999
 GROUP BY tbh.title

-- Join the table of mentors by title and the mentors needed by title to create
-- a final table showing if the mentoring needs are met
SELECT mnt.title,
	   mnt.mentors_needed,
	   mt.eligible_mentors
  INTO mentoring_needs
  FROM mentors_needed_title AS mnt
	   INNER JOIN mentors_title AS mt
	   ON (mnt.title = mt.title);
