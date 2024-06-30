-- 1
SELECT * FROM Projects WHERE Deadline < '2024-12-01';

-- 2
SELECT p.ProjectName, p.Requirements, p.Deadline 
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID
WHERE c.ClientName = 'Big Retail Inc.'
ORDER BY p.Deadline;

-- 3
SELECT e.EmployeeName 
FROM Employees e
JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID
JOIN Projects p ON pt.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Mobile App for Learning' AND pt.IsTeamLead = 1;

-- 4
SELECT * FROM Projects WHERE ProjectName LIKE '%Management%';

-- 5
SELECT COUNT(*) AS ProjectCount 
FROM ProjectTeam pt
JOIN Employees e ON pt.EmployeeID = e.EmployeeID
WHERE e.EmployeeName = 'David Lee';

-- 6
SELECT p.ProjectName, COUNT(pt.EmployeeID) AS EmployeeCount 
FROM Projects p
JOIN ProjectTeam pt ON p.ProjectID = pt.ProjectID
GROUP BY p.ProjectName;

-- 7
SELECT DISTINCT c.ClientName 
FROM Clients c
JOIN Projects p ON c.ClientID = p.ClientID
WHERE p.Deadline > '2024-10-31';

-- 8
SELECT e.EmployeeName 
FROM Employees e
LEFT JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID AND pt.IsTeamLead = 1
WHERE pt.IsTeamLead IS NULL;

-- 9
SELECT * FROM Projects 
WHERE Deadline < '2024-12-01'
UNION
SELECT * FROM Projects 
WHERE ProjectName LIKE '%Management%';

-- 10
SELECT ProjectName, 
    CASE 
        WHEN Deadline < CURDATE() THEN 'Overdue'
        ELSE 'Not overdue'
    END AS Status
FROM Projects;
