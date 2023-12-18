CREATE OR ALTER VIEW view_purchasing_orders_all_data AS (
	SELECT
		poh.PurchaseOrderID,
		poh.RevisionNumber,
		poh.Status,
		poh.EmployeeID,
		CONCAT(emp.FirstName,' ', emp.LastName) AS Employee_Name,
		poh.OrderDate,
		poh.ShipDate,
		pod.DueDate,
		DAY(pod.DueDate)-DAY(poh.OrderDate) AS Order_Due_day_diff,
		YEAR(pod.DueDate) AS due_Year,
		pod.OrderQty,
		pod.ReceivedQty,
		pod.OrderQty-pod.ReceivedQty AS Qty_diff,
		pod.RejectedQty,
		pod.OrderQty-pod.ReceivedQty+pod.RejectedQty AS Qty_missing,
		poh.SubTotal,
		poh.TaxAmt,
		poh.Freight,
		poh.TotalDue,
		poh.VendorID,
		v.Name AS Vendor_Name,
		v.CreditRating,
		v.PreferredVendorStatus,
		poh.ShipMethodID,
		sm.Name AS Ship_method_Name,
		sm.ShipBase,
		sm.ShipRate,
		pod.ProductID,
		phi.Product_Name,
		phi.Product_Category,
		phi.Product_Subcategory
	FROM [AdventureWorks2022].[Purchasing].[PurchaseOrderHeader] poh
	LEFT JOIN [AdventureWorks2022].[Purchasing].[Vendor] v
		ON poh.VendorID = v.BusinessEntityID
	LEFT JOIN [AdventureWorks2022].[Purchasing].[ShipMethod] sm
		ON poh.ShipMethodID = sm.ShipMethodID
	LEFT JOIN [AdventureWorks2022].[Purchasing].[PurchaseOrderDetail] pod
		ON poh.PurchaseOrderID = pod.PurchaseOrderID
	LEFT JOIN [AdventureWorks2022].[dbo].[view_product_hierarchy_basic_info] phi
		ON pod.ProductID = phi.Product_ID
	LEFT JOIN [AdventureWorks2022].[Person].[Person] emp
		ON poh.EmployeeID = emp.BusinessEntityID )
;