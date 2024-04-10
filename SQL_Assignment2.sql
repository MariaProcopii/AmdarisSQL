--First Task
SELECT FirstName, LastName, BusinessEntityID AS Employee_id
FROM Person.Person
ORDER BY LastName;

--Second Task
SELECT person.BusinessEntityID, FirstName, LastName, PhoneNumber
FROM Person.PersonPhone phone
         JOIN Person.Person person
              ON phone.BusinessEntityID = person.BusinessEntityID
WHERE LastName LIKE 'L%'
ORDER BY LastName, FirstName;

SELECT LastName,COUNT(BusinessEntityID)
FROM Person.Person
group by LastName

--Third Task
SELECT LastName, PostalCode, SalesYTD, COUNT(*) AS NumberOfGroups
FROM Sales.SalesPerson s
         JOIN Person.Person p
              ON s.BusinessEntityID = p.BusinessEntityID
         JOIN Person.BusinessEntityAddress bea
              ON s.BusinessEntityID = bea.BusinessEntityID
         JOIN Person.Address a
              ON bea.AddressID = a.AddressID
WHERE SalesYTD <> 0
  AND s.TerritoryID IS NOT NULL
GROUP BY LastName, PostalCode, SalesYTD
ORDER BY SalesYTD DESC, PostalCode;

--Fourth Task
SELECT SalesOrderID, SubTotal
FROM Sales.SalesOrderHeader
WHERE SubTotal > 100000;


