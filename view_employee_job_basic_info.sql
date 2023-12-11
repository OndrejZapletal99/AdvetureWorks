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