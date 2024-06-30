CREATE FUNCTION DaysUntilDeadline (pID INT) RETURNS INT
BEGIN
    DECLARE daysRemaining INT;
    SELECT DATEDIFF(Deadline, CURDATE()) INTO daysRemaining 
    FROM Projects 
    WHERE ProjectID = pID;
    RETURN daysRemaining;
END;


CREATE FUNCTION DaysOverdue (pID INT) RETURNS INT
BEGIN
    DECLARE daysOverdue INT;
    SELECT DATEDIFF(CURDATE(), Deadline) INTO daysOverdue 
    FROM Projects 
    WHERE ProjectID = pID AND Deadline < CURDATE();
    RETURN daysOverdue;
END;
