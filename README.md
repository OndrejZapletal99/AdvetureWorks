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
	WHERE dh.EndDate IS NULL)
    ;
```