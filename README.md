# Adveture Works projekt

- *SQL*
- *DISCORD*: "ondrej_zapletal"
---


- # Obsah
	- [1. Zdroj dat](#1-zdroj-dat)
    	- [1.1 Popis](#11-popis)
    	- [1.2 Zdroj dat](#12-zdroj-dat)
  	- [2. SQL databáze](#2-sql-databáze)
    	- [2.1 Lidské zdroje](#21-lidské-zdroje)
        	- [2.1.1 Základní kontaktní informace o zaměstnacích](#211-základní-kontaktní-informace-o-zaměstnacích)
        	- [2.1.2 Základní informace o pracovní pozici zaměstnanců, jejich zařezení do oddělení a zjištění manažerů oddělení](#212-základní-informace-o-pracovní-pozici-zaměstnanců-jejich-zařezení-do-oddělení-a-zjištění-manažerů-oddělení)
        	- [2.1.3 Základní informace o datumu narození a datumu nástupu jednotlivých pracovníků](#213-základní-informace-o-datumu-narození-a-datumu-nástupu-jednotlivých-pracovníků)
        	- [2.1.4 Základní informace o zbývajících hodinách dovolené, hodinách nemocnosti](#214-základní-informace-o-zbývajících-hodinách-dovolené-hodinách-nemocnosti)
      	-  [2.2 Produkty a produkce](#22-produkty-a-produkce)
         	-  [2.2.1 Produktová hierarchie](#221-produktové-info-a-zařazení-do-hierarchie)
         	-  [2.2.2 Cenová historie produktů](#222-cenová-historie-produktů)
         	-  [2.2.3 Změna cen v čase](#223-změna-cen-v-čase)
         	-  [2.2.4 Základní informace o výrobních zakázkách](#224-základní-informace-o-výrobních-zakázkách)
         	-  [2.2.5 Scrap a náklady plynoucí ze scrapu dle různých pohledů](#225-scrap-a-náklady-plynoucí-ze-scrapu-dle-různých-pohledů)
        - [2.3 Nákup](#23-nákup)
            - [2.3.1 Sloučení nákupních informací](#231-sloučení-nákupních-informací)
            - [2.3.2 Průměrný leadtime podle dodavatele a jeho vývoj v letech](#232-průměrný-leadtime-podle-dodavatele-a-jeho-vývoj-v-letech)
            - [2.3.4 Rozdíl mezi dodaným a objednamým množstvím. Počet odmítnuhé množství zboží](#234-rozdíl-mezi-dodaným-a-objednamým-množstvím-počet-odmítnuhé-množství-zboží
			)
		- [2.4 Prodej](#24-prodej)
  		  - [2.4.1 Sloučení prdejních informací](#241-sloučení-prodejních-informací)
  		  - [2.4.2 Prodeje v jednotlivých oblastech a jejich časový vývoj](#242-prodeje-v-jednotlivých-oblastech-a-jejich-časový-vývoj)
  		  - [2.4.3 Top 5 produktů v každém roce podle prodejů](#243-top-5-produktů-v-každém-roce-podle-prodejů)
## 1. Úvod
### 1.1 Popis
Cílem tohoto projektu je zanalyzovat veřejně dostupnou databázi pomocí SQL v programu SQL Server Management Studio.
### 1.2 Zdroj dat 
Data pro tento projekt jsou veřejně dustupná na [**webu**](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms). Pro stažení a instalaci backupu je vhodné zhlédnout [**video**](https://www.youtube.com/watch?v=bAlQfpjPOEA).
Jedná se o veřejně dostupnou databázi, která slouží k procvičování a trenování v SQL a také k tvorbě vizualizace v PowerBi. Databáze obsahuje data z oblasti podnikového řizení, přesněji z oblasti lidských zdrojů, výroby, prodejů a nákupu.
## 2. SQL databáze
### 2.1 Lidské zdroje
První skupinou databáze jsou lidksé zdroje, cílem této oblasti je vytvoření pohledů, které budou obsahovat jednotlivé informace o zaměstnancích,
#### 2.1.1 Základní kontaktní informace o zaměstnacích.
Pro vytvoření výpisu základních kontaktních informací o jednotlivých zaměstatnancích společnosti bylo nutné propojit tabulky:
- employee
- person
- personPhone
- PhoneNumberType
- EmailAddress

Tyto informace získáme pomocí scriptu:
```
CREATE VIEW view_person_contact_basic_info AS (
	SELECT
		emp.BusinessEntityID,
		p.Title,
		p.FirstName AS First_Name,
		p.MiddleName AS Middle_Name,
		p.LastName AS Last_Name,
		ph.PhoneNumber AS Phone_number,
		pht.Name AS Phone_Type,
		m.EmailAddress AS Mail_address
	FROM [AdventureWorks2022].[HumanResources].Employee emp
	LEFT JOIN [AdventureWorks2022].[Person].Person p 
		ON emp.BusinessEntityID = p.BusinessEntityID
	LEFT JOIN [AdventureWorks2022].[Person].PersonPhone ph
		ON emp.BusinessEntityID = ph.BusinessEntityID
	LEFT JOIN [AdventureWorks2022].[Person].PhoneNumberType pht
		ON ph.PhoneNumberTypeID = pht.PhoneNumberTypeID
	LEFT JOIN [AdventureWorks2022].[Person].EmailAddress m
		ON emp.BusinessEntityID = m.BusinessEntityID)
;

```
#### 2.1.2 Základní informace o pracovní pozici zaměstnanců, jejich zařezení do oddělení a zjištění manažerů oddělení

Pro vytvoření výpisu základních kontaktních informací o jednotlivých zaměstatnancích společnosti bylo nutné propojit tabulky:
- employee
- EmployeeDepartmentHistory
- Department
- Person

```
CREATE OR ALTER VIEW view_employee_job_basic_info AS (
	SELECT
		emp.BusinessEntityID,
		p.FirstName AS First_name,
		p.LastName AS Last_name,
		emp.JobTitle AS Job_title,
		d.Name AS Sub_department,
		d.GroupName AS Department,
		sh.Name,
		CASE 
			WHEN emp.JobTitle LIKE '%manager%' THEN 'Manager'
			ELSE 'Subordinate'
		END AS Head_of_dep
	FROM [AdventureWorks2022].[HumanResources].[Employee] emp
	LEFT JOIN [AdventureWorks2022].[Person].[Person] p
		ON emp.BusinessEntityID = p.BusinessEntityID
	LEFT JOIN  [AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory] dh
		ON emp.BusinessEntityID = dh.BusinessEntityID
	LEFT JOIN [AdventureWorks2022].[HumanResources].[Department] d
		ON dh.DepartmentID = d.DepartmentID
	LEFT JOIN  [AdventureWorks2022].[HumanResources].[Shift] sh
		ON dh.ShiftID = sh.ShiftID
	WHERE dh.EndDate IS NULL)
;
```
#### 2.1.3 Základní informace o datumu narození a datumu nástupu jednotlivých pracovníků
Pro vytvoření výpisu základních informací o datumu narození, datumu nástupu do práce  bylo nutné propojit tabulky:
- employee
- Person
  
Dále byly do tabulky přidány sloupce vypisující velká výročí jak z pohledu narozenin, tak z pohledu nástupu do pracá. Tyto výročí jsou vypisovány pro aktuální a následující kalendářní rok. Jako poslední byl přidán sloupec, který vytváří upozornění 7 dní před velkým výročím narozenin nebo nástupu do práce.

```
CREATE OR ALTER VIEW view_employee_hire_birth_date AS (
	SELECT
    e.NationalIDNumber,
    p.FirstName AS First_Name,
    p.LastName AS Last_Name,
    e.BirthDate AS Birth_date,
    e.HireDate AS Hire_date,
    CASE
        WHEN YEAR(GETDATE()) - YEAR(e.HireDate) IN (10, 20, 30, 40, 50, 60, 70) THEN CONCAT(YEAR(GETDATE()) - YEAR(e.HireDate), ' Anniversary')
        ELSE 'NO'
    END AS Hire_Anniversary_actual_year,
    CASE
        WHEN YEAR(GETDATE()) - YEAR(e.BirthDate) IN (10, 20, 30, 40, 50, 60, 70) THEN CONCAT(YEAR(GETDATE()) - YEAR(e.BirthDate), ' Anniversary')
        ELSE 'NO'
    END AS Birth_Anniversary_actual_year,
    CASE
        WHEN YEAR(GETDATE()) - YEAR(e.BirthDate) IN (10, 20, 30, 40, 50, 60, 70) AND MONTH(GETDATE()) = MONTH(e.BirthDate) AND DATEDIFF(DAY, DAY(e.BirthDate),DAY(GETDATE()))  = -7 THEN 'Seven days into birth anniversary'
        ELSE 'NO'
    END AS Birth_anniversary_alert,
	CASE
        WHEN YEAR(GETDATE()) - YEAR(e.HireDate) IN (10, 20, 30, 40, 50, 60, 70) AND MONTH(GETDATE()) = MONTH(e.HireDate) AND DATEDIFF(DAY, DAY(e.HireDate),DAY(GETDATE()))  = -7 THEN 'Seven days into hire anniversary'
        ELSE 'NO'
    END AS Hire_anniversary_alert,
	 CASE
        WHEN YEAR(GETDATE())+1 - YEAR(e.HireDate) IN (10, 20, 30, 40, 50, 60, 70) THEN CONCAT(YEAR(GETDATE())+1 - YEAR(e.HireDate), ' Anniversary')
        ELSE 'NO'
    END AS Hire_Anniversary_next_year,
    CASE
        WHEN YEAR(GETDATE())+1 - YEAR(e.BirthDate) IN (10, 20, 30, 40, 50, 60, 70) THEN CONCAT(YEAR(GETDATE())+1 - YEAR(e.BirthDate), ' Anniversary')
        ELSE 'NO'
    END AS Birth_Anniversary_next_year
	FROM [AdventureWorks2022].[HumanResources].[Employee] e 
	LEFT JOIN [AdventureWorks2022].[Person].[Person] p
	 ON e.BusinessEntityID = p.BusinessEntityID
)
;
```
#### 2.1.4 Základní informace o zbývajících hodinách dovolené, hodinách nemocnosti
Následující script vytváří přehled o zaměstnancích a jejich hodinách dovolené, hodinách nemocnosti a také dovolené převedené na dny včetně rozdělení zaměstnanců na skipunu, jenž má více jak 5 dní dovolené a na skupinu s méně jak 5 dny dovolené.
```
CREATE OR ALTER VIEW view_employee_hours_vacation_sick_info AS (
	SELECT
		p.FirstName AS First_Name,
		p.MiddleName AS Middle_Name,
		p.LastName AS Last_Name,
		emp. VacationHours,
		emp.SickLeaveHours,
		CASE
		WHEN (emp.VacationHours/7.5)>5 THEN 'More then 5 days Vacation'
			ELSE 'OK'
		END AS Vacation_transfer_next_year,
		ROUND(CAST(emp.VacationHours AS decimal(18,1))/8,2) AS Vacation_days
	FROM [AdventureWorks2022].[HumanResources].[Employee] emp
	
	LEFT JOIN [AdventureWorks2022].[Person].[Person] p
		ON emp.BusinessEntityID = p.BusinessEntityID)
;
```
### 2.2 Produkty a produkce
#### 2.2.1 Produktové info a zařazení do hierarchie

Pro vytvoření výpisu základního produktových  informací o jednotlivých produktech včetně jejich zařazení do hierarchie společnosti bylo nutné propojit tabulky:

- Product
- ProductSubcategory
- ProductModel
- ProductCategory
- ProductDescription

```
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
		d.Description AS Product_Description,
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
		ON s.ProductCategoryID = c.ProductCategoryID
	LEFT JOIN [AdventureWorks2022].[Production].[ProductDescription] d
		ON p.ProductID = d.ProductDescriptionID)
;
```
#### 2.2.2 Cenová historie produktů
Pro vytvoření výpisu základní cenové historie produktů bylo nutné propojit tabulky a pohledy:

- ProductListPriceHistory
- view_product_hierarchy_basic_info

```
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
```
#### 2.2.3 Změna cen v čase
Z pohledu pohledu o cenové historii [2.2.2 Cenová historie produktů](#222-cenová-historie-produktů) byly vytvořeny dva seelct příkazy pro zjištění změny ceny meziročně a také změny ceny během dou let.
>>**Tento script lze jednoduše změnit v případě, že by někdo požadoval zjsitit změny pro produktové kategorie nebo subkategorie**

```
WITH product_price_dev_1_year AS (
	SELECT
		Fiscal_year,
		ProductID,
		Product_Name,
		ROUND(AVG(ListPrice),2) AS AVG_price,
		ROUND(LAG((AVG(ListPrice)),1) OVER (PARTITION BY ProductID ORDER BY Fiscal_year),2) AS Previous_fiscal_year_1
	FROM [AdventureWorks2022].[dbo].[view_product_price_history] 
	GROUP BY Fiscal_year,ProductID,Product_Name
)
SELECT
	Fiscal_year,
	Product_Name,
	ProductID,
	ROUND((AVG_price-Previous_fiscal_year_1)/Previous_fiscal_year_1*100,2) as delta_1
FROM product_price_dev_1_year 
WHERE 1=1
	AND Previous_fiscal_year_1 IS NOT NULL
ORDER BY Fiscal_year DESC
;
```
```
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
```

### 2.2.4 Základní informace o výrobních zakázkách
Pohled obsahuje informace o výrobních zakázkách:

- Číslo zakázky
- Číslo produktu
- Název produktu
- Kategorie, sbukategorie produktu
- Důvod scrapu,
- Počet vyrobených kusů vyrobených
- Počet vyrobených kusů uskladněných
- Počet vyrobených kusů pro scrap
- Časová zpoždění nebo předstih zakázky
- Info o tom jestli je zakázka zpožděná
- Rok produkce
Pro vytvoření pohledu bylo nutné propojit tyto tabulky:

- WorkOrder
- ScrapReason
- Product
- ProductSubcategory
- ProductCategory
```
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
```
#### 2.2.5 Scrap a náklady plynoucí ze scrapu dle různých pohledů
Dva nížd uvedené scripty slouží k zjišťování scrapu v nákladů na scrap dle různých kriterí v jednotlivých letech

Prvně bylo nutné se vytvořit pohled, který sesumarizuje náklady na jednotlivé výrobní zakárky.
```
CREATE OR ALTER VIEW view_production_orders_cost AS (
	SELECT
		WorkOrderID,
		SUM(ActualCost) AS Oder_cost
	FROM [AdventureWorks2022].[Production].[WorkOrderRouting]
	GROUP BY WorkOrderID
)
;
```

Poté je tento pohled propojen s již existujícím pohledem [Základní informace o výrobních zakázkách](#224-základní-informace-o-výrobních-zakázkách) za vyuřití pomocné tabulky. Následný script zobrazuje %scrap pro jednotlivé kategori produktu seskupený podle let. Také jsou zde uvedeny náklady na scrap.

```
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
	Category_Name,
	SUM(Scrap_Qty),
	SUM(Order_Qty),
	ROUND(SUM(Scrap_Qty)*1.0 / SUM(Order_Qty) * 100,2) AS Reason_scrap_,
	SUM(Oder_cost / Order_Qty * Scrap_Qty) AS Reason_scrap_cost
FROM order_cost_table
GROUP BY Production_year,Category_Name
ORDER BY Production_year ASC
```

Analogicky pro důvod scrapu.
```
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
```
>>**Lze využít pro jakýkoliv sloupec, který je uveden v pomocné tabulce (produkt, subkategorie etc.)**
### 2.3 Nákup
#### 2.3.1 Sloučení nákupních informací
V následujícím pohledu jsou sloučeny všechny nákupní informace z tabulek a pohledů:

- PurchaseOrderHeader
- Vendor
- ShipMethod
- PurchaseOrderDetail
- view_product_hierarchy_basic_info
- Person

```
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
		DAY((pod.DueDate)-(OrderDate)) AS Order_Due_day_diff,
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
```
#### 2.3.2 Průměrný leadtime podle dodavatele a jeho vývoj v letech
Tento select scrip zobrazí průměrý leadtime každého dodavatele v jednotlivých letech.
>>**Analogicky lze změnit na produkt, produktovou kategoii, subkategorii, způsob dodání atd.**

```
SELECT
	due_year AS Fiscal_year,
	VendorID,
	Vendor_Name,
	AVG(Order_Due_day_diff) AS AVG_lead_time
FROM  [AdventureWorks2022].[dbo].[view_purchasing_orders_all_data]
GROUP BY VendorID,Vendor_Name,due_year
ORDER BY VendorID,Vendor_Name,due_year;
```
#### 2.3.3 Náklady na jednotlivé typy dopravy a jejich podíl v celkových nákladech
Tento select scrip zobrazí sumu nákladů na jednotlivé typy doprav v jednotlivých letech a následně vypočítá jejich % podíl k celkovým nákladům
```
SELECT
	due_year AS Fiscal_year,
	Ship_method_Name,
	ROUND(SUM(Freight),2) AS Total_freight_cost,
	ROUND(SUM(TotalDue),2) AS Total_order_cost,
	ROUND((SUM(Freight) / SUM(TotalDue) * 100),2) AS Share_of_freight
FROM [AdventureWorks2022].[dbo].[view_purchasing_orders_all_data]
GROUP BY Ship_method_Name, due_year
ORDER BY Ship_method_Name, due_year
```
#### 2.3.4 Rozdíl mezi dodaným a objednamým množstvím. Počet odmítnuhé množství zboží.
Tento select scrip zobrazí sumu rozdílů mezi objedaným nnožstvím a dodaným množstvím podle jednotlivých dodavatelů a sledovaných let. Dále je zde poznámka jestli došlo k navýšení, snížení tohoto rozdílu oproti minulému roku. Dále je zde uveden průmer tohoto rozdílu.
>>**Ten samý výpočet je použit i pro odmítnuté množství zboží.**

```
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
```

### 2.4 Prodej
#### 2.4.1 Sloučení prodejních informací
V následujícím pohledu jsou sloučeny všechny informace o prodejích. Zároveň bylo nutné získat měny k jednotlivým prodejům, protože ne vždy byly data vyplněny.
- SalesOrderHeader
- SalesTerritory
- CountryRegionCurrency
- ShipMethod
- CurrencyRate

Dále bylo nutné odfiltrovat měny u států, které měly více jak jednu měnu. Vždy byla vynechána ta jiná měna, než se nyní používá v daném státě.
```
CREATE OR ALTER VIEW view_sales_all_data_info AS (
SELECT
	soh.SalesOrderID,
	YEAR(soh.DueDate) as Sales_year,
	soh.CustomerID,
	soh.SalesPersonID,
	soh.TerritoryID,
	st.Name AS Territory,
	st.[Group] AS Territory_group,
	st.CountryRegionCode,
	cc.CurrencyCode,
	soh.ShipMethodID,
	sm.Name AS Ship_Method,
	soh.SubTotal,
	soh.TaxAmt,
	soh.Freight,
	soh.TotalDue,
	cr.AverageRate
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] soh
LEFT JOIN [AdventureWorks2022].[Sales].[SalesTerritory] st
	ON soh.TerritoryID = st.TerritoryID
INNER JOIN [AdventureWorks2022].[Sales].[CountryRegionCurrency] cc
	ON st.CountryRegionCode = cc.CountryRegionCode
LEFT JOIN [AdventureWorks2022].[Purchasing].[ShipMethod] sm
	ON soh.ShipMethodID = sm.ShipMethodID
LEFT JOIN [AdventureWorks2022].[Sales].[CurrencyRate] cr
	ON  cc.CurrencyCode = cr.ToCurrencyCode
	AND soh.DueDate = cr.CurrencyRateDate
WHERE cc.CurrencyCode NOT IN ('DEM', 'ESP', 'FIM', 'FRF', 'GRD', 'IEP', 'ITL', 'NLG', 'PTE'))
;
```
#### 2.4.2 Prodeje v jednotlivých oblastech a jejich časový vývoj
Následující select scrip zobrazuje jednotlivé oblasti a jejich prodeje včetně poznámky o meziroční změně jak slovně, tak číselně.


```
SELECT
	Sales_year,
	Territory_group,
	ROUND(SUM(TotalDue/AverageRate),2) AS Sales_total_USD,
	LAG(ROUND(SUM(TotalDue/AverageRate),2)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) AS Sales_total_USD_previous,
	CASE
		WHEN ROUND(SUM(TotalDue/AverageRate),2) / LAG(ROUND(SUM(TotalDue/AverageRate),2)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) > 1 THEN 'Increase'
		WHEN ROUND(SUM(TotalDue/AverageRate),2) / LAG(ROUND(SUM(TotalDue/AverageRate),2)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) < 1 THEN 'Decrease'
		ELSE 'No change'
	END AS Sales_change_one_year,
	(SUM(TotalDue/AverageRate)-LAG(SUM(TotalDue/AverageRate)) OVER (PARTITION BY Territory_group ORDER BY Sales_year)) / LAG(SUM(TotalDue/AverageRate)) OVER (PARTITION BY Territory_group ORDER BY Sales_year) * 100 AS Percent_change
FROM [AdventureWorks2022].[dbo].[view_sales_all_data_info]
GROUP BY Sales_year, Territory_group
ORDER BY Territory_group,Sales_year
```

>>**Tento script lze jednodušše obměnit na jednotlivé 'Territory_group', 'CustomerID' nebo také jen na prodeje za daný rok**

#### 2.4.2 Podíl přijmů z dopravy na celkových prodejích 

Následující select scrip zobrazuje přijmy z dopravy a podílů těchto příijmů na celkových prodejích.

```
SELECT
	Sales_year,
	Ship_Method,
	ROUND(SUM(TotalDue/AverageRate),2) AS Sales_total,
	ROUND(SUM(Freight/AverageRate),2) AS Freight_total,
	ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100 AS Share_Of_freight,
	LAG(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100) OVER (PARTITION BY Ship_Method ORDER BY Sales_year) AS Previous_share,
	(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100 - LAG(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100) OVER (PARTITION BY Ship_Method ORDER BY Sales_year)) / (LAG(ROUND(SUM(Freight/AverageRate),2) / ROUND(SUM(TotalDue/AverageRate),2) * 100) OVER (PARTITION BY Ship_Method ORDER BY Sales_year)) * 100 AS Year_change
FROM [AdventureWorks2022].[dbo].[view_sales_all_data_info]
GROUP BY Sales_year, Ship_Method
ORDER BY Ship_Method, Sales_year
```

#### 2.4.3 Top 5 produktů v každém roce podle prodejů

Následující select scrip zobrazuje TOP 5 produktů v každém roce podle prodejů.

```

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
```