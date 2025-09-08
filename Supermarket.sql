Use master
Go

IF Exists (SELECT NAME FROM SYS.DATABASES WHERE NAME = 'SupermarketeDb') 

	Begin
		PRINT 'DROPING THE DATABASE SupermarketeDb';
		ALTER  DATABASE SupermarketeDb SET Single_USER With rollback immediate
		DROP DATABASE SupermarketeDb
	END
GO

BEGIN TRY
	PRINT 'Creating the database SupermarketDb';
	CREATE DATABASE SupermarketeDb
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	Throw
END CATCH
Go

PRINT 'Switch the New Database';
USE SupermarketeDb
GO
PRINT 'Using SupermarketDb';

								-- CREATING TABLES--
PRINT 'CREATING TABLES';
/*
TABLE1
CATEGORY TABLE
*/
CREATE TABLE Categories(
	CategoryId int PRIMARY KEY IDENTITY(1,1),
	CategoryName VARCHAR(50) NOT NULL UNIQUE,
	Description_ VARCHAR(200),
);
PRINT '***CATEGORY TABLE CREATED';

/*
TABLE2
SUPPLIER TABLE
*/
CREATE TABLE  Supplier(
	SupplierId int PRIMARY KEY IDENTITY(1,1),
	SupplierName VARCHAR(50) NOT NULL UNIQUE,
	ContactPerson VARCHAR(30),
	PhoneNumber VARCHAR(20),
	Email VARCHAR(50),
	Address VARCHAR(255)
);
PRINT '***SUPPLIER TABLE CREATED'

/*
TABLE3
PRODUCTS TABLE
*/
CREATE TABLE Products(
	ProductId INT PRIMARY KEY IDENTITY(1,1),
	ProductName VARCHAR(50) NOT NULL, 
	PDescription VARCHAR(200),
	SKU VARCHAR(20) UNIQUE,
	CategoryId INT NOT NULL,
	SupplierID INT NOT NULL,
	UnitPrice DECIMAL NOT NULL CHECK(UnitPrice>=0),
	CostPrice DECIMAL NOT NULL CHECK(CostPrice>=0),
	QuantityInStock INT NOT NULL CHECK(QuantityInStock>=0),
	MinimumStockLevel INT DEFAULT 5 CHECK(MinimumStockLevel>=0),
	IsActive BIT DEFAULT 1,
	ImageUrl VARCHAR(255),
	BarCoad VARCHAR(100),
	FOREIGN KEY (CategoryId)REFERENCES Categories (CategoryId),
	FOREIGN KEY (SupplierId)REFERENCES Supplier(SupplierId)
);
PRINT '***PRODUCTS TABLE CREATED';
/*
TABLE4
EMPLOYEE TABLE
*/
Create table Employees(
EmployeeID Int Primary key Identity(1,1),
FirstName VARCHAR(50) Not Null,
LastName VARCHAR(50) Not Null,
Role VARCHAR(50),
PhoneNumber VARCHAR(50),
Email VARCHAR(50),
Address VARCHAR(255),
HireDate Date Not Null Default GetDate()
);
PRINT '***EMPLOYEE TABLE Created';
/*
TABLE 5
CUSTOMERS TABLE
*/
Create table Customers(
CustomerID Int Primary key Identity(1,1),
FirstName Varchar(50) Not Null,
LastName Varchar(50) Not Null,
PhoneNumber Varchar(50),
Email Varchar(50),
Address Varchar(255),
RewardPoints int Default 0 Check(RewardPoints >=0)
);
PRINT '***CUSTOMERS TABLE CREATED';

/*
TABLE 6
SALES TRANSECTION TABLE
*/
Create Table SalesTransactions(
TransactionID Int Primary key Identity(1,1),
CustomerID Int,
EmployeeID Int Not Null,
TransactionDateTime DateTime Not Null Default GetDate(),
TotalAmount Decimal(10,2) Not Null Check(TotalAmount>=0),
DiscountAmount Decimal(10,2) Not Null Check(DiscountAmount>=0),
PaymentMethod Varchar(50) Not Null,
Status Varchar(25) Not Null Default 'Completed',
Foreign Key (CustomerID) References Customers(CustomerID),
Foreign Key (EmployeeID) References Employees(EmployeeID),
);
PRINT '***SALES TRANSECTION TABLE CREATED';
/*
TABLE 7
Sales Transactions ItemTable
*/
Create Table SalesTransactionItems(
TransactionItemID Int Primary key Identity(1,1),
TransactionID Int Not Null,
ProductID Int Not Null,
Qty Int Not Null Check(Qty>0),
UnitPriceAtSale Decimal(10,2) Not Null Check(UnitPriceAtSale >=0),
LineTotal Decimal(10,2) Not Null Check(LineTotal >=0),
Foreign Key (TransactionID) References SalesTransactions(TransactionID),
Foreign Key (ProductID) References Products(ProductID),
);
PRINT '***Sales Transactions ItemTable CREATED';
/*
TABLE 8
Purchase order Table
*/
Create Table PurchaseOrders(
PurchaseOrderID Int Primary key Identity(1,1),
SupplierID Int Not Null,
OrderDate Date Not Null Default GetDate(),
ExpectedDeliveryDate Date,
ActualDeliveryDate Date,
TotalCost Decimal(10,2) Not Null Check(TotalCost >=0),
Status Varchar(25) Not Null Default 'Pending',
Foreign Key (SupplierID) References Supplier(SupplierID),
);
PRINT '***Purchase order Table CREATED';
/*
TABLE 9
Purchase order Item Table
*/
Create Table PrchaseOrderItems(
PurchaseOrderItemID Int Primary key Identity(1,1),
PurchaseOrderID Int Not Null,
ProductID Int Not Null,
QtyOrder Int Not Null Check(QtyOrder >=0),
UnitCost Decimal(10,2) Not Null Check(UnitCost >=0),
LineTotal Decimal(10,2) Not Null Check(LineTotal >=0), --Qty*UnitCost
QtyReceived Int Default 0 Check(QtyReceived >=0),
Foreign Key (PurchaseOrderID) References PurchaseOrders(PurchaseOrderID),
Foreign Key (ProductID) References Products(ProductID),
);
PRINT '***Purchase order Item Table CREATED';


/*														--INSERT TABLE
--Select * from Categories
Insert into Categories (CategoryName, Description_) Values
('Beverages','Drinks like soda, juice, water etc');
Go
--Select * from Suppliers 
Insert into Supplier (SupplierName,ContactPerson,PhoneNumber,Email,Address) Values
('CocaCola','Dave','9988776655','dave@cocacola.com','123 St John road, Chennai')
Go
--Select * from Products
insert into Products (ProductName,PDescription,SKU,CategoryID,SupplierID,UnitPrice,CostPrice,QuantityInStock,MinimumStockLevel,IsActive,ImageURL,BarCoad)
values
('Kinely','Water Bottle','SKU-100',1,1,20,18,10,5,1,Null,'123454321') 
Go
--Select * from Employees
insert into Employees (FirstName,LastName,Role,PhoneNumber,Email,Address,HireDate) values
('John','Jose','Cashier','8897665423','John@abc.com','121 St Road, Chennai','2012-03-09') 
Go
--Select * from Customers
insert into Customers (FirstName,LastName,PhoneNumber,Email,Address,RewardPoints) values
('Govid','Raju','889776689','govid.raju@gmail.com','32 St Road, Chennai',150) 
Go
--Select * from SalesTransactions
insert into SalesTransactions (CustomerID, EmployeeID,TransactionDateTime,TotalAmount,DiscountAmount,PaymentMethod,Status) values
(1,1,'2023-02-15 12:20:00',2345.33,0.00,'Card','Completed') 
Go
--Select * from SalesTransactionItems
insert into SalesTransactionItems (TransactionID,ProductID,Qty,UnitPriceAtSale,LineTotal) Values
(1,1,5,100.11,500.55)
Go
--Select * from PurchaseOrders
insert into PurchaseOrders (SupplierID,OrderDate,ExpectedDeliveryDate,ActualDeliveryDate,TotalCost,Status) Values
(1,'2024-04-15','2024-04-28','2024-04-22',1500.00,'Received')
Go
--Select * from PrchaseOrderItems
insert into PrchaseOrderItems (PurchaseOrderID,ProductID,QtyOrder,UnitCost,LineTotal,QtyReceived) Values
(1,1,50,25,1250,50)
Go
Print'All sample data have been inserted in SupermarketDB----'

GO	*/
PRINT 'Inserting sample data into SupermarketDB tables...';
GO

