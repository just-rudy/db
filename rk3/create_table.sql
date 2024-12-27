-- Active: 1731590423559@@localhost@5432@postgres
CREATE TABLE IF NOT EXISTS Employees (
    empID SERIAL PRIMARY KEY,
    employeeName TEXT,
    dateOfBirth DATE,
    jobPosition TEXT
);

CREATE TABLE IF NOT EXISTS Exchanges(
    excID SERIAL PRIMARY KEY,
    empID INTEGER,
    rateID INTEGER,
    summ BIGINT
);

CREATE TABLE IF NOT EXISTS CurrencyRates(
    rateID SERIAL PRIMARY KEY,
    currTypeID INTEGER,
    buyRate INTEGER,
    sellRate INTEGER
);

CREATE TABLE IF NOT EXISTS CurrencyTypes(
    currTypeID SERIAL PRIMARY KEY,
    currency TEXT
);