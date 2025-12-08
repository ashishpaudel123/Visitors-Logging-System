package com.visitor.system.dao;

import com.visitor.system.model.*;
import com.visitor.system.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class VisitorDAO {

    /**
     * Add a new visitor for a specific admin
     * 
     * @param v       Visitor object containing visitor details
     * @param adminId The ID of the admin adding this visitor
     * @return true if visitor added successfully, false otherwise
     */
    public boolean addVisitor(Visitor v, int adminId) {
        String sql = "INSERT INTO visitors(name, phone, purpose, admin_id) VALUES(?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, v.getName());
            ps.setString(2, v.getPhone());
            ps.setString(3, v.getPurpose());
            ps.setInt(4, adminId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all visitors for a specific admin only
     * 
     * @param adminId The ID of the admin whose visitors to retrieve
     * @return List of visitors belonging to this admin
     */
    public List<Visitor> getVisitorsByAdmin(int adminId) {
        List<Visitor> list = new ArrayList<>();
        String sql = "SELECT * FROM visitors WHERE admin_id = ? ORDER BY entry_time DESC";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            con.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Visitor(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("purpose"),
                        rs.getString("entry_time"),
                        rs.getInt("admin_id")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Delete old visitors for a specific admin only
     * 
     * @param days    Number of days to consider as "old"
     * @param adminId The ID of the admin whose old visitors to delete
     * @return Number of deleted visitors
     */
    public int deleteOldVisitors(int days, int adminId) {
        String sql = "DELETE FROM visitors WHERE admin_id = ? AND entry_time < NOW() - INTERVAL ? DAY";
        int deletedCount = 0;
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setInt(2, days);
            deletedCount = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return deletedCount;
    }

    /**
     * Get total visitor count for a specific admin only
     * 
     * @param adminId The ID of the admin
     * @return Total count of visitors for this admin
     */
    public int getTotalVisitorCount(int adminId) {
        String sql = "SELECT COUNT(*) as total FROM visitors WHERE admin_id = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get count of old visitors for a specific admin only
     * 
     * @param days    Number of days to consider as "old"
     * @param adminId The ID of the admin
     * @return Count of old visitors for this admin
     */
    public int getOldVisitorCount(int days, int adminId) {
        String sql = "SELECT COUNT(*) as total FROM visitors WHERE admin_id = ? AND entry_time < NOW() - INTERVAL ? DAY";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setInt(2, days);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Verify that a visitor belongs to a specific admin (for security checks)
     * 
     * @param visitorId The ID of the visitor
     * @param adminId   The ID of the admin
     * @return true if visitor belongs to admin, false otherwise
     */
    public boolean verifyVisitorOwnership(int visitorId, int adminId) {
        String sql = "SELECT COUNT(*) FROM visitors WHERE id = ? AND admin_id = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, visitorId);
            ps.setInt(2, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
