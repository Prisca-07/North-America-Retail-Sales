# North America Retail Sales Optimization Analysis

## Project Overview
Sales Data Analysis for North America Retail
As a data analyst, analyze sales data to uncover key insights on:
-  Profitability
-  Business performance
-  Product performance
-  Customer behavior
Using a dataset containing product, customer, sales, profit, and return details, identify areas for improvement and suggest strategies to enhance efficiency and profitability, ultimately informing business decisions for North America Retail.

## Data Source
Retail supply Chain Sales AnalysisCSV was the dataset used.
## Tools used
- SQL
## Data cleaning and preparation
1. Data importation and inspection
2. Created facts and dimension tables
3. Created ERD
## Objectives
The goal of your analysis is to answer key business questions such as: 
1. What was the Average delivery days for different 
product subcategory?
 2. What was the Average delivery days for each segment ?
 3.What are the Top 5 Fastest delivered products and Top 5 
slowest delivered products? 
4. Which product Subcategory generate most profit?
 5. Which segment generates the most profit?
 6. Which Top 5 customers made the most profit?
 7. What is the total number of products by Subcategory?
## Analysis
### What was the Average delivery days for different 
product subcategory?
```sql
SELECT pt.Sub_Category, AVG(DATEDIFF(DAY,ot.Order_Date,ot.Ship_Date)) AS AvgDeliveryDays
FROM OrderTable AS ot
LEFT JOIN ProductTable  AS pt
ON ot.UKEY = pt.UKEY
GROUP BY pt.Sub_Category
/* Products in thechiars and Bookcases categories are delvered in an average of 32 days whereas Furnishings takes 34 days and tables take 36 days */
```

### What was the Average delivery days for each segment ?
```sql
SELECT pt.Segment, AVG(DATEDIFF(DAY,ot.Order_Date,ot.Ship_Date)) AS AvgDeliveryDays
FROM OrderTable AS ot
LEFT JOIN ProductTable  AS pt
ON ot.UKEY = pt.UKEY
GROUP BY pt.Segment
ORDER BY 2 DESC
/* On Average, it take 36 days to delivr products to Corporate customers, 35 days to Home Office Customers and 32 days to Consumers. */
```

### What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?
```sql
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
```
### Which product Subcategory generate most profit?
```sql
SELECT pt.Sub_Category, ROUND(SUM(ot.Profit),2) AS TotalProfit
FROM OrderTable AS ot
 LEFT JOIN ProductTable AS pt 
 ON ot.UKEY = pt.UKEY
 WHERE  ot.Profit > 0
GROUP BY pt.Sub_Category
ORDER BY 2 DESC
/* Chairs sub-category generates the highest profit with a total of $36,471.1 while Tables generates the least profit. */
```
### Which segment generates the most profit?
```sql
SELECT pt.Segment, SUM(ot.Profit) AS TotalProfit
FROM OrderTable AS ot
 LEFT JOIN ProductTable AS pt 
 ON ot.UKEY = pt.UKEY
 WHERE  ot.Profit > 0
GROUP BY pt.Segment
ORDER BY 2 DESC
/* The consumer segment generates the highest profit while the Corporate generates the least. */
```
### Which Top 5 customers made the most profit?
```sql
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
```
### What is the total number of products by Subcategory ?
```sql
SELECT Sub_category, COUNT(Product_Name) AS Totalroduct
FROM ProductTable
GROUP BY Sub_category;
/* The total number of products by sub-category are 446,219,101,79 for Furnisings, Chairs, Bookcases and Tables respectively. */
```

## Insights
1. Delivery Times: Products in the Chairs and Bookcases categories take an average of 32 days to deliver, while Furnishing products take 34 days, and Tables take 36 days.
2. Customer Segment Delivery Times: Corporate customers experience the longest delivery times (36 days), followed by Home Office customers (35 days), and Consumers (32 days).
3. Fastest Delivered Products: The top 5 fastest delivered products are all  bookcases, with delivery times under 24 hours.
4. Slowest Delivered Products: The top 5 slowest delivered products include chairs, a floor lamp, and a wall clock.
5. Profitability by Sub-Category: Chairs generate the most profit ($36,471.10), while Tables generate the least profit.
6. Profitability by Customer Segment: The Consumer segment generates the most profit, while the Corporate segment generates the least profit.
7. Top Consumers: The top 5 consumers are Laura Armstrong, Joe Elijah, Seth Vernon, Quincy Jones, and Maria Etezadi.
## Recommendation 
1. Optimize Supply Chain: Streamline the supply chain to reduce delivery times, especially for Corporate customers.
2. Improve Product Availability: Ensure that fast-selling products, such as bookcases, are consistently available to meet demand.
3. Enhance Customer Experience: Provide regular updates on delivery times and offer expedited shipping options to improve customer satisfaction.
4. Targeted Marketing: Focus marketing efforts on the Consumer segment, which generates the most profit.
5. Product Development: Consider expanding the Chairs product line, which generates the most profit, and improving the design and functionality of Tables, which generate the least profit.
6. Loyalty Program: Develop a loyalty program to reward top consumers, such as Laura Armstrong and Joe Elijah, and encourage repeat business.
7. Data-Driven Decision Making: Continue to analyze sales data to inform business decisions and drive growth.
