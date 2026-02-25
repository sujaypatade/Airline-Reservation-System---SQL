create database airline_reservation_system ;
CREATE TABLE airlines (
    airline_id INT PRIMARY KEY AUTO_INCREMENT,
    airline_code VARCHAR(3) UNIQUE NOT NULL,
    airline_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
    
    CREATE TABLE airports (
    airport_id INT PRIMARY KEY AUTO_INCREMENT,
    airport_code VARCHAR(3) UNIQUE NOT NULL,
    airport_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    timezone VARCHAR(50),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
    
    CREATE TABLE aircraft (
    aircraft_id INT PRIMARY KEY AUTO_INCREMENT,
    aircraft_type VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL,
    economy_seats INT NOT NULL,
    business_seats INT NOT NULL,
    first_class_seats INT NOT NULL,
    airline_id INT NOT NULL,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    manufacture_year YEAR,
    status ENUM('Active', 'Maintenance', 'Retired') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id) ON DELETE CASCADE);
    
    CREATE TABLE passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    passport_number VARCHAR(20) UNIQUE,
    nationality VARCHAR(50),
    frequent_flyer_number VARCHAR(20) UNIQUE,
    loyalty_tier ENUM('Bronze', 'Silver', 'Gold', 'Platinum') DEFAULT 'Bronze',
    total_miles INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_frequent_flyer (frequent_flyer_number));
    
    CREATE TABLE flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(10) NOT NULL,
    airline_id INT NOT NULL,
    aircraft_id INT NOT NULL,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    departure_datetime DATETIME NOT NULL,
    arrival_datetime DATETIME NOT NULL,
    flight_duration_minutes INT,
    distance_km DECIMAL(10, 2),
    status ENUM('Scheduled', 'Boarding', 'Departed', 'In Air', 'Landed', 'Cancelled', 'Delayed') DEFAULT 'Scheduled',
    base_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id) ON DELETE CASCADE,
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    FOREIGN KEY (departure_airport_id) REFERENCES airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES airports(airport_id),
    INDEX idx_flight_number (flight_number),
    INDEX idx_departure_datetime (departure_datetime),
    INDEX idx_route (departure_airport_id, arrival_airport_id));
    
    CREATE TABLE crew (
    crew_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role ENUM('Pilot', 'Co-Pilot', 'Flight Attendant', 'Purser') NOT NULL,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    airline_id INT NOT NULL,
    status ENUM('Active', 'On Leave', 'Retired') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id) ON DELETE CASCADE,
    INDEX idx_employee_id (employee_id),
    INDEX idx_role (role));
    
    CREATE TABLE flight_crew (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT NOT NULL,
    crew_id INT NOT NULL,
    assigned_role ENUM('Pilot', 'Co-Pilot', 'Flight Attendant', 'Purser') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    FOREIGN KEY (crew_id) REFERENCES crew(crew_id) ON DELETE CASCADE,
    UNIQUE KEY unique_flight_crew (flight_id, crew_id));
    
    CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_reference VARCHAR(10) UNIQUE NOT NULL,
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5),
    booking_class ENUM('Economy', 'Business', 'First Class') NOT NULL,
    booking_status ENUM('Confirmed', 'Cancelled', 'Pending', 'Checked-In', 'Boarded') DEFAULT 'Pending',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Refunded') DEFAULT 'Pending',
    baggage_allowance_kg INT DEFAULT 23,
    special_requests TEXT,
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    INDEX idx_booking_reference (booking_reference),
    INDEX idx_passenger (passenger_id),
    INDEX idx_flight (flight_id),
    INDEX idx_booking_date (booking_date));
    
    CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_id VARCHAR(50) UNIQUE,
    status ENUM('Success', 'Failed', 'Pending', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    INDEX idx_transaction_id (transaction_id));
    
    INSERT INTO airlines (airline_code, airline_name, country, contact_email, contact_phone) VALUES
('AI', 'Air India', 'India', 'support@airindia.com', '+91-1234567890'),
('BA', 'British Airways', 'United Kingdom', 'info@britishairways.com', '+44-2087385050'),
('EK', 'Emirates', 'UAE', 'contact@emirates.com', '+971-600555555'),
('LH', 'Lufthansa', 'Germany', 'service@lufthansa.com', '+49-69-86799799'),
('SQ', 'Singapore Airlines', 'Singapore', 'help@singaporeair.com', '+65-62238888');

