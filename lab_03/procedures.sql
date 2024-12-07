-- 1. Хранимую процедуру без параметров или с параметрами
-- с параметрами, добавляет нового employee

CREATE OR REPLACE FUNCTION add_employee(
    first_name TEXT,
    last_name TEXT,
    study_group TEXT,
    phone_number TEXT,
    pos TEXT
)
    RETURNS VOID AS
$$
BEGIN
    INSERT INTO employees (firstName, lastName, studyGroup, phoneNumber, position)
    VALUES (first_name, last_name, study_group, phone_number, pos);
END;
$$ LANGUAGE plpgsql;

SELECT add_employee('Егор', 'Егор', 'РК4', '+79162225533', 'TechJunior');

-- 2. Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ

CREATE OR REPLACE FUNCTION get_employees_by_task(task_id INT)
    RETURNS TABLE
            (
                employeeId INT,
                firstName  TEXT,
                lastName   TEXT,
                "position"   TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        WITH RECURSIVE EmployeeHierarchy AS (
            -- Базовый случай: выбираем лидера задачи
            SELECT E.employeeId, E.firstName, E.lastName, E."position"
            FROM Employees E
                     JOIN EmployeeTask ET ON E.employeeId = ET.employeeId
            WHERE ET.taskId = task_id
              AND ET.ifLeader = TRUE

            UNION ALL

            -- Рекурсивный случай: выбираем подчиненных сотрудников
            SELECT E.employeeId, E.firstName, E.lastName, E."position"
            FROM Employees E
                     JOIN EmployeeTask ET ON E.employeeId = ET.employeeId
                     JOIN EmployeeHierarchy EH ON ET.employeeId = EH.employeeId
            WHERE (EH."position" = 'TechSenior')
               OR -- TechSenior может управлять всеми
                (EH."position" = 'TechJunior' AND E."position" = 'NotTech') -- TechJunior может управлять только NotTech
        )
        SELECT EH.employeeId, EH.firstName, EH.lastName, EH."position"
        FROM EmployeeHierarchy EH;
END;
$$ LANGUAGE plpgsql;


SELECT *
FROM get_employees_by_task(1);

-- 3. Хранимую процедуру с курсором
CREATE OR REPLACE FUNCTION process_employees_by_status(status TEXT)
    RETURNS VOID AS
$$
DECLARE
    emp RECORD;
    cur CURSOR FOR SELECT firstName, lastName
                   FROM employees
                   WHERE position = status;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO emp;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Employee: %, %', emp.firstName, emp.lastName;
    END LOOP;
    CLOSE cur;
END;
$$ language plpgsql;

-- Вызов процедуры для обработки сотрудников с должностью 'TechSenior'
SELECT process_employees_by_status('TechSenior');

-- 4. Хранимую процедуру доступа к метаданным
CREATE OR REPLACE FUNCTION list_all_tables()
    RETURNS TABLE
            (
                table_name TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT t.table_name::text
        FROM information_schema.tables as t
        WHERE t.table_schema = 'public';
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM list_all_tables();

SELECT * FROM employees;

-- хранимая процедура, которая добавляет каждой таксе без employee первого employee без таски

CREATE OR REPLACE FUNCTION assign_employee()
RETURNS VOID AS $$
DECLARE
    task RECORD;
    employee RECORD;
BEGIN
    FOR task IN
        SELECT t.taskid
        FROM Tasks t
        LEFT JOIN EmployeeTask et on t.taskid = et.taskid
        WHERE et.taskid IS NULL
    LOOP
        SELECT e.employeeid, e.firstname, e.lastname
        INTO employee
        FROM Employees e
        LEFT JOIN EmployeeTask et on e.employeeid = et.employeeid
        WHERE et.taskId IS NULL
        LIMIT 1;

        IF FOUND THEN
            INSERT INTO employeetask (ifLeader, employeeid, taskid)
            VALUES (FALSE, employee.employeeid, task.taskid);
        end if;
    end loop;
end;
$$ LANGUAGE plpgsql;

SELECT assign_employee();

INSERT INTO Tasks (taskName, dateStart, duration, baseId) VALUES
('Задача 1', '2023-10-01', 5, 1),
('Задача 2', '2023-10-02', 3, 1),
('Задача 3', '2023-10-03', 7, 1),
('Задача 4', '2023-10-04', 2, 1);

INSERT INTO Employees (firstName, lastName, studyGroup, phoneNumber, position) VALUES
('Иван', 'Иванов', 'ИУ7-54Б', '1234567890', 'TechJunior'),
('Петр', 'Петров', 'ИУ7-54Б', '0987654321', 'TechJunior'),
('Светлана', 'Сидорова', 'ИУ7-54Б', '1122334455', 'TechJunior'),
('Анна', 'Кузнецова', 'ИУ7-54Б', '5566778899', 'TechJunior');

SELECT * FROM EmployeeTask;

SELECT * FROM Tasks;

