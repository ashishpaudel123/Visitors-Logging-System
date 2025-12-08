-- Create database
CREATE DATABASE IF NOT EXISTS visitor_db;

-- Use the database
USE visitor_db;

-- Create visitors table
CREATE TABLE IF NOT EXISTS visitors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    purpose VARCHAR(255),
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Display confirmation
SELECT 'Database and table created successfully!' as Status;