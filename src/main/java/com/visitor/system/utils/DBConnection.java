package com.visitor.system.utils;

import java.sql.*;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/visitor_db";
    private static final String USER = "root";
    private static final String PASS = "";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void initializeDatabase() {
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = getConnection();
            if (conn != null) {
                stmt = conn.createStatement();
                // Create database and table if they don't exist
                String sql = "CREATE DATABASE IF NOT EXISTS visitor_db; " +
                        "USE visitor_db; " +
                        "CREATE TABLE IF NOT EXISTS visitors (" +
                        "id INT PRIMARY KEY AUTO_INCREMENT, " +
                        "name VARCHAR(100) NOT NULL, " +
                        "phone VARCHAR(20), " +
                        "purpose VARCHAR(255), " +
                        "entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                        ");";
                stmt.executeUpdate(sql);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (stmt != null)
                    stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}