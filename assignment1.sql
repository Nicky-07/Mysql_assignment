drop database if exists Company1;
CREATE DATABASE Company1;

-- Use the database
USE Company1;

-- Create the Worker table
CREATE TABLE Worker (
    WORKER_ID INT,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    DEPARTMENT VARCHAR(50),
    SALARY INT,
    JOINING_DATE DATE,
    EMAIL VARCHAR(100)
);

-- Insert data into Worker table
INSERT INTO Worker (WORKER_ID,FIRST_NAME, LAST_NAME, DEPARTMENT, SALARY, JOINING_DATE, EMAIL)
VALUES
(1,'Minakshi', 'sharma', 'HR', 80000, '2014-02-15', 'Minakshi.b@company.com'),
(2,'Vipul', 'Kumar', 'IT', 90000, '2014-03-10', 'vipul.k@company.com'),
(3,'Satish', 'Sharma', 'Finance', 85000, '2014-02-28', 'satish.s@company.com'),
(4,'Amit', 'Singh', 'IT', 75000, '2014-02-05', 'amit.s@company.com'),
(5,'Rahul', 'Verma', 'HR', 60000, '2015-01-10', 'rahul.v@company.com'),
(6,'Mohit', 'Khan', 'IT', 120000, '2014-02-25', 'mohit.k@company.com'),
(7,'Rakesh', 'Sethi', 'Finance', 95000, '2016-05-15', 'rakesh.s@company.com'),
(4,'Amit', 'Singh', 'IT', 75000, '2014-02-05', 'amit.s@company.com'),
(5,'Rahul', 'Verma', 'HR', 60000, '2015-01-10', 'rahul.v@company.com'),
(8,'Vipul', 'Verma', 'IT', 50000, '2019-01-10', 'vipul.v@company.com'),
(9,'Mittali', 'Kaushal', 'IT', 95000, '2019-03-05', 'mittali.k@'),
(10,'Ajay', 'Chauhan', 'Finance', 86000, '2017-02-05', 'ajay.c@.com'),
(11,'Vikas', 'Dubey', 'HR', 86000, '2018-01-04', 'vikas.d@yahoo.com');

CREATE TABLE WorkerDetails (
    WORKER_ID INT,
    FIRST_NAME VARCHAR(50),
    CITY VARCHAR(50)
);

INSERT INTO WorkerDetails (WORKER_ID, FIRST_NAME, CITY)
VALUES
(1, 'Minakshi', 'Delhi'),
(2, 'Vipul', 'Mumbai'),
(3, 'Satish', 'Kolkata'),
(5, 'Rahul', 'Chennai'),
(6, 'Mohit', 'Delhi'),
(7, 'Rakesh', 'Bangalore'),
(8, 'Vipul', 'Pune'),
(9, 'Mittali', 'Kolkata');

--  Q-1. Write an SQL query to fetch “FIRST_NAME” from Worker table using the alias name as <WORKER_NAME>;.

select first_name as worker_name 
from worker;

--   Q-2. Write an SQL query to fetch unique values of DEPARTMENT from Worker table.
select 
	distinct department
from worker;

--   Q-3. Write an SQL query to fetch total number of unique values of DEPARTMENT from Worker table.
select 
	count(distinct(department))
from worker;

--   Q-4. Write an SQL query to show the last 5 record from a table.
select *
from worker
limit 5 offset 8;
    
-- another way (use in case of p.k)
select * from worker
order by worker_id desc
limit 5;

-- another way
with rankedrecord as (
select *, row_number() over () as row_num
from worker
)
select *
from rankedrecord
where row_num > (select count(*) from worker) - 5;

--  Q-5. Write an SQL query to print the first three characters of  FIRST_NAME from Worker table.
select substring(first_name,1,3)
from worker;

select *,
	substring(first_name,1,3) as 3_char_name
from worker;

--  Q-6. Write an SQL query to find the position of the alphabet (‘a’) in the first name column ‘Amitabh’ from Worker table.	
select position('a' in first_name) as position_of_a
from worker
where first_name = 'minakshi';

-- other way
select locate('a',first_name) as position_of_a
from worker
where first_name = 'ajay';

-- other way 
select locate('a',substring(first_name,2,10))+1 as position_of_a
from worker            -- where 2=start index, 10=next char after index,+1=char that we left 
where first_name = 'ajay';

-- bt above code can't be applicable on all names so lets change with variables
-- 3 (locate index of a and +1 because we want to start the substring index from 3)
-- 10 (replace it with length of string)
-- +2 (2 is the position of i so wew can replace with it locate('a',first_name))
select locate('a',substring(first_name,locate('a',first_name)+1,length(first_name)))+locate('a',first_name) as position
from worker
where first_name = 'ajay';

-- other way
select instr('a',first_name) as position_of_a
from worker
where first_name = 'minakshi';

-- Q-7. Write an SQL query to print the highest salary in each department.
select department, max(salary) as max_Salary
from worker
group by department;

-- Q-8. Write an SQL query to print the name of employees having the highest salary in each department.
select 
	first_name,
	last_name,
	salary,
	department
from worker
where (department,salary) in (
	select department, max(salary)
	from worker
	group by department
);

--  other way
select 
	first_name,
	last_name,
	salary,
	department
from worker as w1
where salary=(
	select max(salary)
	from worker as w2
    where w1.department = w2.department
);