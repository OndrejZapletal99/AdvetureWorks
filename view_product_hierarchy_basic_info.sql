CREATE OR ALTER VIEW view_product_hierarchy_basic_info AS (
	SELECT
		p.ProductID AS Product_ID,
		p.Name AS Product_Name,
		p.ProductNumber AS Product_Num,
		p.MakeFlag,
		p.FinishedGoodsFlag AS Finished_Goods,
		p.Color AS Product_Color,
		p.SafetyStockLevel AS Safety_Stock_Level,
		p.ReorderPoint AS Reorder_Point,
		p.StandardCost AS STD_Cost,
		p.ListPrice AS Price,
		p.Size,
		p.SizeUnitMeasureCode AS Size_Unit,
		p.Weight,
		p.WeightUnitMeasureCode AS Weight_Unit,
		p.DaysToManufacture AS Production_time,
		p.ProductLine AS Product_Line,
		p.Class AS Product_Class,
		p.Style,
		c.Name AS Product_Category,
		s.Name AS Product_Subcategory,
		m.Name AS Product_Model,
		YEAR(p.SellStartDate) AS Sell_Start_year,
		YEAR(p.SellEndDate) AS Sell_End_year,
		p.DiscontinuedDate AS Discontinued_Date,
		CASE	
			WHEN p.SellEndDate IS NOT NULL THEN 'Not Sellable'
			ELSE 'Sellable'
		END AS Sellable
	FROM [AdventureWorks2022].[Production].[Product] p
	LEFT JOIN [AdventureWorks2022].[Production].[ProductSubcategory] s
		ON p.ProductSubcategoryID = s.ProductSubcategoryID
	LEFT JOIN [AdventureWorks2022].[Production].[ProductModel] m
		ON p.ProductModelID = m.ProductModelID
	LEFT JOIN [AdventureWorks2022].[Production].[ProductCategory] c
		ON s.ProductCategoryID = c.ProductCategoryID)
;