-- satellite


-- flight
ALTER TABLE flight
    ADD CONSTRAINT fl_fk FOREIGN KEY (satID) REFERENCES satellite (id);
ALTER TABLE flight
    ADD CONSTRAINT check_01 CHECK (type IN (0, 1));
ALTER TABLE flight
    ADD CONSTRAINT check_weekday CHECK (flight.weekday IN
                                        ('Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота',
                                         'Воскресенье'));