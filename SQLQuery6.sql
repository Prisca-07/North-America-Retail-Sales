SELECT * FROM [Retail Sales]
--CUSTOMER TABLE
SELECT * INTO  CustomerTable
FROM
(SELECT Customer_ID, Customer_Name FROM [Retail Sales])
AS CTABLE

WITH CTE_CTABLE
AS
	(SELECT Customer_ID, Customer_Name, ROW_NUMBER() OVER(PARTITION BY Customer_ID, Customer_Name ORDER BY Customer_ID ASC) AS ROWNUM 
	FROM CustomerTable 
	)
DELETE FROM CTE_CTABLE
WHERE ROWNUM >1
SELECT * FROM CustomerTable

--LOCATION TABLE
SELECT * INTO LocationTable
FROM
(SELECT Country, City, State, Postal_Code, Region FROM [Retail Sales])
AS 
LTABLE

WITH CTE_ltable
AS
	(SELECT Country, City, State, Postal_Code, Region , ROW_NUMBER() OVER (PARTITION BY Country, City, State, Postal_Code, Region ORDER BY  Postal_Code ASC) AS ROWNUM
	FROM LocationTable
	)
DELETE FROM CTE_LTABLE
WHERE ROWNUM >1
SELECT * FROM LocationTable

--PRODUCT TABLE
SELECT * INTO ProductTable
FROM
	(SELECT Product_ID,Product_Name, Category, Sub_Category, Segment FROM [Retail Sales])
AS 
PTABLE

WITH CTE_Ptable
AS
	(SELECT Product_ID,Product_Name, Category, Sub_Category, Segment, ROW_NUMBER() OVER (PARTITION BY Product_ID,Product_Name, Category, Sub_Category, Segment ORDER BY  Product_ID ASC) AS ROWNUM
	FROM ProductTable
	)
DELETE FROM CTE_PTABLE
WHERE ROWNUM >1
SELECT * FROM ProductTable

--ORDER TABLE
SELECT * INTO OrderTable
FROM
	(SELECT Order_Date, Order_ID,Ship_Date, Ship_Mode, Customer_ID,Postal_Code,Retail_Sales_People,Product_ID,Returned,Sales,Quantity,Discount,Profit FROM [Retail Sales])
AS 
OTABLE

WITH CTE_OTABLE
AS
	(SELECT Order_Date, Order_ID,Ship_Date, Ship_Mode, Customer_ID,Postal_Code,Retail_Sales_People,Product_ID,Returned,Sales,Quantity,Discount,Profit, ROW_NUMBER()
	OVER (PARTITION BY Order_Date, Order_ID,Ship_Date, Ship_Mode, Customer_ID,Postal_Code,Retail_Sales_People,Product_ID,Returned,Sales,Quantity,Discount,Profit ORDER BY  Order_ID ASC) AS ROWNUM
	FROM OrderTable
	)
DELETE FROM CTE_OTABLE
WHERE ROWNUM >1
SELECT * FROM OrderTable

--SURROGATE KEYS
ALTER TABLE ProductTable
ADD UKEY  INT IDENTITY(1,1) PRIMARY KEY;

ALTER TABLE OrderTable
ADD UKEY INT;

UPDATE OrderTable
SET UKEY = ProductTable.UKEY
FROM OrderTable 
JOIN ProductTable
ON OrderTable.Product_ID = ProductTable.Product_ID

ALTER TABLE ProductTable
DROP COLUMN Product_ID
ALTER TABLE OrderTable
DROP COLUMN Product_ID

ALTER TABLE OrderTable
ADD Row_ID INT IDENTITY(1,1) PRIMARY KEY;


--ANALYSIS
--What was the Average delivery days for different
product subcategory?

SELECT pt.Sub_Category, AVG(DATEDIFF(DAY,ot.Order_Date,ot.Ship_Date)) AS AvgDeliveryDays
FROM OrderTable AS ot
LEFT JOIN ProductTable  AS pt
ON ot.UKEY = pt.UKEY
GROUP BY pt.Sub_Category
/* Products in the chairs and Bookcases categories are delivered in an average of 32 days whereas Furnishings takes 34 days and tables take 36 days */

