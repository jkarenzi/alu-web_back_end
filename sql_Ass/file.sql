-- Create Database
CREATE DATABASE IF NOT EXISTS SoftwareProjectCompany;
USE SoftwareProjectCompany;

-- Create Clients Table
CREATE TABLE Clients (
    ClientID INT AUTO_INCREMENT PRIMARY KEY,
    ClientName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    ContactEmail VARCHAR(100) UNIQUE
);

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL
);

-- Create Projects Table
CREATE TABLE Projects (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Requirements TEXT,
    Deadline DATE,
    ClientID INT,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE SET NULL
);

-- Create Team Members Table
CREATE TABLE TeamMembers (
    TeamMemberID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT,
    EmployeeID INT,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);

-- Create Project Team Table
CREATE TABLE ProjectTeam (
    ProjectTeamID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT,
    EmployeeID INT,
    IsTeamLead BOOLEAN,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);

-- Populate Clients Table
INSERT INTO Clients (ClientName, ContactName, ContactEmail) VALUES
('Big Retail Inc.', 'Peter Parker', 'peter.parker@example.com'),
('EduTech Solutions', 'Walter White', 'walter.white@example.com'),
('Trendsetters Inc.', 'Sandra Bullock', 'sandra.bullock@example.com'),
('Gearhead Supply Co.', 'Daniel Craig', 'daniel.craig@example.com'),
('Fine Dine Group', 'Olivia Rodriguez', 'olivia.rodriguez@example.com'),
('Green Thumb Gardens', 'Mark Robinson', 'mark.robinson@example.com'),
('Busy Bees Daycare', 'Emily Blunt', 'emily.blunt@example.com'),
('Acme Pharmaceuticals', 'David Kim', 'david.kim@example.com'),
('Knowledge Stream Inc.', 'Matthew McConaughey', 'matthew.mcconaughey@example.com'),
('Software Craft LLC', 'Jennifer Lopez', 'jennifer.lopez@example.com');

-- Populate Employees Table
INSERT INTO Employees (EmployeeName) VALUES
('Alice Brown'),
('David Lee'),
('Jane Doe'),
('Michael Young'),
('Emily Chen'),
('William Green'),
('Sarah Jones');

-- Populate Projects Table
INSERT INTO Projects (ProjectName, Requirements, Deadline, ClientID) VALUES
('E-commerce Platform', 'Extensive documentation', '2024-12-01', 1),
('Mobile App for Learning', 'Gamified learning modules', '2024-08-15', 2),
('Social Media Management Tool', 'User-friendly interface with analytics', '2024-10-31', 3),
('Inventory Management System', 'Barcode integration and real-time stock tracking', '2024-11-01', 4),
('Restaurant Reservation System', 'Online booking with table management', '2024-09-01', 5),
('Content Management System (CMS)', 'Drag-and-drop interface for easy content updates', '2024-12-15', 6),
('Customer Relationship Management (CRM)', 'Secure parent portal and communication tools', '2024-10-01', 7),
('Data Analytics Dashboard', 'Real-time visualization of key performance indicators (KPIs)', '2024-11-30', 8),
('E-learning Platform Development', 'Interactive course creation and delivery tools', '2024-09-15', 9),
('Bug Tracking and Issue Management System', 'Prioritization and collaboration features for bug reporting', '2024-12-31', 10);

-- Populate Project Team Table
INSERT INTO ProjectTeam (ProjectID, EmployeeID, IsTeamLead) VALUES
(1, 1, 0), (1, 2, 1), (1, 3, 0),
(2, 2, 1), (2, 4, 0), (2, 5, 0),
(3, 1, 0), (3, 3, 0), (3, 6, 1),
(4, 2, 1), (4, 4, 0), (4, 5, 0),
(5, 1, 0), (5, 6, 0), (5, 7, 1),
(6, 2, 1), (6, 3, 0), (6, 4, 0),
(7, 1, 0), (7, 6, 0), (7, 7, 1),
(8, 2, 1), (8, 4, 0), (8, 5, 0),
(9, 1, 0), (9, 3, 0), (9, 6, 1),
(10, 2, 1), (10, 4, 0), (10, 7, 0);

