-- Query 1: Roll-up - Total sales by country and quarter
SELECT 
    c.Country,
    t.Quarter,
    t.Year,
    ROUND(SUM(f.TotalSales), 2) AS TotalSales
FROM 
    SalesFact f
JOIN CustomerDim c ON f.CustomerID = c.CustomerID
JOIN TimeDim t ON f.InvoiceDate = t.InvoiceDate
GROUP BY 
    ROLLUP(c.Country, t.Year, t.Quarter)
ORDER BY 
    c.Country, t.Year, t.Quarter;

-- Query 2: Drill-down - UK sales by month (2024-2025)
SELECT 
    t.Month,
    t.Year,
    ROUND(SUM(f.TotalSales), 2) AS MonthlySales,
    COUNT(DISTINCT f.InvoiceNo) AS Transactions
FROM 
    SalesFact f
JOIN CustomerDim c ON f.CustomerID = c.CustomerID
JOIN TimeDim t ON f.InvoiceDate = t.InvoiceDate
WHERE 
    c.Country = 'United Kingdom'
    AND t.InvoiceDate >= '2024-08-01'
GROUP BY 
    t.Year, t.Month
ORDER BY 
    t.Year, t.Month;

-- Query 3: Slice - Electronics sales (assuming StockCode starting with 'ELEC')
SELECT 
    strftime('%Y-%m', t.InvoiceDate) AS Month,
    ROUND(SUM(f.TotalSales), 2) AS ElectronicsSales
FROM 
    SalesFact f
JOIN TimeDim t ON f.InvoiceDate = t.InvoiceDate
WHERE 
    f.StockCode LIKE 'ELEC%'
GROUP BY 
    strftime('%Y-%m', t.InvoiceDate)
ORDER BY 
    Month;








    SELECT 
    c.Country,
    t.Quarter,
    SUM(f.TotalSales) AS TotalSales
FROM SalesFact f
JOIN CustomerDim c ON f.CustomerID = c.CustomerID
JOIN TimeDim t ON f.TimeID = t.TimeID
GROUP BY c.Country, t.Quarter
ORDER BY c.Country, t.Quarter;


SELECT 
    t.Year,
    t.Month,
    SUM(f.TotalSales) AS TotalSales
FROM SalesFact f
JOIN CustomerDim c ON f.CustomerID = c.CustomerID
JOIN TimeDim t ON f.TimeID = t.TimeID
WHERE c.Country = 'United Kingdom'
GROUP BY t.Year, t.Month
ORDER BY t.Year, t.Month;
