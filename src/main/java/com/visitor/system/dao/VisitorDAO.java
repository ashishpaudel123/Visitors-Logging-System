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
     * Get count of visitors added today for a specific admin
     * 
     * @param adminId The ID of the admin
     * @return Count of visitors added today
     */
    public int getTodayVisitorCount(int adminId) {
        String sql = "SELECT COUNT(*) as total FROM visitors WHERE admin_id = ? AND DATE(entry_time) = CURDATE()";
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
     * Get count of visitors added in the last 60 minutes for a specific admin
     * 
     * @param adminId The ID of the admin
     * @return Count of visitors added in the last 60 minutes
     */
    public int getRecentEntriesCount(int adminId) {
        String sql = "SELECT COUNT(*) as total FROM visitors WHERE admin_id = ? AND entry_time >= NOW() - INTERVAL 60 MINUTE";
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

    /**
     * Get filtered visitors for a specific admin with search and purpose filter
     * 
     * @param adminId       The ID of the admin whose visitors to retrieve
     * @param searchTerm    Search term for name or phone (can be null or empty)
     * @param purposeFilter Purpose to filter by (can be null, empty, or "all")
     * @return List of filtered visitors belonging to this admin
     */
    public List<Visitor> getFilteredVisitors(int adminId, String searchTerm, String purposeFilter) {
        List<Visitor> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM visitors WHERE admin_id = ?");
        
        boolean hasSearch = searchTerm != null && !searchTerm.trim().isEmpty();
        boolean hasPurpose = purposeFilter != null && !purposeFilter.trim().isEmpty() 
                             && !"all".equalsIgnoreCase(purposeFilter);
        
        if (hasSearch) {
            sql.append(" AND (name LIKE ? OR phone LIKE ?)");
        }
        
        if (hasPurpose) {
            sql.append(" AND purpose = ?");
        }
        
        sql.append(" ORDER BY entry_time DESC");
        
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            ps.setInt(paramIndex++, adminId);
            
            if (hasSearch) {
                String searchPattern = "%" + searchTerm.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            if (hasPurpose) {
                ps.setString(paramIndex++, purposeFilter.trim());
            }
            
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
}
