--  If your table lacks a primary key, you can use DISTINCT to create a new table without duplicates:
Create a new table with distinct rows:
CREATE TABLE sales_cleaned AS
SELECT DISTINCT customers, inventory, purchase, rolls
FROM sales;

Drop the original table and rename the cleaned table:
DROP TABLE sales;
ALTER TABLE sales_cleaned RENAME TO sales;


# Using CTE for Better Query Structure (Common Table Expressions) for Readability and Performance:
WITH student_scores AS (
    SELECT student_id, AVG(score) AS avg_score FROM students GROUP BY student_id
)
SELECT student_id FROM student_scores WHERE avg_score > 80;


# Use an EXIST Query rather than IN Query to Optimize Sub-Query Performance:
SELECT actor_id FROM actor a
WHERE EXISTS (SELECT 1 FROM film f WHERE f.film_id = a.actor_id);


# Aggregations could slow down on large Tables (Use Indexing or Precomputed tables to speed up analytics queries):
SELECT student_id, SUM(score) 
FROM students 
WHERE last_updated > NOW() - INTERVAL '1 day' 
GROUP BY student_id;


# Optimize Aggregations with Indexing or Precomputed Tables:
## Aggregate only New Data:
SELECT payment_id, SUM(amount) 
FROM payment
WHERE payment_date > NOW() - INTERVAL 1 day
GROUP BY payment_id, amount;




-- To perform Query to remove duplicate records from a database:
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY customers, inventory, purchase, rolls ORDER BY id) AS row_num
    FROM sales
)
SELECT * FROM CTE WHERE row_num > 1;



-- use develop_database;

INSERT INTO `develop_database`.`customers`
(`CustomersID`, `CustomerName`, `ProductName`, `SalesRevenue`, `Payment`)
VALUES
('01', 'John', 'Mobile Devices', '50000', '40000'),
('02', 'Katie', 'Routers', '45000', '65000'),
('03', 'Johnson', 'Samsung', '80000', '56000'),
('04', 'Martins', 'Laptops', '750000', '55000'),
('05', 'Philips', 'Remote Disks', '55000', '75000'),
('06', 'Collins', 'Bottle Waters', '155000', '85000'),
('07', 'Kimberly', 'Wines', '86000', '350000'),
('08', 'Favour', 'Gold', '245000', '90000'),
('09', 'Mark', 'Steel', '10000', '150000'),
('10', 'Jean', 'Soafers', '44000', '67500');



SQL> UPDATE employees SET
  2   dn='"cn=Hermann Baer, ou=PR, o=IMC, c=us"'
  3   WHERE employee_id=204;

0 rows updated.
 
SQL> UPDATE employees SET
  2   dn='"cn=Shelley Higgens, ou=Accounting, o=IMC, c=us"'
  3   WHERE employee_id=205;

0 rows updated.

SQL> UPDATE employees SET
  2   dn='"cn=William Gietz, ou=Accounting, o=IMC, c=us"'
  3   WHERE employee_id=206;

0 rows updated.

SQL> REM **************************************************************************
SQL> REM procedure and statement trigger to allow dmls during business hours:
SQL> CREATE OR REPLACE PROCEDURE secure_dml
  2  IS
  3  BEGIN
  4    IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
  5          OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
  6  	RAISE_APPLICATION_ERROR (-20205, 
  7  		'You may only make changes during normal office hours');
  8    END IF;
  9  END secure_dml;
 10  /

Procedure SECURE_DML compiled

SQL> 
SQL> CREATE OR REPLACE TRIGGER secure_employees
  2    BEFORE INSERT OR UPDATE OR DELETE ON employees
  3  BEGIN
  4    secure_dml;
  5  END secure_employees;
  6  /

Trigger SECURE_EMPLOYEES compiled

