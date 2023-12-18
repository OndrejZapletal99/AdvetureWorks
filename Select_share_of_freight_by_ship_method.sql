SELECT
	due_year AS Fiscal_year,
	Ship_method_Name,
	ROUND(SUM(Freight),2) AS Total_freight_cost,
	ROUND(SUM(TotalDue),2) AS Total_order_cost,
	ROUND((SUM(Freight) / SUM(TotalDue) * 100),2) AS Share_of_freight
FROM [AdventureWorks2022].[dbo].[view_purchasing_orders_all_data]
GROUP BY Ship_method_Name, due_year
ORDER BY Ship_method_Name, due_year