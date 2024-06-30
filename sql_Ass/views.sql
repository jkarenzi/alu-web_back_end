-- 1
CREATE VIEW ClientContact AS
SELECT ClientName, ContactName, ContactEmail 
FROM Clients;

-- 2
CREATE VIEW OngoingProjects AS
SELECT * 
FROM Projects 
WHERE Deadline >= CURDATE();

-- 3
CREATE VIEW ProjectTeamLead AS
SELECT p.ProjectName, e.EmployeeName AS TeamLead 
FROM Projects p
JOIN ProjectTeam pt ON p.ProjectID = pt.ProjectID AND pt.IsTeamLead = 1
JOIN Employees e ON pt.EmployeeID = e.EmployeeID;

-- 4
CREATE VIEW November2024Projects AS
SELECT p.ProjectName, c.ClientName, c.ContactName, c.ContactEmail 
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID
WHERE p.Deadline BETWEEN '2024-11-01' AND '2024-11-30';

-- 5
CREATE VIEW EmployeeProjectCount AS
SELECT e.EmployeeName, COUNT(pt.ProjectID) AS ProjectCount 
FROM Employees e
JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID
GROUP BY e.EmployeeName;
