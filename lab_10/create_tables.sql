-- Active: 1731590423559@@localhost@5432
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
