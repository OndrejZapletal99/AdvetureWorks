CREATE OR ALTER VIEW view_production_orders_cost AS (
	SELECT
		WorkOrderID,
		SUM(ActualCost) AS Oder_cost
	FROM [AdventureWorks2022].[Production].[WorkOrderRouting]
	GROUP BY WorkOrderID
)
;