INSERT INTO Categories (CategoryName, Description_) VALUES 
('Atta & Flour', 'Wheat flour, multigrain flour, besan, and other Indian flours'),
('Rice & Grains', 'Basmati rice, dal, rajma, chana, and pulses'),
('Edible Oils', 'Sunflower oil, mustard oil, ghee, and refined oils'),
('Spices & Masalas', 'Haldi, mirch, garam masala, and spice mixes'),
('Snacks & Namkeen', 'Chips, bhujia, murukku, and other Indian snacks'),
('Biscuits & Bakery', 'Parle-G, Marie, bread, and bakery items'),
('Dairy & Eggs', 'Milk, curd, paneer, cheese, butter, and eggs'),
('Beverages', 'Tea, coffee, fruit juice, lassi, soft drinks'),
('Fresh Produce', 'Fresh fruits and vegetables'),
('Meat & Seafood', 'Chicken, mutton, fish, prawns'),
('Frozen & Ready-to-Eat', 'Frozen parathas, momos, and ready meals'),
('Personal Care', 'Soap, shampoo, toothpaste, hair oil'),
('Household Items', 'Detergents, cleaners, brooms, kitchen tools'),
('Baby Care', 'baby powder, baby food'),
('Puja Items', 'Agarbatti, camphor, diya, and spiritual products');
GO

INSERT INTO Supplier (SupplierName, ContactPerson, PhoneNumber, Email, Address) VALUES
('ITC Limited', 'Raghavendra Rao', '+91-9876543210', 'raghavendra.rao@itc.in', 'ITC House, Kolkata, West Bengal'),
('Hindustan Unilever', 'Meenakshi Iyer', '+91-9823123456', 'meenakshi.iyer@hul.co.in', 'Andheri East, Mumbai, Maharashtra'),
('Patanjali Ayurved', 'Suresh Babu', '+91-9811122233', 'suresh.babu@patanjali.org', 'Haridwar, Uttarakhand'),
('Amul (GCMMF)', 'Divya Lakshmi', '+91-9867451234', 'divya.lakshmi@amul.coop', 'Anand, Gujarat'),
('Parle Products Pvt. Ltd.', 'Karthik Reddy', '+91-9923123456', 'karthik.reddy@parle.com', 'Vile Parle East, Mumbai, Maharashtra'),
('Mother Dairy', 'Sandhya Nair', '+91-9988776655', 'sandhya.nair@motherdairy.com', 'Patparganj, Delhi'),
('Tata Consumer Products', 'Manoj Kumar', '+91-9090909090', 'manoj.kumar@tataconsumer.com', 'Fort, Mumbai, Maharashtra'),
('Britannia Industries', 'Revathi Krishnan', '+91-9012345678', 'revathi.krishnan@britannia.co.in', 'Richmond Road, Bangalore, Karnataka'),
('Dabur India Ltd.', 'Anand Raj', '+91-9876001234', 'anand.raj@dabur.com', 'Kaushambi, Ghaziabad, Uttar Pradesh'),
('Nestlé India', 'Shanthi Raman', '+91-9123456789', 'shanthi.raman@in.nestle.com', 'Moga, Punjab');
GO

INSERT INTO Products (ProductName, PDescription, SKU, CategoryID, SupplierID, UnitPrice, CostPrice, QuantityInStock, MinimumStockLevel, IsActive, ImageURL, BarCoad)
VALUES 
('Aashirvaad Atta', 'Aashirvaad Atta from category Atta & Flour', 'SKU0001', 1, 1, 73.50, 60.00, 120, 5, 1, NULL, 'BAR00001'),
('Pillsbury Atta', 'Pillsbury Atta from category Atta & Flour', 'SKU0002', 1, 2, 84.00, 70.00, 100, 5, 1, NULL, 'BAR00002'),
('Annapurna Atta', 'Annapurna Atta from category Atta & Flour', 'SKU0003', 1, 3, 78.65, 62.00, 95, 5, 1, NULL, 'BAR00003'),
('Organic Flour', 'Organic Flour from category Atta & Flour', 'SKU0004', 1, 4, 115.00, 90.00, 80, 5, 1, NULL, 'BAR00004'),
('India Gate Rice', 'India Gate Rice from category Rice & Grains', 'SKU0005', 2, 2, 104.65, 85.50, 95, 5, 1, NULL, 'BAR00005'),
('Tata Dal', 'Tata Dal from category Rice & Grains', 'SKU0006', 2, 3, 88.90, 72.00, 60, 5, 1, NULL, 'BAR00006'),
('Organic Chana', 'Organic Chana from category Rice & Grains', 'SKU0007', 2, 1, 102.35, 80.00, 45, 5, 1, NULL, 'BAR00007'),
('Rajma Jammu', 'Rajma Jammu from category Rice & Grains', 'SKU0008', 2, 6, 96.20, 78.00, 90, 5, 1, NULL, 'BAR00008'),
('Saffola Gold', 'Saffola Gold from category Edible Oils', 'SKU0009', 3, 3, 171.08, 140.00, 65, 5, 1, NULL, 'BAR00009'),
('Fortune Sunflower Oil', 'Fortune Sunflower Oil from category Edible Oils', 'SKU0010', 3, 5, 155.00, 120.00, 70, 5, 1, NULL, 'BAR0010'),
('Dhara Mustard Oil', 'Dhara Mustard Oil from category Edible Oils', 'SKU0011', 3, 4, 142.00, 110.00, 55, 5, 1, NULL, 'BAR0011'),
('Everest Garam Masala', 'Everest Garam Masala from category Spices & Masalas', 'SKU0012', 4, 4, 94.64, 76.50, 80, 5, 1, NULL, 'BAR0012'),
('MDH Chana Masala', 'MDH Chana Masala from category Spices & Masalas', 'SKU0013', 4, 5, 64.35, 52.00, 85, 5, 1, NULL, 'BAR0013'),
('Catch Red Chilli', 'Catch Red Chilli from category Spices & Masalas', 'SKU0014', 4, 7, 78.20, 65.00, 40, 5, 1, NULL, 'BAR0014'),
('Kurkure Masala Munch', 'Kurkure Masala Munch from category Snacks & Namkeen', 'SKU0015', 5, 5, 25.48, 20.00, 150, 5, 1, NULL, 'BAR0015'),
('Haldiram Bhujia', 'Haldiram Bhujia from category Snacks & Namkeen', 'SKU0016', 5, 8, 34.10, 27.00, 130, 5, 1, NULL, 'BAR0016'),
('Bingo Mad Angles', 'Bingo Mad Angles from category Snacks & Namkeen', 'SKU0017', 5, 4, 18.90, 15.00, 200, 5, 1, NULL, 'BAR0017'),
('Parle-G', 'Parle-G from category Biscuits & Bakery', 'SKU0018', 6, 6, 13.13, 11.00, 200, 5, 1, NULL, 'BAR0018'),
('Good Day Cashew', 'Good Day Cashew from category Biscuits & Bakery', 'SKU0019', 6, 7, 32.45, 26.50, 140, 5, 1, NULL, 'BAR0019'),
('Treat Chocolate', 'Treat Chocolate from category Biscuits & Bakery', 'SKU0020', 6, 2, 27.50, 22.00, 160, 5, 1, NULL, 'BAR0020');
GO

