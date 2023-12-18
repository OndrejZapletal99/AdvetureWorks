SELECT
	due_year AS Fiscal_year,
	VendorID,
	Vendor_Name,
	ROUND(SUM(Qty_Diff),2) AS SUM_Qty_diff_order_recieve,
	LAG(SUM(Qty_Diff)) OVER (PARTITION BY Vendor_Name ORDER BY due_year) AS Prev_Qty_Diff,
	ROUND(AVG(Qty_Diff),2) AS _AVG_Qty_diff_order_recieve,
	CASE 
		WHEN ROUND(SUM(Qty_Diff),2) - LAG(SUM(Qty_Diff)) OVER (PARTITION BY Vendor_Name ORDER BY due_year) > 0 THEN 'Increase'
		WHEN ROUND(SUM(Qty_Diff),2) - LAG(SUM(Qty_Diff)) OVER (PARTITION BY Vendor_Name ORDER BY due_year) < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS Qty_diff_increase,
	ROUND(SUM(RejectedQty),2) AS SUM_Qty_rejected,
	LAG(SUM(RejectedQty)) OVER (PARTITION BY Vendor_Name ORDER BY due_year) AS Prev_Qty_rejected,
	ROUND(AVG(RejectedQty),2) AS AVG_Qty_rejected,
	CASE 
		WHEN ROUND(SUM(RejectedQty),2) - LAG(SUM(RejectedQty)) OVER (PARTITION BY Vendor_Name ORDER BY due_year) > 0 THEN 'Increase'
		WHEN ROUND(SUM(RejectedQty),2) - LAG(SUM(RejectedQty)) OVER (PARTITION BY Vendor_Name ORDER BY due_year) < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS Qty_rejected_increase
FROM  [AdventureWorks2022].[dbo].[view_purchasing_orders_all_data]
WHERE 1=1
	--AND due_year = XXXX
	--AND Vendor_Name = 'XXXXX'
	--AND VendorID = XXXX
GROUP BY VendorID,Vendor_Name,due_year
ORDER BY VendorID,Vendor_Name,due_year;
