SELECT E.employeeid, E.FirstName, E.LastName, E.Position, T.taskName, ET.ifLeader
        FROM Employees E
        JOIN EmployeeTask ET ON ET.employeeId = E.employeeId
        JOIN Tasks T ON ET.taskId = T.taskId;

SELECT * FROM Employees;

SELECT table_name FROM information_schema.tables;