SQL> 
SQL> Rem Recreating the triggers dropped above
SQL> 
SQL> REM **************************************************************************
SQL> REM procedure to add a row to the JOB_HISTORY table and row trigger 
SQL> REM to call the procedure when data is updated in the job_id or 
SQL> REM department_id columns in the EMPLOYEES table:
SQL> 
SQL> CREATE OR REPLACE PROCEDURE add_job_history
  2    (  p_emp_id          job_history.employee_id%type
  3     , p_start_date      job_history.start_date%type
  4     , p_end_date        job_history.end_date%type
  5     , p_job_id          job_history.job_id%type
  6     , p_department_id   job_history.department_id%type 
  7     )
  8  IS
  9  BEGIN
 10    INSERT INTO job_history (employee_id, start_date, end_date, 
 11                             job_id, department_id)
 12      VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
 13  END add_job_history;
 14  /

 
SQL> CREATE OR REPLACE TRIGGER update_job_history
  2    AFTER UPDATE OF job_id, department_id ON employees
  3    FOR EACH ROW
  4  BEGIN
  5    add_job_history(:old.employee_id, :old.hire_date, sysdate, 
  6                    :old.job_id, :old.department_id);
  7  END;
  8  /

Trigger UPDATE_JOB_HISTORY compiled

SQL> 
SQL> COMMIT;

Commit complete.


SQL> ALTER TABLE departments
  2   DROP COLUMN dn ;

Table DEPARTMENTS altered.

SQL> 
SQL> ALTER TABLE employees
  2   DROP COLUMN dn ;

Table EMPLOYEES altered.


INNER JOIN
SELECT a.*, b.*
FROM table1 a
INNER JOIN table2 b ON a.common_column = b.common_column;

LEFT JOIN
SELECT a.*, b.*
FROM table1 a
LEFT JOIN table2 b ON a.common_column = b.common_column;

RIGHT JOIN
SELECT a.*, b.*
FROM table1 a
RIGHT JOIN table2 b ON a.common_column = b.common_column;

FULL OUTER JOIN
SELECT a.*, b.*
FROM table1 a
FULL OUTER JOIN table2 b ON a.common_column = b.common_column;

USING CASE STATEMENT FOR MULTIPLE FILTERS:
SELECT
   COUNT(CASE WHEN salary > 70000 THEN 1 END) AS high_salary_count
   COUNT(CASE WHEN salary BETWEEN 50000 AND 70000 THEN 1 END) AS medium_salary_count
   COUNT(CASE WHEN salary < 50000 THEN 1 END) AS low_salary_count
FROM employees;

WHERE CLAUSE:
SELECT COUNT(*) AS high_salary_count
FROM EMPLOYEES
WHERE SALARY > 70000;


GROUPING:
SELECT department_id, COUNT(*) AS number_of_employees
FROM EMPLOYEES
WHERE join_date > '2020-01-01'
GROUP BY deparment_id;


NESTED GROUPING & SORTING: Having morethan one grouping
SELECT YEAR(sale_date) AS sale_year, product_id, SUM(amount) AS total_sales
FROM SalesGROUP BY sale_year, product_id
ORDER BY sale_year, total_sales DESC;


PIVOTING:
SELECT salesperson, [Jan] AS Jan_sales, [Feb] AS Feb_sales
from
(SELECT salesperson, month, sales FROM sales) AS sourceTable
PIVOT
(
SUM(sales)
FOR month IN ([Jan], [Feb])
)AS PivotTable;


Using Multiple Filter on Pivot:
SELECT
    salesperson,
	SUM(CASE WHEN month = 'Jan' THEN sales ELSE 0 END) AS Jan_sales,
	SUM(CASE WHEN month = 'Feb' THEN sales ELSE 0 END) AS Feb_sales
FROM Sales
GROUP BY salesperson;


JOIN TYPE:
INNER JOIN
SELECT c.customerName, p.paymentDate, p.amount
FROM customers c 
INNER JOIN payments p ON c.customerNumber = p.customerNumber

SELECT c.customerName, p.productName, p.OrderCost
FROM customers c 
INNER JOIN products p ON c.customersID = p.productsID;


lEFT OUTER JOIN:
SELECT c.customerName, p.paymentDate, p.amount
FROM customers c 
lEFT JOIN payments p ON c.customerNumber = p.customerNumber


