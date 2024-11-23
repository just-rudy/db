-- Скалярная функция, получить имя и фамилию работника по его EmployeeID

CREATE OR REPLACE FUNCTION get_full_name(employee_id INT)
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT firstName || ' ' || lastName
        FROM Employees
        WHERE employeeId = employee_id
    );
END;
$$ LANGUAGE plpgsql;

SELECT get_full_name(3034);
-- Подставляемая табличная функция
CREATE OR REPLACE FUNCTION get_equipment_by_base(base_id INT)
RETURNS TABLE (
    equipmentID INT,
    type TEXT,
    manufacturer TEXT,
    cntAll INT,
    cntInUse INT
) AS $$
BEGIN
    -- Промежуточная проверка, чтобы убедиться, что база существует
    IF NOT EXISTS (SELECT 1 FROM Bases WHERE baseId = base_id) THEN
        RAISE EXCEPTION 'Base with ID % does not exist', base_id;
    end if;

    RETURN QUERY
    SELECT e.equipmentId, e.type, e.manufacturer, e.cntAll, e.cntInUse
    from Equipment e
    WHERE baseid = base_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_equipment_by_base(3001);

DROP FUNCTION get_tasks_with_duration_hours(base_id int);

-- Многооператорная табличная функция
CREATE OR REPLACE FUNCTION get_tasks_with_duration_hours(base_id int)
RETURNS TABLE (
    taskId INT,
    taskName TEXT,
    dateStart DATE,
    durHours INT
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Bases WHERE baseid = base_id) THEN
        RAISE EXCEPTION 'Base with ID % does not exist', base_id;
    end if;
    RETURN QUERY
    SELECT t.taskId, t.taskName, t.dateStart, t.duration * 24 as durHours
    FROM Tasks t
    WHERE baseId = base_id;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_tasks_with_duration_hours(3007);

-- TODO: Рекурсивная функция

CREATE OR REPLACE FUNCTION get_employee_hierarchy(employee_id INT)
RETURNS TABLE (
    employeeId INT,
    firstName TEXT,
    lastName TEXT,
    phoneNumber TEXT,
    position TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE employee_cte AS (
        -- Начальный уровень: текущий сотрудник
        SELECT e.employeeId, e.firstName, e.lastName, e.phoneNumber, e.position
        FROM Employees e
        WHERE e.employeeId = employee_id

        UNION ALL

        -- Рекурсивная часть: ищем подчиненных
        SELECT e.employeeId, e.firstName, e.lastName, e.phoneNumber, e.position
        FROM Employees e
        INNER JOIN employee_cte cte
        ON (
            (cte.position = 'TechSenior' AND e.position IN ('TechJunior', 'NotTech')) OR
            (cte.position = 'TechJunior' AND e.position = 'NotTech')
        )
    )
    SELECT * FROM employee_cte;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_employee_hierarchy(3001);
