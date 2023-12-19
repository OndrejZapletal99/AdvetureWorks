CREATE OR ALTER VIEW view_sales_all_data_info AS (
SELECT
	soh.SalesOrderID,
	YEAR(soh.DueDate) as Sales_year,
	soh.CustomerID,
	soh.SalesPersonID,
	soh.TerritoryID,
	st.Name AS Territory,
	st.[Group] AS Territory_group,
	st.CountryRegionCode,
	cc.CurrencyCode,
	soh.ShipMethodID,
	sm.Name AS Ship_Method,
	soh.SubTotal,
	soh.TaxAmt,
	soh.Freight,
	soh.TotalDue,
	cr.AverageRate
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] soh
LEFT JOIN [AdventureWorks2022].[Sales].[SalesTerritory] st
	ON soh.TerritoryID = st.TerritoryID
INNER JOIN [AdventureWorks2022].[Sales].[CountryRegionCurrency] cc
	ON st.CountryRegionCode = cc.CountryRegionCode
LEFT JOIN [AdventureWorks2022].[Purchasing].[ShipMethod] sm
	ON soh.ShipMethodID = sm.ShipMethodID
LEFT JOIN [AdventureWorks2022].[Sales].[CurrencyRate] cr
	ON  cc.CurrencyCode = cr.ToCurrencyCode
	AND soh.DueDate = cr.CurrencyRateDate
WHERE cc.CurrencyCode NOT IN ('DEM', 'ESP', 'FIM', 'FRF', 'GRD', 'IEP', 'ITL', 'NLG', 'PTE'))
;


