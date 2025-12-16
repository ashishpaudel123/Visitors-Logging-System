-- =====================================================
-- Visitor Logging System - Complete Database Setup
-- =====================================================
-- Run this script in MySQL to create all required tables
-- Command: mysql -u root -p < init_db.sql
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS visitor_db;

-- Use the database
USE visitor_db;

-- =====================================================
-- ADMINS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    organization_type VARCHAR(50) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- VISITORS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS visitors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    purpose VARCHAR(255),
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checkout_time TIMESTAMP NULL DEFAULT NULL,
    admin_id INT NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES admins (id) ON DELETE CASCADE
);

-- =====================================================
-- INDEXES for better performance
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_visitors_admin_id ON visitors (admin_id);

CREATE INDEX IF NOT EXISTS idx_visitors_entry_time ON visitors (entry_time);

CREATE INDEX IF NOT EXISTS idx_visitors_admin_entry ON visitors (admin_id, entry_time);

-- =====================================================
-- Display confirmation
-- =====================================================
SELECT 'Database and all tables created successfully!' as Status;

SELECT 'Tables created: admins, visitors' as Tables;

SELECT 'You can now register an admin and start using the system!' as Next_Step;