package com.visitor.system.servlet;

import com.visitor.system.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * ResetPasswordServlet - Handles password reset with token validation
 * 
 * Features:
 * - Validates reset token
 * - Checks token expiry
 * - Updates password securely
 * - Marks token as used
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String token = req.getParameter("token");

        // Validate token parameter
        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "Invalid password reset link.");
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        // Validate token in database
        TokenValidation validation = validateToken(token);
        
        if (!validation.isValid) {
            req.setAttribute("error", validation.errorMessage);
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        // Token is valid, show reset form
        req.setAttribute("token", token);
        req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate inputs
        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "Invalid password reset link.");
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("error", "Password cannot be empty.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters long.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        // Validate token again
        TokenValidation validation = validateToken(token);
        
        if (!validation.isValid) {
            req.setAttribute("error", validation.errorMessage);
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        // Update password
        boolean passwordUpdated = updatePassword(validation.adminId, newPassword);
        
        if (!passwordUpdated) {
            req.setAttribute("error", "Failed to update password. Please try again.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/pages/reset-password.jsp").forward(req, res);
            return;
        }

        // Mark token as used
        markTokenAsUsed(token);

        // Success - redirect to login
        req.getSession().setAttribute("passwordResetSuccess", "Your password has been reset successfully. Please login with your new password.");
        res.sendRedirect(req.getContextPath() + "/login");
    }

    /**
     * Validates the reset token
     */
    private TokenValidation validateToken(String token) {
        String sql = "SELECT admin_id, expiry_time, used FROM password_reset_tokens WHERE token = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            
            if (!rs.next()) {
                return new TokenValidation(false, 0, "Invalid or expired password reset link.");
            }
            
            int adminId = rs.getInt("admin_id");
            String expiryTimeStr = rs.getString("expiry_time");
            boolean used = rs.getBoolean("used");
            
            // Check if already used
            if (used) {
                return new TokenValidation(false, 0, "This password reset link has already been used.");
            }
            
            // Check if expired
            LocalDateTime expiryTime = LocalDateTime.parse(expiryTimeStr, 
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            
            if (LocalDateTime.now().isAfter(expiryTime)) {
                return new TokenValidation(false, 0, "This password reset link has expired. Please request a new one.");
            }
            
            return new TokenValidation(true, adminId, null);
            
        } catch (Exception e) {
            e.printStackTrace();
            return new TokenValidation(false, 0, "An error occurred. Please try again.");
        }
    }

    /**
     * Updates the admin's password
     */
    private boolean updatePassword(int adminId, String newPassword) {
        // Store password directly (consider adding hashing for production)
        String sql = "UPDATE admins SET password = ? WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, newPassword);
            ps.setInt(2, adminId);
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Marks the token as used
     */
    private void markTokenAsUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used = TRUE WHERE token = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, token);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Helper class for token validation results
     */
    private static class TokenValidation {
        boolean isValid;
        int adminId;
        String errorMessage;

        TokenValidation(boolean isValid, int adminId, String errorMessage) {
            this.isValid = isValid;
            this.adminId = adminId;
            this.errorMessage = errorMessage;
        }
    }
}
