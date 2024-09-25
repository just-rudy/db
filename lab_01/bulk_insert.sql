COPY Bases(adress, baseName, manager, contact) FROM '/home/rudy/db/lab_01/csv/bases.csv' DELIMITER ',' CSV HEADER;
COPY Employees(firstName, lastName, studyGroup, phoneNumber, position) FROM '/home/rudy/db/lab_01/csv/employees.csv' DELIMITER ',' CSV HEADER;
COPY Equipment(baseid, type, manufacturer, cntAll, cntInUse) FROM '/home/rudy/db/lab_01/csv/equipment.csv' DELIMITER ',' CSV HEADER;
COPY Tasks(baseid, taskName, dateStart, duration) FROM '/home/rudy/db/lab_01/csv/tasks.csv' DELIMITER ',' CSV HEADER;
COPY EmployeeTask(ifLeader, employeeId, taskId) FROM '/home/rudy/db/lab_01/csv/employee_tasks.csv' DELIMITER ',' CSV HEADER;
COPY EquipmentTask(cntUsed, equipmentId, taskId) FROM '/home/rudy/db/lab_01/csv/equipment_tasks.csv' DELIMITER ',' CSV HEADER;
