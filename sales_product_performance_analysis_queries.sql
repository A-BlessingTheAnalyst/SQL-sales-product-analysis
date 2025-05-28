--  1. High-Value Invoices (Product Cost > $2,000)
SELECT
    SalesOrderNumber,
    SUM(TotalProductCost) AS Total_Cost
FROM FactResellerSales
GROUP BY SalesOrderNumber
HAVING SUM(TotalProductCost) > 2000
ORDER BY Total_Cost DESC;

--  2. Product Subcategory Sales (Top Performing Subcategories)
SELECT
    ps.EnglishProductSubcategoryName,
    SUM(s.SalesAmount) AS Total_Sales
FROM FactInternetSales s
JOIN DimProduct p ON s.ProductKey = p.ProductKey
JOIN DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
GROUP BY ps.EnglishProductSubcategoryName
ORDER BY Total_Sales DESC;

--  3. Sales by Territory and Tax Analysis (December Focus)
SELECT
    t.SalesTerritoryRegion,
    MONTH(s.OrderDate) AS SalesMonth,
    SUM(s.SalesAmount) AS Total_Sales,
    SUM(s.TaxAmt) AS Total_Tax
FROM FactResellerSales s
JOIN DimSalesTerritory t ON s.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY t.SalesTerritoryRegion, MONTH(s.OrderDate)
ORDER BY Total_Sales DESC;

--  4. Customer Segmentation: Homeowners with 2+ Cars
SELECT
    MaritalStatus,
    Gender,
    EnglishOccupation,
    NumberCarsOwned,
    HouseOwnerFlag,
    COUNT(CustomerKey) AS Total_Customers
FROM DimCustomer
WHERE HouseOwnerFlag = '1' AND NumberCarsOwned >= 2
GROUP BY MaritalStatus, Gender, EnglishOccupation, NumberCarsOwned, HouseOwnerFlag
ORDER BY Total_Customers DESC;

--  5. Employee Resignation by Department
SELECT
    DepartmentName,
    HireDate,
    EndDate,
    DATEDIFF(YEAR, HireDate, EndDate) AS Years_Worked
FROM DimEmployee
WHERE EndDate IS NOT NULL
ORDER BY Years_Worked DESC;

--  6. Currency Usage Summary (Across Sales)
SELECT
    c.CurrencyAlternateKey,
    c.CurrencyName,
    COUNT(*) AS Usage_Count
FROM DimCurrency c
JOIN FactInternetSales s ON c.CurrencyKey = s.CurrencyKey
GROUP BY c.CurrencyAlternateKey, c.CurrencyName
ORDER BY Usage_Count DESC;

--  7. Sales by Country and Product Category
SELECT
    g.EnglishCountryRegionName,
    pc.EnglishProductCategoryName,
    SUM(s.SalesAmount) AS Total_Sales
FROM FactInternetSales s
JOIN DimCustomer c ON s.CustomerKey = c.CustomerKey
JOIN DimGeography g ON c.GeographyKey = g.GeographyKey
JOIN DimProduct p ON s.ProductKey = p.ProductKey
JOIN DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY g.EnglishCountryRegionName, pc.EnglishProductCategoryName
ORDER BY Total_Sales DESC;

--  8. Monthly Sales Trend (FactInternetSales)
SELECT
    YEAR(OrderDate) AS Sales_Year,
    MONTH(OrderDate) AS Sales_Month,
    SUM(SalesAmount) AS Monthly_Sales
FROM FactInternetSales
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Sales_Year, Sales_Month;
