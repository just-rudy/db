-- 1. Хранимую процедуру без параметров или с параметрами
-- с параметрами, добавляет нового employee

CREATE OR REPLACE FUNCTION add_employee(
    first_name TEXT,
    last_name TEXT,
    study_group TEXT,
    phone_number TEXT,
    pos TEXT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO employees (firstName, lastName, studyGroup, phoneNumber, position)
    VALUES (first_name, last_name, study_group, phone_number, pos);
END;
$$LANGUAGE plpgsql;

SELECT add_employee('Егор', 'Егор', 'РК4', '+79162225533', 'TechJunior');

--TODO: 2. Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ
-- пока не понятно, че с ней делать то)))))

-- 3. Хранимую процедуру с курсором
CREATE OR REPLACE FUNCTION process_employees_by_status(status TEXT)
RETURNS VOID AS $$
DECLARE
    emp RECORD;
    cur CURSOR FOR SELECT firstName, lastName FROM employees WHERE position = status;
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
RETURNS TABLE (table_name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT t.table_name::text
    FROM information_schema.tables as t
    WHERE t.table_schema = 'public';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM list_all_tables();
