CREATE OR ALTER VIEW view_person_contact_basic_info AS (
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