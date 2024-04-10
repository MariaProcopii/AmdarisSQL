--Best Soled product in 2014
SELECT TOP 1 product.Name, SUM(orderDetails.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderHeader AS orderHeader
         JOIN Sales.SalesOrderDetail AS orderDetails
              ON orderHeader.SalesOrderID = orderDetails.SalesOrderID
         JOIN Production.Product AS product
              ON orderDetails.ProductID = product.ProductID
WHERE YEAR(orderHeader.ShipDate) = 2014
GROUP BY product.Name, YEAR(orderHeader.ShipDate)
ORDER BY TotalQuantitySold DESC

--Category where the product cost increased the most
SELECT TOP 1 category.Name                                         AS CategoryName,
             subcategory.Name                                      AS SubcategoryName,
             MAX(history.StandardCost) - MIN(history.StandardCost) AS PriceIncreaceQty
FROM Production.Product product
         JOIN Production.ProductSubcategory subcategory
              ON product.ProductSubcategoryID = subcategory.ProductSubcategoryID
         JOIN Production.ProductCategory category
              ON subcategory.ProductCategoryID = category.ProductCategoryID
         JOIN Production.ProductCostHistory history
              ON product.ProductID = history.ProductID
GROUP BY category.Name, subcategory.Name
ORDER BY PriceIncreaceQty DESC


--How many sales representative are per geographic area
SELECT Subquery.Groups, COUNT(*) AS TotalEmployee
FROM (SELECT IIF(
                 territory.[Group] IS NULL,
                 LEFT(employee.JobTitle, 13),
                 territory.[Group]
                ) AS Groups
      FROM HumanResources.Employee employee
          JOIN Sales.SalesPerson salesPerson 
              ON salesPerson.BusinessEntityID = employee.BusinessEntityID
          LEFT JOIN Sales.SalesTerritory AS territory
              ON salesPerson.TerritoryID = territory.TerritoryID
      ) AS Subquery
GROUP BY Subquery.Groups;

--Total of employees current working in each department
SELECT department.Name, COUNT(*) AS TotalEmployees
FROM HumanResources.EmployeeDepartmentHistory departmentHistory
         JOIN HumanResources.Department AS department
              ON departmentHistory.DepartmentID = department.DepartmentID
WHERE departmentHistory.EndDate IS NULL
GROUP BY department.Name;

--Amount of products per each category
SELECT category.Name AS CategoryName,
       COUNT(*)      AS AmountOfProducts
FROM Production.Product product
         JOIN Production.ProductSubcategory subcategory
              ON product.ProductSubcategoryID = subcategory.ProductSubcategoryID
         JOIN Production.ProductCategory category
              ON subcategory.ProductCategoryID = category.ProductCategoryID
GROUP BY category.Name;

--Available storages and amount of products there
SELECT location.Name, location.CostRate, SUM(inventory.ProductID) AmountOfProducts
FROM Production.ProductInventory inventory
         JOIN Production.Location location on location.LocationID = inventory.LocationID
WHERE location.Availability > 0
GROUP BY location.Name, location.CostRate;

--Worst product by review rating
SELECT TOP 1 product.Name, AVG(review.Rating) AS AverageRating
FROM Production.ProductReview review
         JOIN Production.Product product
              ON product.ProductID = review.ProductID
GROUP BY product.Name
ORDER BY product.Name;

--Longest duration of a discount (product type included) for a reseller
SELECT TOP 1 DATEDIFF(DAY, StartDate, EndDate) AS AmountOfDays, product.Name
FROM Sales.SpecialOffer AS specialOffer
         JOIN Sales.SalesOrderDetail SOD ON specialOffer.SpecialOfferID = SOD.SpecialOfferID
         JOIN Production.Product AS product ON SOD.ProductID = product.ProductID
WHERE Category = 'Reseller'
ORDER BY AmountOfDays DESC;
