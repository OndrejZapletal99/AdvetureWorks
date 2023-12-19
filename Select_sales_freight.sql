SELECT
	Sales_year,
	Ship_Method,
	ROUND(SUM(TotalDue/AverageRate),2) AS Sales_total,
	ROUND(SUM(Freight/AverageRate),2) AS Freight_total,
	ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100 AS Share_Of_freight,
	LAG(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100) OVER (PARTITION BY Ship_Method ORDER BY Sales_year) AS Previous_share,
	(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100 - LAG(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100) OVER (PARTITION BY Ship_Method ORDER BY Sales_year)) / (LAG(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100) OVER (PARTITION BY Ship_Method ORDER BY Sales_year)) * 100 AS Year_change
FROM [AdventureWorks2022].[dbo].[view_sales_all_data_info]
GROUP BY Sales_year, Ship_Method
ORDER BY Ship_Method, Sales_year