INSERT INTO airports (airport_code, airport_name, city, country, timezone, latitude, longitude) VALUES
('DEL', 'Indira Gandhi International Airport', 'New Delhi', 'India', 'Asia/Kolkata', 28.5665, 77.1031),
('BOM', 'Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'India', 'Asia/Kolkata', 19.0896, 72.8656),
('LHR', 'Heathrow Airport', 'London', 'United Kingdom', 'Europe/London', 51.4700, -0.4543),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE', 'Asia/Dubai', 25.2532, 55.3657),
('SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore', 'Asia/Singapore', 1.3644, 103.9915),
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA', 'America/New_York', 40.6413, -73.7781),
('FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany', 'Europe/Berlin', 50.0379, 8.5622),
('BLR', 'Kempegowda International Airport', 'Bangalore', 'India', 'Asia/Kolkata', 13.1986, 77.7066),
('SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia', 'Australia/Sydney', -33.9399, 151.1753),
('HKG', 'Hong Kong International Airport', 'Hong Kong', 'Hong Kong', 'Asia/Hong_Kong', 22.3080, 113.9185);

INSERT INTO aircraft (aircraft_type, manufacturer, model, total_seats, economy_seats, business_seats, first_class_seats, airline_id, registration_number, manufacture_year, status) VALUES
('Boeing 777', 'Boeing', '777-300ER', 350, 280, 50, 20, 1, 'VT-ALJ', 2018, 'Active'),
('Airbus A380', 'Airbus', 'A380-800', 525, 400, 100, 25, 2, 'G-XLEA', 2019, 'Active'),
('Boeing 787', 'Boeing', '787-9', 290, 230, 50, 10, 3, 'A6-BLR', 2020, 'Active'),
('Airbus A350', 'Airbus', 'A350-900', 325, 260, 55, 10, 4, 'D-AIXM', 2021, 'Active'),
('Boeing 777', 'Boeing', '777-200LR', 300, 240, 45, 15, 5, '9V-SWA', 2017, 'Active'),
('Airbus A320', 'Airbus', 'A320-200', 180, 168, 12, 0, 1, 'VT-EXA', 2019, 'Active'),
('Boeing 737', 'Boeing', '737-800', 189, 180, 9, 0, 2, 'G-GFFB', 2020, 'Active'),
('Airbus A330', 'Airbus', 'A330-300', 277, 230, 42, 5, 3, 'A6-EAF', 2018, 'Active');

INSERT INTO passengers (first_name, last_name, email, phone, date_of_birth, passport_number, nationality, frequent_flyer_number, loyalty_tier, total_miles) VALUES
('Rajesh', 'Kumar', 'rajesh.kumar@email.com', '+91-9876543210', '1985-03-15', 'J1234567', 'Indian', 'AI1001', 'Gold', 75000),
('Priya', 'Sharma', 'priya.sharma@email.com', '+91-9876543211', '1990-07-22', 'J2345678', 'Indian', 'AI1002', 'Silver', 45000),
('John', 'Smith', 'john.smith@email.com', '+44-7700900123', '1988-11-10', 'UK123456', 'British', 'BA2001', 'Platinum', 150000),
('Emily', 'Johnson', 'emily.j@email.com', '+1-2125551234', '1992-05-18', 'US987654', 'American', 'UA3001', 'Bronze', 12000),
('Mohammed', 'Al-Rashid', 'mohammed.ar@email.com', '+971-501234567', '1980-09-25', 'AE456789', 'Emirati', 'EK4001', 'Gold', 82000),
('Li', 'Wei', 'li.wei@email.com', '+86-13812345678', '1987-12-03', 'CN112233', 'Chinese', 'CA5001', 'Silver', 38000),
('Sarah', 'Williams', 'sarah.w@email.com', '+61-412345678', '1995-02-14', 'AU789012', 'Australian', 'QF6001', 'Bronze', 8500),
('Amit', 'Patel', 'amit.patel@email.com', '+91-9876543212', '1983-08-30', 'J3456789', 'Indian', 'AI1003', 'Platinum', 125000),
('Anna', 'Mueller', 'anna.m@email.com', '+49-15112345678', '1991-04-07', 'DE345678', 'German', 'LH7001', 'Gold', 68000),
('Yuki', 'Tanaka', 'yuki.t@email.com', '+81-9012345678', '1989-10-20', 'JP567890', 'Japanese', 'JL8001', 'Silver', 42000),
('David', 'Brown', 'david.b@email.com', '+1-3105551234', '1986-06-12', 'US123789', 'American', 'UA3002', 'Bronze', 15000),
('Maria', 'Garcia', 'maria.g@email.com', '+34-612345678', '1993-01-28', 'ES234567', 'Spanish', 'IB9001', 'Bronze', 6000),
('Ahmed', 'Hassan', 'ahmed.h@email.com', '+20-1012345678', '1984-11-15', 'EG345678', 'Egyptian', 'MS1001', 'Silver', 35000),
('Sophie', 'Martin', 'sophie.m@email.com', '+33-612345678', '1990-03-22', 'FR456789', 'French', 'AF2001', 'Gold', 72000),
('Vikram', 'Singh', 'vikram.s@email.com', '+91-9876543213', '1988-09-05', 'J4567890', 'Indian', 'AI1004', 'Silver', 48000);

INSERT INTO crew (first_name, last_name, role, employee_id, email, phone, hire_date, airline_id, status) VALUES
('Captain', 'Anil Mehra', 'Pilot', 'AI-P-001', 'anil.mehra@airindia.com', '+91-9800001111', '2010-05-15', 1, 'Active'),
('First Officer', 'Sneha Rao', 'Co-Pilot', 'AI-CP-001', 'sneha.rao@airindia.com', '+91-9800001112', '2015-08-20', 1, 'Active'),
('Cabin Crew', 'Deepa Nair', 'Flight Attendant', 'AI-FA-001', 'deepa.nair@airindia.com', '+91-9800001113', '2018-03-10', 1, 'Active'),
('Cabin Crew', 'Ravi Kumar', 'Flight Attendant', 'AI-FA-002', 'ravi.k@airindia.com', '+91-9800001114', '2019-01-15', 1, 'Active'),
('Senior Cabin Crew', 'Meera Iyer', 'Purser', 'AI-PR-001', 'meera.iyer@airindia.com', '+91-9800001115', '2012-07-22', 1, 'Active'),
('Captain', 'James Wilson', 'Pilot', 'BA-P-001', 'james.wilson@ba.com', '+44-7700900001', '2008-04-12', 2, 'Active'),
('First Officer', 'Emma Davis', 'Co-Pilot', 'BA-CP-001', 'emma.davis@ba.com', '+44-7700900002', '2014-09-18', 2, 'Active'),
('Cabin Crew', 'Oliver Taylor', 'Flight Attendant', 'BA-FA-001', 'oliver.t@ba.com', '+44-7700900003', '2017-11-25', 2, 'Active'),
('Captain', 'Ahmed Al-Mansoori', 'Pilot', 'EK-P-001', 'ahmed.am@emirates.com', '+971-501111001', '2009-06-20', 3, 'Active'),
('First Officer', 'Fatima Al-Zaabi', 'Co-Pilot', 'EK-CP-001', 'fatima.az@emirates.com', '+971-501111002', '2016-02-14', 3, 'Active'),
('Cabin Crew', 'Sara Ahmed', 'Flight Attendant', 'EK-FA-001', 'sara.a@emirates.com', '+971-501111003', '2018-08-30', 3, 'Active'),
('Senior Cabin Crew', 'Noora Hassan', 'Purser', 'EK-PR-001', 'noora.h@emirates.com', '+971-501111004', '2011-12-05', 3, 'Active');

INSERT INTO flights (flight_number, airline_id, aircraft_id, departure_airport_id, arrival_airport_id, departure_datetime, arrival_datetime, flight_duration_minutes, distance_km, status, base_price) VALUES
-- Air India Flights
('AI101', 1, 1, 1, 3, '2024-11-15 08:00:00', '2024-11-15 13:30:00', 540, 6700, 'Scheduled', 45000.00),
('AI102', 1, 1, 3, 1, '2024-11-16 15:00:00', '2024-11-17 04:30:00', 570, 6700, 'Scheduled', 47000.00),
('AI201', 1, 6, 1, 2, '2024-11-15 06:00:00', '2024-11-15 08:15:00', 135, 1140, 'Scheduled', 5500.00),
('AI202', 1, 6, 2, 1, '2024-11-15 09:30:00', '2024-11-15 11:45:00', 135, 1140, 'Scheduled', 5500.00),
('AI301', 1, 1, 1, 8, '2024-11-17 10:00:00', '2024-11-17 12:30:00', 150, 1740, 'Scheduled', 8500.00),

-- British Airways Flights
('BA142', 2, 2, 3, 6, '2024-11-15 10:00:00', '2024-11-15 13:30:00', 450, 5540, 'Scheduled', 55000.00),
('BA143', 2, 2, 6, 3, '2024-11-16 18:00:00', '2024-11-17 07:30:00', 450, 5540, 'Scheduled', 58000.00),
('BA256', 2, 7, 3, 7, '2024-11-15 14:00:00', '2024-11-15 15:30:00', 90, 650, 'Scheduled', 12000.00),

-- Emirates Flights
('EK501', 3, 3, 4, 5, '2024-11-15 09:00:00', '2024-11-15 16:30:00', 450, 3900, 'Scheduled', 38000.00),
('EK502', 3, 3, 5, 4, '2024-11-16 22:00:00', '2024-11-17 02:00:00', 480, 3900, 'Scheduled', 40000.00),
('EK211', 3, 8, 4, 1, '2024-11-15 03:00:00', '2024-11-15 08:30:00', 210, 2200, 'Scheduled', 28000.00),
('EK212', 3, 8, 1, 4, '2024-11-16 10:30:00', '2024-11-16 14:00:00', 210, 2200, 'Scheduled', 29000.00),

-- Lufthansa Flights
('LH760', 4, 4, 7, 4, '2024-11-15 20:00:00', '2024-11-16 05:30:00', 390, 4590, 'Scheduled', 48000.00),
('LH761', 4, 4, 4, 7, '2024-11-17 08:00:00', '2024-11-17 13:30:00', 390, 4590, 'Scheduled', 50000.00),

-- Singapore Airlines Flights
('SQ401', 5, 5, 5, 9, '2024-11-15 23:30:00', '2024-11-16 09:00:00', 510, 6300, 'Scheduled', 52000.00),
('SQ402', 5, 5, 9, 5, '2024-11-17 11:00:00', '2024-11-17 17:30:00', 510, 6300, 'Scheduled', 54000.00);

INSERT INTO flight_crew (flight_id, crew_id, assigned_role) VALUES
-- AI101 Crew
(1, 1, 'Pilot'),
(1, 2, 'Co-Pilot'),
(1, 3, 'Flight Attendant'),
(1, 4, 'Flight Attendant'),
(1, 5, 'Purser'),

-- AI102 Crew
(2, 1, 'Pilot'),
(2, 2, 'Co-Pilot'),
(2, 3, 'Flight Attendant'),
(2, 5, 'Purser'),

-- BA142 Crew
(6, 6, 'Pilot'),
(6, 7, 'Co-Pilot'),
(6, 8, 'Flight Attendant'),

-- EK501 Crew
(9, 9, 'Pilot'),
(9, 10, 'Co-Pilot'),
(9, 11, 'Flight Attendant'),
(9, 12, 'Purser');

INSERT INTO bookings (booking_reference, passenger_id, flight_id, seat_number, booking_class, booking_status, price, payment_status, baggage_allowance_kg) VALUES
('AI1A2B3C', 1, 1, '12A', 'Business', 'Confirmed', 65000.00, 'Paid', 30),
('AI2D4E5F', 2, 1, '25B', 'Economy', 'Confirmed', 45000.00, 'Paid', 23),
('BA3G6H7I', 3, 6, '1A', 'First Class', 'Confirmed', 125000.00, 'Paid', 40),
('UA4J8K9L', 4, 6, '32C', 'Economy', 'Confirmed', 55000.00, 'Paid', 23),
('EK5M1N2O', 5, 9, '5B', 'Business', 'Confirmed', 58000.00, 'Paid', 30),
('AI6P3Q4R', 8, 2, '8A', 'First Class', 'Confirmed', 95000.00, 'Paid', 40),
('EK7S5T6U', 5, 11, '14F', 'Business', 'Confirmed', 42000.00, 'Paid', 30),
('AI8V7W8X', 1, 3, '18C', 'Economy', 'Confirmed', 5500.00, 'Paid', 23),
('BA9Y1Z2A', 3, 7, '2A', 'First Class', 'Confirmed', 115000.00, 'Paid', 40),
('SQ1B3C4D', 9, 15, '7D', 'Business', 'Confirmed', 72000.00, 'Paid', 30),
('AI2E5F6G', 10, 4, '22E', 'Economy', 'Confirmed', 5500.00, 'Paid', 23),
('EK3H7I8J', 13, 12, '11B', 'Business', 'Confirmed', 44000.00, 'Paid', 30),
('BA4K9L1M', 11, 8, '28D', 'Economy', 'Confirmed', 12000.00, 'Paid', 23),
('AI5N2O3P', 15, 5, '16A', 'Economy', 'Confirmed', 8500.00, 'Paid', 23),
('SQ6Q4R5S', 6, 16, '10C', 'Business', 'Confirmed', 75000.00, 'Paid', 30);

INSERT INTO payments (booking_id, payment_method, amount, transaction_id, status) VALUES
(1, 'Credit Card', 65000.00, 'TXN1001', 'Success'),
(2, 'Debit Card', 45000.00, 'TXN1002', 'Success'),
(3, 'Credit Card', 125000.00, 'TXN1003', 'Success'),
(4, 'PayPal', 55000.00, 'TXN1004', 'Success'),
(5, 'Credit Card', 58000.00, 'TXN1005', 'Success'),
(6, 'Credit Card', 95000.00, 'TXN1006', 'Success'),
(7, 'Bank Transfer', 42000.00, 'TXN1007', 'Success'),
(8, 'Debit Card', 5500.00, 'TXN1008', 'Success'),
(9, 'Credit Card', 115000.00, 'TXN1009', 'Success'),
(10, 'Credit Card', 72000.00, 'TXN1010', 'Success'),
(11, 'PayPal', 5500.00, 'TXN1011', 'Success'),
(12, 'Credit Card', 44000.00, 'TXN1012', 'Success'),
(13, 'Debit Card', 12000.00, 'TXN1013', 'Success'),
(14, 'Credit Card', 8500.00, 'TXN1014', 'Success'),
(15, 'Credit Card', 75000.00, 'TXN1015', 'Success');

Flight Occupancy Report

SELECT 
    f.flight_number,
    al.airline_name,
    DATE_FORMAT(f.departure_datetime, '%Y-%m-%d') AS flight_date,
    dep.airport_code AS departure,
    arr.airport_code AS arrival,
    ac.total_seats,
    COUNT(b.booking_id) AS seats_booked,
    ROUND((COUNT(b.booking_id) / ac.total_seats) * 100, 2) AS occupancy_percentage,
    f.status
FROM flights f
JOIN airlines al ON f.airline_id = al.airline_id
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
LEFT JOIN bookings b ON f.flight_id = b.flight_id AND b.booking_status IN ('Confirmed', 'Checked-In', 'Boarded')
GROUP BY f.flight_id, f.flight_number, al.airline_name, flight_date, departure, arrival, ac.total_seats, f.status
ORDER BY occupancy_percentage DESC;


Revenue per route

SELECT 
    dep.city AS departure_city,
    dep.airport_code AS departure_code,
    arr.city AS arrival_city,
    arr.airport_code AS arrival_code,
    COUNT(DISTINCT f.flight_id) AS total_flights,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.price) AS total_revenue,
    AVG(b.price) AS avg_ticket_price,
    ROUND(AVG(f.distance_km), 2) AS distance_km
