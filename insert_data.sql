-- Вставка користувачів
INSERT INTO Users (username, email, password, role)
VALUES 
('admin', 'admin@hotel.com', 'password123', 'Admin'),
('employee1', 'emp1@hotel.com', 'password123', 'Employee'),
('client1', 'client1@hotel.com', 'password123', 'Client'),
('client2', 'client2@hotel.com', 'password123', 'Client');

-- Вставка кімнат
INSERT INTO Rooms (room_number, room_type, price_per_night)
VALUES
('101', 'Single', 50.00),
('102', 'Single', 50.00),
('201', 'Double', 80.00),
('202', 'Double', 80.00),
('301', 'Suite', 150.00);

-- Вставка клієнтів
INSERT INTO Clients (full_name, phone, email)
VALUES
('John Doe', '123456789', 'john.doe@gmail.com'),
('Jane Smith', '987654321', 'jane.smith@gmail.com');

-- Вставка співробітників
INSERT INTO Employees (full_name, position, salary, email)
VALUES
('Alice Brown', 'Receptionist', 1200.00, 'alice@hotel.com'),
('Bob Green', 'Manager', 2500.00, 'bob@hotel.com');

-- Вставка послуг
INSERT INTO Services (service_name, price, description)
VALUES
('Breakfast', 10.00, 'Daily breakfast'),
('Parking', 5.00, 'Secure parking lot'),
('Laundry', 15.00, 'Laundry service');

-- Вставка бронювань
INSERT INTO Reservations (client_id, room_id, check_in_date, check_out_date, total_price, status)
VALUES
(1, 1, '2024-11-22', '2024-11-24', 100.00, 'Confirmed'),
(2, 3, '2024-11-25', '2024-11-27', 160.00, 'Pending');

-- Вставка оплат
INSERT INTO Payments (reservation_id, amount, payment_method)
VALUES
(1, 100.00, 'Card'),
(2, 80.00, 'Cash');

-- Вставка послуг до кімнат
INSERT INTO RoomServices (reservation_id, service_id, quantity)
VALUES
(1, 1, 2), -- 2 рази сніданок
(1, 2, 1), -- 1 раз паркінг
(2, 3, 1); -- 1 раз прання

-- Вставка відгуків
INSERT INTO Reviews (client_id, room_id, rating, comment)
VALUES
(1, 1, 5, 'Great stay!'),
(2, 3, 4, 'Comfortable but noisy.');

-- Вставка інвентарю
INSERT INTO Inventory (item_name, quantity, room_id)
VALUES
('Towels', 10, 1),
('Bed Sheets', 5, 2),
('Shampoo', 20, NULL); -- для загального використання

-- Вставка розкладів
INSERT INTO Schedules (employee_id, shift_date, shift_time)
VALUES
(1, '2024-11-22', 'Morning'),
(2, '2024-11-22', 'Evening');

-- Вставка типів кімнат
INSERT INTO RoomTypes (type_name, description, base_price)
VALUES
('Single', 'One single bed', 50.00),
('Double', 'One double bed', 80.00),
('Suite', 'Luxury room', 150.00);

-- Вставка акцій
INSERT INTO Promotions (promotion_name, discount_percentage, start_date, end_date)
VALUES
('Black Friday', 20.00, '2024-11-25', '2024-11-30'),
('Christmas Discount', 15.00, '2024-12-20', '2024-12-25');

-- Вставка технічного обслуговування кімнат
INSERT INTO RoomMaintenance (room_id, description, maintenance_date, status)
VALUES
(3, 'Air conditioning repair', '2024-11-23', 'Pending'),
(5, 'Furniture polishing', '2024-11-25', 'Completed');

-- Вставка логів аудиту
INSERT INTO AuditLogs (table_name, record_id, action, changed_by, change_date)
VALUES
('Rooms', 1, 'INSERT', 1, CURRENT_TIMESTAMP),
('Reservations', 1, 'INSERT', 1, CURRENT_TIMESTAMP);
