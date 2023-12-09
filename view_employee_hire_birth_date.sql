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


