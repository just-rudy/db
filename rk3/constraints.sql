# Employees

# Exchanges
ALTER TABLE Exchanges ADD CONSTRAINT fk_exch_emp FOREIGN KEY (empID) REFERENCES Employees(empID);
ALTER TABLE Exchanges ADD CONSTRAINT fk_exch_cur FOREIGN KEY (rateID) REFERENCES CurrencyRates(rateID);

# CurrencyRates
ALTER TABLE CurrencyRates ADD CONSTRAINT fk_rate_type FOREIGN KEY (currTypeID) REFERENCES CurrencyTypes(currTypeID);

# CurrencyTypes