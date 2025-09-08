	--VIVEWS
/*
ViewName- Sales summary
Description- Provides Consolidated summary of each sales transaction including
	-Transaction Details
	-Customer Details
	--Employee Details
Notes- Display transactions without the registered customers
	- Only transactions with valid employee
*/
CREATE VIEW [Sales Summary] AS
SELECT
ST.TransactionID,ST.TransactionDateTime,ST.TotalAmount,ST.DiscountAmount,ST.PaymentMethod,ST.Status,
C.FirstName+' '+c.LastName AS [Customer Full Name],
E.FirstName+' '+E.LastName AS [Employee Ful Name]
FROM SalesTransactions ST join Customers C  on c.CustomerID=ST.CustomerID join Employees E On E.EmployeeID = ST.EmployeeID
GO

PRINT '***Sales summary CREATED';

GO
/*
View Name- Product Stock Level
Description- Display the stocks status of all active product including their category & supplier information
	Flag products that are at or below minimum stock level
*/

CREATE VIEW [Product Stock Level] AS
SELECT 
P.ProductId,P.ProductName,P.MinimumStockLevel,P.QuantityInStock,
C.CategoryId,C.CategoryName,
S.SupplierId,S.SupplierName
FROM Products P Join Categories C ON C.CategoryId= P.CategoryId Join Supplier S ON S.SupplierId = P.SupplierID
GO

/*
View Name- DailySalesSummary
Description- It should provides daily aggreated sales performance metrics for completed transactions including:
	- Counts, Total, discounts, Average sales values
Table: SalesTransactions 
*/

CREATE VIEW DailySalesSummary AS
SELECT 
Count(TransactionID) AS[Counts],SUM(TotalAmount) AS [Total], Sum(DiscountAmount) AS [Discounts],AVG(TotalAmount) AS [AVG Sales Values],cast(TransactionDateTime AS DATE) AS[Transaction DATE],Status
FROM SalesTransactions
Where Status = 'Completed'
Group By TransactionDateTime,Status
GO

/*
View Name- DetailedSalesSummary
Description- It displays detailed sales item incluuding,
	- Products, Customer, employee information for each transaction item
	- We need to include walking customers as well
Table: SalesTransactions, SalesTransactionItem, Product, employee, Customers 
*/
 
 CREATE VIEW [Detailed Sales Summary]
AS
SELECT 
E.EmployeeID,E.FirstName+' '+E.LastName AS [EMP FULLNAME],
C.CustomerID,C.FirstName+' '+C.LastName AS [CUS FULLNAME],
P.ProductId,P.ProductName,P.CategoryId,P.UnitPrice,P.CostPrice,
STI.TransactionID,STI.TransactionItemID,STI.UnitPriceAtSale,STI.LineTotal,
cast(ST.TransactionDateTime AS date) AS SalesDATE,ST.TotalAmount,ST.DiscountAmount,St.PaymentMethod
FROM SalesTransactionItems STI Join SalesTransactions ST 
on STI.TransactionID =ST.TransactionID Join Products P 
ON P.ProductId =STI.ProductID Join Employees E 
ON E.EmployeeID = ST.EmployeeID left join Customers C 
On C.CustomerID =ST.CustomerID
GO

/*

View Name- SupplierProductCatalog
Description- List of all products along with Supplier & catageory details for building
	- Suppliers category or inventory
Table: Suppliers,  Product, categories

*/
GO
 CREATE VIEW  [Supplier Product Catalog] AS
 SELECT 
 S.SupplierId,S.SupplierName,
 P.ProductId,P.ProductName,P.SKU,P.QuantityInStock,P.UnitPrice,P.CostPrice,P.IsActive,
 C.CategoryId,C.CategoryName
 FROM Supplier S JOIN Products P ON S.SupplierId=P.SupplierID JOIN Categories C ON C.CategoryId =P.CategoryId
 Where IsActive = 1
 GO

 /*
View Name- EmployeeSalesPerformances
Description- Track induvidual employee performance based on the number of transaction we processed
Table: Employees,SalesTransactions
*/

CREATE VIEW [Employee Sales Performances] AS
SELECT 
E.EmployeeID,E.FirstName+' '+E.LastName AS [EMP NAME],E.Role,Count(S.TransactionID)AS [Total Transactions]
FROM Employees E Join SalesTransactions S on E.EmployeeID=S.EmployeeID

Group by E.EmployeeID,E.FirstName,E.LastName,E.Role
GO
/*
View Name- LowStockProducts
Description- Highlight Products that we need restockingby comparing inventory aganist tht defined minimun stock level
Table: Suppliers,  Product, categories
*/
CREATE VIEW [Low Stock Products] AS
SELECT
    P.ProductId,
    P.ProductName,
    P.QuantityInStock,
    P.MinimumStockLevel,
    S.SupplierName,
    C.CategoryName
FROM
    Supplier S
    JOIN Products P ON S.SupplierId = P.SupplierId
    JOIN Categories C ON C.CategoryId = P.CategoryId
WHERE
    P.QuantityInStock <= P.MinimumStockLevel;

