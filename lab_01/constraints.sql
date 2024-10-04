# BASE
ALTER TABLE bases ADD UNIQUE (adress, baseName);

# EQU
ALTER TABLE equipment ADD CONSTRAINT fk_equ_base FOREIGN KEY (baseid) REFERENCES Bases(baseid);
ALTER TABLE equipment ADD UNIQUE (type, manufacturer);
ALTER TABLE equipment ADD CONSTRAINT check_equ CHECK(cntInUse <= cntAll);

# TASK
ALTER TABLE Tasks ADD CONSTRAINT fk_task_base FOREIGN KEY (baseid) REFERENCES Bases(baseid);
ALTER TABLE Tasks ADD CONSTRAINT ck_task_date CHECK(duration <= 30 and duration <= 1);

# EMP
ALTER TABLE Employees ADD CONSTRAINT chk_position CHECK (position IN ('TechSenior', 'TechJunior', 'NotTech'));
 
# EMP_TASK
ALTER TABLE EmployeeTask ADD CONSTRAINT fk_emptask_emp FOREIGN KEY (employeeId) REFERENCES Employees(employeeId);
ALTER TABLE EmployeeTask ADD CONSTRAINT fk_emptask_task FOREIGN KEY (taskId) REFERENCES Tasks(taskId);

# EQU_TASK
ALTER TABLE EquipmentTask ADD CONSTRAINT fk_equtask_equ FOREIGN KEY (equipmentId) REFERENCES Equipment(equipmentId);
ALTER TABLE EquipmentTask ADD CONSTRAINT fk_equtask_task FOREIGN KEY (taskId) REFERENCES Tasks(taskId);

# триггер на проверку что cntequ < EQU.cntAll - EQU.cntInUse