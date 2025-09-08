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
