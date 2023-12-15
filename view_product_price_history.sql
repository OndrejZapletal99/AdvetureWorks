CREATE OR ALTER VIEW view_product_price_history AS (
	SELECT
		pph.ProductID,
		info.Product_Name,
		pph.ListPrice,
		YEAR(pph.StartDate) + 1 AS Fiscal_year,
		info.Product_Category,
		info.Product_Subcategory,
		info.Product_Model
	FROM [AdventureWorks2022].[Production].[ProductListPriceHistory] pph
		LEFT JOIN [AdventureWorks2022].[dbo].[view_product_hierarchy_basic_info] info
			ON pph.ProductID = info.Product_ID)
;