-- Процедура для створення бронювання
DELIMITER //

CREATE PROCEDURE CreateReservation(
    IN ClientID INT,
    IN RoomID INT,
    IN CheckInDate DATE,
    IN CheckOutDate DATE
)
BEGIN
    DECLARE TotalPrice DECIMAL(10, 2);
    DECLARE RoomAvailable INT;

    -- Перевірка доступності номера для заданих дат
    SELECT COUNT(*) INTO RoomAvailable
    FROM Reservations
    WHERE room_id = RoomID
      AND status NOT IN ('Cancelled', 'Completed')
      AND (CheckInDate < check_out_date AND CheckOutDate > check_in_date);

    IF RoomAvailable > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Номер вже заброньовано на вказаний період.';
    END IF;

    -- Розрахунок загальної вартості
    SELECT DATEDIFF(CheckOutDate, CheckInDate) * price_per_night
    INTO TotalPrice
    FROM Rooms
    WHERE room_id = RoomID AND is_available = 1;

    IF TotalPrice IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Номер недоступний для бронювання.';
    END IF;

    -- Додавання нового бронювання
    INSERT INTO Reservations (client_id, room_id, check_in_date, check_out_date, total_price, status, created_at)
    VALUES (ClientID, RoomID, CheckInDate, CheckOutDate, TotalPrice, 'Pending', CURRENT_TIMESTAMP);

    -- Оновлення статусу номера
    UPDATE Rooms
    SET is_available = 0
    WHERE room_id = RoomID;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE CancelReservation(
    IN ReservationID INT
)
BEGIN
    DECLARE RoomID INT;

    -- Отримання room_id для скасованого бронювання
    SELECT room_id INTO RoomID
    FROM Reservations
    WHERE reservation_id = ReservationID AND status = 'Pending';

    IF RoomID IS NOT NULL THEN
        -- Оновлення статусу бронювання
        UPDATE Reservations
        SET status = 'Cancelled', updated_at = CURRENT_TIMESTAMP
        WHERE reservation_id = ReservationID;

        -- Відновлення доступності номера
        UPDATE Rooms
        SET is_available = 1
        WHERE room_id = RoomID;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Бронювання не знайдено або його не можна скасувати.';
    END IF;
END //

DELIMITER ;


-- Функція для розрахунку знижки
DELIMITER //
CREATE FUNCTION CalculateDiscount(OriginalPrice DECIMAL(10, 2), DiscountPercentage DECIMAL(5, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    RETURN OriginalPrice - (OriginalPrice * DiscountPercentage / 100);
END //
DELIMITER ;

-- Процедура для отримання бронювань клієнта
DELIMITER //

CREATE PROCEDURE GetClientReservations(
    IN ClientID INT
)
BEGIN
    SELECT 
        r.reservation_id,
        rm.room_number,
        r.check_in_date,
        r.check_out_date,
        r.total_price,
        r.status
    FROM Reservations r
    JOIN Rooms rm ON r.room_id = rm.room_id
    WHERE r.client_id = ClientID
    ORDER BY r.check_in_date ASC;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateReservationStatuses()
BEGIN
    -- Оновлення статусів на 'Confirmed', якщо дата заїзду вже настала
    UPDATE Reservations
    SET status = 'Confirmed', updated_at = CURRENT_TIMESTAMP
    WHERE check_in_date <= CURRENT_TIMESTAMP AND status = 'Pending';

    -- Оновлення статусів на 'Completed', якщо дата виїзду вже минула
    UPDATE Reservations
    SET status = 'Completed', updated_at = CURRENT_TIMESTAMP
    WHERE check_out_date < CURRENT_TIMESTAMP AND status = 'Confirmed';
END;
//

DELIMITER ;


