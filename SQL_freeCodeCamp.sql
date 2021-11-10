create database SQLlearning;

CREATE table employee (
	emp_id INT PRIMARY KEY,   
    first_name VARCHAR (40),  
    last_name VARCHAR(40),    
    birth_day DATE,          	
    gender VARCHAR (1),	
	salary INT,	
    branch_id INT,
	super_id INT
    );		    
    
SELECT * from employee;
CREATE TABLE branch(
branch_id INT PRIMARY KEY,
branch_name VARCHAR(20),
mgr_id INT,
mgr_start_date DATE,
FOREIGN KEY (mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);
-- ADDING FOREIGN KEY----------------------------------------------------------------------------------------------------------------
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD 
FOREIGN KEY(super_id) 
REFERENCES employee(emp_id)
ON DELETE SET NULL;
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE client (
client_id INT PRIMARY KEY,
client_name VARCHAR(40),
branch_id INT,
FOREIGN KEY(branch_id) REFERENCES branch(branch_id)
ON DELETE SET NULL
);
/*--------------------------------------------------------------------------------------------------------------------*/
CREATE TABLE works_with(
emp_id INT, 
client_id INT,
total_sales int,
PRIMARY KEY(emp_id,client_id),
FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY (client_id) REFERENCES client(client_id) ON DELETE CASCADE
);
/*---------------------------------------------------------------------------------------------------------------*/
CREATE TABLE branch_supplier(
branch_id INT ,
supplier_name VARCHAR(40),
supply_type VARCHAR(40),
PRIMARY KEY(branch_id,supplier_name),
FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);
-- when foreign key is also a primary key use ON DELETE CASCADE
-- AS PRIMARY KEY CAN NEVER BE NULL

INSERT INTO employee VALUES (100,'David','Wallace','1967-11-17','M',250000,null,null);
INSERT INTO branch VALUES (1,'Corporate',100,'2006-02-09');

UPDATE employee 
SET branch_id = 1
WHERE emp_id = 100;
INSERT INTO employee VALUES(101,'Jan','Levinson','1961-05-11','F',110000,1,100);

-- Scranton branch
INSERT into employee VALUES(102,'Michael','Scott','1964-03-15','M','75000',null,100);
INSERT into branch VALUES (2,'Scranton',102,'1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT into employee VALUES(103,'Angela','Martin','1971-06-25','F',63000,2,102);
INSERT into employee VALUES(104,'Kelly','Kapoor','1980-02-05','F',55000,2,102);
INSERT into employee VALUES(105,'Stanley','Hudson','1958-02-19','M',69000,2,102);

-- stamford branch
INSERT into employee VALUES(106,'Josh','Porter','1969-09-05','M',78000,null,100);
INSERT into branch VALUES (3,'Stamford',106,'1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT into employee VALUES(107,'Andy','Bernard','1973-07-22','M',65000,3,106);
INSERT into employee VALUES(108,'Jim','Halpert','1978-10-01','M',71000,3,106);

select * from employee;
select * from branch;

-- BRANCH SUPPLIER
INSERT into branch_supplier VALUES(2,'Hammer Mill','Paper');
INSERT into branch_supplier VALUES(2,'Uni-ball','Writing Utensils');
INSERT into branch_supplier VALUES(3,'Patriot Paper','Paper');
INSERT into branch_supplier VALUES(2,'J.T. Forms & Labels','Custom Forms');
INSERT into branch_supplier VALUES(3,'Uni-ball','Writing Utensils');
INSERT into branch_supplier VALUES(3,'Hammer Mill','Paper');
INSERT into branch_supplier VALUES(3,'Stamford Labels','Custom Forms');

-- Client
INSERT into client VALUES (400,'Dunmore Highschool',2);
INSERT into client VALUES (401,'Lackawana Country',2);
INSERT into client VALUES (402,'FedEx',3);
INSERT into client VALUES (403,'John Daly Law,LLC',3);
INSERT into client VALUES (404,'Scranton Whitepages',2);
INSERT into client VALUES (405,'Times Newspaper',3);
INSERT into client VALUES (406,'FedEx',2);

-- works_with
INSERT into works_with VALUES (105,400,55000);
INSERT into works_with VALUES (102,401,267000);
INSERT into works_with VALUES (108,402,22500);
INSERT into works_with VALUES (107,403,5000);
INSERT into works_with VALUES (108,403,12000);
INSERT into works_with VALUES (105,404,33000);
INSERT into works_with VALUES (107,405,26000);
INSERT into works_with VALUES (102,406,15000);
INSERT into works_with VALUES (105,406,130000);

select * from works_with;
select * from client;

-- FIND ALL EMPLOYEES
SELECT * from employee;
-- FIND ALL EMLOYEES ORDERED BY THEIR SALARY
SELECT * from employee
ORDER BY salary;
SELECT * from employee
ORDER BY salary DESC;

-- FIND ALL EMPLOYEES ORDERED BY GENDER AND THEN NAME
SELECT * from employee
ORDER BY gender, first_name,last_name;

-- FIND THE FIRST 5 EMPLOYEES IN THE TABLE
SELECT * from employee limit 5;

-- FIND THE FIRST AND LAST NAME OF ALL EMPLOYEES
SELECT first_name,last_name
FROM employee;

-- FIND FORENAME AND SURNAME OF ALL EMPLOYEES
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- FIND OUT ALL THE DIFFERENT GENDERS
SELECT DISTINCT gender
FROM employee;

-- FUNCTIONS IN SQL
-- FIND THE NUMBER OF EMPLOYEES 
SELECT count(emp_id)
FROM employee;

-- FIND THE NUMBER OF FEMALE EMPLOYEE BORN AFTER 1970
SELECT count(emp_id)
FROM employee
WHERE gender = 'F' and birth_day > '1970-01-01';

-- FIND THE NUMBER OF FEMALE EMPLOYEE
SELECT count(gender)
FROM employee
WHERE gender = 'F';

-- FIND THE AVERAGE OF ALL EMPLOYEES SALLARIES
SELECT AVG(salary)
FROM employee
WHERE gender = 'M';

-- FIND THE SUM OF ALL EMPLOYEE SALARY
SELECT SUM(salary)
FROM employee;

-- FIND OUT HOW MANY MALES AND HOW MANY FEMALES ARE THERE IN THE COMPANY
SELECT count(gender), gender
FROM employee
GROUP BY gender;

-- FIND THE TOTAL SALES OF EACH SALESMAN
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY (emp_id);

CREATE TABLE total_sales_per_emp
SELECT SUM(total_sales) AS sales_per_emp, emp_id
FROM works_with
GROUP BY (emp_id);

-- FIND HOW MUCH EACH CLIENT SPENDS
SELECT sum(total_sales), client_id
FROM works_with
GROUP BY (client_id); 

-- WILDCARD KEYS
-- % = any number of characters , _ = one character

-- find any client who are working in LLC
SELECT * FROM client 
WHERE client_name LIKE '%LLC';

-- FIND THE BRANCH SUPPLIERS THAT ARE IN THE LABEL BUSINESS
SELECT * FROM branch_supplier
WHERE supplier_name LIKE '%LABELS%';

-- FIND ANY EMPLOYEE BORN IN OCTOBER
SELECT * FROM employee
WHERE birth_day LIKE '____-10%';

-- FIND any CLIENTS WHO ARE SCHOOLS
SELECT * FROM client
WHERE client_name LIKE '%school%';

-- UNION in SQL (combining results of multiple select statements into one)
-- FIND A LIST OF EMPLOYEES AND BRANCH NAMES
-- RULES FOR UNION : there must be same number of columns in EACH select statements
--                  : the datatype must be same of each select statements
SELECT first_name AS comapny_names
FROM employee
UNION
SELECT branch_name
FROM branch;

-- FIND A LIST OF ALL THE CLIENTS AND BRANCH SUPPLIERS' NAME
SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name,branch_supplier.branch_id
FROM branch_supplier;

-- FIND A LIST OF ALL MONEY SPENT OR EARNED BY THE COMPANY
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

-- JOINS -- COMBINE ROWS FROM TWO OR MORE TABELS BASED ON A RELATED COLUMN BETWEEN THEM

INSERT INTO branch VALUES (4,"Buffalo",NULL,NULL);

-- FIND ALL BRANCHES AND THE NAME OF THEIR MANAGERS

-- NORMAL JOIN
SELECT branch.branch_id,employee.first_name AS branch_mgr,branch.branch_name,branch.mgr_id
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;

-- LEFT JOIN
SELECT employee.emp_id,employee.first_name AS branch_mgr,branch.branch_name,branch.mgr_id
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id;

-- RIGHT JOIN
SELECT employee.emp_id,employee.first_name AS branch_mgr,branch.branch_name,branch.mgr_id
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;

-- NESTED QUERIES (MULTIPLE SELECT STATEMENTS)
-- FIND THE NAMES OF THE EMPLOYEES WHO HAVE SOLD OVER 30,000 TO A SINGLE CLIENT


SELECT employee.emp_id,employee.first_name,employee.last_name
from employee
WHERE employee.emp_id IN (
		SELECT works_with.emp_id
		from works_with
		WHERE total_sales > 30000
        );

-- FIND ALL CLIENTS WHO ARE HANDLED BY THE BRANCH THAT MICHAEL SCOTT MANAGES
-- ASSUME YOU KNOW MICHAEL'S id
SELECT emp_id, first_name
FROM employee
where first_name = "Michael";
-- Michail scotts manager id is 2

SELECT client_name,branch_id
FROM client
WHERE branch_id IN( 
		SELECT branch_id
		FROM branch
		WHERE mgr_id = 102
);