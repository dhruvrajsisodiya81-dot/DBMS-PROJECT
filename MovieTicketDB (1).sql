-- MovieTicketDB.sql (MySQL)
CREATE DATABASE MovieTicketDB;
USE MovieTicketDB;

CREATE TABLE Movies (
  movie_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  duration_minutes INT NOT NULL CHECK (duration_minutes > 0)
);
CREATE TABLE Screens (
  screen_id INT PRIMARY KEY AUTO_INCREMENT,
  screen_name VARCHAR(50) NOT NULL UNIQUE,
  total_seats INT NOT NULL CHECK (total_seats > 0)
);
CREATE TABLE Shows (
  show_id INT PRIMARY KEY AUTO_INCREMENT,
  movie_id INT NOT NULL,
  screen_id INT NOT NULL,
  show_date DATE NOT NULL,
  show_time TIME NOT NULL,
  ticket_price DECIMAL(8,2) NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
  FOREIGN KEY (screen_id) REFERENCES Screens(screen_id),
  UNIQUE (screen_id, show_date, show_time)
);
CREATE TABLE Bookings (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  show_id INT NOT NULL,
  seat_no VARCHAR(10) NOT NULL,
  booking_date DATE NOT NULL,
  status ENUM('CONFIRMED','CANCELLED') DEFAULT 'CONFIRMED',
  booking_source ENUM('DEMO','USER') DEFAULT 'DEMO',
  FOREIGN KEY (show_id) REFERENCES Shows(show_id),
  UNIQUE (show_id, seat_no)
);

-- Sample data
INSERT INTO Movies (title, duration_minutes) VALUES ('Hanuman Ansh',150),('Toxic: A Fairy Tale for Grown-Ups',194),('Drishyam: The Conclusion (Drishyam 3)',159),('Border 2',175),('Ramayana',180);
INSERT INTO Screens (screen_name, total_seats) VALUES ('Screen 1 - IMAX Laser',60),('Screen 2 - Dolby Atmos',50),('Screen 3 - Gold Class',40);
INSERT INTO Shows (movie_id, screen_id, show_date, show_time, ticket_price) VALUES
(1,1,CURDATE()+INTERVAL 1 DAY,'18:00',180),(2,2,CURDATE()+INTERVAL 1 DAY,'20:30',200),(3,3,CURDATE()+INTERVAL 1 DAY,'21:00',250),
(4,2,CURDATE()+INTERVAL 2 DAY,'14:30',130),(5,1,CURDATE()+INTERVAL 2 DAY,'19:00',220),(1,3,CURDATE()+INTERVAL 2 DAY,'17:00',160);
INSERT INTO Bookings (show_id, seat_no, booking_date, status, booking_source) VALUES
(1,'A1',CURDATE(),'CONFIRMED','DEMO'),(1,'A2',CURDATE(),'CONFIRMED','DEMO'),(1,'A3',CURDATE(),'CONFIRMED','DEMO'),(1,'A4',CURDATE(),'CANCELLED','DEMO'),
(2,'B5',CURDATE(),'CONFIRMED','DEMO'),(2,'B6',CURDATE(),'CONFIRMED','DEMO');

-- Query 1: Show time management
SELECT m.title, sc.screen_name, s.show_date, s.show_time, s.ticket_price
FROM Shows s JOIN Movies m ON s.movie_id = m.movie_id JOIN Screens sc ON s.screen_id = sc.screen_id
ORDER BY s.show_date, s.show_time;
-- Query 2: Reserved seat tracking
SELECT b.seat_no, b.status FROM Bookings b WHERE b.show_id = 1 AND b.status = 'CONFIRMED' ORDER BY b.seat_no;
-- Query 3: Total booking revenue
SELECT SUM(s.ticket_price) AS total_booking_revenue FROM Bookings b JOIN Shows s ON b.show_id = s.show_id WHERE b.status = 'CONFIRMED';


-- Personal booking revenue: only tickets booked by the user through the website
SELECT SUM(s.ticket_price) AS my_show1_revenue
FROM Bookings b
JOIN Shows s ON b.show_id = s.show_id
WHERE b.status = 'CONFIRMED'
  AND b.booking_source = 'USER';

-- Total revenue (all confirmed bookings, including demo/sample bookings)
SELECT SUM(s.ticket_price) AS total_booking_revenue
FROM Bookings b
JOIN Shows s ON b.show_id = s.show_id
WHERE b.status = 'CONFIRMED';
