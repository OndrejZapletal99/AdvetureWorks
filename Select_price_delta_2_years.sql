WITH product_price_dev_2_year AS (
	SELECT
		Fiscal_year,
		ProductID,
		Product_Name,
		ROUND(AVG(ListPrice),2) AS AVG_price,
		ROUND(LAG((AVG(ListPrice)),2) OVER (PARTITION BY ProductID ORDER BY Fiscal_year),2) AS Previous_fiscal_year_2
	FROM [AdventureWorks2022].[dbo].[view_product_price_history] 
	GROUP BY Fiscal_year,ProductID,Product_Name
)
SELECT
	Fiscal_year,
	Product_Name,
	ProductID,
	ROUND((AVG_price-Previous_fiscal_year_2)/Previous_fiscal_year_2*100,2) as delta_1
FROM product_price_dev_2_year 
WHERE 1=1
	AND Previous_fiscal_year_2 IS NOT NULL
ORDER BY Fiscal_year DESC
;