-- What was the Average delivery days for each segment ?

SELECT pt.Segment, AVG(DATEDIFF(DAY,ot.Order_Date,ot.Ship_Date)) AS AvgDeliveryDays
FROM OrderTable AS ot
LEFT JOIN ProductTable  AS pt
ON ot.UKEY = pt.UKEY
GROUP BY pt.Segment
ORDER BY 2 DESC
/* On Average, it take 36 days to deliver products to Corporate customers, 35 days to Home Office Customers and 32 days to Consumers. */

--What are the Top 5 Fastest delivered products and Top 5 slowest delivered products? 

SELECT TOP 5 (pt.Product_Name), (DATEDIFF(DAY,ot.Order_Date,ot.Ship_Date)) AS DeliveryDays
FROM OrderTable AS ot
LEFT JOIN ProductTable  AS pt
ON ot.UKEY = pt.UKEY
ORDER BY 2 ASC; 
/* The top 5 Fastest delivered Products which were delivered under 24 hours are Sauder Camden County Barrister Bookcase, Planked Cherry Finish,
Sauder Inglewood Library Bookcases, 
O'Sullivan 2-Shelf Heavy-Duty Bookcases,
O'Sullivan Plantations 2-Door Library in Landvery Oak, 
'Sullivan Plantations 2-Door Library in Landvery Oak. */

SELECT TOP 5 (pt.Product_Name), (DATEDIFF(DAY,ot.Order_Date,ot.Ship_Date)) AS DeliveryDays
FROM OrderTable AS ot
LEFT JOIN ProductTable  AS pt
ON ot.UKEY = pt.UKEY
ORDER BY 2 DESC; 
/* The slowest delivered products which were delivered in 214 days are Bush Mission Pointe Library,
Hon Multipurpose Stacking Arm Chairs,
Global Ergonomic Managers Chair,
Tensor Brushed Steel Torchiere Floor Lamp,
Howard Miller 11-1/2" Diameter Brentwood Wall Clock. */

--Which product Subcategory generate most profit?
SELECT pt.Sub_Category, ROUND(SUM(ot.Profit),2) AS TotalProfit
FROM OrderTable AS ot
 LEFT JOIN ProductTable AS pt 
 ON ot.UKEY = pt.UKEY
 WHERE  ot.Profit > 0
GROUP BY pt.Sub_Category
ORDER BY 2 DESC
/* Chairs sub-category generates the highest profit with a total of $36,471.1 while Tables generates the least profit. */

--Which segment generates the most profit?
SELECT pt.Segment, SUM(ot.Profit) AS TotalProfit
FROM OrderTable AS ot
 LEFT JOIN ProductTable AS pt 
 ON ot.UKEY = pt.UKEY
 WHERE  ot.Profit > 0
GROUP BY pt.Segment
ORDER BY 2 DESC
/* The consumer segment generates the highest profit while the Corporate generates the least. */

--Which Top 5 customers made the most profit?
SELECT TOP 5 (ct.Customer_Name), ROUND(SUM(ot.Profit),2) AS TotalProfit
FROM OrderTable AS ot
LEFT JOIN CustomerTable AS ct
ON ot.Customer_ID = ct.Customer_ID
WHERE Profit > 0
GROUP BY Customer_Name
ORDER BY 2 DESC;
/* The Top 5 Customers are:
Laura Armstrong
Joe Elijah
Seth Vernon
Quincy Jones
Maria Etezadi */

--What is the total number of products by Subcategory ?
SELECT Sub_category, COUNT(Product_Name) AS Totalroduct
FROM ProductTable
GROUP BY Sub_category;
/* The total number of products by sub-category are 446,219,101,79 for Furnisings, Chairs, Bookcases and Tables respectively. */