SELECT
	Sales_year,
	Territory_group,
	ROUND(SUM(TotalDue/AverageRate),2) AS Sales_total_USD,
	LAG(ROUND(SUM(TotalDue/AverageRate),2)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) AS Sales_total_USD_previous,
	CASE
		WHEN ROUND(SUM(TotalDue/AverageRate),2) / LAG(ROUND(SUM(TotalDue/AverageRate),2)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) > 1 THEN 'Increase'
		WHEN ROUND(SUM(TotalDue/AverageRate),2) / LAG(ROUND(SUM(TotalDue/AverageRate),2)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) < 1 THEN 'Decrease'
		ELSE 'No change'
	END AS Sales_change_one_year,
	(SUM(TotalDue/AverageRate)-LAG(SUM(TotalDue/AverageRate)) OVER (PARTITION BY Territory_group ORDER BY Sales_year)) / LAG(SUM(TotalDue/AverageRate)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) * 100 AS Percent_change
FROM [AdventureWorks2022].[dbo].[view_sales_all_data_info]
GROUP BY Sales_year, Territory_group
ORDER BY Territory_group,Sales_year