SELECT
	due_year AS Fiscal_year,
	VendorID,
	Vendor_Name,
	AVG(Order_Due_day_diff) AS AVG_lead_time
FROM  [AdventureWorks2022].[dbo].[view_purchasing_orders_all_data]
GROUP BY VendorID,Vendor_Name,due_year
ORDER BY VendorID,Vendor_Name,due_year;