FROM flights f
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
LEFT JOIN bookings b ON f.flight_id = b.flight_id 
    AND b.booking_status IN ('Confirmed', 'Checked-In', 'Boarded')
    AND b.payment_status = 'Paid'
GROUP BY dep.city, dep.airport_code, arr.city, arr.airport_code
ORDER BY total_revenue DESC;

Customer loyalty analysis 

SELECT 
    p.loyalty_tier,
    COUNT(DISTINCT p.passenger_id) AS total_passengers,
    COUNT(b.booking_id) AS total_bookings,
    ROUND(AVG(p.total_miles), 2) AS avg_miles,
    SUM(b.price) AS total_revenue,
    ROUND(AVG(b.price), 2) AS avg_booking_value,
    ROUND(COUNT(b.booking_id) * 1.0 / COUNT(DISTINCT p.passenger_id), 2) AS bookings_per_passenger
FROM passengers p
LEFT JOIN bookings b ON p.passenger_id = b.passenger_id 
    AND b.payment_status = 'Paid'
GROUP BY p.loyalty_tier
ORDER BY FIELD(p.loyalty_tier, 'Platinum', 'Gold', 'Silver', 'Bronze');

Top revenue generating passengers 

SELECT 
    p.passenger_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    p.email,
    p.loyalty_tier,
    p.frequent_flyer_number,
    p.total_miles,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.price) AS total_spent,
    ROUND(AVG(b.price), 2) AS avg_booking_value,
    MAX(b.booking_date) AS last_booking_date
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
WHERE b.payment_status = 'Paid'
GROUP BY p.passenger_id, passenger_name, p.email, p.loyalty_tier, p.frequent_flyer_number, p.total_miles
ORDER BY total_spent DESC
LIMIT 10;














