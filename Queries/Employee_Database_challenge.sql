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
 
 -- Unique titles table - use Dictinct with Orderby to remove duplicate rows
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
 ORDER BY e.emp_no;