-- Queries

-- Find all projects with a deadline before December 1st, 2024
SELECT * FROM Projects WHERE Deadline < '2024-12-01';

-- List all projects for "Big Retail Inc." ordered by deadline
SELECT p.ProjectName, p.Requirements, p.Deadline 
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID
WHERE c.ClientName = 'Big Retail Inc.'
ORDER BY p.Deadline;

-- Find the team lead for the "Mobile App for Learning" project
SELECT e.EmployeeName 
FROM Employees e
JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID
JOIN Projects p ON pt.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Mobile App for Learning' AND pt.IsTeamLead = 1;

-- Find projects containing "Management" in the name
SELECT * FROM Projects WHERE ProjectName LIKE '%Management%';

-- Count the number of projects assigned to David Lee
SELECT COUNT(*) AS ProjectCount 
FROM ProjectTeam pt
JOIN Employees e ON pt.EmployeeID = e.EmployeeID
WHERE e.EmployeeName = 'David Lee';

-- Find the total number of employees working on each project
SELECT p.ProjectName, COUNT(pt.EmployeeID) AS EmployeeCount 
FROM Projects p
JOIN ProjectTeam pt ON p.ProjectID = pt.ProjectID
GROUP BY p.ProjectName;

-- Find all clients with projects having a deadline after October 31st, 2024
SELECT DISTINCT c.ClientName 
FROM Clients c
JOIN Projects p ON c.ClientID = p.ClientID
WHERE p.Deadline > '2024-10-31';

-- List employees who are not currently team leads on any project
SELECT e.EmployeeName 
FROM Employees e
LEFT JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID AND pt.IsTeamLead = 1
WHERE pt.IsTeamLead IS NULL;

-- Combine a list of projects with deadlines before December 1st and another list with "Management" in the project name
SELECT * FROM Projects 
WHERE Deadline < '2024-12-01'
UNION
SELECT * FROM Projects 
WHERE ProjectName LIKE '%Management%';

-- Display a message indicating if a project is overdue (deadline passed)
SELECT ProjectName, 
    CASE 
        WHEN Deadline < CURDATE() THEN 'Overdue'
        ELSE 'Not overdue'
    END AS Status
FROM Projects;

-- Views

-- Create a view to simplify retrieving client contact
CREATE VIEW ClientContact AS
SELECT ClientName, ContactName, ContactEmail 
FROM Clients;

-- Create a view to show only ongoing projects (not yet completed)
CREATE VIEW OngoingProjects AS
SELECT * 
FROM Projects 
WHERE Deadline >= CURDATE();

-- Create a view to display project information along with assigned team leads
CREATE VIEW ProjectTeamLead AS
SELECT p.ProjectName, e.EmployeeName AS TeamLead 
FROM Projects p
JOIN ProjectTeam pt ON p.ProjectID = pt.ProjectID AND pt.IsTeamLead = 1
JOIN Employees e ON pt.EmployeeID = e.EmployeeID;

-- Create a view to show project names and client contact information for projects with a deadline in November 2024
CREATE VIEW November2024Projects AS
SELECT p.ProjectName, c.ClientName, c.ContactName, c.ContactEmail 
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID
WHERE p.Deadline BETWEEN '2024-11-01' AND '2024-11-30';

-- Create a view to display the total number of projects assigned to each employee
CREATE VIEW EmployeeProjectCount AS
SELECT e.EmployeeName, COUNT(pt.ProjectID) AS ProjectCount 
FROM Employees e
JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID
GROUP BY e.EmployeeName;

-- Functions

-- Create a function to calculate the number of days remaining until a project deadline
CREATE FUNCTION DaysUntilDeadline (pID INT) RETURNS INT
BEGIN
    DECLARE daysRemaining INT;
    SELECT DATEDIFF(Deadline, CURDATE()) INTO daysRemaining 
    FROM Projects 
    WHERE ProjectID = pID;
    RETURN daysRemaining;
