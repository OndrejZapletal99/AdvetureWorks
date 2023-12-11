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