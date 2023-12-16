CREATE OR ALTER VIEW view_production_orders AS(
	SELECT
		wo.WorkOrderID AS Workorder_ID,
		wo.ProductID as Product_ID,
		p.Name AS Product_Name,
		sp.Name AS Subcategory_Name,
		c.Name AS Category_Name,
		wo.OrderQty AS Order_Qty,
		wo.StockedQty AS Stocked_Qty,
		wo.ScrappedQty AS Scrap_Qty,
		sc.Name AS Scrap_Reason,
		DAY(wo.DueDate) - DAY(wo.EndDate) AS Day_diff,
		CASE 
			WHEN (wo.DueDate) - DAY(wo.EndDate) <0 THEN 'Delyed'
			WHEN (wo.DueDate) - DAY(wo.EndDate) = 0 THEN 'JIT'
			ELSE 'Early'
		END AS Late_Status,
		YEAR(wo.EndDate) AS Production_year
	FROM [AdventureWorks2022].[Production].[WorkOrder] wo
		LEFT JOIN [AdventureWorks2022].[Production].[ScrapReason] sc
			ON wo.ScrapReasonID = sc.ScrapReasonID
		LEFT JOIN [AdventureWorks2022].[Production].[Product] p
			ON wo.ProductId = p.ProductID
		LEFT JOIN [AdventureWorks2022].[Production].[ProductSubcategory] sp
			ON p.ProductSubcategoryID = sp.ProductSubcategoryID
		LEFT JOIN [AdventureWorks2022].[Production].[ProductCategory] c
			ON sp.ProductCategoryID = c.ProductCategoryID)
;
