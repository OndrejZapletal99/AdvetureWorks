
WITH RankedSales AS (
    SELECT
        vs.Sales_year,
        pod.ProductID,
        ROUND(SUM(vs.TotalDue / vs.AverageRate),0) AS Total_sales,
        RANK() OVER (PARTITION BY vs.Sales_year ORDER BY SUM(vs.TotalDue / vs.AverageRate) DESC) AS SalesRank
    FROM
        [AdventureWorks2022].[dbo].[view_sales_all_data_info] vs
    LEFT JOIN
        [AdventureWorks2022].[Sales].[SalesOrderDetail] pod 
	ON vs.SalesOrderID = pod.SalesOrderID
    GROUP BY vs.Sales_year, pod.ProductID
)

SELECT
    Sales_year,
    ProductID,
    Total_sales
FROM
    RankedSales
WHERE
    SalesRank <= 5
ORDER BY
    Sales_year, Total_sales DESC;