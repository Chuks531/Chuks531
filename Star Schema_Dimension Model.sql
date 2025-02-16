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

CREATE TABLE DateDim (
  DateKey INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ProductDate DATE
);

INSERT INTO DateDim (ProductDate)
SELECT DISTINCT Order_Date FROM orders;

CREATE TABLE CustomerDim (
  CustomerID VARCHAR(50) PRIMARY KEY,
  CustomerName VARCHAR(100),
  Segment VARCHAR(50),
  City VARCHAR(50),
  State VARCHAR(50),
  Country VARCHAR(50),
  PostalCode VARCHAR(20)
);

INSERT INTO CustomerDim (CustomerID, CustomerName, Segment, City, State, Country, PostalCode)
SELECT DISTINCT Customer_ID, Customer_Name, Segment, City, State, Country, Postal_Code
FROM orders;

CREATE TABLE ProductDim (
  ProductID VARCHAR(50) PRIMARY KEY,
  ProductName VARCHAR(255),
  Category VARCHAR(50),
  SubCategory VARCHAR(50)
);

select * from orders;

update orders
set product_id = '10013023'
where id = 14;

INSERT INTO ProductDim (ProductID, ProductName, Category, SubCategory)
SELECT DISTINCT Product_ID, Product_Name, Category, Sub_Category
FROM orders;

CREATE TABLE RegionDim (
  Region VARCHAR(50) PRIMARY KEY,
  Market VARCHAR(50)
);

INSERT INTO RegionDim (Region, Market)
SELECT DISTINCT Region, Market FROM orders;

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
  
select * from factorders;