INSERT INTO Products (ProductName, PDescription, SKU, CategoryID, SupplierID, UnitPrice, CostPrice, QuantityInStock, MinimumStockLevel, IsActive, ImageURL, BarCoad)
VALUES 
('Amul Butter', 'Amul Butter from category Dairy & Eggs', 'SKU0021', 7, 4, 58.50, 48.00, 90, 5, 1, NULL, 'BAR0021'),
('Nandini Paneer', 'Nandini Paneer from category Dairy & Eggs', 'SKU0022', 7, 6, 72.20, 60.00, 60, 5, 1, NULL, 'BAR0022'),
('Aavin Curd', 'Aavin Curd from category Dairy & Eggs', 'SKU0023', 7, 3, 34.65, 28.00, 110, 5, 1, NULL, 'BAR0023'),
('Britannia Cheese', 'Britannia Cheese from category Dairy & Eggs', 'SKU0024', 7, 8, 96.85, 79.50, 55, 5, 1, NULL, 'BAR0024'),
('Tata Tea', 'Tata Tea from category Beverages', 'SKU0025', 8, 7, 131.04, 108.00, 100, 5, 1, NULL, 'BAR0025'),
('Bru Coffee', 'Bru Coffee from category Beverages', 'SKU0026', 8, 6, 145.20, 120.00, 85, 5, 1, NULL, 'BAR0026'),
('Real Mixed Fruit Juice', 'Real Mixed Fruit Juice from category Beverages', 'SKU0027', 8, 5, 105.80, 88.00, 65, 5, 1, NULL, 'BAR0027'),
('Maza Mango Drink', 'Maza Mango Drink from category Beverages', 'SKU0028', 8, 2, 38.23, 30.00, 190, 5, 1, NULL, 'BAR0028'),
('Sprite Bottle', 'Sprite Bottle from category Beverages', 'SKU0029', 8, 3, 42.00, 33.00, 140, 5, 1, NULL, 'BAR0029'),
('Tomato', 'Tomato from category Fresh Produce', 'SKU0030', 9, 6, 31.50, 25.00, 180, 5, 1, NULL, 'BAR0030'),
('Onion', 'Onion from category Fresh Produce', 'SKU0031', 9, 4, 28.05, 23.00, 200, 5, 1, NULL, 'BAR0031'),
('Banana (Robusta)', 'Banana (Robusta) from category Fresh Produce', 'SKU0032', 9, 5, 41.60, 34.00, 160, 5, 1, NULL, 'BAR0032'),
('Apple Shimla', 'Apple Shimla from category Fresh Produce', 'SKU0033', 9, 3, 130.00, 105.00, 85, 5, 1, NULL, 'BAR0033'),
('Coriander Bunch', 'Coriander Bunch from category Fresh Produce', 'SKU0034', 9, 2, 12.60, 10.00, 250, 5, 1, NULL, 'BAR0034'),
('Chicken (Broiler)', 'Chicken (Broiler) from category Meat & Seafood', 'SKU0035', 10, 1, 273.60, 228.00, 75, 5, 1, NULL, 'BAR0035'),
('Mutton Curry Cut', 'Mutton Curry Cut from category Meat & Seafood', 'SKU0036', 10, 2, 589.50, 480.00, 45, 5, 1, NULL, 'BAR0036'),
('Rohu Fish', 'Rohu Fish from category Meat & Seafood', 'SKU0037', 10, 7, 220.40, 180.00, 55, 5, 1, NULL, 'BAR0037'),
('Fresh Prawns', 'Fresh Prawns from category Meat & Seafood', 'SKU0038', 10, 6, 342.25, 270.00, 30, 5, 1, NULL, 'BAR0038'),
('Country Eggs (6 pack)', 'Country Eggs (6 pack) from category Meat & Seafood', 'SKU0039', 10, 5, 72.00, 60.00, 90, 5, 1, NULL, 'BAR0039'),
('Frozen Paratha', 'Frozen Paratha from category Frozen & Ready-to-Eat', 'SKU0040', 11, 5, 99.84, 78.00, 60, 5, 1, NULL, 'BAR0040');
GO

INSERT INTO Products (ProductName, PDescription, SKU, CategoryID, SupplierID, UnitPrice, CostPrice, QuantityInStock, MinimumStockLevel, IsActive, ImageURL, BarCoad)
VALUES 
('McCain French Fries', 'McCain French Fries from category Frozen & Ready-to-Eat', 'SKU0041', 11, 8, 132.60, 108.00, 70, 5, 1, NULL, 'BAR0041'),
('ITC Chicken Nuggets', 'ITC Chicken Nuggets from category Frozen & Ready-to-Eat', 'SKU0042', 11, 9, 148.75, 120.00, 40, 5, 1, NULL, 'BAR0042'),
('MTR Ready Meals', 'MTR Ready Meals from category Frozen & Ready-to-Eat', 'SKU0043', 11, 10, 115.00, 95.00, 60, 5, 1, NULL, 'BAR0043'),
('Dabur Red Paste', 'Dabur Red Paste from category Personal Care', 'SKU0044', 12, 9, 47.25, 37.50, 130, 5, 1, NULL, 'BAR0044'),
('Colgate Strong Teeth', 'Colgate Strong Teeth from category Personal Care', 'SKU0045', 12, 6, 56.10, 45.00, 100, 5, 1, NULL, 'BAR0045'),
('Lifebuoy Soap', 'Lifebuoy Soap from category Personal Care', 'SKU0046', 12, 7, 33.00, 26.00, 150, 5, 1, NULL, 'BAR0046'),
('Dove Shampoo', 'Dove Shampoo from category Personal Care', 'SKU0047', 12, 5, 139.75, 110.00, 90, 5, 1, NULL, 'BAR0047'),
('Roff Cera Cleaner', 'Roff Cera Tile Cleaner from category Household Items', 'SKU0048', 13, 2, 73.32, 58.00, 85, 5, 1, NULL, 'BAR0048'),
('Lizol Floor Cleaner', 'Lizol Floor Cleaner from category Household Items', 'SKU0049', 13, 3, 110.50, 90.00, 65, 5, 1, NULL, 'BAR0049'),
('Vim Dishwash Gel', 'Vim Dishwash Gel from category Household Items', 'SKU0050', 13, 4, 49.30, 40.00, 120, 5, 1, NULL, 'BAR0050'),
('Surf Excel', 'Surf Excel from category Household Items', 'SKU0051', 13, 5, 220.40, 180.00, 75, 5, 1, NULL, 'BAR0051'),
('Nestle Cerelac', 'Bay cereal from category Baby Care', 'SKU0052', 14, 10, 207.83, 168.00, 40, 5, 1, NULL, 'BAR0052'),
('One little farm baby food', 'Stage 2 instant food from category Baby Care', 'SKU0053', 14, 9, 225.00, 185.00, 50, 5, 1, NULL, 'BAR0053'),
('Johnson’s Baby Powder', 'Johnson’s Baby Powder from category Baby Care', 'SKU0054', 14, 8, 75.65, 60.00, 95, 5, 1, NULL, 'BAR0054'),
('Johnson’s Baby Oil', 'Johnson’s Baby Oil from category Baby Care', 'SKU0055', 14, 7, 110.00, 90.00, 60, 5, 1, NULL, 'BAR0055'),
('Cycle Agarbatti', 'Cycle Agarbatti from category Puja Items', 'SKU0056', 15, 3, 36.66, 30.00, 160, 5, 1, NULL, 'BAR0056'),
('Mangaldeep Agarbatti', 'Mangaldeep Agarbatti from category Puja Items', 'SKU0057', 15, 4, 34.10, 28.00, 140, 5, 1, NULL, 'BAR0057'),
('Dhoop Cones', 'Dhoop Cones from category Puja Items', 'SKU0058', 15, 2, 42.00, 34.00, 130, 5, 1, NULL, 'BAR0058'),
('Camphor Tablets', 'Camphor Tablets from category Puja Items', 'SKU0059', 15, 1, 62.70, 50.00, 85, 5, 1, NULL, 'BAR0059'),
('Wicks for Lamps', 'Wicks for Lamps from category Puja Items', 'SKU0060', 15, 5, 19.20, 15.00, 110, 5, 1, NULL, 'BAR0060');
GO