RIGHT JOIN:
SELECT c.customerName, p.paymentDate, p.amount
FROM customers c 
RIGHT JOIN payments p ON c.customerNumber = p.customerNumber

FULL OUTER JOIN

CROSS OUTER JOIN - IT GIVES EVERY POSSIBLE COMBINATION FROM BOTH TABLES WHETHER THERE IS A MACTH.
SELECT c.customerName, p.paymentDate, p.amount
FROM payments p 
CROSS JOIN customers c



GROUP BY COUNT:
SELECT
    reviewerid,
	reviewername,
	COUNT(*) AS review_count
FROM 
    reviews
GROUP BY 
      reviewerid,
	  reviewername
ORDER BY 
      review_count DESC;
	  
	  
INSERT INTO products (	(productsID, productName, DeptNo, SalesOrder, OrderCost, CustomerID, CustomerName)
VALUES  
(4, 'Matress', 104, 'SO12348', 250.00, 1004, 'James Brown'),
(5, 'Remote', 105, 'SO12349', 550.00, 1005, 'Philips Brown'),
(6, 'Keyboard', 106, 'SO12355', 20000.00, 1006, 'Brian Naomi'),
(7, 'Designers', 107, 'SO12399', 20000.00, 1007, 'Douglas Bates'),
(8, 'Desktop', 108, 'SO12366', 850.00, 1008, 'Collins Kim'),
(9, 'ClockWatch', 109, 'SO12344', 770.00, 1009, 'Anna Holmes'),
(10, 'CloudWatch', 110, 'SO15348', 5000.00, 1010, 'Martins Law'),
(11, 'TrailerMax', 111, 'SO12377', 7500.00, 1011, 'Fisher Trend');

INSERT INTO `develop_database`.`sales`
(`SalesID`,
`CustomerName`,
`Customer_email`,
`DeptName`,
`Revenue`)
VALUES
(001, 'James Crowd', 'james001@gmail.com', 'Finance', 50000),
(002, 'Charles Law', 'charles002@gmail.com', 'Marketing', 70000),
(003, 'Grace Divine', 'divine003@gmail.com', 'Accounting', 95000),
(004, 'James Philips', 'phils004@gmail.com', 'Human Resource', 150000),
(005, 'Brian Jones', 'brian005@gmail.com', 'Hospitality', 100000),
(006, 'Lucas Kult', 'lucas006@gmail.com', 'Funding', 300000),
(007, 'Martins Jones', 'martin007@gmail.com', 'Infrastructure', 55000),
(008, 'Jane Holt', 'jane008@gmail.com', 'Development', 770000),
(009, 'Katie Jones', 'katie009@gmail.com', 'Restructural', 85000),
(010, 'Matthew Fish', 'matt0011@gmail.com', 'Budgeting', 750000)


INNER JOIN:
SELECT 
    employees.employee_id, 
    employees.first_name, 
    employees.last_name, 
    departments.department_name
FROM 
    employees
INNER JOIN 
    departments 
ON 
    employees.department_id = departments.department_id;

select CustomersID, ProductName,
sum(payment) as total_cost
from Customers
group by CustomersID, ProductName;


POSTGRESQL:
 CREATE TABLE users (
 id serial PRIMARY KEY,
 name VARCHAR (50) UNIQUE NOT NULL
 );
 

POSTGRESQL:
INSERT INTO "FinanceDB"."Departments"(
	"Department_ID", "Human_Resources", "Employee", "Email", "Salary", "Staff_Name")
	VALUES (6, 'Janet', 'Chris Brown', 'janet112@gmail.com', 400000, 'Lance'),
	       (7, 'Katie', 'Bobby Holmes', 'holms22@gmail.com', 330000, 'John'),
		   (8, 'Kay', 'Smith Lawrence', 'law22@gmail.com', 750000, 'Judas'),
		   (9, 'Cruise', 'Tommy Hardy', 'hardy01@gmail.com', 650000, 'Faith'),
		   (10, 'Chuks', 'Executive', 'chuks24@gmail.com', 1200000, 'Nora');


INSERT INTO "ExpenseDB"."Expenses"(
	"Expense_ID", "Supplier_Names", "Inventories", "Sales_ID", "Customers", "Suppliers_email")
	VALUES (1, 'Jeffrey John', 'Iron Rods', 001, 'Kenneth', 'ken002@gmail.com'),
	       (2, 'Johnny Bravo', 'Laptops', 002, 'Guddy', 'gud121@gmail.com'),
		   (3, 'Rodrigo Judin', 'Stationaries', 003, 'Justin', 'just002@gmail.com'),
		   (4, 'Marts Jombo', 'Buildings', 004, 'Martin', 'martin09@gmail.com'),
		   (5, 'Daniel Craig', 'Cement', 005, 'David', 'dav224@gmail.com'),
		   (6, 'Sunny Paulin', 'Electronics', 006, 'Smith', 'smith123@gmail.com'),
		   (7, 'Federick Smith', 'Blocks', 007, 'Feddy', 'fed232@gmail.com'),
		   (8, 'Claudia James', 'Airconditions', 008, 'Philips', 'phil234@gmail.com'),
		   (9, 'Saint Hope', 'Fans', 009, 'John', 'jon01@gmail.com'),
		   (10, 'Heidi Jack', 'Cables', 010, 'Hank', 'han004@gmail.com');
		   
SELECT 
    "Expenses"."Expense_ID", 
    "Expenses"."Sales_ID", 
    "Expenses"."Inventories", 
    "Departments"."Department_ID"
FROM 
    "Expenses"
INNER JOIN 
    "Departments"
ON 
    "Expenses"."Department_ID" = "Departments"."Department_ID";
	

SELECT 
    "Department_ID", 
    "Employee", 
    "Salary"
FROM 
    "FinanceDB"."Departments"
WHERE 
    "Salary" > '500000' AND "Employee" LIKE '%e%'
GROUP BY "Department_ID", "Employee", "Salary"

ORDER BY 1 DESC;


HOSTNAME TO CREATE A CONNECTION WITH METABASE:
host.docker.internal


HOW TO QUERY DATA GUARD STATUS IN ORACLE:
SELECT DATABASE_ROLE, DB_UNIQUE_NAME INSTANCE, OPEN_MODE, PROTECTION_MODE, PROTECTION_LEVEL, SWITCHOVER_STATUS FROM V$DATABASE;

IN SQL SERVER TO AUTOMATE DATABASE BACKUP:
NAVIGATE TO MAINTENANCE PLAN WIZARD > GIVE THE BACKUP A NAME > CONFIGURE TIME FOR BACKUP
BUT CONFIRM WITH THE APPLICATION TEAM > CLICK BACKUP DATABASE (FULL) > CHOOSE DESTINATION
IF SERVER DRIVE, THEN CLICK NEXT > OKAY. THE BACKUP IS DONE THROUGH THE SQL SESRVER AGENT.


BACKUP DATABASE:
mysqldump -u root -p develop_database > backup_develop_database.sql
ENTER PASSWORD:
du -sh backup_databasename.sql - Linux
dir backup_develop_database.sql - windows



-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: develop_database
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `CustomersID` int NOT NULL,
  `CustomerName` varchar(255) NOT NULL,
  `ProductName` varchar(250) NOT NULL,
  `SalesRevenue` decimal(10,0) NOT NULL,
  `Payment` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'John','Mobile Devices',50000,40000),(2,'Katie','Routers',45000,65000),(3,'Johnson','Samsung',80000,56000),(4,'Martins','Laptops',750000,55000),(5,'Philips','Remote Disks',55000,75000),(6,'Collins','Bottle Waters',155000,85000),(7,'Kimberly','Wines',86000,350000),(8,'Favour','Gold',245000,90000),(9,'Mark','Steel',10000,150000),(10,'Jean','Soafers',44000,67500),(1,'John','Mobile Devices',50000,40000),(2,'Katie','Routers',45000,65000),(3,'Johnson','Samsung',80000,56000),(4,'Martins','Laptops',750000,55000),(5,'Philips','Remote Disks',55000,75000),(6,'Collins','Bottle Waters',155000,85000),(7,'Kimberly','Wines',86000,350000),(8,'Favour','Gold',245000,90000),(9,'Mark','Steel',10000,150000),(10,'Jean','Soafers',44000,67500);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `ProductsID` int NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `DeptNo` int NOT NULL,
  `SalesOrder` varchar(250) NOT NULL,
  `OrderCost` decimal(10,0) NOT NULL,
  `CustomerID` int NOT NULL,
  `Customer_Name` varchar(255) NOT NULL,
  PRIMARY KEY (`ProductsID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Mobile Phone',101,'SO12345',150,1001,'John Melt'),(2,'Television',102,'SO12346',170,1002,'Mason James'),(3,'Laptop',103,'SO12347',2000,1003,'Kim Chuks'),(4,'Matress',104,'SO12348',250,1004,'James Brown'),(5,'Remote',105,'SO12349',550,1005,'Philips Brown'),(6,'Keyboard',106,'SO12355',20000,1006,'Brian Naomi'),(7,'Designers',107,'SO12399',20000,1007,'Douglas Bates'),(8,'Desktop',108,'SO12366',850,1008,'Collins Kim'),(9,'ClockWatch',109,'SO12344',770,1009,'Anna Holmes'),(10,'CloudWatch',110,'SO15348',5000,1010,'Martins Law'),(11,'TrailerMax',111,'SO12377',7500,1011,'Fisher Trend');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `SalesID` int NOT NULL,
  `CustomerName` varchar(255) NOT NULL,
  `Customer_email` varchar(250) NOT NULL,
  `DeptName` varchar(250) NOT NULL,
  `Revenue` varchar(255) NOT NULL,
  PRIMARY KEY (`SalesID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (1,'James Crowd','james001@gmail.com','Finance','50000'),(2,'Charles Law','charles002@gmail.com','Marketing','70000'),(3,'Grace Divine','divine003@gmail.com','Accounting','95000'),(4,'James Philips','phils004@gmail.com','Human Resource','150000'),(5,'Brian Jones','brian005@gmail.com','Hospitality','100000'),(6,'Lucas Kult','lucas006@gmail.com','Funding','300000'),(7,'Martins Jones','martin007@gmail.com','Infrastructure','55000'),(8,'Jane Holt','jane008@gmail.com','Development','770000'),(9,'Katie Jones','katie009@gmail.com','Restructural','85000'),(10,'Matthew Fish','matt0011@gmail.com','Budgeting','750000');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


To move data from one database to another when creating a Table:
CREATE TABLE inventory AS select * from develop_database.customers;

mysql> SOURCE C:/temp/sakila-db/sakila-schema.sql

mysql -u root -p sakila < sakila-schema.sql

SELECT f.title, f.rental_rate, a.first_name, a.last_name
from  film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
Limit 10;

CREATE TABLE Directors_note (
note_id INT AUTO_INCREMENT PRIMARY KEY,
film_id INT,
director_note VARCHAR(255),
edit_date DATE
);

INSERT INTO Directors_note (film_id, director_note, edit_date)
VALUES(1, 'Fix sound in minute 20', '2024-12-12');


select f.title, n.director_note, n.edit_date
from film f
left join Directors_note n
ON n.film_id =f.film_id;

$host="localhost";
$port=3306;
$socket="";
$user="root";
$password="";
$dbname="develop_database";

$con = new mysqli($host, $user, $password, $dbname, $port, $socket)
	or die ('Could not connect to the database server' . mysqli_connect_error());

//$con->close();


# To create permission to another user connection to MySQL server:
CREATE USER 'root2'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON *.* TO 'root2'@'%' WITH GRANT OPTION;


# Stored Procedure:
DELIMITER //

CREATE PROCEDURE GetStudentsByCourse(IN course_id INT)
BEGIN
    SELECT student_id, student_name
    FROM students
    WHERE course_id = course_id;
END //

DELIMITER ;


#Create a Function:
DELIMITER //

CREATE FUNCTION GetStudentCount(course_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE student_count INT;

    SELECT COUNT(*) INTO student_count
    FROM students
    WHERE course_id = course_id;

    RETURN student_count;
END //

DELIMITER ;


# Creating A VIEW:
CREATE VIEW ActiveStudents AS
SELECT student_id, student_name, course_id
FROM students
WHERE status = 'active';


# To get value for Order made yesterday.
SELECT * FROM Order_table
WHERE 
 Order_Date = Current_Date() - 1;
 


# How to determine or compare data for the past 5years to today, using data warehouse (RedShift)
SELECT 
    EXTRACT(YEAR FROM your_date_column) AS year,
    EXTRACT(MONTH FROM your_date_column) AS month,
    SUM(your_metric_column) AS total_metric
FROM 
    your_table
WHERE 
    your_date_column >= DATEADD(YEAR, -5, DATE_TRUNC('month', CURRENT_DATE))
    AND EXTRACT(MONTH FROM your_date_column) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY 
    EXTRACT(YEAR FROM your_date_column),
    EXTRACT(MONTH FROM your_date_column)
ORDER BY 
    year ASC;


# Activating the AWS Glue Crawler using the AWS CLI.
aws glue start-crawler --name tickit_postgresql;
aws glue start-crawler --name tickit_mysql;
aws glue start-crawler --name tickit_mssql


# Using the AWS CLI to start the Glue Job and write to the Bronze layer of our data lake.
aws glue start-job-run--job-name tickit_bronze_crm_user;
aws glue start-job-run--job-name tickit_bronze_ecomm_date;
aws glue start-job-run --job-name tickit_bronze_ecomm_listing;
aws glue start-job-run --job-name tickit_bronze_ecomm_sale;
aws glue start-job-run --job-name tickit_bronze_ems_category;
aws glue start-job-run --job-name tickit_bronze_ems_event;
aws glue start-job-run --job-name tickit_bronze_ems_venue;


# Writing to the Silver layer by doing some transformation with the Glue Job.
aws glue start-job-run --job-name tickit_silver_crm_user;
aws glue start-job-run --job-name tickit_silver_ecomm_date;
aws glue start-job-run --job-name tickit_silver_ecomm_listing;
aws glue start-job-run --job-name tickit_silver_ecomm_sale;
aws glue start-job-run --job-name tickit_silver_ems_category;
aws glue start-job-run --job-name tickit_silver_ems_event;
aws glue start-job-run --job-name tickit_silver_ems_venue;



# Writing to data lake (Gold Layer), using the PARTITION BY and Bucketed BY alongside JOINS.
CREATE TABLE gold_layer.student_course_summary
WITH (
    format = 'PARQUET',                 -- Use an optimized storage format
    partitioned_by = ARRAY['academic_year'], -- Partitioning by academic year
    bucketed_by = ARRAY['student_id'],  -- Bucketing by student ID
    bucket_count = 10,                  -- Number of buckets
    external_location = 's3://your-datalake-path/gold/student_course_summary/', -- S3 path
    write_compression = 'SNAPPY'        -- Optional: Snappy compression for parquet
) AS
SELECT 
    s.student_id,
    s.student_name,
    e.course_id,
    c.course_name,
    c.instructor,
    e.enrollment_date,
    e.academic_year,
    COUNT(*) OVER (PARTITION BY e.academic_year, s.student_id) AS total_courses,
    SUM(c.credits) OVER (PARTITION BY e.academic_year, s.student_id) AS total_credits
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE e.academic_year = '2024' -- Optional: Filter for specific year
ORDER BY s.student_id, e.academic_year;


# CREATING A SELECT STATEMENT TO PARTITION THE DATA OUTPUT RUNNING THE QUERY IN ATHENA.
SELECT caldate, sale_amount, commission
FROM "data_lake_demo"."gold_sales_by_category"
WHERE catgroup = 'shows' AND catname = 'Opera'
LIMIT 25000;


select a.actor_id, a.first_name, p.payment_id, p.amount, ad.address
from actor a
    JOIN payment p
    ON a.actor_id = p.payment_id
    JOIN address ad
    ON ad.address_id = p.payment_id
    WHERE amount > 4 AND first_name LIKE '%th%'
    GROUP BY a.actor_id, p.payment_id, p.amount, ad.address
    ORDER BY 1 DESC;


#Using SQL Query to check duplicate records:
SELECT email, COUNT(*) 
FROM customers 
GROUP BY email 
HAVING COUNT(*) > 1;


#Applying deduplicate logic in SQL:
DELETE FROM customers 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM customers 
    GROUP BY lower(email)
);


STEP 1 (Fact Table)
CREATE TABLE FactOrders (
  OrderID VARCHAR(50),
  ProductID VARCHAR(50),
  CustomerID VARCHAR(50),
  DateKey INT,
  Region VARCHAR(50),
  Sales DECIMAL(10, 2),
  Quantity INT,
  Discount DECIMAL(5, 2),
  Profit DECIMAL(10, 2),
  PRIMARY KEY (OrderID, ProductID)
);


STEP 2: Dimension Table: (DateDim)
CREATE TABLE DateDim (
  DateKey INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ProductDate DATE
);

-- Populate DateDim with distinct dates from orders
INSERT INTO DateDim (ProductDate)
SELECT DISTINCT Order_Date FROM orders;


Customer Dimension - CustomerDim:
CREATE TABLE CustomerDim (
  CustomerID VARCHAR(50) PRIMARY KEY,
  CustomerName VARCHAR(100),
  Segment VARCHAR(50),
  City VARCHAR(50),
  State VARCHAR(50),
  Country VARCHAR(50),
  PostalCode VARCHAR(20)
);

-- Populate CustomerDim from orders
INSERT INTO CustomerDim (CustomerID, CustomerName, Segment, City, State, Country, PostalCode)
SELECT DISTINCT Customer_ID, Customer_Name, Segment, City, State, Country, Postal_Code
FROM orders;


Product Dimension - ProductDim:
CREATE TABLE ProductDim (
  ProductID VARCHAR(50) PRIMARY KEY,
  ProductName VARCHAR(255),
  Category VARCHAR(50),
  SubCategory VARCHAR(50)
);

-- Populate ProductDim from orders
INSERT INTO ProductDim (ProductID, ProductName, Category, SubCategory)
SELECT DISTINCT Product_ID, Product_Name, Category, Sub_Category
FROM orders;


Region Dimension - RegionDim:
CREATE TABLE RegionDim (
  Region VARCHAR(50) PRIMARY KEY,
  Market VARCHAR(50)
);

-- Populate RegionDim from orders
INSERT INTO RegionDim (Region, Market)
SELECT DISTINCT Region, Market FROM orders;


Populating the Fact Table
After creating all dimension tables, the FactOrders table is populated by joining the necessary data::

INSERT INTO FactOrders (OrderID, ProductID, CustomerID, DateKey, Region, Sales, Quantity, Discount, Profit)
SELECT 
  o.Order_ID,
  o.Product_ID,
  o.Customer_ID,
  d.DateKey,
  o.Region,
  o.Sales,
  o.Quantity,
  o.Discount,
  o.Profit
FROM 
  orders o
JOIN 
  DateDim d ON o.Order_Date = d.ProductDate;
  

Query the completed Transaction:

SELECT 
    f.OrderID,
    f.OrderDate,
    f.ShipDate,
    f.Sales,
    f.Quantity,
    f.Discount,
    f.Profit,
    f.ShippingCost,
    f.OrderPriority,
    c.CustomerName,
    c.City,
    c.State,
    c.Country,
    p.ProductName,
    p.Category,
    p.SubCategory
FROM 
    OrdersFact f
JOIN 
    CustomerDim c ON f.CustomerID = c.CustomerID
JOIN 
    ProductDim p ON f.ProductID = p.ProductID
JOIN 
    DateDim d ON f.OrderDateKey = d.DateKey
WHERE 
    f.OrderPriority = 'Critical';