END;

-- Create a function to calculate the number of days a project is overdue
CREATE FUNCTION DaysOverdue (pID INT) RETURNS INT
BEGIN
    DECLARE daysOverdue INT;
    SELECT DATEDIFF(CURDATE(), Deadline) INTO daysOverdue 
    FROM Projects 
    WHERE ProjectID = pID AND Deadline < CURDATE();
    RETURN daysOverdue;
END;

-- Procedures

-- Create a stored procedure to add a new client and their first project in one call
CREATE PROCEDURE AddClientAndProject (
    IN cName VARCHAR(100), IN contactName VARCHAR(100), IN contactEmail VARCHAR(100),
    IN pName VARCHAR(100), IN requirements TEXT, IN deadline DATE
)
BEGIN
    DECLARE newClientID INT;
    INSERT INTO Clients (ClientName, ContactName, ContactEmail) 
    VALUES (cName, contactName, contactEmail);
    SET newClientID = LAST_INSERT_ID();
    INSERT INTO Projects (ProjectName, Requirements, Deadline, ClientID) 
    VALUES (pName, requirements, deadline, newClientID);
END;

-- Create a stored procedure to move completed projects (past deadlines) to an archive table
CREATE PROCEDURE ArchiveCompletedProjects ()
BEGIN
    CREATE TABLE IF NOT EXISTS ArchivedProjects LIKE Projects;
    INSERT INTO ArchivedProjects SELECT * FROM Projects WHERE Deadline < CURDATE();
    DELETE FROM Projects WHERE Deadline < CURDATE();
END;

-- Triggers

-- Create a trigger to log any updates made to project records in a separate table for auditing purposes
CREATE TABLE ProjectLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT,
    ChangeType VARCHAR(10),
    ChangeTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogProjectUpdates
AFTER UPDATE ON Projects
FOR EACH ROW
BEGIN
    INSERT INTO ProjectLog (ProjectID, ChangeType) VALUES (OLD.ProjectID, 'UPDATE');
END;

-- Create a trigger to ensure a team lead assigned to a project is a valid employee
CREATE TRIGGER ValidateTeamLead
BEFORE INSERT ON ProjectTeam
FOR EACH ROW
BEGIN
    IF NEW.IsTeamLead = 1 THEN
        IF (SELECT COUNT(*) FROM Employees WHERE EmployeeID = NEW.EmployeeID) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid team lead ID';
        END IF;
    END IF;
END;

-- Create a view to display project details along with the total number of team members assigned
CREATE VIEW ProjectDetailsWithTeamSize AS
SELECT p.ProjectName, COUNT(pt.EmployeeID) AS TeamSize 
FROM Projects p
JOIN ProjectTeam pt ON p.ProjectID = pt.ProjectID
GROUP BY p.ProjectName;

-- Create a view to show overdue projects with the number of days overdue
CREATE VIEW OverdueProjects AS
SELECT p.ProjectName, DATEDIFF(CURDATE(), p.Deadline) AS DaysOverdue 
FROM Projects p
WHERE p.Deadline < CURDATE();

-- Create a stored procedure to update project team members (remove existing, add new ones)
CREATE PROCEDURE UpdateProjectTeam (
    IN pID INT, IN newTeamMembers JSON
)
BEGIN
    DECLARE teamMemberID INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT JSON_UNQUOTE(JSON_EXTRACT(newTeamMembers, CONCAT('$[', n, '].EmployeeID'))) 
        FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DELETE FROM ProjectTeam WHERE ProjectID = pID AND IsTeamLead = 0;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO teamMemberID;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO ProjectTeam (ProjectID, EmployeeID, IsTeamLead) VALUES (pID, teamMemberID, 0);
    END LOOP;
    CLOSE cur;
END;

-- Create a trigger to prevent deleting a project that still has assigned team members
CREATE TRIGGER PreventProjectDeletion
BEFORE DELETE ON Projects
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM ProjectTeam WHERE ProjectID = OLD.ProjectID) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete a project with assigned team members';
    END IF;
END;



