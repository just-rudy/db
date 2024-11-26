--TODO Извлечь данные в JSON

CREATE TABLE IF NOT EXISTS Employees (
    employeeId SERIAL PRIMARY KEY,
    firstName TEXT,
    lastName TEXT,
    studyGroup TEXT,
    phoneNumber TEXT,
    position TEXT
);

SELECT row_to_json(employees)
FROM Employees;

INSERT INTO jsondata (jdata)
SELECT row_to_json(employees)
FROM Employees;

SELECT *
from jsondata;
-- Чтобы вынести данные в JSON файл, запустить питон скрипт to_json.py


--TODO Выполнить загрузку и сохранение JSON файла в таблицу.

DELETE
FROM Employees;
SELECT *
FROM Employees;

-- run python script from_json

SELECT *
FROM Employees;


--TODO Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или добавить атрибут с типом JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE.

SELECT *
FROM jsondata;

DELETE
FROM jsondata;

INSERT INTO jsondata (jdata)
VALUES ('{
  "employeeid": 17,
  "firstname": "Егор",
  "lastname": "Клевлин",
  "studygroup": "РКТ3-31",
  "phonenumber": "001-890-992-9459x6333",
  "position": "TechSenior"
}'),
       ('{
         "employeeid": 18,
         "firstname": "Антон",
         "lastname": "Павленко",
         "studygroup": "РК6-74Б",
         "phonenumber": "001-504-430-3370x7518",
         "position": "TechJunior"
       }'),
       ('{
         "employeeid": 19,
         "firstname": "Семен",
         "lastname": "Носов",
         "studygroup": "СМ6-59",
         "phonenumber": "(966)362-2734",
         "position": "TechJunior"
       }'),
       ('{
         "employeeid": 23,
         "firstname": "Иракли",
         "lastname": "Чкареули",
         "studygroup": "МТ6-31М",
         "phonenumber": "828-779-1004x41225",
         "position": "TechSenior"
       }');

-- TODO Выполнить следующие действия:

ALTER TABLE employees
    ADD COLUMN data JSONB;

UPDATE employees
SET data = row_to_json(employees);

SELECT *
FROM employees;

-- 1. Извлечь XML/JSON фрагмент из XML/JSON документа
SELECT data->'dog' AS dog_info_frag
FROM Employees
WHERE employeeId = 1;


-- 2. Извлечь значения конкретных узлов или атрибутов XML/JSON документа
SELECT data->'dog'->>'breed' AS dog
FROM Employees;
-- WHERE employeeId = 1;


-- 3. Выполнить проверку существования узла или атрибута

SELECT data ? 'dog'
FROM Employees
WHERE employeeId = 10;


-- 4. Изменить XML/JSON документ
UPDATE Employees
SET data = jsonb_set(data::jsonb, '{address,city}', '"New City"')
WHERE employeeId = 1;


-- 5. Разделить XML/JSON документ на несколько строк по узлам
SELECT
    employeeId,
    firstName,
    lastName,
    studyGroup,
    phoneNumber,
    position,
    key AS json_key,
    value AS json_value
FROM
    Employees,
    jsonb_each_text(data);