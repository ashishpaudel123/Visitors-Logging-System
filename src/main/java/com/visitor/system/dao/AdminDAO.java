package com.visitor.system.dao;

import com.visitor.system.model.Admin;
import com.visitor.system.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {

    public Admin authenticateAdmin(String username, String password) {
        String query = "SELECT * FROM admins WHERE (username = ? OR email = ?) AND password = ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Admin getAdminById(int id) {
        String query = "SELECT * FROM admins WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean addAdmin(String username, String email, String password) {
        String query = "INSERT INTO admins (username, email, password) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isUsernameExists(String username) {
        String query = "SELECT COUNT(*) FROM admins WHERE username = ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(*) FROM admins WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
