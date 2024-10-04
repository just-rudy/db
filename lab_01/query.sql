-- Active: 1727951228131@@localhost@5432
-- 1. Инструкция SELECT, использующая предикат сравнения
SELECT
    firstName,
    lastName
FROM
    Employees
WHERE
    position = 'TechSenior';

-- 2. Инструкция SELECT, использующая предикат BETWEEN
SELECT
    taskName,
    dateStart
FROM
    Tasks
WHERE
    dateStart BETWEEN '2023-01-01' AND '2023-12-31';

-- 3. Инструкция SELECT, использующая предикат LIKE
SELECT
    equipmentid,
    type
FROM
    Equipment
WHERE
    type LIKE '%ключ%';

-- 4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом
SELECT
    firstName,
    lastName
FROM
    Employees
WHERE
    employeeId IN (
        SELECT
            employeeId
        FROM
            EmployeeTask
        WHERE
            ifLeader = TRUE
    );

-- 5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом
SELECT
    baseName,
    adress
FROM
    Bases b
WHERE
    EXISTS (
        SELECT
            1
        FROM
            Tasks t
        WHERE
            t.baseId = b.baseId
    );

-- 6. Инструкция SELECT, использующая предикат сравнения с квантором
SELECT
    firstName,
    lastName
FROM
    Employees
WHERE
    employeeId = ANY (
        SELECT
            employeeId
        FROM
            EmployeeTask
        WHERE
            taskId = 11
    );

-- 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
SELECT
    type,
    SUM(cntAll) AS totalEquipment,
    AVG(cntInUse) AS avgInUse
FROM
    Equipment
GROUP BY
    type;

-- 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов
SELECT
    firstName,
    lastName,
    (
        SELECT
            COUNT(*)
        FROM
            EmployeeTask et
        WHERE
            et.employeeId = e.employeeId
    ) AS taskCount
FROM
    Employees e;

-- 9. Инструкция SELECT, использующая простое выражение CASE
SELECT
    firstName,
    lastName,
    CASE
        WHEN position = 'TechSenior' THEN 'Senior Technician'
        WHEN position = 'TechJunior' THEN 'Junior Technician'
        ELSE 'Non-Technician'
    END AS positionDescription
FROM
    Employees;

-- 10. Инструкция SELECT, использующая поисковое выражение CASE
SELECT
    baseName,
    adress,
    CASE baseName
        WHEN 'Central Base' THEN 'Main Office'
        WHEN 'West Base' THEN 'Western Branch'
        ELSE 'Other Location'
    END AS locationType
FROM
    Bases;

-- 11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
SELECT
    firstName,
    lastName,
    position INTO TEMP TABLE TempEmpl
FROM
    Employees
WHERE
    position = 'TechSenior';

-- 12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM
SELECT
    e.firstName,
    e.lastName,
    et.taskCount
FROM
    Employees e
    JOIN (
        SELECT
            employeeId,
            COUNT(*) AS taskCount
        FROM
            EmployeeTask
        GROUP BY
            employeeId
    ) et ON e.employeeId = et.employeeId;

-- 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3
SELECT
    baseName,
    adress
FROM
    Bases
WHERE
    baseId IN (
        SELECT
            baseId
        FROM
            Tasks
        WHERE
            taskId IN (
                SELECT
                    taskId
                FROM
                    EmployeeTaskЫ
                WHERE
                    employeeId = (
                        SELECT
                            employeeId
                        FROM
                            Employees
                        WHERE
                            firstName = 'Егор'
                            AND lastName = 'Клевлин'
                    )
            )
    );

-- 15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING
SELECT
    baseId,
    COUNT(*) AS taskCount
FROM
    Tasks
GROUP BY
    baseId
HAVING
    COUNT(*) > 3;

-- 16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений
INSERT INTO
    Bases (adress, baseName, manager, contact)
VALUES
    (
        '123 Main St',
        'Central Base',
        'Alice Smith',
        '123-456-7890'
    );

-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса
INSERT INTO
    EmployeeTask (ifLeader, employeeId, taskId)
SELECT
    FALSE,
    employeeId,
    taskId
FROM
    Employees e,
    Tasks t
WHERE
    e.position = 'TechJunior'
    AND t.duration < 10;

