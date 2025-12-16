-- Schema for Password Reset Tokens
-- Run this SQL script to add password reset functionality to your database

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expiry_time DATETIME NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_admin_id (admin_id)
);

-- Clean up expired tokens (optional - you can run this periodically or in the app)
-- DELETE FROM password_reset_tokens WHERE expiry_time < NOW() OR used = TRUE;
