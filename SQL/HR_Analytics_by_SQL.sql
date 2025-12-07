create database hr_analytics;
use hr_analytics;
describe hr_employee;

select * from hr_employee;

# Total Records
select count(*) 
from hr_employee;

# Identification of Missing Values
select count(*)
from hr_employee
where Last_Working_Date is null;

# Feature Engineering
alter table hr_employee add column Age_Group varchar(30);
set sql_safe_updates=0;
update hr_employee
set Age_Group=case
when Age>=20 and Age<=30 then "Young"
when Age>30 and Age<=40 then "Adult"
else "Senior"
end;

alter table hr_employee add column Experience_Level varchar(30);
update hr_employee
set Experience_Level=case
when Experience_Years<=2 then "Junior"
when Experience_Years<=5 then "Mid_Level"
when Experience_Years<=10 then "Senior"
else "Expert"
end;

alter table hr_employee add column Employment_Status varchar(30);
update hr_employee
set Employment_Status = case
when Attrition='No' then "Active"
else "Exited"
end;

# overall Attrition_rate
select round(count(case when Attrition='Yes' then 1 end),2)
			*100/count(Employee_ID) as Attrition_Rate
from hr_employee;

# Attrition by City
select count(Attrition) as Attrited_Employees,
City
from hr_employee
group by City
order by count(Attrition)
desc;

# Exploratory Data Analysis

#Employees by Department
select count(Employee_ID) as Total_Employees,
Department
from hr_employee
group by Department;

# Employees by Gender
select count(*) as Employees,Gender
from hr_employee
group by Gender;

# Attrition count by department
select count(Employment_Status) as Attrition_Count,
Department
from hr_employee
where Employment_Status='Exited'
group by Department;

# Attrition Rate by Department
select count(case when Attrition='Yes' then 1 end) as Attrited_Employees,
count(Employee_ID) as Total_Employees,
round(count(case when Attrition='Yes' then 1 end)*100/count(Employee_ID),2) as Attrition_Rate,
Department
from hr_employee
group by Department
order by Attrition_Rate desc;

# Average Salary by Department
select round(avg(Salary),2) as Average_Salary,
Department
from hr_employee
group by Department;

#Top 10 Employees who receives Higher Salary
select max(Salary) as Highest_Salary,Employee_ID
from hr_employee
group by Employee_ID
order by max(Salary) desc;

# Average age and experience years by department
select round(avg(Age),2) as Average_Age,
round(avg(Experience_Years),2) as Average_Experience_Years,
Department
from hr_employee
group by Department;

#Highest Attrition by Top 5 Job_Role
select count(Attrition) as Highest_Attrition,
Job_Role
from hr_employee
where Attrition='Yes'
group by Job_Role
order by count(Attrition)
desc
limit 5;

# Average Performance Rating by Job Role
select round(avg(Performance_Rating),2) as Average_Performance_Rating,
Job_Role
from hr_employee
group by Job_Role
order by avg(Performance_Rating)
desc;

# Average, Minimum, Maximum Salary by education
select round(avg(Salary),2) as Average_Salary,
min(Salary) as Minimum_Salary,
max(Salary) as Maximum_Salary,
Education
from hr_employee
group by Education;

# Employees by City
select count(Employee_ID) as Total_Employees,City
from hr_employee
group by City;

# Attrition & Performance_Analysis

# Attrition Rate by Gender
select count(case when Attrition='Yes' then 1 end) as Attrited_Employees,
count(Employee_ID) as Total_Employees,
round(count(case when Attrition='Yes' then 1 end)*100/count(Employee_ID),2) as Attrition_Rate,
Gender
from hr_employee
group by Gender
order by Attrition_Rate desc;

# Attrition_Rate by Age_Group
select count(Employee_ID) as Total_Employees,
round(count(case when Attrition='Yes' then 1 end)*100/count(Employee_ID),2) as Attrition_Rate,
Age_Group
from hr_employee
group by Age_Group;

# Attrition Rate by Experience_Level
select count(case when Attrition='Yes' then 1 end) as Attrited_Employees,
count(Employee_ID) as Total_Employees,
round(count(case when Attrition='Yes' then 1 end)*100/count(Employee_ID),2) as Attrition_Rate,
Experience_Level
from hr_employee
group by Experience_Level;

# Corelation check of average salary by employees who left Vs Stayed
select round(avg(Salary),2) as Average_Salary,
Attrition
from hr_employee
group by Attrition;

# Employees under Performance Improvement plan
select count(Performance_Improvement_Plan) as Employee_under_Improvement_Plan,
Department
from hr_employee
where Performance_Improvement_Plan='Yes'
group by Department;

# Attrition by Trainings
select Total_Trainings,count(Attrition) as Attrited_Employees
from hr_employee
where Attrition='Yes' 
group by Total_Trainings
order by Total_Trainings
asc;

# Average Leave count by Attrition
select Attrition,
avg(Leaves_Count) as Average_Leave_Count
from hr_employee
group by Attrition;

# Sub-Queries

# Employee with salary higher than average salary
select Employee_ID,Salary
from hr_employee
where Salary>(select avg(Salary) from hr_employee);

# Attrition Rate higher than overall Attrition_Rate by Department
select Department,count(case when Attrition='Yes' then 1 end)*100/count(Employee_ID) as Attrition_Rate
from hr_employee 
group by Department
having count(case when Attrition='Yes' then 1 end)*100/count(Employee_ID) > 
     (select count(case when Attrition='Yes' then 1 end)*100/count(Employee_ID)
     from hr_employee);
     
# Employee with Salary higher than their department average salary
select Employee_ID,
	   Department,
       Salary
from hr_employee e 
where Salary>(
select avg(Salary)
from hr_employee
where Department=e.Department);

# job roles with salary higher than the overall average salary
select Job_Role,Salary
from hr_employee
where Salary>
(select 
avg(Salary)
from hr_employee);
