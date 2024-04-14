--1) Create a new order + order details
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @NewOrderID INT;

    INSERT INTO Sales.SalesOrderHeader (RevisionNumber, OrderDate, DueDate, Status, OnlineOrderFlag,
                                        CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID,
                                        ShipMethodID, TaxAmt, Freight)
    VALUES (8, GETDATE(), DATEADD(DAY, 10, GETDATE()), 1, 1,
            29672, 279, 1, 921, 921,
            5, 124.2483, 38.8276);

    SET @NewOrderID = SCOPE_IDENTITY();

    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID,
                                        UnitPrice, UnitPriceDiscount)
    VALUES (@NewOrderID, '4911-403C-98', 3, 777, 1,
            2024.9940, 0.0000);

    UPDATE Sales.SalesOrderHeader
    SET SubTotal = (SELECT SUM(LineTotal) FROM Sales.SalesOrderDetail WHERE SalesOrderID = @NewOrderID)
    WHERE SalesOrderID = @NewOrderID;

    COMMIT TRANSACTION;
    PRINT 'Success.';
    PRINT @NewOrderID;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH

--2) Create a new customer
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @NewBusinessEntityID INT;
    INSERT INTO Person.BusinessEntity (ModifiedDate)
    VALUES (getdate());
    SET @NewBusinessEntityID = SCOPE_IDENTITY();

    INSERT INTO Person.Person (BusinessEntityID, PersonType, NameStyle, FirstName, LastName, EmailPromotion)
    VALUES (@NewBusinessEntityID, 'IN', 0, 'Maria', 'Procopii', 0);

    INSERT INTO Sales.Customer (PersonID, StoreID, TerritoryID)
    VALUES (@NewBusinessEntityID, 934, 1);

    COMMIT TRANSACTION;
    PRINT 'Success.';
    PRINT @NewBusinessEntityID;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH 

--3) Delete a Customer
BEGIN TRANSACTION 
BEGIN TRY
    DECLARE @BusinessEntityID INT;
    SET @BusinessEntityID = 20781;

    DELETE FROM Person.PersonPhone
    WHERE BusinessEntityID = @BusinessEntityID;

    DELETE FROM Person.EmailAddress
    WHERE BusinessEntityID = @BusinessEntityID;

    DELETE FROM Sales.Customer
    WHERE PersonID = @BusinessEntityID;

    DELETE FROM Person.Person
    WHERE BusinessEntityID = @BusinessEntityID;

    DELETE FROM Person.BusinessEntity
    WHERE BusinessEntityID = @BusinessEntityID;

    COMMIT TRANSACTION;
    PRINT 'Success.';
    PRINT @BusinessEntityID;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH

--4) Create a new product with model description
BEGIN TRANSACTION 
BEGIN TRY
    DECLARE @NewModelID INT;
    INSERT INTO Production.ProductModel (Name)
    VALUES ('Modern Style Vest');

    SET @NewModelID = SCOPE_IDENTITY();

    INSERT INTO Production.Product (Name, ProductNumber, MakeFlag, FinishedGoodsFlag,
                                    Color, SafetyStockLevel, ReorderPoint, StandardCost,
                                    ListPrice, DaysToManufacture, ProductLine, Style,
                                    ProductSubcategoryID, ProductModelID, SellStartDate)
    VALUES ('Modern Vest', 'NP123456', 1, 1, 'Red', 100, 50,
            50.00, 100.00, 5, 'M', 'U', 25, @NewModelID, '2024-04-15');

    COMMIT TRANSACTION;
    PRINT 'Success.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH

--5) Delete the product model record
BEGIN TRANSACTION
BEGIN TRY
    DECLARE @ModelID INT;
    
    SELECT @ModelID = ProductModelID
    FROM Production.ProductModel
    WHERE Name = 'Modern Style Vest';

    UPDATE Production.Product
    SET ProductModelID = NULL
    WHERE ProductModelID = @ModelID;

    DELETE FROM Production.ProductModel
    WHERE ProductModelID = @ModelID;

    COMMIT TRANSACTION;
    PRINT 'Success.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH

--6) Create person contact information
BEGIN TRANSACTION
BEGIN TRY
    DECLARE @BusinessEntityID INT;
    SET  @BusinessEntityID = 20782;

    INSERT INTO Person.EmailAddress(businessentityid, emailaddress)
    VALUES (@BusinessEntityID, 'mariaProcopii@adventure-works.com');
    
    INSERT INTO Person.PersonPhone(businessentityid, phonenumber, phonenumbertypeid)
    VALUES (@BusinessEntityID,'697-555-1020', 1);
    
    COMMIT TRANSACTION;
    PRINT 'Success.';
    PRINT @BusinessEntityID;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH

--7) Update person contact information
BEGIN TRANSACTION
BEGIN TRY
    DECLARE @BusinessEntityID INT;
    SET @BusinessEntityID = 20782;
    
    UPDATE Person.EmailAddress
    SET EmailAddress = 'crystalnew@adventure-works.com'
    WHERE BusinessEntityID = @BusinessEntityID;
    
    UPDATE Person.PersonPhone
    SET PhoneNumber = 250-555-0127,
        PhoneNumberTypeID = 1
    WHERE BusinessEntityID = @BusinessEntityID
    
    COMMIT TRANSACTION;
    PRINT 'Success.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH

--8) Remove created order and order details
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @DeleteOrderID INT;
    SET @DeleteOrderID = 75136;

    DELETE FROM Sales.SalesOrderDetail 
    WHERE SalesOrderID = @DeleteOrderID;
     
    DELETE FROM Sales.SalesOrderHeader
    WHERE SalesOrderID = @DeleteOrderID;

    COMMIT TRANSACTION;
    PRINT 'Success.';
    PRINT @DeleteOrderID;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE();
END CATCH
