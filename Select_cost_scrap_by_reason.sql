WITH order_cost_table AS(
	SELECT
		o.Workorder_ID,
		o.Product_ID,
		o.Product_Name,
		o.Subcategory_Name,
		o.Category_Name,
		o.Order_Qty,
		o.Scrap_Qty,
		o.Scrap_Reason,
		o.Production_year,
		c.Oder_cost
	FROM [AdventureWorks2022].[dbo].[view_production_orders] o
	LEFT JOIN [AdventureWorks2022].[dbo].[view_production_orders_cost] c
		ON o.Workorder_ID = c.WorkOrderID
)
SELECT
	Production_year,
	Scrap_Reason,
	SUM(Scrap_Qty),
	SUM(Order_Qty),
	ROUND(SUM(Scrap_Qty)*1.0 / SUM(Order_Qty) * 100,2) AS Reason_scrap,
	SUM(Oder_cost / Order_Qty * Scrap_Qty) AS Reason_scrap_cost
FROM order_cost_table
GROUP BY Production_year,Scrap_Reason
ORDER BY Production_year ASC