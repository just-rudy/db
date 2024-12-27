-- 10 самых популярных кусков оборудования

SELECT e.type, COUNT(*) AS usage_cnt
FROM equipment e
JOIN equipmenttask et ON e.equipmentid = et.equipmentid
GROUP BY e.type
ORDER BY usage_cnt DESC
LIMIT 10;

SELECT * from equipment e;
SELECT * FROM tasks t;

INSERT INTO Equipment (type, manufacturer, cntAll, cntInUse, baseId) VALUES
('hammer', 'Bosch', 10, 0, 1),
('screwdriver', 'Stanley', 5, 0, 1),
('wrench', 'Craftsman', 3, 0, 2),
('drill', 'DeWalt', 7, 0, 2),
('saw', 'Makita', 2, 0, 1);

INSERT INTO EquipmentTask (cntUsed, equipmentId, taskId) VALUES
(2, 1, 1),
(1, 2, 1),
(1, 3, 2),
(3, 4, 3),
(1, 1, 3),
(2, 2, 4),
(1, 5, 5),
--
(2, 6, 1),
(1, 7, 6),
(1, 8, 7),
(3, 9, 9),
(1, 6, 3),
(2, 7, 8),
(1, 10, 7);

