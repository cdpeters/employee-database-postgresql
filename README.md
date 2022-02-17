# **Employee Database Using PostgreSQL**

## **Overview of Project**
The purpose of this project is to identify, for a fictional company, the number of employees that are likely to retire and thus the positions that will need to be filled in the near future. The company is also interested in determining which other employees would be eligible to work in a reduced capacity as a mentor in a mentorship program for new hires. The hope would be to ease the burden of losing many employees to retirement by helping to facilitate the transition to their replacements.

The data for this project is contained within six starting csv's that are imported into PostgresSQL for storage and querying. The data contains information about employees both past and present including the departments they worked for, titles, salary, and to/from dates. The starting csv's are:

| No. | File Name        | Description                                                 |
| --- | ---------------- | ----------------------------------------------------------- |
| 1   | *departments.csv*  | a look up table for department names by department number |
| 2   | *dept_emp.csv*     | employees for each department                             |
| 3   | *dept_manager.csv* | managers for each department                              |
| 4   | *employees.csv*    | employee information for each employee                    |
| 5   | *salaries.csv*     | salary information for each employee                      |
| 6   | *titles.csv*       | title information for each employee                       |

The work for determining the relevant retirement information that the company is interested in can be found in the form of queries in the file *[Employee_Database_challenge.sql](/Queries/Employee_Database_challenge.sql)* within the Queries directory. The starting csv's and all csv's of tables created from queries are contained within the *[data_files.zip](/Data/data_files.zip)* file in the Data directory.

>##### Note: The additional csv's in *data_files.zip* are the result of tangentially related queries not central to this particular project (see *queries.sql* in the Query directory for details).

<br/>

## **Analysis and Results**
### **Deliverable 1: Retirement by Title**
The first goal of the analysis is to retrieve the number of employees likely to be retiring, based on age, for each title that exists at the company. The range of birth dates used to filter the data will include the birth years 1952 to 1955. The *retirement_titles* table holds the retirement eligible employees and is created from the *employees* and *titles* tables. Past employees are filtered out and then the *retiring_titles* table is created by grouping the remaining employees by title. Below is the resulting table:

### *retiring_titles*
<div align="center">
    <img src="Images/retiring_titles.png" alt="retiring titles" />
</div>

- As would be expected, the titles with the highest number of retiring employees are the more senior level positions such as Senior Engineer and Senior Staff. Their counts comprise about 70% of all likely retirees.
- Two of the nine departments have managers that are retiring.

### **Deliverable 2: Mentorship Program Needs**
The second objective is to determine which employees that meet a specific age criteria would be eligible to join a mentorship program as mentors for new hires. The age criteria, in this instance, is restricted to current employees born in the year 1965. The choice of this particular birth year is to select employees decently close to the retirement age, the idea being that each year this analysis can be run again with the birth year increased by one to retrieve the next pool of mentorship program eligible employees.

The initial gathering of eligible mentors is done in the *mentorship_eligibility* table. For reporting, the *mentoring_needs* table is created in the Additional Queries of Interest section of the SQL file. For this table, in order to establish the number of mentors needed, the most recent year with complete hiring data is used as the class of "new hires" that would benefit from the program (see the comments under Question 2 in the section of additional queries). The resulting table showing the summary of mentoring needs is shown here:

### *mentoring_needs*
<div align="center">
    <img src="Images/mentoring_needs.png" alt="mentoring needs" />
</div>

- The percent_need_met column reveals that there are 3 titles for which the need for mentors is not met: Assistant Engineer, Engineer, and Staff. The needs for mentors for Senior Engineers and Senior Staff, however, are greatly exceeded.

The following *mentoring_needs_eng_staff* table further groups all of the engineering and staff titles to see if the excess mentors for the senior positions could possibly be used to meet the remaining needs.
### *mentoring_needs_eng_staff*
<div align="center">
    <img src="Images/mentoring_needs_eng_staff.png"
         alt="mentoring needs for all engineering and staff titles" />
</div>

- As seen in the table above, the total number of mentors with staff related titles exceeds the need, and in the case of engineers, the total number is very close to meeting the need. It is therefore recommended that the excess Senior Engineers and Senior Staff be used to cover the remaining need for mentors for the non-senior Engineering and Staff positions respectively. Additionally, some engineers from birth years near 1965 could be recruited for the program to  fully cover the small remaining need for engineering mentors.

<br/>

## **Summary**
**How many roles will need to be filled as the employees that meet retirement eligibility begin to retire?**

The following *retirement_summary* table gives a summary of the overall retirement situation the company is facing:

### *retirement_summary*
<div align="center">
    <img src="Images/retirement_summary.png" alt="retirement summary" />
</div>

In total, 30% of the current workforce meets the retirement eligibility requirements and thus 72,458 positions will need to be replaced with new hires.

<br/>

**Are there enough qualified, near retirement-ready employees in the departments to mentor the next generation of employees?**

As explained in the second bullet point in the deliverable 2 section, there are enough near retirement-ready employees that can work as mentors as along as the excess Senior position mentor-eligible employees are used to meet the need for non-senior positions.

<br/>

**Additional Queries**

Below is a query that shows the impact of the retirements on each department:

### *retiring_dept*
<div align="center">
    <img src="Images/retiring_dept.png" alt="retiring departments" />
</div>

The table shows that the three most heavily impacted departments will be Development, Production, and Sales. A further investigation comparing these numbers to the relative sizes of each departments might show that this was to be expected. Nonetheless, recruiting efforts should likely be emphasized in these departments as they appear to be the most important given the size of the expected loss due to retirements.

The following table breaks down the positions in need of replacement for the three departments by title. It is clear that prioritizing finding Senior Engineers for Development and Production, and Senior Staff for Sales will be important to maintaining the productivity of those departments.

### *top_3_dept_retiring_titles*
<div align="center">
    <img src="Images/top_3_dept_retiring_titles.png"
         alt="top 3 departments retiring titles" />
</div>

<br/>

Lastly, here is a follow up query, based on the second bullet point in deliverable 1, showing the departments of the retiring managers:

### *retiring_managers*
<div align="center">
    <img src="Images/retiring_managers.png" alt="retiring managers" />
</div>

 Since managers are involved in the recruiting and hiring processes for their respective departments, filling these two positions in Sales and Research should be the top priority above any suggestions stated above in order to allow for the smoothest transition going forward.