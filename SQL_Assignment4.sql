--How many times products with list price bigger than average was ordered
SELECT ProductID, COUNT(*) AS AmountOfPurchasing
FROM Sales.SalesOrderDetail
WHERE ProductID IN (SELECT PP.ProductID
                    FROM Production.Product PP
                    WHERE ListPrice > (SELECT AVG(ListPrice)
                                       FROM Production.Product))
GROUP BY ProductID;

--Name of products which are on special offer of type Excess Inventory
SELECT P.Name
FROM Sales.SpecialOfferProduct SOP
JOIN Production.Product P
ON SOP.ProductID = P.ProductID
WHERE SOP.SpecialOfferID IN (SELECT SO.SpecialOfferID 
                            FROM Sales.SpecialOffer SO
                            WHERE SO.Type = 'Excess Inventory');

--How many sales representative are per geographic area (manager + sales)
SELECT GroupName, 
       COUNT(*) FROM (
SELECT GroupName =  CASE LEFT(HE.JobTitle, 1)
                                WHEN 'N' THEN 'North America'
                                WHEN 'P' THEN 'Pacific'
                                WHEN 'E' THEN 'Europe'
                                ELSE ST.[Group]
                            END
        FROM HumanResources.Employee HE
        JOIN Sales.SalesPerson SP
        ON SP.BusinessEntityID = HE.BusinessEntityID
        LEFT JOIN Sales.SalesTerritory AS ST
        ON SP.TerritoryID = ST.TerritoryID
        WHERE HE.BusinessEntityID = SP.BusinessEntityID
       ) AS Groups
GROUP BY GroupName;

---The most expensive order per territory
SELECT ST.TerritoryID, (
        SELECT MAX(SOH.TotalDue) FROM Sales.SalesOrderHeader AS SOH
        WHERE SOH.TerritoryID = ST.TerritoryID
        ) AS TotalDueLastName
FROM Sales.SalesTerritory AS ST;

--Name of products which are on special offer
SELECT PP.Name
FROM Production.Product PP
WHERE EXISTS(
    SELECT * FROM Sales.SpecialOfferProduct SSOP
    WHERE SSOP.ProductID = PP.ProductID
    AND SSOP.SpecialOfferID <> 1
);

--Name of vendor whose product has the worse rating
SELECT PV.Name FROM Purchasing.Vendor PV
JOIN Purchasing.ProductVendor PPV 
ON PPV.BusinessEntityID = PV.BusinessEntityID
WHERE PPV.ProductID IN (
    SELECT TOP 1 PPR.ProductID AS AverageRating
    FROM Production.ProductReview PPR
    GROUP BY PPR.ProductID
    ORDER BY AverageRating
    );

--Name of employees who have more than average vacation hours
SELECT PP.FirstName, PP.LastName FROM Person.Person PP
WHERE PP.BusinessEntityID IN (
    SELECT HR.BusinessEntityID 
    FROM HumanResources.Employee HR
    WHERE HR.VacationHours > (SELECT AVG(VacationHours) 
                              FROM HumanResources.Employee InnerHR)
    )

--Name of 5 vendors whose products were rejected the most by %
SELECT PV.Name FROM Purchasing.Vendor PV
JOIN Purchasing.PurchaseOrderHeader POH
ON PV.BusinessEntityID = POH.VendorID
WHERE PurchaseOrderID IN (
    SELECT TOP 5 POD.PurchaseOrderID
    FROM Purchasing.PurchaseOrderDetail POD
    GROUP BY POD.PurchaseOrderID
    ORDER BY SUM(POD.RejectedQty) * 100 / SUM(POD.ReceivedQty) DESC
    );