-- 18. Простая инструкция UPDATE
UPDATE Employees
SET
    phoneNumber = '987-654-3210'
WHERE
    employeeId = 1;

-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET
UPDATE Equipment
SET
    cntInUse = (
        SELECT
            SUM(cntUsed)
        FROM
            EquipmentTask
        WHERE
            equipmentId = Equipment.equipmentId
    )
WHERE
    cntInUse < cntAll;

-- 20. Простая инструкция DELETE
DELETE FROM Employees
WHERE
    employeeId = 2;

--21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
DELETE FROM EmployeeTask
WHERE
    taskId IN (
        SELECT
            taskId
        FROM
            Tasks
        WHERE
            dateStart < '2023-01-01'
    );

--22. Инструкция SELECT, использующая простое обобщенное табличное выражение
WITH
    BaseTasks AS (
        SELECT
            baseId,
            COUNT(*) AS taskCount
        FROM
            Tasks
        GROUP BY
            baseId
    )
SELECT
    b.baseName,
    bt.taskCount
FROM
    Bases b
    JOIN BaseTasks bt ON b.baseId = bt.baseId;

--23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
WITH RECURSIVE
    TaskHierarchy AS (
        SELECT
            taskId,
            taskName,
            sq dateStart,
            duration,
            baseId
        FROM
            Tasks
        WHERE
            dateStart = (
                SELECT
                    MIN(dateStart)
                FROM
                    Tasks
            )
        UNION ALL
        SELECT
            t.taskId,
            t.taskName,
            t.dateStart,
            t.duration,
            t.baseId
        FROM
            Tasks t
            JOIN TaskHierarchy th ON t.dateStart > th.dateStart
    )
SELECT
    *
FROM
    TaskHierarchy;

--24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
SELECT
    baseId,
    cntInUse,
    AVG(cntInUse) OVER (
        PARTITION BY
            baseId
    ) AS AvgInUse,
    MIN(cntInUse) OVER (
        PARTITION BY
            baseId
    ) AS MinInUse,
    MAX(cntInUse) OVER (
        PARTITION BY
            baseId
    ) AS MaxInUse
FROM
    Equipment;

--25. Оконные функции для устранения дублей
-- Добавим дублирующие строки в таблицу Employees
INSERT INTO
    Employees (
        firstName,
        lastName,
        studyGroup,
        phoneNumber,
        position
    )
VALUES
    (
        'Клевлин',
        'Егор',
        'РКТ3',
        '123-456-7890',
        'TechSenior'
    ),
    (
        'Клевлин',
        'Егор',
        'РКТ3',
        '123-456-7890',
        'TechSenior'
    ),
    (
        'Клевлин',
        'Егор',
        'РКТ3',
        '123-456-7890',
        'TechSenior'
    ),
    (
        'Клевлин',
        'Егор',
        'РКТ3',
        '123-456-7890',
        'TechSenior'
    ),
    (
        'Клевлин',
        'Егор',
        'РКТ3',
        '123-456-7890',
        'TechSenior'
    );

-- Запрос для устранения дублей
WITH
    EmployeeDuplicates AS (
        SELECT
            employeeId,
            firstName,
            lastName,
            studyGroup,
            phoneNumber,
            position,
            ROW_NUMBER() OVER (
                PARTITION BY
                    firstName,
                    lastName,
                    studyGroup,
                    phoneNumber,
                    position
                ORDER BY
                    employeeId
            ) AS row_num
        FROM
            Employees
    )
DELETE FROM Employees
WHERE
    employeeId IN (
        SELECT
            employeeIdЫ
        FROM
            EmployeeDuplicates
        WHERE
            row_num > 1
    );

-- Проверка удаления дублей
SELECT
    *
FROM
    Employees;

-- Дополнительная задача: вытащить для определенного куска оборудования все таски, к которому оно привязано и вывести дату начала и длительность
SELECT
    e.type,
    t.taskname,
    t.datestart,
    t.duration,
    et.cntused,
    e.cntall
FROM
    Equipment e
    JOIN EquipmentTask et ON e.equipmentid = et.equipmentid
    JOIN Tasks t ON et.taskid = t.taskid
WHERE
    e.equipmentid = 11
ORDER BY
    datestart