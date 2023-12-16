# Adveture Works projekt

- *SQL*
- *PoweBI*
- *DISCORD*: "ondrej_zapletal"
---


- # Obsah
	- [1. Zdroj dat](#1-zdroj-dat)
    	- [1.1 Popis](#11-popis)
    	- [1.2 Popis](#12-zdroj-dat)
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

Cenová historie produktů
## 1. Úvod
### 1.1 Popis
Cílem tohoto projektu je zanalyzovat veřejně dostupnou databázi pomocí SQL v programu SQL Server Management Studio a také provést vizualizaci dat v programu PowerBi.
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
Tyto příkazy lze jednoduše změnit v případě, že by někdo požadoval zjsitit změny pro produktové kategorie nebo subkategorie

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

Poté je tento pohled propojen s již existujícím pohledem [Základní informace o výrobních zakázkách](#224-základní-informace-o-výrobních-zakázkách) za vyuřití pomocné tabulky. Následný script zobrazuje %scrap pro jednotlivé kaategori produktu seskupený podle let. Také jsou zde uvedeny náklady na scrap.

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
Lze využít pro jakýkoliv sloupec, který je uveden v pomocné tabulce (produkt, subkategorie etc.)