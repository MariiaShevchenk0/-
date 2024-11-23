-- Тригер для логування змін в таблиці Rooms
DELIMITER //

CREATE TRIGGER LogRoomChanges
AFTER UPDATE ON Rooms
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogs (table_name, record_id, action, changed_by, change_date)
    VALUES ('Rooms', OLD.room_id, 'UPDATE', CURRENT_USER(), CURRENT_TIMESTAMP);
END;
//

DELIMITER ;


-- Тригер для логування змін у таблиці Reservations
DELIMITER //

CREATE TRIGGER Reservations_AfterInsert
AFTER INSERT ON Reservations
FOR EACH ROW
BEGIN
    INSERT INTO Reservation_Audit (reservation_id, action, action_date)
    VALUES (NEW.reservation_id, 'INSERT', CURRENT_TIMESTAMP);
END;
//

DELIMITER ;
