-- В'юха для доступних кімнат
CREATE VIEW AvailableRooms AS
SELECT room_id, room_number, room_type, price_per_night
FROM Rooms
WHERE is_available = 1 AND is_deleted = 0;

-- В'юха для історії бронювань клієнтів
CREATE VIEW ClientReservationHistory AS
SELECT 
    c.client_id,
    c.full_name,
    r.reservation_id,
    rm.room_number,
    r.check_in_date,
    r.check_out_date,
    r.total_price,
    r.status
FROM Reservations r
JOIN Clients c ON r.client_id = c.client_id
JOIN Rooms rm ON r.room_id = rm.room_id;

-- В'юха для фінансового звіту
CREATE VIEW FinancialReport AS
SELECT 
    r.reservation_id,
    c.full_name AS client_name,
    rm.room_number,
    r.total_price,
    p.payment_date,
    p.payment_method
FROM Payments p
JOIN Reservations r ON p.reservation_id = r.reservation_id
JOIN Clients c ON r.client_id = c.client_id
JOIN Rooms rm ON r.room_id = rm.room_id;
