package com.visitor.system.dao;

import com.visitor.system.model.*;
import com.visitor.system.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class VisitorDAO {
    public void addVisitor(Visitor v) {
        String sql = "INSERT INTO visitors(name,phone,purpose) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, v.getName());
            ps.setString(2, v.getPhone());
            ps.setString(3, v.getPurpose());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Visitor> getVisitors() {
        List<Visitor> list = new ArrayList<>();
        String sql = "SELECT * FROM visitors ORDER BY entry_time DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            con.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Visitor(rs.getInt("id"), rs.getString("name"), rs.getString("phone"),
                        rs.getString("purpose"), rs.getString("entry_time")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int deleteOldVisitors(int days) {
        String sql = "DELETE FROM visitors WHERE entry_time < NOW() - INTERVAL ? DAY";
        int deletedCount = 0;
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, days);
            deletedCount = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return deletedCount;
    }

    public int getTotalVisitorCount() {
        String sql = "SELECT COUNT(*) as total FROM visitors";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getOldVisitorCount(int days) {
        String sql = "SELECT COUNT(*) as total FROM visitors WHERE entry_time < NOW() - INTERVAL ? DAY";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, days);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}