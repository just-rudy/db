CREATE TABLE IF NOT EXISTS Bases (
    baseId SERIAL PRIMARY KEY,
    adress TEXT,
    baseName TEXT,
    manager TEXT,
    contact TEXT
);

CREATE TABLE IF NOT EXISTS Employees (
    employeeId SERIAL PRIMARY KEY,
    firstName TEXT,
    lastName TEXT,
    studyGroup TEXT,
    phoneNumber TEXT,
    position TEXT
);

CREATE TABLE IF NOT EXISTS Equipment (
    equipmentId SERIAL PRIMARY KEY,
    type TEXT,
    manufacturer TEXT,
    cntAll INT,
    cntInUse INT,
    baseId INT
);

CREATE TABLE IF NOT EXISTS Tasks (
    taskId SERIAL PRIMARY KEY,
    taskName TEXT,
    dateStart DATE,
    duration INT,
    baseId INT
);

CREATE TABLE IF NOT EXISTS EmployeeTask (
    empTaskId SERIAL PRIMARY KEY,
    ifLeader BOOLEAN,
    employeeId INT,
    taskId INT
);

CREATE TABLE IF NOT EXISTS EquipmentTask (
    eqTaskId SERIAL PRIMARY KEY,
    cntUsed INT,
    equipmentId INT,
    taskId INT
    
);

-- Active: 1731590423559@@localhost@5432@postgres
-- # BASE
ALTER TABLE bases ADD UNIQUE (adress, baseName);

-- # EQU
ALTER TABLE equipment ADD CONSTRAINT fk_equ_base FOREIGN KEY (baseid) REFERENCES Bases(baseid);
ALTER TABLE equipment ADD UNIQUE (type, manufacturer);
ALTER TABLE equipment ADD CONSTRAINT check_equ CHECK(cntInUse <= cntAll);

-- # TASK
ALTER TABLE Tasks ADD CONSTRAINT fk_task_base FOREIGN KEY (baseid) REFERENCES Bases(baseid);
-- ALTER TABLE Tasks ADD CONSTRAINT ck_task_date CHECK(duration <= 30 and duration >= 1);

-- # EMP
ALTER TABLE Employees ADD CONSTRAINT chk_position CHECK (position IN ('TechSenior', 'TechJunior', 'NotTech'));

-- # EMP_TASK
ALTER TABLE EmployeeTask ADD CONSTRAINT fk_emptask_emp FOREIGN KEY (employeeId) REFERENCES Employees(employeeId);
ALTER TABLE EmployeeTask ADD CONSTRAINT fk_emptask_task FOREIGN KEY (taskId) REFERENCES Tasks(taskId);

-- # EQU_TASK
ALTER TABLE EquipmentTask ADD CONSTRAINT fk_equtask_equ FOREIGN KEY (equipmentId) REFERENCES Equipment(equipmentId);
ALTER TABLE EquipmentTask ADD CONSTRAINT fk_equtask_task FOREIGN KEY (taskId) REFERENCES Tasks(taskId);

-- # триггер на проверку что cntequ < EQU.cntAll - EQU.cntInUse

SELECT
    COUNT(CASE WHEN position = 'TechSenior' THEN 1 END) AS seniors,
    COUNT(CASE WHEN position = 'TechJunior' THEN 1 END) AS juns,
    COUNT(CASE WHEN position = 'NotTech' THEN 1 END) AS jusppl
FROM Employees;

select * from tasks;

INSERT INTO Tasks (taskname, datestart, duration, baseid)
         values ('task1', '2022-01-01', 20, 1),
          ('task11', '2022-01-01', 20, 2),
          ('task12', '2004-05-15', 20, 3),
          ('task13', '2022-01-01', 20, 4);