INSERT INTO Products (ProductName, PDescription, SKU, CategoryID, SupplierID, UnitPrice, CostPrice, QuantityInStock, MinimumStockLevel, IsActive, ImageURL, BarCoad)
VALUES
('Britannia Cake', 'Britannia Cake from category Biscuits & Bakery', 'SKU0061', 6, 6, 45.00, 37.00, 120, 5, 1, NULL, 'BAR0061'),
('Britannia Good Day', 'Britannia Good Day from category Biscuits & Bakery', 'SKU0062', 6, 7, 35.00, 28.00, 140, 5, 1, NULL, 'BAR0062'),
('Dairy Milk Silk', 'Dairy Milk Silk from category Chocolates & Confectionery', 'SKU0063', 5, 8, 120.00, 95.00, 90, 5, 1, NULL, 'BAR0063'),
('Munch Chocolate', 'Munch Chocolate from category Chocolates & Confectionery', 'SKU0064', 5, 9, 25.00, 20.00, 160, 5, 1, NULL, 'BAR0064'),
('Perk Chocolate', 'Perk Chocolate from category Chocolates & Confectionery', 'SKU0065', 5, 10, 12.00, 9.50, 180, 5, 1, NULL, 'BAR0065'),
('Tata Salt', 'Tata Salt from category Salt & Sugar', 'SKU0066', 4, 1, 20.00, 15.00, 130, 5, 1, NULL, 'BAR0066'),
('Saffola Sugar', 'Saffola Sugar from category Salt & Sugar', 'SKU0067', 4, 2, 40.00, 33.00, 90, 5, 1, NULL, 'BAR0067'),
('Sundrop Cooking Oil', 'Sundrop Cooking Oil from category Edible Oils', 'SKU0068', 3, 3, 185.00, 150.00, 100, 5, 1, NULL, 'BAR0068'),
('Fortune Oil', 'Fortune Oil from category Edible Oils', 'SKU0069', 3, 4, 190.00, 160.00, 110, 5, 1, NULL, 'BAR0069'),
('Patanjali Atta', 'Patanjali Atta from category Atta & Flour', 'SKU0070', 1, 5, 70.00, 55.00, 140, 5, 1, NULL, 'BAR0070'),
('Daawat Basmati Rice', 'Daawat Basmati Rice from category Rice & Grains', 'SKU0071', 2, 6, 160.00, 125.00, 75, 5, 1, NULL, 'BAR0071'),
('Tata Tea Premium', 'Tata Tea Premium from category Beverages', 'SKU0072', 8, 7, 145.00, 110.00, 95, 5, 1, NULL, 'BAR0072'),
('Bru Coffee', 'Bru Coffee from category Beverages', 'SKU0073', 8, 8, 140.00, 105.00, 85, 5, 1, NULL, 'BAR0073'),
('Mother Dairy Paneer', 'Mother Dairy Paneer from category Dairy & Eggs', 'SKU0074', 7, 9, 120.00, 95.00, 100, 5, 1, NULL, 'BAR0074'),
('Fresh Chicken', 'Fresh Chicken from category Meat & Seafood', 'SKU0075', 10, 10, 280.00, 230.00, 70, 5, 1, NULL, 'BAR0075'),
('Fresh Tomato', 'Fresh Tomato from category Fresh Produce', 'SKU0076', 9, 1, 30.00, 25.00, 150, 5, 1, NULL, 'BAR0076'),
('Fresh Potato', 'Fresh Potato from category Fresh Produce', 'SKU0077', 9, 2, 25.00, 20.00, 170, 5, 1, NULL, 'BAR0077'),
('Nescafe Classic', 'Nescafe Classic from category Beverages', 'SKU0078', 8, 3, 150.00, 120.00, 80, 5, 1, NULL, 'BAR0078'),
('Lays Classic', 'Lays Classic from category Snacks & Namkeen', 'SKU0079', 5, 4, 20.00, 15.00, 200, 5, 1, NULL, 'BAR0079'),
('Bingo Mad Angles', 'Bingo Mad Angles from category Snacks & Namkeen', 'SKU0080', 5, 5, 25.00, 19.00, 150, 5, 1, NULL, 'BAR0080');
GO

INSERT INTO Products (ProductName, PDescription, SKU, CategoryID, SupplierID, UnitPrice, CostPrice, QuantityInStock, MinimumStockLevel, IsActive, ImageURL, BarCoad)
VALUES
('Haldiram Bhujia', 'Haldiram Bhujia from category Snacks & Namkeen', 'SKU0081', 5, 6, 40.00, 32.00, 140, 5, 1, NULL, 'BAR0081'),
('Bournvita', 'Bournvita from category Beverages', 'SKU0082', 8, 7, 210.00, 160.00, 90, 5, 1, NULL, 'BAR0082'),
('Dabur Honey', 'Dabur Honey from category Grocery & Staples', 'SKU0083', 4, 8, 180.00, 140.00, 75, 5, 1, NULL, 'BAR0083'),
('Surf Excel Detergent', 'Surf Excel Detergent from category Household Items', 'SKU0084', 13, 9, 150.00, 120.00, 110, 5, 1, NULL, 'BAR0084'),
('Vaseline Petroleum Jelly', 'Vaseline from category Personal Care', 'SKU0085', 12, 10, 90.00, 70.00, 130, 5, 1, NULL, 'BAR0085'),
('Fair & Lovely Cream', 'Fair & Lovely from category Personal Care', 'SKU0086', 12, 1, 160.00, 130.00, 85, 5, 1, NULL, 'BAR0086'),
('Maggi Noodles', 'Maggi Noodles from category Instant Foods', 'SKU0087', 5, 2, 45.00, 37.00, 170, 5, 1, NULL, 'BAR0087'),
('Knorr Soup', 'Knorr Soup from category Instant Foods', 'SKU0088', 5, 3, 60.00, 48.00, 110, 5, 1, NULL, 'BAR0088'),
('Amul Cheese', 'Amul Cheese from category Dairy & Eggs', 'SKU0089', 7, 4, 95.00, 75.00, 100, 5, 1, NULL, 'BAR0089'),
('Red Label Tea', 'Red Label Tea from category Beverages', 'SKU0090', 8, 5, 125.00, 100.00, 95, 5, 1, NULL, 'BAR0090'),
('Tata Sampann Dal', 'Tata Sampann Dal from category Pulses & Lentils', 'SKU0091', 2, 6, 120.00, 95.00, 85, 5, 1, NULL, 'BAR0091'),
('Saffola Oats', 'Saffola Oats from category Breakfast & Cereals', 'SKU0092', 5, 7, 140.00, 115.00, 75, 5, 1, NULL, 'BAR0092'),
('Catch Masala', 'Catch Masala from category Spices & Masalas', 'SKU0093', 4, 8, 95.00, 75.00, 130, 5, 1, NULL, 'BAR0093'),
('Tide Detergent', 'Tide Detergent from category Household Items', 'SKU0094', 13, 9, 160.00, 130.00, 105, 5, 1, NULL, 'BAR0094'),
('Closeup Toothpaste', 'Closeup Toothpaste from category Personal Care', 'SKU0095', 12, 10, 60.00, 48.00, 120, 5, 1, NULL, 'BAR0095'),
('Gillette Razor', 'Gillette Razor from category Personal Care', 'SKU0096', 12, 1, 200.00, 160.00, 90, 5, 1, NULL, 'BAR0096'),
('Dettol Soap', 'Dettol Soap from category Personal Care', 'SKU0097', 12, 2, 50.00, 40.00, 140, 5, 1, NULL, 'BAR0097'),
('Real Fruit Juice', 'Real Fruit Juice from category Beverages', 'SKU0098', 8, 3, 110.00, 85.00, 95, 5, 1, NULL, 'BAR0098'),
('Mother Dairy Milk', 'Mother Dairy Milk from category Dairy & Eggs', 'SKU0099', 7, 4, 45.00, 38.00, 150, 5, 1, NULL, 'BAR0099'),
('Amul Ice Cream', 'Amul Ice Cream from category Dairy & Eggs', 'SKU0100', 7, 5, 70.00, 55.00, 130, 5, 1, NULL, 'BAR0100');
GO

