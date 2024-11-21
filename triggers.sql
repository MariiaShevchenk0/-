-- Тригер для логування змін в таблиці Rooms
DELIMITER //
CREATE TRIGGER LogRoomChanges
AFTER UPDATE ON Rooms
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogs (table_name, record_id, action, changed_by, change_date)
    VALUES ('Rooms', OLD.room_id, 'UPDATE', USER(), CURRENT_TIMESTAMP);
END;
//
DELIMITER ;

-- Тригер для логування змін у таблиці Reservations
DELIMITER //

CREATE TRIGGER Reservations_AfterInsert
AFTER INSERT ON Reservations
FOR EACH ROW
BEGIN
    DECLARE Action VARCHAR(10);

    -- Логування дії
    SET Action = 'INSERT';
    INSERT INTO Reservation_Audit (reservation_id, action, action_date)
    VALUES (NEW.reservation_id, Action, CURRENT_TIMESTAMP);
END //

DELIMITER ;


-- Тригер для оновлення статусу бронювання в таблиці Reservations
DELIMITER //
CREATE TRIGGER UpdateReservationStatus
AFTER UPDATE ON Reservations
FOR EACH ROW
BEGIN
    UPDATE Reservations
    SET status = CASE
        WHEN NEW.check_in_date <= CURRENT_TIMESTAMP AND NEW.status = 'Pending' THEN 'Confirmed'
        WHEN NEW.check_out_date < CURRENT_TIMESTAMP AND NEW.status = 'Confirmed' THEN 'Completed'
        ELSE NEW.status
    END
    WHERE reservation_id = NEW.reservation_id;
END;
//
DELIMITER ;
