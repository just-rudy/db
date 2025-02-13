CREATE TABLE IF NOT EXISTS satellite (
    id SERIAL PRIMARY KEY NOT NULL,
    satname TEXT NOT NULL,
    bday DATE NOT NULL,
    origin TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS flight(
    flightID SERIAL PRIMARY KEY,
    satID INTEGER NOT NULL,
    launchdate DATE NOT NULL,
    launchtime TIME NOT NULL,
    weekday TEXT NOT NULL,
    type INTEGER NOT NULL
);

ALTER TABLE flight
    ADD CONSTRAINT fl_fk FOREIGN KEY (satID) REFERENCES satellite (id);
ALTER TABLE flight
    ADD CONSTRAINT check_01 CHECK (type IN (0, 1));
ALTER TABLE flight
    ADD CONSTRAINT check_weekday CHECK (flight.weekday IN
                                        ('Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота',
                                         'Воскресенье'));

INSERT INTO satellite (id, satname, bday, origin)
VALUES
    (1, 'SIT-2086', '2050-01-01', 'Россия'),
    (2, 'Шисянь 16-02', '2049-12-01', 'Китай');

-- Вставка данных в таблицу Космических полетов
INSERT INTO flight (flightID, satID, launchdate, launchtime, weekday, type)
VALUES
    (1, 1, '2050-05-11', '09:00:00', 'Среда', 1),
    (2, 1, '2051-06-14', '23:05:00', 'Среда', 0),
    (3, 1, '2051-10-10', '23:00:00', 'Вторник', 1),
    (4, 2, '2052-01-15', '15:15:00', 'Среда', 1),
    (5, 2, '2052-01-01', '12:15:00', 'Понедельник', 0);

INSERT INTO flight (flightID, satID, launchdate, launchtime, weekday, type)
VALUES
    (6, 1, '2024-05-11', '09:00:00', 'Среда', 1),
    (7, 2, '2024-01-15', '15:15:00', 'Среда', 1),
    (8, 2, '2024-01-01', '12:15:00', 'Понедельник', 0);

-- Задание 1
-- схема 1
-- запрос возвращает спутники, которые совершили полет в месяц выпуска
EXPLAIN ANALYSE
SELECT *
FROM flight f
JOIN (
    SELECT date_trunc('month', s.bday) AS mth_b
    FROM satellite s
    GROUP BY date_trunc('month', s.bday)
) sat_gr
ON date_trunc('month', f.launchdate) = sat_gr.mth_b;

-- схема 2
-- запрос возвращает одну строку по критерию: самая ранняя дата рождения среди всех записей satellite
EXPLAIN ANALYSE
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY s.bday) AS rn
    FROM
        satellite s
) f
WHERE f.rn = 1;

-- Задание 2

-- Найти самый новый спутник в Китае
SELECT *
FROM satellite s
WHERE s.origin = 'Китай'
ORDER BY s.bday DESC
LIMIT 1;

-- Найти спутник, который в этом году был отправлен раньше всех
SELECT *
FROM satellite s
JOIN flight f ON s.id = f.satID
WHERE date_trunc('year', f.launchdate) = date_trunc('year', CURRENT_DATE)
ORDER BY f.launchdate, f.launchtime
LIMIT 1;

-- Найти все страны, в которых есть хоть один космический аппарат, первый запуск которого был после 2024-10-01
SELECT DISTINCT satellite.origin
FROM satellite
JOIN flight ON satellite.id = flight.satID
WHERE flight.launchdate > '2024-10-01';