INSERT INTO Employees (FirstName, LastName, Role, PhoneNumber, Email, Address, HireDate)
VALUES
('Arun', 'Reddy', 'Cashier', '9876543210', 'arun.reddy@example.com', '123 MG Road, Chennai', '2022-03-15'),
('Priya', 'Kumar', 'Manager', '9876512345', 'priya.kumar@example.com', '45 Residency Road, Bangalore', '2021-11-10'),
('Vijay', 'Nair', 'Stock Keeper', '9876123456', 'vijay.nair@example.com', '78 Park Street, Chennai', '2023-01-05'),
('Lakshmi', 'Iyer', 'Cleaner', '9876234567', 'lakshmi.iyer@example.com', '23 Kamarajar Salai, Madurai', '2020-06-21'),
('Suresh', 'Raman', 'Supervisor', '9876345678', 'suresh.raman@example.com', '89 OMR Road, Chennai', '2019-09-15'),

('Meena', 'Rao', 'Cashier', '9876456789', 'meena.rao@example.com', '56 Residency Road, Bangalore', '2022-07-30'),
('Karthik', 'Sharma', 'Manager', '9876567890', 'karthik.sharma@example.com', '12 Mylapore, Chennai', '2021-05-11'),
('Anitha', 'Sundar', 'Stock Keeper', '9876678901', 'anitha.sundar@example.com', '89 Gandhi Road, Coimbatore', '2023-03-18'),
('Ramesh', 'Menon', 'Cleaner', '9876789012', 'ramesh.menon@example.com', '90 Anna Nagar, Chennai', '2020-10-02'),
('Divya', 'Krishna', 'Supervisor', '9876890123', 'divya.krishna@example.com', '54 MG Road, Bangalore', '2019-12-24'),

('Ganesh', 'Subramanian', 'Cashier', '9876901234', 'ganesh.subramanian@example.com', '34 Race Course Road, Mysore', '2022-02-14'),
('Sanjay', 'Iyer', 'Manager', '9876012345', 'sanjay.iyer@example.com', '22 T Nagar, Chennai', '2021-08-09'),
('Nisha', 'Reddy', 'Stock Keeper', '9876123456', 'nisha.reddy@example.com', '77 Residency Road, Bangalore', '2023-04-20'),
('Prakash', 'Kumar', 'Cleaner', '9876234567', 'prakash.kumar@example.com', '100 OMR Road, Chennai', '2020-11-16'),
('Anjali', 'Raman', 'Supervisor', '9876345678', 'anjali.raman@example.com', '15 Gandhi Nagar, Coimbatore', '2019-07-30'),

('Bhavana', 'Nair', 'Cashier', '9876454321', 'bhavana.nair@example.com', '67 MG Road, Kochi', '2023-05-01'),
('Raghav', 'Iyer', 'Cashier', '9876549876', 'raghav.iyer@example.com', '45 Gandhi Street, Chennai', '2022-12-10'),
('Sindhu', 'Raman', 'Cashier', '9876598765', 'sindhu.raman@example.com', '89 Residency Road, Bangalore', '2021-03-20'),
('Vimal', 'Kumar', 'Cashier', '9876576543', 'vimal.kumar@example.com', '12 T Nagar, Chennai', '2023-01-15'),
('Lakshman', 'Subramanian', 'Cashier', '9876532109', 'lakshman.subramanian@example.com', '23 Mylapore, Chennai', '2022-08-05');
GO

INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email, Address, RewardPoints)
VALUES
('Anitha', 'Reddy', '9876500001', 'anitha.reddy@example.com', '12 MG Road, Chennai', 120),
('Karthik', 'Iyer', '9876500002', 'karthik.iyer@example.com', '45 Gandhi Street, Bangalore', 90),
('Meena', 'Krishna', '9876500003', 'meena.krishna@example.com', '23 Residency Road, Chennai', 80),
('Suresh', 'Raman', '9876500004', NULL, '78 OMR Road, Chennai', 150),
('Divya', 'Sharma', '9876500005', 'divya.sharma@example.com', '34 Park Avenue, Coimbatore', 75),
('Ganesh', 'Nair', '9876500006', NULL, '56 T Nagar, Chennai', 40),
('Priya', 'Menon', '9876500007', 'priya.menon@example.com', '90 Anna Nagar, Chennai', 130),
('Vijay', 'Rao', '9876500017', 'vijay.rao@example.com', '12 Race Course Road, Mysore', 60),
('Lakshmi', 'Subramanian', '9876500008', 'lakshmi.subramanian@example.com', '22 Mylapore, Chennai', 110),
('Ramesh', 'Kumar', '9876500009', NULL, '77 Gandhi Nagar, Coimbatore', 55),
('Anjali', 'Iyer', '9876500019', 'anjali.iyer@example.com', '100 MG Road, Bangalore', 90),
('Bhaskar', 'Reddy', '9876500010', NULL, '67 Residency Road, Chennai', 45),
('Sindhu', 'Krishna', '9876500011', 'sindhu.krishna@example.com', '89 OMR Road, Chennai', 70),
('Sanjay', 'Raman', '9876500111', NULL, '45 Gandhi Street, Bangalore', 100),
('Nisha', 'Sharma', '9876500012', 'nisha.sharma@example.com', '34 Park Avenue, Coimbatore', 125),
('Manoj', 'Nair', '9876500013', NULL, '56 T Nagar, Chennai', 80),
('Rekha', 'Menon', '9876500014', 'rekha.menon@example.com', '90 Anna Nagar, Chennai', 95),
('Arun', 'Rao', '9876500114', 'arun.rao@example.com', '12 Race Course Road, Mysore', 65),
('Sita', 'Subramanian', '9876500015', NULL, '22 Mylapore, Chennai', 140),
('Kumar', 'Kumar', '9876500016', 'kumar.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 50);
GO

INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email, Address, RewardPoints)
VALUES
('Radha', 'Iyer', '9876504017', 'radha.iyer@example.com', '100 MG Road, Bangalore', 120),
('Dinesh', 'Reddy', '9876511017', 'dinesh.reddy@example.com', '67 Residency Road, Chennai', 60),
('Kavya', 'Krishna', '9876500018', NULL, '89 OMR Road, Chennai', 130),
('Ajay', 'Raman', '9876501019', 'ajay.raman@example.com', '45 Gandhi Street, Bangalore', 90),
('Latha', 'Sharma', '9876501217', 'latha.sharma@example.com', '34 Park Avenue, Coimbatore', 100),
('Mohan', 'Nair', '9876500020', NULL, '56 T Nagar, Chennai', 85),
('Priya', 'Menon', '9876500021', 'priya.menon@example.com', '90 Anna Nagar, Chennai', 70),
('Hari', 'Rao', '9876522017', 'hari.rao@example.com', '12 Race Course Road, Mysore', 45),
('Bhavana', 'Subramanian', '9876500022', NULL, '22 Mylapore, Chennai', 95),
('Sanjay', 'Kumar', '9876500023', 'sanjay.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 80),
('Nithya', 'Iyer', '9876533017', 'nithya.iyer@example.com', '100 MG Road, Bangalore', 120),
('Raghav', 'Reddy', '9876500024', NULL, '67 Residency Road, Chennai', 110),
('Megha', 'Krishna', '9876500025', 'megha.krishna@example.com', '89 OMR Road, Chennai', 55),
('Rajesh', 'Raman', '9876544017', 'rajesh.raman@example.com', '45 Gandhi Street, Bangalore', 65),
('Kavitha', 'Sharma', '9876500026', NULL, '34 Park Avenue, Coimbatore', 150),
('Vimal', 'Nair', '9876500027', 'vimal.nair@example.com', '56 T Nagar, Chennai', 70),
('Lakshmi', 'Menon', '9876555017', 'lakshmi.menon@example.com', '90 Anna Nagar, Chennai', 100),
('Suresh', 'Rao', '9876500028', NULL, '12 Race Course Road, Mysore', 85),
('Divya', 'Subramanian', '9876500029', 'divya.subramanian@example.com', '22 Mylapore, Chennai', 130),
('Gopal', 'Kumar', '9876566017', 'gopal.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 95);
GO

INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email, Address, RewardPoints)
VALUES
('Manju', 'Iyer', '9876500030', 'manju.iyer@example.com', '100 MG Road, Bangalore', 75),
('Sanjay', 'Reddy', '9876520030', 'sanjay.reddy@example.com', '67 Residency Road, Chennai', 100),
('Anjali', 'Krishna', '9876500031', NULL, '89 OMR Road, Chennai', 120),
('Vikram', 'Raman', '9876500032', 'vikram.raman@example.com', '45 Gandhi Street, Bangalore', 110),
('Shweta', 'Sharma', '9876530030', 'shweta.sharma@example.com', '34 Park Avenue, Coimbatore', 65),
('Ravi', 'Nair', '9876500033', NULL, '56 T Nagar, Chennai', 90),
('Nisha', 'Menon', '9876500034', 'nisha.menon@example.com', '90 Anna Nagar, Chennai', 55),
('Arjun', 'Rao', '9876540030', 'arjun.rao@example.com', '12 Race Course Road, Mysore', 70),
('Kavya', 'Subramanian', '9876500035', NULL, '22 Mylapore, Chennai', 150),
('Raghav', 'Kumar', '9876500036', 'raghav.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 80),
('Neha', 'Iyer', '9876550030', 'neha.iyer@example.com', '100 MG Road, Bangalore', 110),
('Vasanth', 'Reddy', '9876500037', NULL, '67 Residency Road, Chennai', 90),
('Preethi', 'Krishna', '9876500038', 'preethi.krishna@example.com', '89 OMR Road, Chennai', 140),
('Raj', 'Raman', '9876560030', 'raj.raman@example.com', '45 Gandhi Street, Bangalore', 120),
('Maya', 'Sharma', '9876500039', NULL, '34 Park Avenue, Coimbatore', 75),
('Kiran', 'Nair', '9876500040', 'kiran.nair@example.com', '56 T Nagar, Chennai', 95),
('Sneha', 'Menon', '9876570030', 'sneha.menon@example.com', '90 Anna Nagar, Chennai', 60),
('Anil', 'Rao', '9876500041', NULL, '12 Race Course Road, Mysore', 85),
('Deepa', 'Subramanian', '9876500042', 'deepa.subramanian@example.com', '22 Mylapore, Chennai', 100),
('Suresh', 'Kumar', '9876580030', 'suresh.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 130);
GO

INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email, Address, RewardPoints)
VALUES
('Madhavi', 'Iyer', '9876500043', 'madhavi.iyer@example.com', '100 MG Road, Bangalore', 110),
('Ajith', 'Reddy', '9876520043', 'ajith.reddy@example.com', '67 Residency Road, Chennai', 90),
('Kumari', 'Krishna', '9876500044', NULL, '89 OMR Road, Chennai', 85),
('Sathish', 'Raman', '9876500045', 'sathish.raman@example.com', '45 Gandhi Street, Bangalore', 75),
('Raji', 'Sharma', '9876530043', 'raji.sharma@example.com', '34 Park Avenue, Coimbatore', 140),
('Vinod', 'Nair', '9876500046', NULL, '56 T Nagar, Chennai', 65),
('Anu', 'Menon', '9876500047', 'anu.menon@example.com', '90 Anna Nagar, Chennai', 95),
('Arvind', 'Rao', '9876540043', 'arvind.rao@example.com', '12 Race Course Road, Mysore', 100),
('Ritika', 'Subramanian', '9876500048', NULL, '22 Mylapore, Chennai', 130),
('Gautham', 'Kumar', '9876500049', 'gautham.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 90),
('Sahana', 'Iyer', '9876550043', 'sahana.iyer@example.com', '100 MG Road, Bangalore', 80),
('Balaji', 'Reddy', '9876500050', NULL, '67 Residency Road, Chennai', 150),
('Chitra', 'Krishna', '9876500051', 'chitra.krishna@example.com', '89 OMR Road, Chennai', 70),
('Hariharan', 'Raman', '9876560043', 'hariharan.raman@example.com', '45 Gandhi Street, Bangalore', 55),
('Lavanya', 'Sharma', '9876500052', NULL, '34 Park Avenue, Coimbatore', 100),
('Manish', 'Nair', '9876500053', 'manish.nair@example.com', '56 T Nagar, Chennai', 60),
('Radha', 'Menon', '9876570043', 'radha.menon@example.com', '90 Anna Nagar, Chennai', 110),
('Sandeep', 'Rao', '9876500054', NULL, '12 Race Course Road, Mysore', 75),
('Divya', 'Subramanian', '9876500055', 'divya.subramanian@example.com', '22 Mylapore, Chennai', 140),
('Nitin', 'Kumar', '9876580043', 'nitin.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 130);
GO

INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email, Address, RewardPoints)
VALUES
('Sowmya', 'Iyer', '9876500056', 'sowmya.iyer@example.com', '100 MG Road, Bangalore', 115),
('Vijay', 'Reddy', '9876502056', 'vijay.reddy@example.com', '67 Residency Road, Chennai', 95),
('Anitha', 'Krishna', '9876500057', NULL, '89 OMR Road, Chennai', 125),
('Naveen', 'Raman', '9876500058', 'naveen.raman@example.com', '45 Gandhi Street, Bangalore', 60),
('Mala', 'Sharma', '9876503056', 'mala.sharma@example.com', '34 Park Avenue, Coimbatore', 130),
('Kiran', 'Nair', '9876500059', NULL, '56 T Nagar, Chennai', 90),
('Pooja', 'Menon', '9876500060', 'pooja.menon@example.com', '90 Anna Nagar, Chennai', 100),
('Suresh', 'Rao', '9876504056', 'suresh.rao@example.com', '12 Race Course Road, Mysore', 70),
('Divya', 'Subramanian', '9876500061', NULL, '22 Mylapore, Chennai', 115),
('Rahul', 'Kumar', '9876500062', 'rahul.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 95),
('Nandini', 'Iyer', '9876505056', 'nandini.iyer@example.com', '100 MG Road, Bangalore', 85),
('Karthik', 'Reddy', '9876500063', NULL, '67 Residency Road, Chennai', 75),
('Manju', 'Krishna', '9876500064', 'manju.krishna@example.com', '89 OMR Road, Chennai', 90),
('Prakash', 'Raman', '9876506056', 'prakash.raman@example.com', '45 Gandhi Street, Bangalore', 120),
('Lakshmi', 'Sharma', '9876500065', NULL, '34 Park Avenue, Coimbatore', 100),
('Vimal', 'Nair', '9876500066', 'vimal.nair@example.com', '56 T Nagar, Chennai', 110),
('Sneha', 'Menon', '9876507056', 'sneha.menon@example.com', '90 Anna Nagar, Chennai', 130),
('Ravi', 'Rao', '9876500067', NULL, '12 Race Course Road, Mysore', 65),
('Anjali', 'Subramanian', '9876500068', 'anjali.subramanian@example.com', '22 Mylapore, Chennai', 115),
('Sanjay', 'Kumar', '9876508056', 'sanjay.kumar@example.com', '77 Gandhi Nagar, Coimbatore', 95);
--GO

PRINT 'Sample data insertion into SupermarketDB completed successfully';
GO

----------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE InsertSampleTransaction
AS
BEGIN
    SET NOCOUNT ON; -- Suppress the message about the number of rows affected
    BEGIN TRY
        BEGIN TRANSACTION;

        -- DECLARE Variables
        DECLARE @i INT = 0;
        DECLARE @CustomerID INT;
        DECLARE @EmployeeID INT;
        DECLARE @TransactionDateTime DATETIME;
        DECLARE @TotalAmount DECIMAL(10,2);
        DECLARE @DiscountAmount DECIMAL(10,2);
        DECLARE @PaymentMethod VARCHAR(50);
        DECLARE @Status VARCHAR(50);

        -- Loop to insert 1000 Dummy Transactions
        WHILE @i < 1000
        BEGIN
            -- Select a Random CustomerID from customer table
            SELECT TOP 1 @CustomerID = CustomerID FROM Customers ORDER BY NEWID();
            SELECT TOP 1 @EmployeeID = EmployeeID FROM Employees ORDER BY NEWID();

            -- Generate a random date within the last 30 Days
            SET @TransactionDateTime = DATEADD(DAY, -FLOOR(RAND() * 200), GETDATE());

            -- Generate a random total amount between 50 and 550
            SET @TotalAmount = ROUND(RAND() * 500 + 50, 2);

            -- Set Discount amount to 0
            SET @DiscountAmount = 0;

            -- Randomly choose a payment method between CASH, UPI, CARD
            DECLARE @RandNum INT = FLOOR(RAND() * 3);
            IF @RandNum = 0
                SET @PaymentMethod = 'CASH';
            ELSE IF @RandNum = 1
                SET @PaymentMethod = 'UPI';
            ELSE
                SET @PaymentMethod = 'CARD';

            -- Set status of payment
            SET @Status = 'Completed';

            -- Insert record
            INSERT INTO SalesTransactions (CustomerID, EmployeeID, TransactionDateTime, TotalAmount, DiscountAmount, PaymentMethod, Status)
            VALUES (@CustomerID, @EmployeeID, @TransactionDateTime, @TotalAmount, @DiscountAmount, @PaymentMethod, @Status);

            SET @i += 1;
        END

        COMMIT TRANSACTION;
        PRINT 'Sample Sales Transaction Data Entered';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-----------------------------------------------------------------------------------------------------------------------------------
Create Procedure InsertSamplePurchaseOrders
As
Begin
	SET NOCOUNT ON
	Begin Try
		Begin Transaction;
		Declare @i int=0, 
		@SupplierID int, ---Random supplier id
		@OrderDate Date, ---Random date within last 60 days
		@ExpectedDeliveryDate Date, ------3 to 10 days after orderdate
		@ActualDeliveryDate Date, -- Nullable
		@TotalCost Decimal(10,2), --between 4000 t0 5000
		@Status Varchar(25) --Pending
		While @i<500
		Begin
			Set @SupplierID = FLOOR(RAND()*10)+1
			Set @OrderDate	= DATEADD(Day, -FLOOR(rand() * 60),cast(getdate() as date))
			Set @ExpectedDeliveryDate = DATEADD(DAY,FLOOR(Rand()*8)+3, @OrderDate)
			if Rand() <0.5
				Set @ActualDeliveryDate = Null
			Else
				Set @ActualDeliveryDate = DATEADD(Day,FLOOR(Rand()*10),@OrderDate)
			Set @TotalCost = Round(Rand() * 5000 +4000 , 2)
			Set @Status = 'Pending'
			--------insert values
			insert into PurchaseOrders(SupplierID, OrderDate , ExpectedDeliveryDate, ActualDeliveryDate,TotalCost,Status)
			Values (@SupplierID, @OrderDate , @ExpectedDeliveryDate, @ActualDeliveryDate, @TotalCost, @Status)
			Set @i += 1
			End
		Commit Transaction;
		Print'Sample purchase orders inserted'
	End Try
	Begin Catch
 
	End Catch
 
End
Go
--___________________________________________________________________________________________________________________________________
/*GO
CREATE PROCEDURE InsertSampleTransactionItems
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- DECLARE Variables
        DECLARE @i INT = 0;
        DECLARE @TransactionID INT;
        DECLARE @ProductID INT;
        DECLARE @Qty INT;
        DECLARE @UnitPriceAtSale DECIMAL(10,2);
        DECLARE @LineTotal DECIMAL(10,2);

        WHILE @i < 1000
        BEGIN
            -- Select random TransactionID and ProductID
            SELECT TOP 1 @TransactionID = TransactionID FROM SalesTransactions ORDER BY NEWID();
            SELECT TOP 1 @ProductID = ProductID FROM Products ORDER BY NEWID();

            -- Generate random quantity and price
            SET @Qty = FLOOR(RAND() * 10) + 1; -- ensures at least 1
            SELECT @UnitPriceAtSale = UnitPrice FROM Products WHERE ProductID = @ProductID;

            -- Calculate line total
            SET @LineTotal = @Qty * @UnitPriceAtSale;

            -- Insert into SalesTransactionItems
            INSERT INTO SalesTransactionItems (TransactionID, ProductID, Qty, UnitPriceAtSale, LineTotal)
            VALUES (@TransactionID, @ProductID, @Qty, @UnitPriceAtSale, @LineTotal);

            SET @i += 1;
        END

        COMMIT TRANSACTION;
        PRINT 'Sample Sales Transaction Items inserted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO


*/
--__________________________________________________________________________________________________________________________________________________________________________
CREATE or alter PROCEDURE InsertSampleSalesTransactionItems
AS
BEGIN
	SET NOCOUNT ON; -- this is supress the msz the number rows affected
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @TotalAmount DECIMAL(10,2);
		DECLARE @TransactionID INT;
		DECLARE @ProductID INT;
		DECLARE @Qty INT;
		DECLARE @UnitPriceAtSale DECIMAL(10,2);
		DECLARE @LineTotal DECIMAL(10,2);
		-- Inorder to avoid duplicate product IDs for transactions, we need to declare a variable
		DECLARE @UsedProducts TABLE(ProductID INT);
		DECLARE @ItemCount INT;
 
		DECLARE @PaymentMethod VARCHAR(20);
		DECLARE @DiscountAmount DECIMAL(10,2);
 
		-- Inorder to loop through each raws {Sales Transactions} in a Table a concept called Cursor
		-- Cursor is a pointer help us to move raws one by one in an result set.
 
		-- Step-1: Declaration Cursor
		-- Step-2: Open Cursor
		-- Step-3: Fetch Cursor
		-- Step-4: Process Cursor
		-- Step-5: Close Cursor
		-- Step-6: Deallocate the Cursor
 
		DECLARE Trans_CursorName CURSOR LOCAL FAST_FORWARD FOR 
			SELECT TransactionID, PaymentMethod FROM SalesTransactions;
		OPEN Trans_CursorName;
		FETCH NEXT FROM Trans_CursorName INTO @TransactionID, @PaymentMethod;
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			DELETE FROM @UsedProducts;
			SET @ItemCount = FLOOR(RAND()*6)+5;
			DECLARE @i INT = 0;
			WHILE @i < 	@ItemCount
			BEGIN 
				SET @ProductID = FLOOR(RAND()*(SELECT COUNT(*) FROM Products)) + 1;
				IF NOT EXISTS(SELECT 1 FROM @UsedProducts WHERE ProductID = @ProductID) 
				BEGIN 
					SELECT @UnitPriceAtSale = UnitPrice FROM Products 
					WHERE ProductID = @ProductID;
					IF @UnitPriceAtSale IS NOT NULL
					BEGIN 
						SET @Qty = FLOOR(RAND()*5)+1;
						SET @LineTotal = ROUND(@Qty * @UnitPriceAtSale, 2);
 
						-- Insert Induvidual Transaction Items
						INSERT INTO SalesTransactionItems(TransactionID, ProductID, Qty, UnitPriceAtSale, LineTotal)
						VALUES (@TransactionID, @ProductID, @Qty, @UnitPriceAtSale, @LineTotal);
 
						INSERT INTO @UsedProducts VALUES (@ProductID);
						SET @i += 1;
					END
				END
			END
			-- Calculate and apply total amount
			SELECT @TotalAmount = SUM(LineTotal) FROM SalesTransactionItems
			WHERE TransactionID = @TransactionID;
 
			-- Update Discount logics based on the Payment Method
			-- CASH = 5%
			-- UPI = 2.5%
			-- CARD = 0%
			IF @PaymentMethod = 'CASH'
				SET @DiscountAmount = ROUND(@TotalAmount * 0.05, 2);
			ELSE IF @PaymentMethod = 'UPI'
				SET @DiscountAmount = ROUND(@TotalAmount * 0.025, 2);
			ELSE
				SET @DiscountAmount = 0;
 
			-- Upadte Sales Transaction Table with Final amounts and discounts
			UPDATE SalesTransactions
			SET TotalAmount = @TotalAmount, DiscountAmount = @DiscountAmount
			WHERE TransactionID = @TransactionID;
 
			-- Fetch Next
			FETCH NEXT FROM Trans_CursorName INTO @TransactionID, @PaymentMethod;
		END;
		-- Close Cursor
		CLOSE Trans_CursorName;
 
		-- Deallocate Trans_CursorName
		DEALLOCATE Trans_CursorName;
 
		COMMIT TRANSACTION;
		PRINT 'Sample Transaction Items updated with Totals';
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <= 0
			ROLLBACK TRANSACTION;
 
		-- Output Detailed error information
		DECLARE @ERR_MSG NVARCHAR(4000), @ERR_SEVIRITY INT, @ERR_STATE INT;
		SELECT @ERR_MSG = ERROR_MESSAGE(),
		@ERR_SEVIRITY = ERROR_SEVERITY(),
		@ERR_STATE = @ERR_STATE;
 
		RAISERROR('Error Occured in InsertSampleSalesTransactionItems: %S',@ERR_SEVIRITY,  @ERR_MSG, @ERR_STATE);
	END CATCH
END;
GO
-------------------------------------------------------------------------------------------------------
CREATE or alter PROCEDURE InsertSamplePurchaseOrderItems
AS
BEGIN
	SET NOCOUNT ON; -- this is supress the msz the number rows affected
	BEGIN TRY
		BEGIN TRANSACTION;
 
		-- Declare variables
		DECLARE 
			@PurchaseOrderID INT,
			@ProductID INT,
			@QtyOrder INT,
			@UnitCost DECIMAL(10,2),
			@LineTotal DECIMAL(10,2),
			@QtyReceived INT,
			@ItemCount INT,
			@i INT,
			@TotalAmount DECIMAL(10,2),
			@Status VARCHAR(25),
			@OrderType INT,
			@RandomNumber FLOAT
			-- Create a Cursor to iterate all purchase orders
			DECLARE OrderCursor CURSOR LOCAL FAST_FORWARD FOR 
			SELECT PurchaseOrderID FROM PurchaseOrders;
			--OPEN CURSOR
			OPEN OrderCursor;
			FETCH NEXT FROM OrderCursor INTO @PurchaseOrderID;
			WHILE
			@@FETCH_STATUS = 0
			BEGIN
				-- Random number of items per purchase orders 'Generate between 10 and 15'
				SET @ItemCount = FLOOR(RAND()*6) + 10
				--SET @ItemCount = FLOOR(RAND()*{Range + 1}) + lower_limit
				SET @i = 0;
				-- Randomly assign OrderType
				-- 25% Pending, 25% Received, 50% Partially Received
				SET @RandomNumber = RAND(CHECKSUM(NewID()));
				IF @RandomNumber < 0.25
					SET @OrderType = 1; -- Pending
				ELSE IF @RandomNumber < 0.5
					SET @OrderType = 2; -- Received
				ELSE 
					SET @OrderType = 3; -- Partially Received
				WHILE @i <= @ItemCount
				BEGIN
				-- Pick Random ProductID
				SET @ProductID = FLOOR(RAND()*(SELECT COUNT(*) FROM Products))+1;
				-- Get Cost Price of the Products
				SELECT @UnitCost = CostPrice FROM Products WHERE ProductID = @ProductID;
				IF @UnitCost IS NOT NULL 
				BEGIN
					-- Gererate Random qty ordered between 1 and 20
					SET @QtyOrder = FLOOR(RAND()*20) + 1;
					-- Calculate the LineTotal
					SET @LineTotal = ROUND(@UnitCost * @QtyOrder, 2);
					-- Determined the Qty Received based on the Order Type
					IF @OrderType = 1
						SET @QtyReceived = 0;
					ELSE IF @OrderType = 2
						SET @QtyReceived = @QtyOrder;
					ELSE 
						-- Random number between 1 and {qty ordered-1}
						SET @QtyReceived = FLOOR(RAND(CHECKSUM(NEWID())) * (@QtyOrder-1))+1;
						INSERT INTO PrchaseOrderItems(PurchaseOrderID, ProductID, QtyOrder, UnitCost, LineTotal, QtyReceived) VALUES
						(@PurchaseOrderID, @ProductID, @QtyOrder, @UnitCost, @LineTotal, @QtyReceived);
						SET @i += 1;
					END
				END
				-- Calculate Total Caost for the purchase Order for the given Items.
				SELECT @TotalAmount = SUM(@LineTotal) FROM PrchaseOrderItems
				WHERE PurchaseOrderID = @PurchaseOrderID;
				-- Define Status Text based on OrderType
				IF @OrderType = 1
					SET @Status = 'Pending'
				ELSE IF @OrderType = 2
					SET @Status = 'Received'
				ELSE 
					SET @Status = 'Partially Received'
				-- Update PurchaseOrders with Totals and Status
				UPDATE PurchaseOrders
				SET 
					TotalCost = @TotalAmount,
					Status = @Status,
					ActualDeliveryDate = CASE WHEN @Status = 'Received' THEN GETDATE() ELSE NULL END
				WHERE PurchaseOrderID = @PurchaseOrderID;
				FETCH NEXT FROM OrderCursor INTO @PurchaseOrderID;
			END
			CLOSE OrderCursor;
			DEALLOCATE OrderCursor;
			COMMIT TRANSACTION;
			PRINT 'Sample Purchase Order Items Inserted along with varied status and delivery Dates'
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <= 0
			ROLLBACK TRANSACTION;
		-- Output Detailed error information
		DECLARE @ERR_MSG NVARCHAR(4000), @ERR_SEVIRITY INT, @ERR_STATE INT;
		SELECT @ERR_MSG = ERROR_MESSAGE(),
		@ERR_SEVIRITY = ERROR_SEVERITY(),
		@ERR_STATE = @ERR_STATE;
		RAISERROR('Error Occured in InsertSamplePurchaseOrderItems: %S',@ERR_SEVIRITY,  @ERR_MSG, @ERR_STATE);
	END CATCH
END;
GO

---------------------------------------------------------------------------------------------------------------------------------------

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



