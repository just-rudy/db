CREATE EXTENSION IF NOT EXISTS plpython3u;

-- TODO: Определяемую пользователем скалярную функцию CLR,
CREATE OR REPLACE FUNCTION get_full_name(first_name TEXT, last_name TEXT)
    RETURNS TEXT AS
$$
    return first_name + ' ' + last_name
$$ LANGUAGE plpython3u;

SELECT get_full_name('Dean', 'Winchester') as full_name;


-- TODO: Пользовательскую агрегатную функцию CLR,

CREATE AGGREGATE sum_equipment_usage (INT) (
    SFUNC = sum,
    STYPE = INT,
    INITCOND = '0'
    );

CREATE OR REPLACE FUNCTION sum(a INT, b INT) RETURNS INT AS
$$
    return a + b
$$ LANGUAGE plpython3u;


SELECT sum_equipment_usage(cntUsed)
FROM EquipmentTask;

SELECT *
from equipmenttask;

-- TODO: Определяемую пользователем табличную функцию CLR,

SELECT e.firstname, e.lastname
FROM Employees e
         LEFT JOIN employeetask et
                   ON e.employeeid = et.employeeid
WHERE et.taskid IS NULL;

SELECT *
FROM employeetask;

SELECT *
FROM employees;

DROP FUNCTION IF EXISTS get_employees_without_task;

CREATE OR REPLACE FUNCTION get_employees_without_task()
    RETURNS TABLE
            (
                employeeid INT,
                firstName  TEXT,
                lastname   TEXT,
                "position" TEXT
            )
AS
$$
    query = plpy.execute('''
    SELECT e.employeeid, e.firstName, e.lastname, e.position
    FROM Employees e
    LEFT JOIN employeetask et
    ON e.employeeid = et.employeeid
    WHERE et.taskid IS NULL
    ORDER BY
        CASE e.position
            WHEN 'TechSenior' THEN 1
            WHEN 'TechJunior' THEN 2
            WHEN 'NotTech' THEN 3
            ELSE 4
        END;
    ''')
    return query
$$ LANGUAGE plpython3u;

SELECT *
FROM get_employees_without_task();


-- TODO: Хранимую процедуру CLR,

SELECT t.taskId, t.taskName
FROM Tasks t
         LEFT JOIN employeetask et ON t.taskid = et.taskid
WHERE et.employeeid IS NULL
   OR et.ifleader = false;

CREATE OR REPLACE FUNCTION get_tasks_without_leader()
    RETURNS TABLE
            (
                taskId   INT,
                taskName TEXT
            )
AS
$$
    # import plpy

    result = plpy.execute("""
        SELECT t.taskid, t.taskname, et.employeeid, et.ifleader
        FROM Tasks t
        LEFT JOIN employeetask et ON t.taskid = et.taskid
    """)

    tasks_without_leader = []

    for row in result:
        if row['employeeid'] is None or (row['ifleader'] is not None and not row['ifleader']):
            tasks_without_leader.append((row['taskid'], row['taskname']))

    return tasks_without_leader
$$ LANGUAGE plpython3u;


SELECT *
FROM get_tasks_without_leader();

SELECT *
FROM bases;

CALL update_base_contact(1, '1-234-567-89-00');


-- TODO: Триггер CLR,

-- Drop the trigger if it exists
DROP TRIGGER IF EXISTS equipment_changes_trigger ON Equipment;

-- Create or replace the trigger function
CREATE OR REPLACE FUNCTION log_equipment_changes() RETURNS TRIGGER AS
$$
    import plpy

    # Fetch the trigger operation type
    tg_op = TD["event"]

    # Determine the equipment ID based on the operation type
    if tg_op == 'DELETE':
        equipment_id = TD["old"]["equipmentid"]
    else:
        equipment_id = TD["new"]["equipmentid"]

    # Construct the log message
    log_message = f"Action: {tg_op}, Equipment ID: {equipment_id}"

    # Execute the insert statement
    query = f"INSERT INTO EquipmentLog (logMessage) VALUES ('{log_message}')"
    plpy.execute(query)

    # Return the appropriate record based on the operation
    if tg_op == 'DELETE':
        return TD["old"]
    else:
        return TD["new"]
$$ LANGUAGE plpython3u;

-- Create the trigger
CREATE TRIGGER equipment_changes_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON Equipment
    FOR EACH ROW
EXECUTE FUNCTION log_equipment_changes();



SELECT *
FROM equipment;

UPDATE Equipment
SET cntall = cntall + 5
WHERE equipmentid > 3;


-- TODO: Определяемый пользователем тип данных CLR.

CREATE TYPE employee_info AS
(
    employeeId  INT,
    firstName   TEXT,
    phoneNumber TEXT,
    taskName    TEXT
);

CREATE OR REPLACE FUNCTION get_employee_leader() RETURNS employee_info AS
$$
    query = plpy.execute('''
        SELECT e.employeeId, e.firstName, e.phoneNumber, t.taskName
        FROM Employees e
        JOIN employeetask et ON e.employeeid = et.employeeid
        JOIN tasks t ON et.taskid = t.taskid
        WHERE et.ifLeader = true
    ''')
    if query:
        return query
    else:
        return None
$$ LANGUAGE plpython3u;

SELECT *
FROM get_employee_leader();

SELECT *
FROM EmployeeTask;
