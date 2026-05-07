-- init_rating_schema.sql
-- Creates the `rating` database and minimal tables the application expects:
--  - users
--  - appointments
--  - ratings
-- Also inserts a small set of seed users and one completed appointment for testing.
-- IMPORTANT: This script assumes MySQL server is running and that the
-- credentials in `DBConnection.java` (root / 1234) can access the server.

CREATE DATABASE IF NOT EXISTS `rating` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `rating`;

-- Users table (stores authentication info and basic profile)
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `password` CHAR(64) NOT NULL, -- SHA-256 hex (64 chars)
  `role` VARCHAR(32) NOT NULL DEFAULT 'patient',
  `first_name` VARCHAR(100),
  `last_name` VARCHAR(100),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Appointments table (minimal columns used by RatingDAO)
CREATE TABLE IF NOT EXISTS `appointments` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `patient_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `appointment_date` DATETIME NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'SCHEDULED',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX (`patient_id`),
  INDEX (`doctor_id`),
  CONSTRAINT `fk_appointments_patient` FOREIGN KEY (`patient_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointments_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Ratings table (as used throughout the project)
CREATE TABLE IF NOT EXISTS `ratings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `patient_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `appointment_id` INT NOT NULL,
  `score` INT NOT NULL,
  `review` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_ratings_patient` FOREIGN KEY (`patient_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ratings_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ratings_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_patient_appointment` (`patient_id`, `appointment_id`)
);

-- Seed data: admin, one patient and one doctor; one completed appointment
-- Credentials (for testing):
--   admin / admin
--   patient1 / patient
--   doctor1 / doctor

INSERT IGNORE INTO `users` (`id`, `username`, `password`, `role`, `first_name`, `last_name`) VALUES
  (1, 'admin',  SHA2('admin',256),  'admin',   'System', 'Administrator'),
  (2, 'patient1',SHA2('patient',256),'patient', 'John',   'Doe'),
  (3, 'doctor1', SHA2('doctor',256), 'doctor',  'Alice',  'Smith');

INSERT IGNORE INTO `appointments` (`id`, `patient_id`, `doctor_id`, `appointment_date`, `status`) VALUES
  (1, 2, 3, '2026-01-01 10:00:00', 'COMPLETED');

-- Example: you can later add a rating for the above appointment using
-- INSERT INTO ratings (patient_id, doctor_id, appointment_id, score, review) VALUES (2,3,1,5,'Great care');

-- End of script

