-- 1. Триггер AFTER

ALTER TABLE Equipment ADD COLUMN cntFree INT;

CREATE OR REPLACE FUNCTION update_free_of_use_equ()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE Equipment
        SET cntFree = cntAll - cntInUse
        WHERE equipmentId = NEW.equipmentId;
    ELSEIF TG_OP = 'UPDATE' THEN
        UPDATE Equipment
        SET cntFree = cntAll - cntInUse
        WHERE equipmentId = NEW.equipmentId;
    ELSEIF TG_OP = 'DELETE' THEN
        UPDATE Equipment
        SET cntFree = cntAll - cntInUse
        WHERE equipmentId = OLD.equipmentId;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_equipment_changes
AFTER INSERT OR UPDATE OR DELETE ON Equipment
FOR EACH ROW
EXECUTE FUNCTION update_free_of_use_equ();

-- 2. Триггер INSTEAD OF

CREATE VIEW EmployeeView AS
SELECT employeeId, firstName, lastName, studyGroup, phoneNumber, position
FROM Employees;

CREATE OR REPLACE FUNCTION instead_of_employee_view()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO Employees (firstName, lastName, studyGroup, phoneNumber, position)
        VALUES (NEW.firstName, NEW.lastName, NEW.studyGroup, NEW.phoneNumber, NEW.position);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE Employees
        SET firstName = NEW.firstName,
            lastName = NEW.lastName,
            studyGroup = NEW.studyGroup,
            phoneNumber = NEW.phoneNumber,
            position = NEW.position
        WHERE employeeId = OLD.employeeId;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instead_of_employee_view_trigger
INSTEAD OF INSERT OR UPDATE ON EmployeeView
FOR EACH ROW
EXECUTE FUNCTION instead_of_employee_view();
